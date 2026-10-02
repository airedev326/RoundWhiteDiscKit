import Foundation

public enum Child23KAuthImportError: Error, Equatable {
    case invalidKAuthLength(Int)
    case unexpectedKAuthVersion(UInt8)
    case invalidPayloadLength(Int)
    case unsupportedPayloadLength(Int)
    case invalidResourceSize(String, Int)
    case tableReadOutOfBounds(String, Int)
    case invalidDescriptorStream(String)
    case staticCopyDecodeFailed(String)
    case generatedVMEndedBeforeTerminal(Int)
    case unknownGeneratedVMHandler(Int, Int)
}

public struct Child23KAuthMaterial: Equatable, Sendable {
    public let keyBlock: Data
    public let payload: Data
    public let payloadDigest: Data
    public let payloadMix66: Data
    public let temp66: Data
    public let ptr05: Data
    public let phase5RawKey: Data
}

// Clean-room port of child[23].vt+0x50 one-block kAuth import:
//   lib+0x721ef4 -> lib+0x71e090 -> generated VM lib+0x71fb38
//   -> lib+0x70d6a4(0x4200002fda1, temp66, temp66) == handle+0x28 ptr05.
//
// This is takeover-only material. It converts the 149-byte persisted kAuth
// blob into the 66-byte ptr05-equivalent input, then uses Phase5KeySchedule
// to derive the raw key consumed by LibAES.phase5BlockEncryptor.
public enum Child23KAuthImport {
    public static func importOneBlock(_ kAuth: Data) throws -> Child23KAuthMaterial {
        let tables = try cachedTables.get()
        let parsed = try parseType0KAuth([UInt8](kAuth))
        guard parsed.payload.count == 16 else {
            throw Child23KAuthImportError.unsupportedPayloadLength(parsed.payload.count)
        }

        let payloadMix = try apply71fb38(payload: parsed.payload, tables: tables)
        let (temp66, ptr05) = try importCoreOneBlock(parsed: parsed, payloadMix66: payloadMix, tables: tables)
        let rawKey = try Phase5KeySchedule.deriveRawKey(input66: Data(ptr05))

        return Child23KAuthMaterial(
            keyBlock: Data(parsed.keyBlock),
            payload: Data(parsed.payload),
            payloadDigest: Data(parsed.payloadDigest),
            payloadMix66: Data(payloadMix),
            temp66: Data(temp66),
            ptr05: Data(ptr05),
            phase5RawKey: rawKey
        )
    }

    public static func phase5RawKey(forKAuthBlob kAuth: Data) throws -> Data {
        try importOneBlock(kAuth).phase5RawKey
    }

    private struct ParsedKAuth {
        let keyBlock: [UInt8]
        let payload: [UInt8]
        let payloadDigest: [UInt8]
    }

    private struct ImportTables {
        let sboxMaster: [UInt8]
        let programRegion: [UInt8]
        let vmStart: [UInt8]
        let vmDesc: [UInt8]
        let staticTable: [UInt8]
        let staticCopyCode: [UInt8]
        let ttableBExt: [UInt8]
        let staticCopyPairs: [(src: Int, dst: Int)]
    }

    private static let cachedTables = SuccessCache<ImportTables> {
        let sbox = try Tables.load(.sbox19)
        let program = try Tables.load(.child23ProgramRegion)
        let vmStart = try Tables.load(.child23VMStart)
        let vmDesc = try Tables.load(.child23VMDesc)
        let staticTable = try Tables.load(.child23StaticTable)
        let staticCopyCode = try Tables.load(.child23StaticCopyCode)
        let ttableBExt = try Tables.load(.child23TTableBExt)

        try checkSize(RuntimeTable.sbox19.rawValue, sbox, 0x80000)
        try checkSize(RuntimeTable.child23ProgramRegion.rawValue, program, 0x44500)
        try checkSize(RuntimeTable.child23VMStart.rawValue, vmStart, 1000)
        try checkSize(RuntimeTable.child23VMDesc.rawValue, vmDesc, 324_816)
        try checkSize(RuntimeTable.child23StaticTable.rawValue, staticTable, 2120)
        try checkSize(RuntimeTable.child23StaticCopyCode.rawValue, staticCopyCode, 0x1328)
        try checkSize(RuntimeTable.child23TTableBExt.rawValue, ttableBExt, 0x100000)

        let pairs = try decodeStaticCopyPairs(code: staticCopyCode)
        return ImportTables(
            sboxMaster: sbox,
            programRegion: program,
            vmStart: vmStart,
            vmDesc: vmDesc,
            staticTable: staticTable,
            staticCopyCode: staticCopyCode,
            ttableBExt: ttableBExt,
            staticCopyPairs: pairs
        )
    }

    private static func parseType0KAuth(_ kAuth: [UInt8]) throws -> ParsedKAuth {
        guard kAuth.count >= 0x95 else {
            throw Child23KAuthImportError.invalidKAuthLength(kAuth.count)
        }
        guard kAuth[4] == 2 else {
            throw Child23KAuthImportError.unexpectedKAuthVersion(kAuth[4])
        }
        let payloadLen = readBE32(kAuth, 0x5d)
        guard payloadLen > 0, 0x61 + payloadLen + 20 <= kAuth.count else {
            throw Child23KAuthImportError.invalidPayloadLength(payloadLen)
        }
        return ParsedKAuth(
            keyBlock: slice(kAuth, 0x31, 16),
            payload: slice(kAuth, 0x61, payloadLen),
            payloadDigest: slice(kAuth, 0x61 + payloadLen, 20)
        )
    }

    private static func importCoreOneBlock(parsed: ParsedKAuth, payloadMix66: [UInt8],
                                           tables: ImportTables) throws -> (temp66: [UInt8], ptr05: [UInt8]) {
        guard payloadMix66.count == 66 else {
            throw Child23KAuthImportError.invalidPayloadLength(payloadMix66.count)
        }

        let mixedBlock = Array(parsed.keyBlock.reversed())
        let expandedA = try expand96(block16: mixedBlock, tableOff: expandAOff, tables: tables)
        let expandedB = try expand96(block16: mixedBlock, tableOff: expandBOff, tables: tables)

        let first66 = try treeReduce96(expandedA, firstProg: 0x1492b, restProg: 0x13c75,
                                       finalMagic: 0x4200002ce43, tables: tables)
        let second66 = try treeReduce96(expandedB, firstProg: 0x2990d, restProg: 0x32a26,
                                        finalMagic: 0x420000112d3, tables: tables)
        let combined66 = try vm70d6a4(magic: 0x4200001445b, src1: first66, src2: second66, tables: tables)
        let delayed66 = try vm710df4(magic: 0x000c03f000c0fa6c, src: combined66, tables: tables)
        let temp66 = try vm70d6a4(magic: 0x42000032b6a, src1: payloadMix66, src2: delayed66, tables: tables)
        let ptr05 = try vm70d6a4(magic: 0x4200002fda1, src1: temp66, src2: temp66, tables: tables)
        return (temp66, ptr05)
    }

    // MARK: - Generated 71fb38 VM

    private static func apply71fb38(payload: [UInt8], tables: ImportTables) throws -> [UInt8] {
        var stack = try load71fb38Stack(payload: payload, tables: tables)
        var handler = handlerExpandByte
        let desc = tables.vmDesc

        guard desc.count % 24 == 0 else {
            throw Child23KAuthImportError.invalidDescriptorStream("descriptor length \(desc.count) is not /24")
        }
        guard desc.count >= 0x4f4d0 else {
            throw Child23KAuthImportError.invalidDescriptorStream("missing terminal entry")
        }

        var pc = 0
        for off in stride(from: 0, to: desc.count, by: 24) {
            if handler == handlerTerminal {
                return slice(stack, 0x699, 66)
            }

            let arg = readU64LE(desc, off)
            let h8 = Int(readU16LE(desc, off + 8))
            let h10 = Int(readU16LE(desc, off + 10))
            let h12 = Int(readU16LE(desc, off + 12))
            let nextDelta = Int(readI32LE(desc, off + 16))
            let warg = Int(arg & 0xffff_ffff)

            switch handler {
            case handler710f00:
                try vmAWriteStack(progOff: warg, stack: &stack, src1Off: h8, src2Off: h10, dstOff: h12,
                                  primer: 0, writeCount: 6, tables: tables)
            case handler711014:
                try vm711014Stack(progOff: warg, stack: &stack, srcOff: h8, dstOff: h10, tables: tables)
            case handlerShift:
                try copyShift721248(arg: warg, h8: h8, h10: h10, stack: &stack)
            case handler711144:
                try vmAWriteStack(progOff: warg, stack: &stack, src1Off: h8, src2Off: h10, dstOff: h12,
                                  primer: 0, writeCount: 4, tailSrc2: 2, tables: tables)
            case handler711240:
                try vmAWriteStack(progOff: warg, stack: &stack, src1Off: h8, src2Off: h10, dstOff: h12,
                                  primer: 0, writeCount: 4, tables: tables)
            case handler7112fc:
                try vmAWriteStack(progOff: warg, stack: &stack, src1Off: h8, src2Off: h10, dstOff: h12,
                                  primer: 2, writeCount: 4, tables: tables)
            case handler711400:
                try vmAWriteStack(progOff: warg, stack: &stack, src1Off: h8, src2Off: h10, dstOff: h12,
                                  primer: 1, writeCount: 4, tables: tables)
            case handler7114e0:
                try vmAWriteStack(progOff: warg, stack: &stack, src1Off: h8, src2Off: h10, dstOff: h12,
                                  primer: 3, writeCount: 3, tailProgOnly: 1, tables: tables)
            case handler7115f4:
                try vmAWriteStack(progOff: warg, stack: &stack, src1Off: h8, src2Off: h10, dstOff: h12,
                                  primer: 2, writeCount: 4, tailProgOnly: 2, tables: tables)
            case handler711728:
                try vm711728Stack(progOff: warg, stack: &stack, srcOff: h8, dstOff: h10, tables: tables)
            case handler70d6a4:
                _ = try vm70d6a4Stack(magic: arg, stack: &stack, src1Off: h8, src2Off: h10,
                                      dstOff: h12, tables: tables)
            case handlerExpandByte:
                let base = libAESTablePackedOff - programRegionBase + warg
                let src = Int(try read(stack, h8, "71fb38 stack"))
                let packedOff = base + src * 3
                let packed = try checkedSlice(tables.programRegion, packedOff, 3, RuntimeTable.child23ProgramRegion.rawValue)
                stack[h10 + 0] = packed[0] & 7
                stack[h10 + 1] = packed[0] >> 3
                stack[h10 + 2] = packed[1] & 7
                stack[h10 + 3] = packed[1] >> 3
                stack[h10 + 4] = packed[2] & 7
                stack[h10 + 5] = packed[2] >> 3
            case handlerMemcpy:
                let srcAdd = Int(arg & 0xffff)
                let dstAdd = Int((arg >> 16) & 0xffff)
                let length = Int((arg >> 32) & 0xffff)
                let chunk = try checkedSlice(stack, h8 + srcAdd, length, "71fb38 stack")
                write(chunk, to: &stack, at: h10 + dstAdd)
            default:
                throw Child23KAuthImportError.unknownGeneratedVMHandler(handler, pc)
            }

            handler = handlerTerminal - nextDelta
            pc += 1
        }

        if handler == handlerTerminal {
            return slice(stack, 0x699, 66)
        }
        throw Child23KAuthImportError.generatedVMEndedBeforeTerminal(handler)
    }

    private static func load71fb38Stack(payload: [UInt8], tables: ImportTables) throws -> [UInt8] {
        guard payload.count == 16 else {
            throw Child23KAuthImportError.unsupportedPayloadLength(payload.count)
        }
        guard tables.vmStart.count >= 8 + 0x398 else {
            throw Child23KAuthImportError.invalidResourceSize(RuntimeTable.child23VMStart.rawValue, tables.vmStart.count)
        }

        let maxStaticDst = (tables.staticCopyPairs.map { $0.dst }.max() ?? 0) + 6
        let maxPayloadDst = (payloadStackSlots.map { $0.dst }.max() ?? 0) + 1
        var stack = [UInt8](repeating: 0, count: max(0x2000, 0x699 + 66, maxStaticDst, maxPayloadDst))

        for (srcIdx, dst) in payloadStackSlots {
            stack[dst] = payload[srcIdx]
        }

        for pair in tables.staticCopyPairs {
            let chunk = try checkedSlice(tables.staticTable, pair.src, 6, RuntimeTable.child23StaticTable.rawValue)
            write(chunk, to: &stack, at: pair.dst)
        }

        write(slice(tables.vmStart, 8, 0x398), to: &stack, at: 0)
        return stack
    }

    private static func decodeStaticCopyPairs(code: [UInt8]) throws -> [(src: Int, dst: Int)] {
        var pairs: [(src: Int, dst: Int)] = []
        var regs: [Int: Int] = [:]
        var lastMov8 = 0

        for off in stride(from: 0, to: code.count, by: 4) {
            let addr = staticCopyCodeBase + off
            let insn = readU32LE(code, off)
            let rd = Int(insn & 31)
            let rn = Int((insn >> 5) & 31)

            if (insn & 0x7f00_0000) == 0x1100_0000 && ((insn >> 31) & 1) == 1 {
                let shift = ((insn >> 22) & 1) == 1 ? 12 : 0
                let imm = Int((insn >> 10) & 0xfff) << shift
                if rd == 0 && rn == 21 {
                    regs[0] = imm
                } else if rd == 1 && rn == 20 {
                    regs[1] = imm
                }
                continue
            }

            if insn == 0xaa15_03e0 {
                regs[0] = 0
                continue
            }

            if (insn & 0x7f80_0000) == 0x5280_0000 && rd == 8 {
                let hw = Int((insn >> 21) & 3)
                lastMov8 = Int((insn >> 5) & 0xffff) << (16 * hw)
                continue
            }

            let rm = Int((insn >> 16) & 31)
            if (insn & 0xffe0_fc00) == 0x8b00_0000 && rd == 1 && rn == 20 && rm == 8 {
                regs[1] = lastMov8
                continue
            }

            if (insn >> 26) == 0b100101 {
                let target = addr + signExtend(Int(insn & 0x03ff_ffff), bits: 26) * 4
                if target == staticMemcpyTarget {
                    guard let src = regs[0], let dst = regs[1] else {
                        throw Child23KAuthImportError.staticCopyDecodeFailed("missing regs at \(String(addr, radix: 16))")
                    }
                    pairs.append((src: src, dst: dst))
                    regs.removeAll()
                }
            }
        }

        guard pairs.count == 352 else {
            throw Child23KAuthImportError.staticCopyDecodeFailed("expected 352 pairs, got \(pairs.count)")
        }
        return pairs
    }

    // MARK: - VM Helpers

    private static func vm6_710f00(progOff: Int, src1: [UInt8], src2: [UInt8],
                                   tables: ImportTables) throws -> [UInt8] {
        let program = try prog(progOff, 6, tables)
        var state = 0
        var out = [UInt8](repeating: 0, count: 6)
        for i in 0..<6 {
            let idx = ((((state & 0xf8) ^ Int(src1[i])) | (Int(src2[i]) << 8)) ^ (Int(program[i]) << 11)) & 0x7ffff
            state = Int(tables.sboxMaster[idx])
            out[i] = UInt8(state & 7)
        }
        return out
    }

    private static func vmAWriteStack(progOff: Int, stack: inout [UInt8], src1Off: Int, src2Off: Int,
                                      dstOff: Int, primer: Int, writeCount: Int, tailSrc2: Int = 0,
                                      tailProgOnly: Int = 0, tables: ImportTables) throws {
        let program = try prog(progOff, primer + writeCount + tailSrc2 + tailProgOnly, tables)
        var state = 0
        for pos in 0..<primer {
            state = vmAStep(state: state, src1: Int(stack[src1Off + pos]),
                            src2: Int(stack[src2Off + pos]), prog: Int(program[pos]), tables: tables)
        }

        var pos = primer
        var outPos = 0
        for _ in 0..<writeCount {
            state = vmAStep(state: state, src1: Int(stack[src1Off + pos]),
                            src2: Int(stack[src2Off + pos]), prog: Int(program[pos]), tables: tables)
            stack[dstOff + outPos] = UInt8(state & 7)
            pos += 1
            outPos += 1
        }

        for _ in 0..<tailSrc2 {
            state = vmAStep(state: state, src1: nil, src2: Int(stack[src2Off + pos]),
                            prog: Int(program[pos]), tables: tables)
            stack[dstOff + outPos] = UInt8(state & 7)
            pos += 1
            outPos += 1
        }

        for _ in 0..<tailProgOnly {
            state = vmAStep(state: state, src1: nil, src2: nil, prog: Int(program[pos]), tables: tables)
            stack[dstOff + outPos] = UInt8(state & 7)
            pos += 1
            outPos += 1
        }
    }

    private static func vmAStep(state: Int, src1: Int?, src2: Int?, prog: Int, tables: ImportTables) -> Int {
        var idx = state & 0xf8
        if let src1 {
            idx = (idx ^ src1) & 0xff
        }
        if let src2 {
            idx |= src2 << 8
        }
        idx ^= prog << 11
        return Int(tables.sboxMaster[idx & 0x7ffff])
    }

    private static func vm711014Stack(progOff: Int, stack: inout [UInt8], srcOff: Int, dstOff: Int,
                                      tables: ImportTables) throws {
        let program = try prog(progOff, 9, tables)
        var state = try ttableBHalfword((Int(stack[srcOff]) << 1) | (Int(program[0]) << 13), tables)
        for i in 1..<4 {
            state = try ttableBHalfword((((state & 0xff8) ^ Int(stack[srcOff + i])) << 1) | (Int(program[i]) << 13), tables)
        }

        stack[dstOff] = UInt8(state & 7)
        var outPos = 1
        for i in [4, 5] {
            state = try ttableBHalfword((((state & 0xff8) ^ Int(stack[srcOff + i])) << 1) | (Int(program[i]) << 13), tables)
            stack[dstOff + outPos] = UInt8(state & 7)
            outPos += 1
        }

        for (i, pi) in [(2, 6), (3, 7), (4, 8)] {
            state = try ttableBHalfword((Int(program[pi]) << 13) ^ ((state ^ Int(stack[srcOff + i])) << 1), tables)
            stack[dstOff + outPos] = UInt8(state & 7)
            outPos += 1
        }
    }

    private static func vm711728Stack(progOff: Int, stack: inout [UInt8], srcOff: Int, dstOff: Int,
                                      tables: ImportTables) throws {
        let program = try prog(progOff, 7, tables)
        var state = try ttableBHalfword((Int(stack[srcOff]) << 1) | (Int(program[0]) << 13), tables)
        for i in 1..<4 {
            state = try ttableBHalfword((((state & 0xff8) ^ Int(stack[srcOff + i])) << 1) | (Int(program[i]) << 13), tables)
        }

        stack[dstOff] = UInt8(state & 7)
        for (outPos, i) in [(1, 4), (2, 5)] {
            state = try ttableBHalfword((((state & 0xff8) ^ Int(stack[srcOff + i])) << 1) | (Int(program[i]) << 13), tables)
            stack[dstOff + outPos] = UInt8(state & 7)
        }

        state = try ttableBHalfword(((Int(stack[srcOff + 2]) | (Int(program[6]) << 12)) ^ state) << 1, tables)
        stack[dstOff + 3] = UInt8(state & 7)
    }

    private static func vm70d6a4(magic: UInt64, src1: [UInt8], src2: [UInt8],
                                 tables: ImportTables) throws -> [UInt8] {
        let off = Int(magic & 0x3f_ffff)
        let count = Int((magic >> 36) & 0x3fff)
        let tail = Int(magic >> 50)
        let program = try prog(off, count + tail, tables)
        var state = 0
        var out = [UInt8](repeating: 0, count: count + tail)

        for i in 0..<count {
            state = vmAStep(state: state, src1: Int(src1[i]), src2: Int(src2[i]),
                            prog: Int(program[i]), tables: tables)
            out[i] = UInt8(state & 7)
        }

        for i in 0..<tail {
            let pi = count + i
            state = vmAStep(state: state, src1: nil, src2: Int(src2[pi]),
                            prog: Int(program[pi]), tables: tables)
            out[pi] = UInt8(state & 7)
        }
        return out
    }

    private static func vm70d6a4Stack(magic: UInt64, stack: inout [UInt8], src1Off: Int,
                                      src2Off: Int, dstOff: Int, tables: ImportTables) throws -> Int {
        let off = Int(magic & 0x3f_ffff)
        let count = Int((magic >> 36) & 0x3fff)
        let tail = Int(magic >> 50)
        let program = try prog(off, count + tail, tables)
        var state = 0

        for i in 0..<count {
            state = vmAStep(state: state, src1: Int(stack[src1Off + i]), src2: Int(stack[src2Off + i]),
                            prog: Int(program[i]), tables: tables)
            stack[dstOff + i] = UInt8(state & 7)
        }

        for i in 0..<tail {
            let pi = count + i
            state = vmAStep(state: state, src1: nil, src2: Int(stack[src2Off + pi]),
                            prog: Int(program[pi]), tables: tables)
            stack[dstOff + pi] = UInt8(state & 7)
        }
        return count + tail
    }

    private static func vm710df4(magic: UInt64, src: [UInt8], tables: ImportTables) throws -> [UInt8] {
        let off = Int(magic & 0x3f_ffff)
        let primer = Int((magic >> 22) & 0x3fff)
        let writeCount = Int((magic >> 36) & 0x3fff)
        let program = try prog(off, primer + writeCount + 3, tables)

        var state = 0
        for i in 0..<primer {
            let idx = ((state & 0xff8) ^ Int(src[i])) | (Int(program[i]) << 12)
            state = try ttableBHalfword(idx * 2, tables)
        }

        var out = [UInt8](repeating: 0, count: writeCount + 3)
        for i in 0..<writeCount {
            let si = primer + i
            let idx = ((state & 0xff8) ^ Int(src[si])) | (Int(program[si]) << 12)
            state = try ttableBHalfword(idx * 2, tables)
            out[i] = UInt8(state & 7)
        }

        let tailProg = primer + writeCount
        var idx = (state ^ Int(src[2])) ^ (Int(program[tailProg]) << 12)
        state = try ttableBHalfword(idx * 2, tables)
        out[writeCount] = UInt8(state & 7)

        idx = (Int(program[tailProg + 1]) << 13) ^ ((state ^ Int(src[3])) << 1)
        state = try ttableBHalfword(idx, tables)
        out[writeCount + 1] = UInt8(state & 7)

        idx = (Int(program[tailProg + 2]) << 13) ^ ((state ^ Int(src[4])) << 1)
        state = try ttableBHalfword(idx, tables)
        out[writeCount + 2] = UInt8(state & 7)
        return out
    }

    private static func copyShift721248(arg: Int, h8: Int, h10: Int, stack: inout [UInt8]) throws {
        let low = arg & 0x1ff
        let end = ((arg >> 18) & 0x1ff) - 1

        if end >= low {
            let srcLimit = (arg >> 9) & 0x1ff
            for pos in stride(from: end, through: low, by: -1) {
                let srcIdx = pos - low
                stack[h10 + pos] = srcIdx < srcLimit ? stack[h8 + srcIdx] : 0
            }
        }

        let marker = low - 1
        guard marker >= 0 else {
            throw Child23KAuthImportError.tableReadOutOfBounds("721248 stack marker", marker)
        }
        stack[h10 + marker] = UInt8((arg >> 27) & 7)
        if marker > 0 {
            for i in 0..<marker {
                stack[h10 + i] = 0
            }
        }
    }

    private static func expand96(block16: [UInt8], tableOff: Int, tables: ImportTables) throws -> [UInt8] {
        var out = [UInt8](repeating: 0, count: 96)
        let rel = tableOff - programRegionBase
        for (i, byte) in block16.enumerated() {
            let j = rel + Int(byte) * 3
            let packed = try checkedSlice(tables.programRegion, j, 3, RuntimeTable.child23ProgramRegion.rawValue)
            out[i * 6 + 0] = packed[0] & 7
            out[i * 6 + 1] = packed[0] >> 3
            out[i * 6 + 2] = packed[1] & 7
            out[i * 6 + 3] = packed[1] >> 3
            out[i * 6 + 4] = packed[2] & 7
            out[i * 6 + 5] = packed[2] >> 3
        }
        return out
    }

    private static func treeReduce96(_ expanded: [UInt8], firstProg: Int, restProg: Int,
                                     finalMagic: UInt64, tables: ImportTables) throws -> [UInt8] {
        var reduced: [[UInt8]] = []
        reduced.reserveCapacity(16)
        for chunkIdx in 0..<16 {
            let chunk = slice(expanded, chunkIdx * 6, 6)
            reduced.append(try vm6_710f00(progOff: chunkIdx == 0 ? firstProg : restProg,
                                          src1: chunk, src2: chunk, tables: tables))
        }

        var packed = [UInt8](repeating: 0, count: 66)
        write(reduced[0], to: &packed, at: 0)
        var dst = 6
        for chunk in reduced.dropFirst() {
            for i in 2..<6 {
                packed[dst] = chunk[i]
                dst += 1
            }
        }
        return try vm70d6a4(magic: finalMagic, src1: packed, src2: packed, tables: tables)
    }

    // MARK: - Byte Helpers

    private static func prog(_ off: Int, _ length: Int, _ tables: ImportTables) throws -> [UInt8] {
        try checkedSlice(tables.programRegion, off, length, RuntimeTable.child23ProgramRegion.rawValue)
    }

    private static func ttableBHalfword(_ byteOff: Int, _ tables: ImportTables) throws -> Int {
        let lo = Int(try read(tables.ttableBExt, byteOff, RuntimeTable.child23TTableBExt.rawValue))
        let hi = Int(try read(tables.ttableBExt, byteOff + 1, RuntimeTable.child23TTableBExt.rawValue))
        return lo | (hi << 8)
    }

    private static func checkedSlice(_ bytes: [UInt8], _ off: Int, _ count: Int, _ name: String) throws -> [UInt8] {
        guard off >= 0, count >= 0, off + count <= bytes.count else {
            throw Child23KAuthImportError.tableReadOutOfBounds(name, off)
        }
        return slice(bytes, off, count)
    }

    private static func read(_ bytes: [UInt8], _ off: Int, _ name: String) throws -> UInt8 {
        guard off >= 0, off < bytes.count else {
            throw Child23KAuthImportError.tableReadOutOfBounds(name, off)
        }
        return bytes[off]
    }

    private static func slice(_ bytes: [UInt8], _ off: Int, _ count: Int) -> [UInt8] {
        Array(bytes[off..<(off + count)])
    }

    private static func write(_ bytes: [UInt8], to dst: inout [UInt8], at off: Int) {
        for i in 0..<bytes.count {
            dst[off + i] = bytes[i]
        }
    }

    private static func checkSize(_ name: String, _ bytes: [UInt8], _ expected: Int) throws {
        guard bytes.count == expected else {
            throw Child23KAuthImportError.invalidResourceSize(name, bytes.count)
        }
    }

    private static func signExtend(_ value: Int, bits: Int) -> Int {
        let sign = 1 << (bits - 1)
        return (value ^ sign) - sign
    }

    private static func readBE32(_ b: [UInt8], _ off: Int) -> Int {
        (Int(b[off]) << 24) | (Int(b[off + 1]) << 16) | (Int(b[off + 2]) << 8) | Int(b[off + 3])
    }

    private static func readU16LE(_ b: [UInt8], _ off: Int) -> UInt16 {
        UInt16(b[off]) | (UInt16(b[off + 1]) << 8)
    }

    private static func readU32LE(_ b: [UInt8], _ off: Int) -> UInt32 {
        UInt32(b[off]) | (UInt32(b[off + 1]) << 8) | (UInt32(b[off + 2]) << 16) | (UInt32(b[off + 3]) << 24)
    }

    private static func readI32LE(_ b: [UInt8], _ off: Int) -> Int32 {
        Int32(bitPattern: readU32LE(b, off))
    }

    private static func readU64LE(_ b: [UInt8], _ off: Int) -> UInt64 {
        UInt64(b[off])
            | (UInt64(b[off + 1]) << 8)
            | (UInt64(b[off + 2]) << 16)
            | (UInt64(b[off + 3]) << 24)
            | (UInt64(b[off + 4]) << 32)
            | (UInt64(b[off + 5]) << 40)
            | (UInt64(b[off + 6]) << 48)
            | (UInt64(b[off + 7]) << 56)
    }

    // MARK: - Constants

    private static let programRegionBase = 0x435cf0
    private static let expandAOff = 0x479bd2
    private static let expandBOff = 0x479ed2
    private static let libAESTablePackedOff = 0x4729a5
    private static let staticCopyCodeBase = 0x71fca0
    private static let staticMemcpyTarget = 0x5bdce0

    private static let handler710f00 = 0x7211f0
    private static let handler711014 = 0x721220
    private static let handlerShift = 0x721248
    private static let handler711144 = 0x7212cc
    private static let handler711240 = 0x7212fc
    private static let handler7112fc = 0x72132c
    private static let handler711400 = 0x72135c
    private static let handler7114e0 = 0x72138c
    private static let handler7115f4 = 0x7213bc
    private static let handler711728 = 0x7213ec
    private static let handler70d6a4 = 0x721414
    private static let handlerExpandByte = 0x721444
    private static let handlerMemcpy = 0x7214f8
    private static let handlerTerminal = 0x721530

    private static let payloadStackSlots: [(idx: Int, dst: Int)] = [
        (9, 0x527),
        (2, 0x0ab8),
        (12, 0x0964),
        (1, 0x1681),
        (5, 0x1893),
        (10, 0x03ba),
        (3, 0x0a13),
        (8, 0x1df3),
        (0, 0x1424),
        (13, 0x07c3),
        (6, 0x0e56),
        (11, 0x171c),
        (7, 0x0d45),
        (15, 0x11af),
        (14, 0x1c06),
        (4, 0x063e),
    ]
}
