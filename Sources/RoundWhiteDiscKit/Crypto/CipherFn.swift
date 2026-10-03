import Foundation

// Runtime-tables loader + the catalogue of entries in the installed blob
// (see RuntimeTables.swift). The white-box AES VM that formerly lived here
// (`CipherFn.aes_K`) was only reachable from the kAuth-blob takeover path
// (KAuth / KBKDF / AESCMAC), which is dead — real sensor takeover uses an NFC
// receiver-ID switch, and live pairing/streaming uses LibAES + CommonCrypto.
// It was removed along with its `sbox12`/`bytecode`/`params`/`t5Seed`/
// `singleton`/`phase2Pairs` tables.

enum Tables {
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
    case decode      = "decode_table_lib_237dcc"
    case phase5KeySchedRegion = "phase5_keysched_region_274000"
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
