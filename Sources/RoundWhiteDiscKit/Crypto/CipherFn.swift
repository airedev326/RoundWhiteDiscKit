import Foundation

// White-box AES VM, ported 1:1 from cleanroom_cipher_fn/cipher_fn_v3.py.
// 13-opcode bytecode VM driven by ~3 MB of lookup tables from the installed
// runtime-tables blob (see RuntimeTables.swift).
// The "key" is the tables — there is no separate key input.
//
// API:
//   CipherFn.aes_K(input)                     // installed runtime tables
//   CipherFn.run(input, singleton, bytecode)  // for test vector replay
//
// Bit-exact against captured device dumps; see RuntimeTableTests.

public enum CipherFnError: Error {
    case missingResource(String)
    case invalidInputLength(Int)
}

public enum CipherFn {

    public static func aes_K(_ input: Data) throws -> Data {
        guard input.count == 16 else { throw CipherFnError.invalidInputLength(input.count) }
        let t = try Tables.shared.get()
        return run(input: input, singleton: t.singleton, bytecode: t.bytecode, t: t)
    }

    public static func run(input: Data, singleton: Data, bytecode: Data) throws -> Data {
        guard input.count == 16 else { throw CipherFnError.invalidInputLength(input.count) }
        return run(input: input, singleton: singleton, bytecode: bytecode, t: try Tables.shared.get())
    }

    static func run(input: Data, singleton: Data, bytecode: Data, t: Tables) -> Data {
        var scratch = [UInt8](repeating: 0, count: SCRATCH_SIZE)
        // T5 seed
        let seed = t.t5Seed
        scratch.withUnsafeMutableBufferPointer { dst in
            seed.withUnsafeBytes { src in
                dst.baseAddress!.update(from: src.bindMemory(to: UInt8.self).baseAddress!,
                                        count: min(seed.count, SCRATCH_SIZE))
            }
        }
        // Phase 1: place 16 input bytes
        for i in 0..<16 {
            scratch[INPUT_OFFSETS[i]] = input[input.startIndex + i]
        }
        // Phase 2: 544 6-byte memcpys from singleton (ctx) to scratch
        let singletonBytes = [UInt8](singleton)
        for (srcOff, dstOff) in t.phase2Pairs {
            let s = Int(srcOff)
            let d = Int(dstOff)
            if s + 6 <= singletonBytes.count && d + 6 <= SCRATCH_SIZE {
                scratch[d..<d+6] = singletonBytes[s..<s+6]
            }
        }

        runVM(scratch: &scratch, bytecode: bytecode, t: t)

        var out = Data(count: 16)
        for i in 0..<16 {
            out[i] = scratch[INPUT_OFFSETS[OUTPUT_PERM[i]]]
        }
        return out
    }

    // MARK: - VM dispatcher

    static func runVM(scratch: inout [UInt8], bytecode: Data, t: Tables) {
        let numInsns = bytecode.count / 24
        var nextOp: Int? = 0  // initial dispatch is opcode 0 (ENCODE)

        let bc = [UInt8](bytecode)
        for i in 0..<numInsns {
            guard let op = nextOp else { return }
            let base = i * 24
            let operandLo = readU32(bc, base + 0)
            let operandHi = readU32(bc, base + 4)
            let field8   = Int(readU16(bc, base + 8))
            let fieldA   = Int(readU16(bc, base + 10))
            let fieldC   = Int(readU16(bc, base + 12))
            let nextDisp = readI32(bc, base + 16)

            switch op {
            case 0:
                op_encode(&scratch, operand: operandLo, field8: field8, fieldA: fieldA, fieldC: fieldC, t: t)
            case 1:
                op_memcpy(&scratch, operandLo: operandLo, operandHi: operandHi, field8: field8, fieldA: fieldA)
            case 2:
                op_51f8(&scratch, operand: operandLo, srcOff: field8, dstOff: fieldA, t: t)
            case 5:
                op_4ae4(&scratch, operand: operandLo, srcOff: field8, dstOff: fieldA, t: t)
            case 9:
                op_decode(&scratch, operandLo: operandLo, operandHi: operandHi, field8: field8, fieldA: fieldA, t: t)
            case 11:
                op_shiftrows(&scratch, operand: operandLo, field8: field8, fieldA: fieldA)
            case 3, 4, 6, 7, 8, 10, 12:
                op_3bit_chain(&scratch, operand: operandLo, src1Off: field8, src2Off: fieldA, dstOff: fieldC,
                              iters: SBC_OPS[op]!, t: t)
            default:
                break
            }

            nextOp = DISPATCH_TO_OPCODE[Int(nextDisp)]
        }
    }

    // MARK: - Constants

    static let SCRATCH_SIZE = 0x2500

    static let INPUT_OFFSETS: [Int] = [
        0x0f6e, 0x1c8d, 0x100d, 0x0a61, 0x065e, 0x1134, 0x1a14, 0x1da2,
        0x1963, 0x0801, 0x2133, 0x17f6, 0x0980, 0x158d, 0x0d7b, 0x0b46,
    ]

    // Phase 5 output extraction is a permutation of the input slots.
    static let OUTPUT_PERM: [Int] = [9, 0, 3, 2, 11, 7, 8, 5, 14, 4, 15, 13, 1, 6, 12, 10]

    static let DISPATCH_TO_OPCODE: [Int: Int] = [
        228: 0, 56: 1, 360: 2, 552: 3, 456: 4, 820: 5, 504: 6,
        600: 7, 408: 8, 320: 9, 648: 10, 780: 11, 868: 12,
    ]
}

// MARK: - Iter descriptors for the 7 3-bit-chain opcodes

enum SBCIter {
    case full(s1: Int, s2: Int, p: Int, d: Int?)
    case noSrc1(s2: Int, p: Int, d: Int?)
    case prmOnly(p: Int, d: Int?)
}

// Mirrors SBC_OPS in cipher_fn_v3.py exactly.
let SBC_OPS: [Int: [SBCIter]] = [
    12: (0..<6).map { .full(s1: $0, s2: $0, p: $0, d: $0) },                               // Op_49d0
    10: (0..<4).map { .full(s1: $0, s2: $0, p: $0, d: $0) }                                // Op_4c14
        + (4..<6).map { .noSrc1(s2: $0, p: $0, d: $0) },
    7:  (0..<4).map { .full(s1: $0, s2: $0, p: $0, d: $0) },                               // Op_4d10
    3:  (0..<2).map { .full(s1: $0, s2: $0, p: $0, d: nil) }                               // Op_4dcc
        + (2..<6).map { .full(s1: $0, s2: $0, p: $0, d: $0 - 2) },
    6:  [.full(s1: 0, s2: 0, p: 0, d: nil)]                                                // Op_4ed0
        + (1..<5).map { .full(s1: $0, s2: $0, p: $0, d: $0 - 1) },
    4:  (0..<3).map { .full(s1: $0, s2: $0, p: $0, d: nil) }                               // Op_4fb0
        + (3..<6).map { .full(s1: $0, s2: $0, p: $0, d: $0 - 3) }
        + [.prmOnly(p: 6, d: 3)],
    8:  (0..<2).map { .full(s1: $0, s2: $0, p: $0, d: nil) }                               // Op_50c4
        + (2..<6).map { .full(s1: $0, s2: $0, p: $0, d: $0 - 2) }
        + [.prmOnly(p: 6, d: 4), .prmOnly(p: 7, d: 5)],
]

// MARK: - Helpers

@inline(__always) func readU16(_ b: [UInt8], _ off: Int) -> UInt16 {
    UInt16(b[off]) | (UInt16(b[off + 1]) << 8)
}
@inline(__always) func readU32(_ b: [UInt8], _ off: Int) -> UInt32 {
    UInt32(b[off]) | (UInt32(b[off + 1]) << 8) | (UInt32(b[off + 2]) << 16) | (UInt32(b[off + 3]) << 24)
}
@inline(__always) func readI32(_ b: [UInt8], _ off: Int) -> Int32 {
    Int32(bitPattern: readU32(b, off))
}

@inline(__always) func sbGet(_ scratch: [UInt8], _ off: Int) -> UInt8 {
    (off >= 0 && off < CipherFn.SCRATCH_SIZE) ? scratch[off] : 0
}
@inline(__always) func sbSet(_ scratch: inout [UInt8], _ off: Int, _ val: Int) {
    if off >= 0 && off < CipherFn.SCRATCH_SIZE {
        scratch[off] = UInt8(val & 0xff)
    }
}

@inline(__always) func safeSbox12(_ tables: Tables, _ idx: Int) -> Int {
    let byteIdx = idx & ~1  // halfword aligned
    if byteIdx + 2 > tables.sbox12.count { return 0 }
    let lo = Int(tables.sbox12[byteIdx])
    let hi = Int(tables.sbox12[byteIdx + 1])
    return lo | (hi << 8)
}
@inline(__always) func safeSbox19(_ tables: Tables, _ idx: Int) -> Int {
    (idx >= 0 && idx < tables.sbox19.count) ? Int(tables.sbox19[idx]) : 0
}
@inline(__always) func safeParams(_ tables: Tables, _ idx: Int) -> Int {
    (idx >= 0 && idx < tables.params.count) ? Int(tables.params[idx]) : 0
}

// MARK: - Opcode handlers

func op_encode(_ scratch: inout [UInt8], operand: UInt32, field8: Int, fieldA: Int, fieldC: Int, t: Tables) {
    // Inline_4794 (opcode 0): byte → 6-byte 3-bit ENCODE via DECODE_TABLE.
    let srcByte = Int(sbGet(scratch, field8))
    let base = Int(operand) + srcByte * 3
    let dt = t.decode
    var b0 = 0, b1 = 0, b2 = 0
    if base >= 0 && base + 3 <= dt.count {
        b0 = Int(dt[base]); b1 = Int(dt[base + 1]); b2 = Int(dt[base + 2])
    }
    sbSet(&scratch, fieldA + 0, b0 & 0x07)
    sbSet(&scratch, fieldA + 1, b0 >> 3)
    sbSet(&scratch, fieldA + 2, b1 & 0x07)
    sbSet(&scratch, fieldA + 3, b1 >> 3)
    sbSet(&scratch, fieldA + 4, b2 & 0x07)
    sbSet(&scratch, fieldA + 5, b2 >> 3)
}

func op_memcpy(_ scratch: inout [UInt8], operandLo: UInt32, operandHi: UInt32, field8: Int, fieldA: Int) {
    // Inline_4840 (opcode 1): generic memcpy.
    let srcAdj = Int(operandLo & 0xffff)
    let dstAdj = Int((operandLo >> 16) & 0xffff)
    let length = Int(operandHi & 0xffff)
    let src = field8 + srcAdj
    let dst = fieldA + dstAdj
    if src >= 0, src + length <= CipherFn.SCRATCH_SIZE,
       dst >= 0, dst + length <= CipherFn.SCRATCH_SIZE,
       length > 0 {
        // Use copyMemory-style move that supports overlap.
        if dst < src {
            for i in 0..<length { scratch[dst + i] = scratch[src + i] }
        } else {
            for i in (0..<length).reversed() { scratch[dst + i] = scratch[src + i] }
        }
    }
}

func op_3bit_chain(_ scratch: inout [UInt8], operand: UInt32, src1Off: Int, src2Off: Int, dstOff: Int,
                   iters: [SBCIter], t: Tables) {
    let paramsOffset = Int(operand)
    var carry = 0
    for it in iters {
        let idx: Int
        let dstI: Int?
        switch it {
        case let .full(s1i, s2i, pi, di):
            let s1 = Int(sbGet(scratch, src1Off + s1i))
            let s2 = Int(sbGet(scratch, src2Off + s2i))
            let prm = safeParams(t, paramsOffset + pi)
            let part = ((carry ^ s1) & 0xff) | (s2 << 8)
            idx = (part ^ (prm << 11)) & 0x7ffff
            dstI = di
        case let .noSrc1(s2i, pi, di):
            let s2 = Int(sbGet(scratch, src2Off + s2i))
            let prm = safeParams(t, paramsOffset + pi)
            idx = ((carry | (s2 << 8)) ^ (prm << 11)) & 0x7ffff
            dstI = di
        case let .prmOnly(pi, di):
            let prm = safeParams(t, paramsOffset + pi)
            idx = (carry | (prm << 11)) & 0x7ffff
            dstI = di
        }
        let byte = safeSbox19(t, idx)
        carry = byte & 0xf8
        if let di = dstI {
            sbSet(&scratch, dstOff + di, byte & 0x07)
        }
    }
}

func op_4ae4(_ scratch: inout [UInt8], operand: UInt32, srcOff: Int, dstOff: Int, t: Tables) {
    // Op_4ae4 (opcode 5): halfword 12-bit chain, 9 lookups → 6 output bytes.
    let paramsOffset = Int(operand)
    @inline(__always) func src(_ i: Int) -> Int { Int(sbGet(scratch, srcOff + i)) }
    @inline(__always) func prm(_ i: Int) -> Int { safeParams(t, paramsOffset + i) }

    var idx = (src(0) << 1) | (prm(0) << 13)
    var state = 0
    var lookup = 0
    for i in 1...3 {
        lookup = safeSbox12(t, idx)
        state = lookup & 0xff8
        idx = ((state ^ src(i)) << 1) | (prm(i) << 13)
    }
    lookup = safeSbox12(t, idx)
    sbSet(&scratch, dstOff + 0, lookup & 0x07)
    state = lookup & 0xff8

    // dst[1..2] use ORR-style index with masked state
    let pairs12: [(Int, Int)] = [(4, 4), (5, 5)]
    for (k, pair) in pairs12.enumerated() {
        idx = ((state ^ src(pair.0)) << 1) | (prm(pair.1) << 13)
        lookup = safeSbox12(t, idx)
        sbSet(&scratch, dstOff + 1 + k, lookup & 0x07)
        if k == 0 { state = lookup & 0xff8 }
    }
    // dst[3..5] use EOR-style with full unmasked previous lookup
    var prev = lookup
    let pairs35: [(Int, Int)] = [(2, 6), (3, 7), (4, 8)]
    for (k, pair) in pairs35.enumerated() {
        idx = ((prev ^ src(pair.0)) << 1) ^ (prm(pair.1) << 13)
        lookup = safeSbox12(t, idx)
        sbSet(&scratch, dstOff + 3 + k, lookup & 0x07)
        prev = lookup
    }
}

func op_51f8(_ scratch: inout [UInt8], operand: UInt32, srcOff: Int, dstOff: Int, t: Tables) {
    // Op_51f8 (opcode 2): 4-output halfword 12-bit chain.
    let paramsOffset = Int(operand)
    @inline(__always) func src(_ i: Int) -> Int { Int(sbGet(scratch, srcOff + i)) }
    @inline(__always) func prm(_ i: Int) -> Int { safeParams(t, paramsOffset + i) }

    var idx = (src(0) << 1) | (prm(0) << 13)
    var state = 0
    var lookup = 0
    for i in 1...3 {
        lookup = safeSbox12(t, idx)
        state = lookup & 0xff8
        idx = ((state ^ src(i)) << 1) | (prm(i) << 13)
    }
    lookup = safeSbox12(t, idx)
    sbSet(&scratch, dstOff + 0, lookup & 0x07)
    state = lookup & 0xff8

    // dst[1]
    idx = ((state ^ src(4)) << 1) | (prm(4) << 13)
    lookup = safeSbox12(t, idx)
    sbSet(&scratch, dstOff + 1, lookup & 0x07)
    state = lookup & 0xff8

    // dst[2]
    idx = ((state ^ src(5)) << 1) | (prm(5) << 13)
    lookup = safeSbox12(t, idx)
    sbSet(&scratch, dstOff + 2, lookup & 0x07)

    // dst[3]: SPECIAL — idx = (src[2] | (prm[6]<<12)) ^ FULL_unmasked_lookup_for_dst[2]
    let specialIdx = (src(2) | (prm(6) << 12)) ^ lookup
    let byteOff = (specialIdx << 1) & 0x1fffff
    var lookup2 = 0
    if byteOff + 2 <= t.sbox12.count {
        lookup2 = Int(t.sbox12[byteOff]) | (Int(t.sbox12[byteOff + 1]) << 8)
    }
    sbSet(&scratch, dstOff + 3, lookup2 & 0x07)
}

func op_decode(_ scratch: inout [UInt8], operandLo: UInt32, operandHi: UInt32,
               field8: Int, fieldA: Int, t: Tables) {
    // Inline_4738 (opcode 9): nibble-combiner / 3-bit → 8-bit DECODE.
    let srcOffLo = (Int(operandLo) & 0x1fff) << 2
    let srcOffHi = (Int(operandLo) >> 13) & 0x7ffff
    let srcBase = field8 + srcOffLo
    let s2 = Int(sbGet(scratch, srcBase + 2))
    let s3 = Int(sbGet(scratch, srcBase + 3))
    let s4 = Int(sbGet(scratch, srcBase + 4))
    let s5 = Int(sbGet(scratch, srcBase + 5))
    let idx1 = s4 ^ (s5 << 3)
    let idx2 = s2 ^ (s3 << 3)
    let dt = t.decode
    var lookup1 = 0, lookup2 = 0
    if srcOffHi + idx1 < dt.count && srcOffHi + idx2 < dt.count {
        lookup1 = Int(dt[srcOffHi + idx1])
        lookup2 = Int(dt[srcOffHi + idx2])
    }
    let outByte = (lookup1 & 0xf0) | (lookup2 & 0x0f)
    sbSet(&scratch, fieldA, outByte)
}

func op_shiftrows(_ scratch: inout [UInt8], operand: UInt32, field8: Int, fieldA: Int) {
    // Inline_456c (opcode 11): backwards copy with bound check + memset.
    let LENGTH = Int(operand & 0x1ff)
    let SRC_LIMIT = Int((operand >> 9) & 0x1ff)
    let START = Int((operand >> 18) & 0x1ff)
    let FILL = Int((operand >> 27) & 0x07)
    if LENGTH == 0 { return }
    let srcBase = field8
    let dstBase = fieldA

    if START - 1 < LENGTH {
        sbSet(&scratch, dstBase + LENGTH - 1, FILL)
        if LENGTH > 1 {
            for i in 0..<(LENGTH - 1) { sbSet(&scratch, dstBase + i, 0) }
        }
        return
    }

    var w10 = START - 1
    while w10 >= LENGTH {
        let srcIdx = w10 - LENGTH
        let byte: Int
        if srcIdx < SRC_LIMIT {
            byte = Int(sbGet(scratch, srcBase + srcIdx))
        } else {
            byte = 0
        }
        sbSet(&scratch, dstBase + w10, byte)
        w10 -= 1
    }
    sbSet(&scratch, dstBase + LENGTH - 1, FILL)
    if LENGTH > 1 {
        for i in 0..<(LENGTH - 1) { sbSet(&scratch, dstBase + i, 0) }
    }
}

// MARK: - Tables (lazy-loaded once)

final class Tables {
    let sbox19: [UInt8]
    let sbox12: [UInt8]
    let decode: [UInt8]
    let params: [UInt8]
    let bytecode: Data
    let t5Seed: Data
    let singleton: Data
    let phase2Pairs: [(UInt16, UInt16)]

    private init() throws {
        sbox19 = try Tables.load(.sbox19)
        sbox12 = try Tables.load(.sbox12)
        decode = try Tables.load(.decode)
        params = try Tables.load(.params)
        bytecode = try Tables.loadData(.bytecode)
        t5Seed = try Tables.loadData(.t5Seed)
        singleton = try Tables.loadData(.singleton)

        let pairsData = try Tables.loadData(.phase2Pairs)
        var pairs: [(UInt16, UInt16)] = []
        pairs.reserveCapacity(pairsData.count / 4)
        for i in stride(from: 0, to: pairsData.count, by: 4) {
            let s = UInt16(pairsData[i]) | (UInt16(pairsData[i + 1]) << 8)
            let d = UInt16(pairsData[i + 2]) | (UInt16(pairsData[i + 3]) << 8)
            pairs.append((s, d))
        }
        phase2Pairs = pairs
    }

    static let shared = SuccessCache { try Tables() }

    static func load(_ table: RuntimeTable) throws -> [UInt8] {
        [UInt8](try loadData(table))
    }

    static func loadData(_ table: RuntimeTable) throws -> Data {
        try RemoteRuntimeTables.data(named: table.rawValue)
    }
}

enum RuntimeTable: String {
    // Names of entries in the installed runtime-tables blob (RuntimeTables.swift).
    case sbox19      = "sbox_19bit_lib_986819"
    case sbox12      = "sbox_12bit_full"
    case decode      = "decode_table_lib_237dcc"
    case params      = "params_lib_22a1a0"
    case bytecode    = "bytecode_lib_b25d20"
    case t5Seed      = "t5_seed_lib_b25708"
    case singleton   = "singleton_4k"
    case gfReduce    = "gf_reduce_table_lib_23840c"
    case bitMask     = "bit_mask_table_lib_1267e0"
    case phase2Pairs = "phase2_pairs"
    case phase5KeySchedRegion = "phase5_keysched_region_274000"
    case child23ProgramRegion = "child23_program_region_435cf0"
    case child23VMStart = "child23_71fb38_vm_start_d843d0"
    case child23VMDesc = "child23_71fb38_vm_desc_d84770"
    case child23StaticTable = "child23_static_table_71e870"
    case child23StaticCopyCode = "child23_static_copy_code_71fca0"
    case child23TTableBExt = "child23_ttable_b_ext_976ea8_100000"
    case firstPairProg64e2b8 = "firstpair_prog_64e2b8_3041b4"
    case firstPairProg638840 = "firstpair_prog_638840_2f5046"
    case firstPair6388f0LowSeedStatics = "firstpair_6388f0_low_seed_statics_2f4d28"
    case firstPair6388f0LowLoopStatics = "firstpair_6388f0_low_loop_statics_2fe600"
    case firstPair6388f0SharedContext = "firstpair_6388f0_shared_context_2cdae1"
    case firstPair6388f0CallerLoopInterleaved = "firstpair_6388f0_caller_loop_interleaved_2cdfa9"
    case firstPair6388f0LaneTables = "firstpair_6388f0_lane_tables_302678"
    case firstPair6388f0SelectorMul = "firstpair_6388f0_selector_mul_116968"
    case firstPair6388f0SelectorAdd = "firstpair_6388f0_selector_add_119788"
    case firstPair63c278U32Tables = "firstpair_63c278_u32_tables_112588"
    case firstPair63c278FoldTables = "firstpair_63c278_fold_tables_2feb18"
    case firstPair633fa8TailFoldTables = "firstpair_633fa8_tail_fold_tables_2fe798"
    case firstPair633fa8TailU32LowTables = "firstpair_633fa8_tail_u32_low_tables_112528"
    case firstPair633fa8NullTables = "firstpair_633fa8_null_tables_2fd1f1"
    case firstPair633fa8NullNibble = "firstpair_633fa8_null_nibble_303a14"
    case firstPairProcess2PublicTables = "firstpair_process2_public_tables_3038c0"
    case firstPairProg67cc18 = "firstpair_prog_67cc18_369862"
    case firstPairFinalLenTables = "firstpair_final_len_tables_372102"
    case firstPairDF80RoundTables = "firstpair_df80_round_tables_37120e"
    case firstPairFinalizerTables = "firstpair_finalizer_tables_370e30"
    case firstPair679f48SeedTables = "firstpair_679f48_seed_tables_37075e"
    case firstPairReducer67ea28Nibble = "firstpair_reducer67ea28_nibble_373cf4"
    case firstPairProg67076c = "firstpair_prog_67076c_35d3ef"

    func load() throws -> Data {
        try Tables.loadData(self)
    }
}
