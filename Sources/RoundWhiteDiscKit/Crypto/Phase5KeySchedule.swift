import Foundation

public enum Phase5KeyScheduleError: Error, Equatable {
    case invalidInputLength(Int)
    case invalidTableSize(String, Int)
    case tableReadOutOfBounds(String, Int)
}

// Clean-room port of lib+0x5de1e4 for the Phase 5 wire cipher key.
//
// Input is the 66-byte stage-1 source observed at the lib wrapper. The caller
// still owns discovering or importing the correct source bytes for a given
// pairing path; this schedule only turns those bytes into the raw 16-byte key
// consumed by LibAES.phase5BlockEncryptor(rawKey:).
public enum Phase5KeySchedule {
    public static func deriveRawKey(input66: Data) throws -> Data {
        guard input66.count == stage1Count else {
            throw Phase5KeyScheduleError.invalidInputLength(input66.count)
        }
        let tables = try cachedTables.get()
        return Data(try deriveRawKey(input: [UInt8](input66), tables: tables))
    }

    private struct ScheduleTables {
        let sboxMaster: [UInt8]
        let region274000: [UInt8]
    }

    private static let cachedTables = SuccessCache<ScheduleTables> {
        let sbox = try Tables.load(.sbox19)
        let region = try Tables.load(.phase5KeySchedRegion)
        guard sbox.count == 0x80000 else {
            throw Phase5KeyScheduleError.invalidTableSize(RuntimeTable.sbox19.rawValue, sbox.count)
        }
        guard region.count == regionLength else {
            throw Phase5KeyScheduleError.invalidTableSize(RuntimeTable.phase5KeySchedRegion.rawValue, region.count)
        }
        return ScheduleTables(sboxMaster: sbox, region274000: region)
    }

    private static func deriveRawKey(input: [UInt8], tables: ScheduleTables) throws -> [UInt8] {
        let sbox = tables.sboxMaster
        let region = tables.region274000
        let prog = slice(region, progDataBase - regionBase, 0x1000)

        var inBuf = [UInt8](repeating: 0, count: 0x90)
        let stage1Prog = slice(prog, stage1TableOffset, stage1Count)
        let stage1 = vmA(sbox: sbox, src1: input, src2: input, prog: stage1Prog, length: stage1Count)
        write(stage1, to: &inBuf, at: 0)

        var stack = [UInt8](repeating: 0, count: 0x180)
        for call in phase1Calls {
            let totalRead: Int
            switch call.op {
            case .vmD:
                totalRead = 6
            case .vmB:
                totalRead = call.countA + call.countB
            case .vmA:
                totalRead = call.countB
            }

            let src1 = source(call.src1, inBuf: inBuf, stack: stack, count: totalRead)
            let src2 = source(call.src2, inBuf: inBuf, stack: stack, count: totalRead)
            let progSeg = slice(prog, call.progOffset, totalRead)
            let out: [UInt8]
            switch call.op {
            case .vmA:
                out = vmA(sbox: sbox, src1: src1, src2: src2, prog: progSeg, length: call.countB)
            case .vmB:
                out = vmB(sbox: sbox, src1: src1, src2: src2, prog: progSeg,
                          lengthA: call.countA, lengthB: call.countB)
            case .vmD:
                out = vmD(sbox: sbox, src1: src1, src2: src2, prog: progSeg)
            }
            write(out, to: &stack, at: call.dst)
        }

        var subOrcBytes = [UInt8](repeating: 0, count: 16)
        for iter in 0..<16 {
            let chunkInOff = phase2ChunkOffsetsSP[iter]
            for round in 0..<4 {
                let src1Off = round == 0 ? chunkInOff : phase2ScratchSrcs[round]
                let src1 = slice(stack, src1Off, 6)
                let src2 = try regionSlice(region, libOffset: phase2Src2LibOffsets[iter][round], count: 6)
                let progSeg = slice(prog, phase2ProgOffsets[iter][round], 6)
                let out = vmD(sbox: sbox, src1: src1, src2: src2, prog: progSeg)
                write(out, to: &stack, at: phase2ScratchDsts[round])
            }

            let compressed = try subOrc(arg6B: slice(stack, subOrcArgSP, 6),
                                        sboxMaster: sbox,
                                        progData: prog,
                                        region: region)
            subOrcBytes[iter] = compressed
            stack[subOrcAccumSP] = compressed
        }

        var aesKey = [UInt8](repeating: 0, count: 16)
        for iter in 0..<16 {
            let tableOffset = iter == 0 ? 0 : iter * 0x100 + 0x40
            let regionOff = postLoopBase - regionBase + tableOffset + Int(subOrcBytes[iter])
            aesKey[keyPosByIter[iter]] = try read(region, offset: regionOff, name: RuntimeTable.phase5KeySchedRegion.rawValue)
        }
        return aesKey
    }

    // MARK: - VM Primitives

    private static func vmA(sbox: [UInt8], src1: [UInt8], src2: [UInt8], prog: [UInt8], length: Int) -> [UInt8] {
        var state = 0
        var out = [UInt8](repeating: 0, count: length)
        for i in 0..<length {
            let result = vmOpWrite(state: state, src1: src1[i], src2: src2[i], prog: prog[i], sbox: sbox)
            state = result.state
            out[i] = result.output
        }
        return out
    }

    private static func vmB(sbox: [UInt8], src1: [UInt8], src2: [UInt8], prog: [UInt8],
                            lengthA: Int, lengthB: Int, lengthC: Int = 0) -> [UInt8] {
        var state = 0
        for i in 0..<lengthA {
            state = vmOpNoWrite(state: state, src1: src1[i], src2: src2[i], prog: prog[i], sbox: sbox)
        }

        var out = [UInt8](repeating: 0, count: lengthB + lengthC)
        for i in 0..<lengthB {
            let idx = lengthA + i
            let result = vmOpWrite(state: state, src1: src1[idx], src2: src2[idx], prog: prog[idx], sbox: sbox)
            state = result.state
            out[i] = result.output
        }

        for i in 0..<lengthC {
            let idx = lengthA + lengthB + i
            let sboxIdx = (((state & 0xf8) | (Int(prog[idx]) << 11)) & 0x7ffff)
            state = Int(sbox[sboxIdx])
            out[lengthB + i] = UInt8(state & 7)
        }
        return out
    }

    private static func vmD(sbox: [UInt8], src1: [UInt8], src2: [UInt8], prog: [UInt8]) -> [UInt8] {
        vmA(sbox: sbox, src1: src1, src2: src2, prog: prog, length: 6)
    }

    private static func vmOpNoWrite(state: Int, src1: UInt8, src2: UInt8, prog: UInt8, sbox: [UInt8]) -> Int {
        let idx = ((((state & 0xf8) ^ Int(src1)) | ((Int(src2) << 8) ^ (Int(prog) << 11))) & 0x7ffff)
        return Int(sbox[idx])
    }

    private static func vmOpWrite(state: Int, src1: UInt8, src2: UInt8, prog: UInt8,
                                  sbox: [UInt8]) -> (state: Int, output: UInt8) {
        let next = vmOpNoWrite(state: state, src1: src1, src2: src2, prog: prog, sbox: sbox)
        return (next, UInt8(next & 7))
    }

    private static func subOrc(arg6B: [UInt8], sboxMaster: [UInt8], progData: [UInt8],
                               region: [UInt8]) throws -> UInt8 {
        let scratch = try transform6B(arg6B, sboxMaster: sboxMaster)
        let vma1Prog = slice(progData, subOrcVMA1Offset, 4)
        let vma2Prog = slice(progData, subOrcVMA2Offset, 4)

        let keep = vmA(sbox: sboxMaster, src1: Array(scratch[0..<4]), src2: Array(scratch[0..<4]),
                       prog: vma1Prog, length: 4)

        var scratchMut = scratch
        let vmbProg = slice(progData, subOrcVMBOffset, subOrcVMBLengthA + subOrcVMBLengthB + subOrcVMBLengthC)
        let vmbOut = vmB(sbox: sboxMaster, src1: scratchMut, src2: scratchMut, prog: vmbProg,
                         lengthA: subOrcVMBLengthA, lengthB: subOrcVMBLengthB, lengthC: subOrcVMBLengthC)
        write(vmbOut, to: &scratchMut, at: 0)

        let step5 = vmA(sbox: sboxMaster, src1: keep, src2: keep, prog: vma2Prog, length: 4)
        let idx5 = Int(step5[2]) ^ (Int(step5[3]) << 3)
        let lookup5 = try read(region, offset: phase5SBoxOff + idx5, name: RuntimeTable.phase5KeySchedRegion.rawValue)

        let postVMB = Array(scratchMut[0..<4])
        let keep2 = vmA(sbox: sboxMaster, src1: postVMB, src2: postVMB, prog: vma1Prog, length: 4)
        let step7 = vmA(sbox: sboxMaster, src1: keep2, src2: keep2, prog: vma2Prog, length: 4)
        let idx7 = Int(step7[2]) ^ (Int(step7[3]) << 3)
        let lookup7 = try read(region, offset: phase5SBoxOff + idx7, name: RuntimeTable.phase5KeySchedRegion.rawValue)

        return (lookup7 & 0xf0) | (lookup5 & 0x0f)
    }

    private static func transform6B(_ arg6B: [UInt8], sboxMaster: [UInt8]) throws -> [UInt8] {
        var out = [UInt8](repeating: 0, count: 6)
        var x = try scramblerHalfword(sboxMaster, index: Int(arg6B[0]) + 0x2000)
        x = try scramblerHalfword(sboxMaster, index: ((x & 0xff8) ^ Int(arg6B[1])) | 0x2000)
        x = try scramblerHalfword(sboxMaster, index: ((x & 0xff8) ^ Int(arg6B[2])) | 0x2000)
        x = try scramblerHalfword(sboxMaster, index: ((x & 0xff8) ^ Int(arg6B[3])) | 0x4000)
        out[0] = UInt8(x & 7)

        x = try scramblerHalfword(sboxMaster, index: (((x & 0xff8) ^ Int(arg6B[4])) | 0x21000) + 0xd000)
        out[1] = UInt8(x & 7)
        x = try scramblerHalfword(sboxMaster, index: ((x & 0xff8) ^ Int(arg6B[5])) | 0x21000)
        out[2] = UInt8(x & 7)

        x = try scramblerHalfword(sboxMaster, index: (x ^ Int(arg6B[2])) ^ 0x6000)
        out[3] = UInt8(x & 7)
        x = try scramblerHalfword(sboxMaster, index: (x ^ Int(arg6B[3])) ^ 0x2000)
        out[4] = UInt8(x & 7)
        x = try scramblerHalfword(sboxMaster, index: (x ^ Int(arg6B[4])) ^ 0x4000)
        out[5] = UInt8(x & 7)
        return out
    }

    private static func scramblerHalfword(_ sboxMaster: [UInt8], index: Int) throws -> Int {
        let byteOffset = scramblerOffsetInSboxMaster + index * 2
        let lo = Int(try read(sboxMaster, offset: byteOffset, name: RuntimeTable.sbox19.rawValue))
        let hi = Int(try read(sboxMaster, offset: byteOffset + 1, name: RuntimeTable.sbox19.rawValue))
        return lo | (hi << 8)
    }

    // MARK: - Byte Helpers

    private static func source(_ source: Source, inBuf: [UInt8], stack: [UInt8], count: Int) -> [UInt8] {
        switch source {
        case .input:
            return slice(inBuf, 0, count)
        case .stack(let offset):
            return slice(stack, offset, count)
        }
    }

    private static func slice(_ bytes: [UInt8], _ offset: Int, _ count: Int) -> [UInt8] {
        Array(bytes[offset..<(offset + count)])
    }

    private static func regionSlice(_ region: [UInt8], libOffset: Int, count: Int) throws -> [UInt8] {
        let offset = libOffset - regionBase
        guard offset >= 0, offset + count <= region.count else {
            throw Phase5KeyScheduleError.tableReadOutOfBounds(RuntimeTable.phase5KeySchedRegion.rawValue, offset)
        }
        return slice(region, offset, count)
    }

    private static func read(_ bytes: [UInt8], offset: Int, name: String) throws -> UInt8 {
        guard offset >= 0, offset < bytes.count else {
            throw Phase5KeyScheduleError.tableReadOutOfBounds(name, offset)
        }
        return bytes[offset]
    }

    private static func write(_ bytes: [UInt8], to dst: inout [UInt8], at offset: Int) {
        for i in 0..<bytes.count {
            dst[offset + i] = bytes[i]
        }
    }

    // MARK: - Constants

    private static let regionBase = 0x274000
    private static let regionLength = 0x2000
    private static let progDataBase = 0x274624
    private static let stage1TableOffset = 0x124
    private static let stage1Count = 66
    private static let phase5SBoxOff = 0x9d3
    private static let postLoopBase = 0x274a13
    private static let scramblerOffsetInSboxMaster = 0x20001

    private static let subOrcVMA1Offset = 465
    private static let subOrcVMBOffset = 194
    private static let subOrcVMBLengthA = 2
    private static let subOrcVMBLengthB = 4
    private static let subOrcVMBLengthC = 2
    private static let subOrcVMA2Offset = 833

    private static let phase2ScratchDsts = [0xb4, 0x92, 0xe8, 0xd6]
    private static let phase2ScratchSrcs = [0, 0xb4, 0x92, 0xe8]
    private static let subOrcArgSP = 0xd6
    private static let subOrcAccumSP = 0x104

    private static let phase2ChunkOffsetsSP = [
        0x8c, 0x86, 0x80, 0x7a, 0x74, 0x6e, 0x68, 0x62,
        0x5c, 0x56, 0x50, 0x4a, 0x44, 0x3e, 0x38, 0x32,
    ]

    private static let phase2ProgOffsets = [
        [611, 364, 805, 382],
        [581, 208, 569, 160],
        [124, 136, 765, 737],
        [106, 112, 370, 18],
        [731, 523, 425, 843],
        [553, 895, 675, 715],
        [487, 24, 398, 879],
        [12, 743, 821, 30],
        [669, 657, 873, 118],
        [547, 517, 587, 188],
        [166, 0, 182, 286],
        [837, 36, 651, 867],
        [404, 202, 663, 376],
        [605, 130, 575, 681],
        [6, 599, 749, 499],
        [645, 493, 358, 541],
    ]

    private static let phase2Src2LibOffsets = [
        [0x2749bb, 0x2749c1, 0x2749c7, 0x2749cd],
        [0x275a53, 0x275a59, 0x275a5f, 0x275a65],
        [0x275a6b, 0x275a71, 0x275a77, 0x275a7d],
        [0x275a83, 0x275a89, 0x275a8f, 0x275a95],
        [0x275a9b, 0x275aa1, 0x275aa7, 0x275aad],
        [0x275ab3, 0x275ab9, 0x275abf, 0x275ac5],
        [0x275acb, 0x275ad1, 0x275ad7, 0x275add],
        [0x275ae3, 0x275ae9, 0x275aef, 0x275af5],
        [0x275afb, 0x275b01, 0x275b07, 0x275b0d],
        [0x275b13, 0x275b19, 0x275b1f, 0x275b25],
        [0x275b2b, 0x275b31, 0x275b37, 0x275b3d],
        [0x275b43, 0x275b49, 0x275b4f, 0x275b55],
        [0x275b5b, 0x275b61, 0x275b67, 0x275b6d],
        [0x275b73, 0x275b79, 0x275b7f, 0x275b85],
        [0x275b8b, 0x275b91, 0x275b97, 0x275b9d],
        [0x275ba3, 0x275ba9, 0x275baf, 0x275bb5],
    ]

    private static let keyPosByIter = [
        3, 2, 1, 0,
        7, 6, 5, 4,
        11, 10, 9, 8,
        15, 14, 13, 12,
    ]

    private enum VMOp {
        case vmA
        case vmB
        case vmD
    }

    private enum Source {
        case input
        case stack(Int)
    }

    private struct Phase1Call {
        let op: VMOp
        let progOffset: Int
        let countA: Int
        let countB: Int
        let src1: Source
        let src2: Source
        let dst: Int
    }

    private static let phase1Calls: [Phase1Call] = [
        Phase1Call(op: .vmA, progOffset: 0x1af, countA: 0, countB: 34, src1: .input, src2: .input, dst: 0xb4),
        Phase1Call(op: .vmB, progOffset: 0x0d6, countA: 32, countB: 34, src1: .input, src2: .input, dst: 0x92),
        Phase1Call(op: .vmA, progOffset: 0x269, countA: 0, countB: 18, src1: .stack(0xb4), src2: .stack(0xb4), dst: 0xe8),
        Phase1Call(op: .vmB, progOffset: 0x303, countA: 16, countB: 18, src1: .stack(0xb4), src2: .stack(0xb4), dst: 0xd6),
        Phase1Call(op: .vmA, progOffset: 0x02a, countA: 0, countB: 10, src1: .stack(0xe8), src2: .stack(0xe8), dst: 0x104),
        Phase1Call(op: .vmB, progOffset: 0x1d5, countA: 8, countB: 10, src1: .stack(0xe8), src2: .stack(0xe8), dst: 0xfa),
        Phase1Call(op: .vmD, progOffset: 0x211, countA: 0, countB: 6, src1: .stack(0x104), src2: .stack(0x104), dst: 0x32),
        Phase1Call(op: .vmB, progOffset: 0x32b, countA: 4, countB: 6, src1: .stack(0x104), src2: .stack(0x104), dst: 0x38),
        Phase1Call(op: .vmD, progOffset: 0x1f9, countA: 0, countB: 6, src1: .stack(0xfa), src2: .stack(0xfa), dst: 0x3e),
        Phase1Call(op: .vmB, progOffset: 0x2d1, countA: 4, countB: 6, src1: .stack(0xfa), src2: .stack(0xfa), dst: 0x44),
        Phase1Call(op: .vmA, progOffset: 0x0ac, countA: 0, countB: 10, src1: .stack(0xd6), src2: .stack(0xd6), dst: 0x104),
        Phase1Call(op: .vmB, progOffset: 0x2b9, countA: 8, countB: 10, src1: .stack(0xd6), src2: .stack(0xd6), dst: 0xfa),
        Phase1Call(op: .vmD, progOffset: 0x1a3, countA: 0, countB: 6, src1: .stack(0x104), src2: .stack(0x104), dst: 0x4a),
        Phase1Call(op: .vmB, progOffset: 0x034, countA: 4, countB: 6, src1: .stack(0x104), src2: .stack(0x104), dst: 0x50),
        Phase1Call(op: .vmD, progOffset: 0x217, countA: 0, countB: 6, src1: .stack(0xfa), src2: .stack(0xfa), dst: 0x56),
        Phase1Call(op: .vmB, progOffset: 0x27b, countA: 4, countB: 6, src1: .stack(0xfa), src2: .stack(0xfa), dst: 0x5c),
        Phase1Call(op: .vmA, progOffset: 0x08e, countA: 0, countB: 18, src1: .stack(0x92), src2: .stack(0x92), dst: 0xe8),
        Phase1Call(op: .vmB, progOffset: 0x03e, countA: 16, countB: 18, src1: .stack(0x92), src2: .stack(0x92), dst: 0xd6),
        Phase1Call(op: .vmA, progOffset: 0x22f, countA: 0, countB: 10, src1: .stack(0xe8), src2: .stack(0xe8), dst: 0x104),
        Phase1Call(op: .vmB, progOffset: 0x351, countA: 8, countB: 10, src1: .stack(0xe8), src2: .stack(0xe8), dst: 0xfa),
        Phase1Call(op: .vmD, progOffset: 0x1ff, countA: 0, countB: 6, src1: .stack(0x104), src2: .stack(0x104), dst: 0x62),
        Phase1Call(op: .vmB, progOffset: 0x375, countA: 4, countB: 6, src1: .stack(0x104), src2: .stack(0x104), dst: 0x68),
        Phase1Call(op: .vmD, progOffset: 0x33b, countA: 0, countB: 6, src1: .stack(0xfa), src2: .stack(0xfa), dst: 0x6e),
        Phase1Call(op: .vmB, progOffset: 0x2af, countA: 4, countB: 6, src1: .stack(0xfa), src2: .stack(0xfa), dst: 0x74),
        Phase1Call(op: .vmA, progOffset: 0x184, countA: 0, countB: 10, src1: .stack(0xd6), src2: .stack(0xd6), dst: 0x104),
        Phase1Call(op: .vmB, progOffset: 0x385, countA: 8, countB: 10, src1: .stack(0xd6), src2: .stack(0xd6), dst: 0xfa),
        Phase1Call(op: .vmD, progOffset: 0x118, countA: 0, countB: 6, src1: .stack(0x104), src2: .stack(0x104), dst: 0x7a),
        Phase1Call(op: .vmB, progOffset: 0x2f3, countA: 4, countB: 6, src1: .stack(0x104), src2: .stack(0x104), dst: 0x80),
        Phase1Call(op: .vmD, progOffset: 0x251, countA: 0, countB: 6, src1: .stack(0xfa), src2: .stack(0xfa), dst: 0x86),
        Phase1Call(op: .vmB, progOffset: 0x060, countA: 4, countB: 6, src1: .stack(0xfa), src2: .stack(0xfa), dst: 0x8c),
    ]
}
