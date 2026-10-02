import Foundation

public enum FirstPairSourceSliceError: Error, Equatable {
    case invalidEncodedBlockLength(Int)
    case invalidDF80BlockLength(Int)
    case invalidDF80WorkspaceLength(Int)
    case invalidDF80ScheduleLength(Int)
    case invalidDF80StateLength(Int)
    case invalid679f48BlockIndex(UInt32)
    case invalid67aa8cInitialSourceLength(Int)
    case invalid67aa8cInitialFlag(UInt8)
    case invalid67d630BlockLength(Int)
    case invalid67dd7cEncodedLength(Int)
    case invalid67dd7cRawLength(Int)
    case invalid67eb94PendingLength(UInt32)
    case invalid6388f0PrefinalLength(Int)
    case invalid6388f0WorkspaceLength(Int)
    case invalid6388f0StageLength(Int)
    case invalid6388f0PackHeadLength(Int)
    case invalid6388f0PackBodyLength(Int)
    case invalid6388f0LaneBlocksLength(Int)
    case invalid6388f0ScheduleWordCount(Int)
    case invalid6388f0EntryIndex(Int)
    case invalid6388f0RowLimit(Int)
    case invalid641fccPrimer(Int)
    case invalidLowSeedMarker(Int)
    case invalidLowSeedShift(Int)
    case invalidLowSeedPhaseInputCount(String, Int, Int)
    case invalidLowSeedExpandedPreludeLength(Int)
    case invalidLowSeedSeedBlocksLength(Int)
    case invalid633fa8WordCount(Int)
    case invalid633fa8QwordCount(Int)
    case invalid633fa8TailWordCount(String, Int)
    case invalid633fa8NullEntropyLength(Int)
    case invalid633fa8NullSeedBlocksLength(Int)
    case invalid633fa8NullPostAcceptBlocksLength(String, Int)
    case invalid633fa8NullMaxAttempts(Int)
    case rejected633fa8NullEntropy
    case rejected633fa8NullEntropyAfterAttempts(Int)
    case invalidProcess2P5PublicSourceLength(Int)
    case invalidProcess2P5PublicWordCount(String, Int)
    case invalidProcess2P5PublicQwordCount(String, Int)
    case invalidP256ScalarLength(Int)
    case invalidP256PointLength(Int)
    case invalidP256Point
    case invalid63c278VectorWordCount(Int)
    case branchLoopDidNotTerminate(Int)
    case invalidSlice(offset: Int, length: Int)
    case invalidContextLength(Int)
    case nonInvertibleAffineMultiplier(Int)
    case emptySource
    case sliceStartsPastSource(Int)
    case invalidTableSize(String, Int)
    case tableReadOutOfBounds(String, Int)
    case sourceTooShort(String, Int, Int)
}

public struct Builder6388f0Next642f60Inputs: Equatable {
    public let x0: Data
    public let x1: Data
    public let x2: Data

    public init(x0: Data, x1: Data, x2: Data) {
        self.x0 = x0
        self.x1 = x1
        self.x2 = x2
    }
}

public struct Builder6388f0FirstPair642f60Starts: Equatable {
    public let row0: Builder6388f0Next642f60Inputs
    public let row59: Builder6388f0Next642f60Inputs

    public init(row0: Builder6388f0Next642f60Inputs, row59: Builder6388f0Next642f60Inputs) {
        self.row0 = row0
        self.row59 = row59
    }
}

public struct Builder6388f0FirstPairStreamSeeds: Equatable {
    public let nullScalarWindow: Data
    public let staticScalarWindow: Data
    public let nullEntropy11A: Data
    public let nullAttempts: Int
    public let row0Out4: Data
    public let row0Out3: Data
    public let row0Out2: Data
    public let row0Out1: Data
    public let row0Out0: Data
    public let row59Out1: Data
    public let row59Out0: Data

    public init(
        nullScalarWindow: Data,
        staticScalarWindow: Data,
        nullEntropy11A: Data,
        nullAttempts: Int,
        row0Out4: Data,
        row0Out3: Data,
        row0Out2: Data,
        row0Out1: Data,
        row0Out0: Data,
        row59Out1: Data,
        row59Out0: Data
    ) {
        self.nullScalarWindow = nullScalarWindow
        self.staticScalarWindow = staticScalarWindow
        self.nullEntropy11A = nullEntropy11A
        self.nullAttempts = nullAttempts
        self.row0Out4 = row0Out4
        self.row0Out3 = row0Out3
        self.row0Out2 = row0Out2
        self.row0Out1 = row0Out1
        self.row0Out0 = row0Out0
        self.row59Out1 = row59Out1
        self.row59Out0 = row59Out0
    }
}

public struct Builder642f60Result: Equatable {
    public let out0: Data
    public let out1: Data
    public let out2: Data

    public init(out0: Data, out1: Data, out2: Data) {
        self.out0 = out0
        self.out1 = out1
        self.out2 = out2
    }
}

public struct Builder6473d0Result: Equatable {
    public let in0After: Data
    public let in1After: Data
    public let in2After: Data
    public let out0: Data
    public let out1: Data
    public let out2: Data
    public let out3: Data
    public let out4: Data

    public init(
        in0After: Data,
        in1After: Data,
        in2After: Data,
        out0: Data,
        out1: Data,
        out2: Data,
        out3: Data,
        out4: Data
    ) {
        self.in0After = in0After
        self.in1After = in1After
        self.in2After = in2After
        self.out0 = out0
        self.out1 = out1
        self.out2 = out2
        self.out3 = out3
        self.out4 = out4
    }
}

public struct Builder6473d0OutputPreimages: Equatable {
    public let out4: Data
    public let out3: Data
    public let out2: Data
    public let out1: Data
    public let out0: Data

    public init(out4: Data, out3: Data, out2: Data, out1: Data, out0: Data) {
        self.out4 = out4
        self.out3 = out3
        self.out2 = out2
        self.out1 = out1
        self.out0 = out0
    }
}

public struct Builder6388f0CallerLoopTables: Equatable {
    public let first: Data
    public let second: Data

    public init(first: Data, second: Data) {
        self.first = first
        self.second = second
    }
}

public struct Builder6388f0Caller64CallState: Equatable {
    public let arg0: Data
    public let scalar: UInt64
    public let x2Workspace: Data
    public let x3Preimage: Data
    public let stackWindow: Data

    public init(arg0: Data, scalar: UInt64, x2Workspace: Data, x3Preimage: Data, stackWindow: Data) {
        self.arg0 = arg0
        self.scalar = scalar
        self.x2Workspace = x2Workspace
        self.x3Preimage = x3Preimage
        self.stackWindow = stackWindow
    }
}

public struct Builder6388f0Caller64Call: Equatable {
    public let arg0: Data
    public let scalar: UInt64
    public let x2Workspace: Data
    public let x3Preimage: Data
    public let stackWindow: Data
    public let output: Data

    public init(
        arg0: Data,
        scalar: UInt64,
        x2Workspace: Data,
        x3Preimage: Data,
        stackWindow: Data,
        output: Data
    ) {
        self.arg0 = arg0
        self.scalar = scalar
        self.x2Workspace = x2Workspace
        self.x3Preimage = x3Preimage
        self.stackWindow = stackWindow
        self.output = output
    }
}

public struct Builder6388f0SeededCaller64Row: Equatable {
    public let index: Int
    public let current642f60: Builder6388f0Next642f60Inputs
    public let preimages: Builder6473d0OutputPreimages
    public let after642f60: Builder642f60Result
    public let after6473d0: Builder6473d0Result
    public let minimalStack20: Data
    public let first64cd40: Builder6388f0Caller64Call
    public let second64cd40: Builder6388f0Caller64Call
    public let third64cd40: Builder6388f0Caller64Call
    public let next642f60: Builder6388f0Next642f60Inputs

    public init(
        index: Int,
        current642f60: Builder6388f0Next642f60Inputs,
        preimages: Builder6473d0OutputPreimages,
        after642f60: Builder642f60Result,
        after6473d0: Builder6473d0Result,
        minimalStack20: Data,
        first64cd40: Builder6388f0Caller64Call,
        second64cd40: Builder6388f0Caller64Call,
        third64cd40: Builder6388f0Caller64Call,
        next642f60: Builder6388f0Next642f60Inputs
    ) {
        self.index = index
        self.current642f60 = current642f60
        self.preimages = preimages
        self.after642f60 = after642f60
        self.after6473d0 = after6473d0
        self.minimalStack20 = minimalStack20
        self.first64cd40 = first64cd40
        self.second64cd40 = second64cd40
        self.third64cd40 = third64cd40
        self.next642f60 = next642f60
    }
}

public struct Builder6388f0Seeded63c278Stream: Equatable {
    public let rowIndex: Int
    public let arg0: Data
    public let arg1: Data
    public let arg2: Data
    public let scalar: UInt64
    public let scheduleWords: [UInt32]

    public init(rowIndex: Int, arg0: Data, arg1: Data, arg2: Data, scalar: UInt64, scheduleWords: [UInt32]) {
        self.rowIndex = rowIndex
        self.arg0 = arg0
        self.arg1 = arg1
        self.arg2 = arg2
        self.scalar = scalar
        self.scheduleWords = scheduleWords
    }
}

public struct Builder6388f0Seeded63c278Schedules: Equatable {
    public let first: Builder6388f0Seeded63c278Stream
    public let second: Builder6388f0Seeded63c278Stream

    public init(first: Builder6388f0Seeded63c278Stream, second: Builder6388f0Seeded63c278Stream) {
        self.first = first
        self.second = second
    }
}

public struct Builder6388f0HighSeedStreamStartSeeds: Equatable {
    public let out0: Data
    public let out1: Data

    public init(out0: Data, out1: Data) {
        self.out0 = out0
        self.out1 = out1
    }
}

public struct Builder6388f0FirstPairHighSeedStreamStartSeeds: Equatable {
    public let row0: Builder6388f0HighSeedStreamStartSeeds
    public let row59: Builder6388f0HighSeedStreamStartSeeds

    public init(row0: Builder6388f0HighSeedStreamStartSeeds, row59: Builder6388f0HighSeedStreamStartSeeds) {
        self.row0 = row0
        self.row59 = row59
    }
}

public struct Builder6388f0LowSeedCF0Seeds: Equatable {
    public let phase1: Data
    public let phase2: Data
    public let phase3: Data

    public init(phase1: Data, phase2: Data, phase3: Data) {
        self.phase1 = phase1
        self.phase2 = phase2
        self.phase3 = phase3
    }
}

public struct Builder6388f0LowSeedTailPair: Equatable {
    public let left: Data
    public let right: Data

    public init(left: Data, right: Data) {
        self.left = left
        self.right = right
    }
}

public struct Builder6388f0LowSeedLoopResult: Equatable {
    public let final6377f0: Data
    public let scheduleWords: [UInt32]

    public init(final6377f0: Data, scheduleWords: [UInt32]) {
        self.final6377f0 = final6377f0
        self.scheduleWords = scheduleWords
    }
}

public struct Builder6388f0Row0LowSeedPreimages: Equatable {
    public let out4: Data
    public let out3: Data
    public let out2: Data

    public init(out4: Data, out3: Data, out2: Data) {
        self.out4 = out4
        self.out3 = out3
        self.out2 = out2
    }
}

public struct Builder633fa8TailBoundary: Equatable {
    public let words3ab0: [UInt32]
    public let words3120: [UInt32]
    public let words2dfc: [UInt32]
    public let seed3110: UInt64
    public let preludeSource: Data

    public init(
        words3ab0: [UInt32],
        words3120: [UInt32],
        words2dfc: [UInt32],
        seed3110: UInt64,
        preludeSource: Data
    ) {
        self.words3ab0 = words3ab0
        self.words3120 = words3120
        self.words2dfc = words2dfc
        self.seed3110 = seed3110
        self.preludeSource = preludeSource
    }
}

public struct Builder633fa8NullEntrySources: Equatable {
    public let prologueSource: Data
    public let check1SourceWords: [UInt32]
    public let check2SourceWords: [UInt32]

    public init(prologueSource: Data, check1SourceWords: [UInt32], check2SourceWords: [UInt32]) {
        self.prologueSource = prologueSource
        self.check1SourceWords = check1SourceWords
        self.check2SourceWords = check2SourceWords
    }
}

public struct Builder633fa8NullInitialResult: Equatable {
    public let maskedEntropy: Data
    public let cf0: Data
    public let e10: Data
    public let seedInputs: Data
    public let seedBlocks: Data

    public init(maskedEntropy: Data, cf0: Data, e10: Data, seedInputs: Data, seedBlocks: Data) {
        self.maskedEntropy = maskedEntropy
        self.cf0 = cf0
        self.e10 = e10
        self.seedInputs = seedInputs
        self.seedBlocks = seedBlocks
    }
}

public struct Builder633fa8NullFirstLoopResult: Equatable {
    public let finalTLane: Data
    public let scheduleWords: [UInt32]

    public init(finalTLane: Data, scheduleWords: [UInt32]) {
        self.finalTLane = finalTLane
        self.scheduleWords = scheduleWords
    }
}

public struct Builder633fa8NullScheduleAcceptance: Equatable {
    public let firstOK: Bool
    public let secondOK: Bool

    public init(firstOK: Bool, secondOK: Bool) {
        self.firstOK = firstOK
        self.secondOK = secondOK
    }
}

public struct Builder633fa8NullPostAcceptResult: Equatable {
    public let blocks4080: Data
    public let blocks3f40: Data

    public init(blocks4080: Data, blocks3f40: Data) {
        self.blocks4080 = blocks4080
        self.blocks3f40 = blocks3f40
    }
}

public struct Builder633fa8NullScalarResult: Equatable {
    public let scalarWindow: Data
    public let entropy11A: Data
    public let attempts: Int

    public init(scalarWindow: Data, entropy11A: Data, attempts: Int) {
        self.scalarWindow = scalarWindow
        self.entropy11A = entropy11A
        self.attempts = attempts
    }
}

public struct Builder5bcf98P256Outputs: Equatable {
    public let xOutput70: Data
    public let yOutput70: Data

    public init(xOutput70: Data, yOutput70: Data) {
        self.xOutput70 = xOutput70
        self.yOutput70 = yOutput70
    }
}

// Clean-room port of the final first-pair source slicer at lib+0x64de54.
// This starts from already-encoded 66-byte descriptor blocks and emits the
// encoded 66-byte Phase 5 key-source descriptor consumed by Phase5KeySchedule.
public enum FirstPairSourceSlice {
    // Candidate invariant 532-byte entry source consumed by the row-0 low-seed
    // path. Python default: BUILDER_6388F0_LOW_SEED_ENTRY_SOURCE.
    public static let bundled6388f0LowSeedEntrySource = Data(hexBytes(
        "0500000701060202030607010603030501000503000607040400050105030105" +
        "0507020005000507050206000104000603060102060003070003020006010703" +
        "0303040500040303060500050705000306000704060701060200020002040701" +
        "0604030706020405010303030204040400040004070107020706040301070407" +
        "0207060403050302020201070700020001050603000500050607000505000707" +
        "0105070407010205010301020001040707060604050700010502000201020203" +
        "0702020502070700030707070002000401030303010204000702000106020703" +
        "0304000606040205040003050305030706020500030305030002040101030204" +
        "0305060407010400000204000307040401010706010607040205000503060000" +
        "0704040002050105000707030504030502060405050503010103030000040305" +
        "0007070207070301020204030701020706010305050506000401050700030607" +
        "0704050403060601050204020405030302060701040002030507000604020502" +
        "0705000306000000010303070402030204040303060507020500040603000607" +
        "0007000104000102050202060700020101050005050302050300030503000006" +
        "0404050005030107050505070203040604050402070007010106020401010005" +
        "0003070206060006000401020006010303020403020101010606050607030505" +
        "0403070707070507020300040707000304020001"
    ))

    public static let pre63c278Arg0Source = Data([
        0x21, 0xed, 0x7e, 0x8f, 0xc9, 0x86, 0x29, 0x76,
        0xac, 0x50, 0xb4, 0xcb, 0x1e, 0x31, 0xa9, 0x1f,
        0x30, 0xfa, 0x05, 0xc7, 0x06, 0x82, 0xac, 0x26,
        0xbc, 0x7d, 0xb7, 0x62, 0x19, 0xfd, 0x1d, 0x35,
        0x21, 0xed, 0x7e, 0x8f, 0xb9, 0x8b, 0xbe, 0x51,
        0xa3, 0x76, 0x9d, 0xa0, 0xc5, 0x08, 0x6c, 0x23,
        0x30, 0xfa, 0x05, 0xc7, 0x06, 0x82, 0xac, 0x26,
        0xbc, 0x7d, 0xb7, 0xd1, 0x19, 0xfd, 0x1d, 0x35,
        0x46, 0x68, 0x3b, 0x2a, 0x18, 0xd7, 0xe2, 0xe2,
        0xa3, 0x76, 0x9d, 0xa0, 0xc5, 0x08, 0x6c, 0x23,
        0x30, 0xfa, 0x05, 0xc7, 0x06, 0x82, 0xac, 0x26,
    ])
    public static let pre63c278Scalar: UInt64 = 0x33b7dca8cdf2d720
    public static let streamStart642f60X2Source = Data([
        0x4c, 0x2d, 0xf3, 0x05, 0xdd, 0xb7, 0x0c, 0x76,
        0xe8, 0x2a, 0xd4, 0x04, 0x3b, 0xe2, 0xee, 0xa5,
        0x81, 0xab, 0x69, 0xf3, 0x7c, 0xaa, 0x49, 0xf5,
        0xfa, 0x7d, 0x43, 0x81, 0x2f, 0x10, 0x25, 0x05,
        0xd3, 0x4e, 0x67, 0xbe, 0x8d, 0x2e, 0x98, 0xd3,
        0xe8, 0x2a, 0xe3, 0x78, 0x3b, 0x32, 0xb0, 0x16,
        0x81, 0xab, 0x69, 0x5c, 0xe3, 0x6c, 0x62, 0xec,
        0xa5, 0x62, 0x1f, 0xaf, 0xcf, 0x68, 0x46, 0x16,
        0xc5, 0x19, 0x8a, 0x79, 0x48, 0xa0, 0x3a, 0xd3,
        0xe8, 0x2a, 0xe3, 0x78, 0x3b, 0x32, 0xb0, 0x16,
        0x81, 0xab, 0x69, 0x5c, 0xe3, 0x6c, 0x62, 0xec,
    ])
    public static let highSeed6421c0X2Source = Data([
        0xd6, 0xce, 0x5d, 0x63, 0xde, 0x75, 0xb3, 0x91,
        0x43, 0x98, 0xc9, 0xa1, 0x23, 0x40, 0x76, 0x0f,
        0x3c, 0x69, 0x5a, 0x13, 0x9c, 0xbb, 0xc9, 0x13,
        0x5d, 0x94, 0xf6, 0x57, 0xb7, 0x29, 0x9c, 0xb1,
        0x82, 0x46, 0x31, 0x56, 0x4e, 0x88, 0x5b, 0x47,
        0x9d, 0x21, 0x1c, 0xae, 0xf3, 0x69, 0xd9, 0xea,
        0x19, 0xae, 0x4d, 0x0d, 0xc9, 0x70, 0x20, 0x4b,
        0x5d, 0x94, 0xf6, 0x84, 0xd7, 0xde, 0x58, 0xc2,
        0x35, 0xac, 0xa4, 0x60, 0xfc, 0x3d, 0xd5, 0xb4,
        0xc8, 0x46, 0x76, 0x15, 0xc0, 0xa7, 0xe6, 0xc0,
        0x19, 0xae, 0x4d, 0x0d, 0xc9, 0x70, 0x20, 0x4b,
    ])
    public static let highSeed6421c0X1Source = Data([
        0xf9, 0xb8, 0xa2, 0x3b, 0x79, 0x89, 0x3d, 0xab,
        0x28, 0xf6, 0x8f, 0x89, 0x3a, 0x72, 0x9b, 0xfc,
        0x43, 0x32, 0x3b, 0x85, 0x8f, 0xcb, 0xd6, 0x95,
        0xf4, 0xd2, 0x62, 0x09, 0x77, 0x91, 0x59, 0xaf,
        0xa1, 0x03, 0xdf, 0xee, 0x09, 0x58, 0xb8, 0x3b,
        0xb5, 0x0a, 0x88, 0x9d, 0x20, 0x4a, 0xad, 0xbb,
        0xa4, 0x80, 0x61, 0x06, 0xa7, 0x57, 0x0b, 0xca,
        0xf4, 0x52, 0x42, 0xee, 0x5f, 0xa7, 0xa2, 0x7e,
        0xac, 0x8b, 0xc6, 0xb0, 0x87, 0xa3, 0x03, 0x84,
        0xa3, 0xc2, 0xaf, 0x99, 0x20, 0x4a, 0xad, 0xbb,
        0xa4, 0x80, 0x61, 0x06, 0xa7, 0x57, 0x0b, 0xca,
    ])
    public static let highSeed6421c0Scalar: UInt64 = 0x68404ef676a9b7d3

    public static func init679f48Context() throws -> Data {
        let tables = try cachedTables.get()
        var context = [UInt8](repeating: 0, count: context679f48Size)

        for spec in init679f48Block18Specs {
            let src = try checkedSlice(
                tables.seedTables679f48,
                spec.srcOffset,
                df80WordSize,
                RuntimeTable.firstPair679f48SeedTables.rawValue
            )
            replace(
                &context,
                at: spec.dstOffset,
                with: try vm67cc18(magic: spec.magic, src1: src, src2: src, tables: tables)
            )
        }

        let src66 = try checkedSlice(
            tables.seedTables679f48,
            init679f48Block66SrcOffset,
            block66Size,
            RuntimeTable.firstPair679f48SeedTables.rawValue
        )
        let block66 = try vm67cc18(magic: 0x42000001e72, src1: src66, src2: src66, tables: tables)
        for dstOffset in init679f48Block66DstOffsets {
            replace(&context, at: dstOffset, with: block66)
        }
        return Data(context)
    }

    public static func update67aa8cLen4Initial(context: Data, src4: Data) throws -> Data {
        guard src4.count == 4 else {
            throw FirstPairSourceSliceError.invalid67aa8cInitialSourceLength(src4.count)
        }
        guard context.count >= context679f48Size else {
            throw FirstPairSourceSliceError.sourceTooShort("67aa8c context", context.count, context679f48Size)
        }
        let tables = try cachedTables.get()
        var ctx = [UInt8](context)
        guard ctx[0x1a4] == 0 else {
            throw FirstPairSourceSliceError.invalid67aa8cInitialFlag(ctx[0x1a4])
        }

        ctx[0x1a4] = 1
        try seed67aa8cInitialWords(context: &ctx, tables: tables)
        replace(&ctx, at: 0x1a5, with: [UInt8](src4))
        writeUInt32LE(4, into: &ctx, at: 0x1e8)
        return Data(ctx)
    }

    public static func apply67eb94PendingBlocks(context: Data) throws -> Data {
        guard context.count >= context679f48Size else {
            throw FirstPairSourceSliceError.sourceTooShort("67eb94 context", context.count, context679f48Size)
        }
        let tables = try cachedTables.get()
        var ctx = [UInt8](context)
        if ctx[0x1a4] == 0 {
            return Data(ctx)
        }

        ctx[0x1a4] = 0
        var words: [[UInt8]] = []
        words.reserveCapacity(8)
        for index in 0..<8 {
            let start = 0x1ec + index * 4
            words.append(Array(ctx[start..<(start + 4)]))
        }
        replace(&ctx, at: 0x114, with: try update67eb94Blocks(wordsLE: words, tables: tables))
        return Data(ctx)
    }

    public static func encode67d630Block(_ src: Data) throws -> Data {
        guard src.count > 0 && src.count <= 0x10 else {
            throw FirstPairSourceSliceError.invalid67d630BlockLength(src.count)
        }
        let tables = try cachedTables.get()
        let srcBytes = [UInt8](src)
        var scratch16 = [UInt8](repeating: 0, count: 0x10)
        for index in 0..<srcBytes.count {
            scratch16[0x10 - srcBytes.count + index] = srcBytes[srcBytes.count - 1 - index]
        }

        var sideA: [UInt8] = []
        var sideB: [UInt8] = []
        sideA.reserveCapacity(0x60)
        sideB.reserveCapacity(0x60)
        for byte in scratch16 {
            sideA.append(contentsOf: try expandRawByte67d630(byte, tableOffset: raw67d630TableAOffset, tables: tables))
            sideB.append(contentsOf: try expandRawByte67d630(byte, tableOffset: raw67d630TableBOffset, tables: tables))
        }

        let foldedA = try fold96To66(firstMagic: 0x600000032b2, tailMagic: 0x60000005e9c, src96: sideA, tables: tables)
        let mixedA = try vm67cc18(magic: 0x42000004b29, src1: foldedA, src2: foldedA, tables: tables)

        let foldedB = try fold96To66(firstMagic: 0x60000000133, tailMagic: 0x600000033db, src96: sideB, tables: tables)
        let mixedB = try vm67cc18(magic: 0x42000000263, src1: foldedB, src2: foldedB, tables: tables)

        let mixed = try vm67cc18(magic: 0x42000000b0e, src1: mixedA, src2: mixedB, tables: tables)
        return Data(try vm67d524(magic: 0xc03f000c0112f, src: mixed, tables: tables))
    }

    public static func apply67eb94WithPendingRawAdapter(context: Data) throws -> Data {
        guard context.count >= context679f48Size else {
            throw FirstPairSourceSliceError.sourceTooShort("67eb94 context", context.count, context679f48Size)
        }
        var ctx = [UInt8](context)
        if ctx[0x1a4] == 0 {
            return Data(ctx)
        }
        let pendingLength = readUInt32LE(ctx, 0x1e8)
        guard pendingLength <= 0x40 else {
            throw FirstPairSourceSliceError.invalid67eb94PendingLength(pendingLength)
        }

        ctx = [UInt8](try apply67eb94PendingBlocks(context: Data(ctx)))
        let pending = try checkedSlice(ctx, 0x1a5, Int(pendingLength), "67eb94 pending bytes")
        var offset = 0
        while offset < pending.count {
            let end = min(offset + 0x10, pending.count)
            let chunk = Array(pending[offset..<end])
            let encoded = try encode67d630Block(Data(chunk))
            ctx = [UInt8](try apply67dd7cUpdateUntilDF80(
                context: Data(ctx),
                encoded66: encoded,
                rawLength: chunk.count
            ))
            offset = end
        }
        writeUInt32LE(0, into: &ctx, at: 0x1e8)
        return Data(ctx)
    }

    public static func apply67dd7cUpdateUntilDF80(
        context: Data,
        encoded66: Data,
        rawLength: Int
    ) throws -> Data {
        guard context.count >= context679f48Size else {
            throw FirstPairSourceSliceError.sourceTooShort("67dd7c context", context.count, context679f48Size)
        }
        guard encoded66.count == block66Size else {
            throw FirstPairSourceSliceError.invalid67dd7cEncodedLength(encoded66.count)
        }
        guard rawLength > 0 && rawLength <= 0x10 else {
            throw FirstPairSourceSliceError.invalid67dd7cRawLength(rawLength)
        }

        let tables = try cachedTables.get()
        var ctx = [UInt8](context)
        let encoded = [UInt8](encoded66)
        let contextLength = readUInt64LE(ctx, 0)
        let low = Int(contextLength & 0x0f)
        let room = 0x10 - low
        var blockIndex = readUInt32LE(ctx, 0x110)
        let slot = 0x08 + Int(blockIndex) * block66Size

        if low != 0 {
            var staged = try vm67cc18(magic: 0x42000005c05, src1: encoded, src2: encoded, tables: tables)
            for _ in 0..<low {
                staged = try vm67cecc(magic: 0x1003e001002eaf, src1: staged, src2: staged, tables: tables)
            }

            let pad = try checkedSlice(
                tables.finalizerTables,
                finalizerDD7CPadOffset + (low ^ 0x0f) * block66Size,
                block66Size,
                RuntimeTable.firstPairFinalizerTables.rawValue
            )
            let current = try checkedSlice(ctx, slot, block66Size, "67dd7c context slot")
            let prefix = try vm67cc18(magic: 0x42000002fd4, src1: current, src2: pad, tables: tables)
            replace(
                &ctx,
                at: slot,
                with: try vm67cc18(magic: 0x42000003060, src1: prefix, src2: staged, tables: tables)
            )
        } else {
            replace(
                &ctx,
                at: slot,
                with: try vm67cc18(magic: 0x42000001c66, src1: encoded, src2: encoded, tables: tables)
            )
        }

        if room <= rawLength {
            blockIndex += 1
            writeUInt32LE(blockIndex, into: &ctx, at: 0x110)
            if blockIndex == 4 {
                let transformed = try df80Transform(
                    state: Data(ctx[0x114..<0x1a4]),
                    blocks: Data(ctx[0x08..<0x110])
                )
                replace(&ctx, at: 0x114, with: [UInt8](transformed))
                blockIndex = 0
                writeUInt32LE(0, into: &ctx, at: 0x110)
            }

            if room < rawLength {
                var remainder = try vm67cc18(magic: 0x42000003d8b, src1: encoded, src2: encoded, tables: tables)
                for _ in 0..<room {
                    remainder = try shift67dd7cRemainder(remainder, tables: tables)
                }
                let nextSlot = 0x08 + Int(blockIndex) * block66Size
                replace(
                    &ctx,
                    at: nextSlot,
                    with: try vm67cc18(magic: 0x420000008de, src1: remainder, src2: remainder, tables: tables)
                )
            }
        }

        writeUInt64LE(contextLength + UInt64(rawLength), into: &ctx, at: 0)
        return Data(ctx)
    }

    public static func previousDescriptorBlocksToDD7CInputs(previousBlocks: Data) throws -> Data {
        guard previousBlocks.count % block66Size == 0 else {
            throw FirstPairSourceSliceError.invalidEncodedBlockLength(previousBlocks.count)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](previousBlocks)
        var out: [UInt8] = []
        out.reserveCapacity(previousBlocks.count)
        for start in stride(from: 0, to: bytes.count, by: block66Size) {
            let block = Array(bytes[start..<(start + block66Size)])
            let encoded = try vm67cc18(magic: 0x42000001341, src1: block, src2: block, tables: tables)
            let staged = try vm67cc18(magic: 0x420000053ba, src1: encoded, src2: encoded, tables: tables)
            out.append(contentsOf: try vm67cc18(magic: 0x42000000c2c, src1: staged, src2: staged, tables: tables))
        }
        return Data(out)
    }

    public static func finalized679f48ContextFromInputs(
        previousBlocks: Data,
        src4: Data = Data([0, 0, 0, 1])
    ) throws -> Data {
        var context = try init679f48Context()
        context = try update67aa8cLen4Initial(context: context, src4: src4)
        context = try apply67eb94WithPendingRawAdapter(context: context)

        let fullUpdates = try previousDescriptorBlocksToDD7CInputs(previousBlocks: previousBlocks)
        let updateBytes = [UInt8](fullUpdates)
        for start in stride(from: 0, to: updateBytes.count, by: block66Size) {
            context = try apply67dd7cUpdateUntilDF80(
                context: context,
                encoded66: Data(updateBytes[start..<(start + block66Size)]),
                rawLength: 0x10
            )
        }

        context = try apply67eb94WithPendingRawAdapter(context: context)
        return try finalize679f48ToSecondDF80(context: context)
    }

    public static func deriveFrom679f48Inputs(
        previousBlocks: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let context = try finalized679f48ContextFromInputs(previousBlocks: previousBlocks, src4: src4)
        return try deriveFromFinalized679f48Context(context, offset: offset, length: length)
    }

    public static func constructor670978Ptr28Blocks(rawDescriptorBlocks: Data) throws -> Data {
        try constructor67076cBlocks(rawDescriptorBlocks: rawDescriptorBlocks, magic: 0x42000000000)
    }

    public static func constructor670a54Ptr10Blocks(rawDescriptorBlocks: Data) throws -> Data {
        try constructor67076cBlocks(rawDescriptorBlocks: rawDescriptorBlocks, magic: 0x42000000042)
    }

    public static func deriveFrom660448RawDescriptor(
        rawDescriptorBlocks: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let previousBlocks = try constructor670978Ptr28Blocks(rawDescriptorBlocks: rawDescriptorBlocks)
        return try deriveFrom679f48Inputs(previousBlocks: previousBlocks, src4: src4, offset: offset, length: length)
    }

    public static func deriveFrom660448Sources(
        firstRawBlocks: Data,
        secondRawBlocks: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        var combined = Data()
        combined.append(firstRawBlocks)
        combined.append(secondRawBlocks)
        return try deriveFrom660448RawDescriptor(
            rawDescriptorBlocks: combined,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom64d774RawStreams(
        firstRawBlocks: Data,
        secondRawBlocks: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let firstFor660448 = try constructor670a54Ptr10Blocks(rawDescriptorBlocks: firstRawBlocks)
        let secondFor660448 = try constructor670a54Ptr10Blocks(rawDescriptorBlocks: secondRawBlocks)
        return try deriveFrom660448Sources(
            firstRawBlocks: firstFor660448,
            secondRawBlocks: secondFor660448,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func builder6388f0FinalRawBlocks(internalBlocks: Data) throws -> Data {
        guard internalBlocks.count % block66Size == 0 else {
            throw FirstPairSourceSliceError.invalidEncodedBlockLength(internalBlocks.count)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](internalBlocks)
        var out: [UInt8] = []
        out.reserveCapacity(internalBlocks.count)
        for start in stride(from: 0, to: bytes.count, by: block66Size) {
            let block = Array(bytes[start..<(start + block66Size)])
            out.append(contentsOf: try vm638840(magic: 0x42000007e29, src1: block, src2: block, tables: tables))
        }
        return Data(out)
    }

    public static func builder6388f0PrefinalLen32InternalBlocks(prefinalSourceBlocks: Data) throws -> Data {
        guard prefinalSourceBlocks.count == 2 * block66Size else {
            throw FirstPairSourceSliceError.invalid6388f0PrefinalLength(prefinalSourceBlocks.count)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](prefinalSourceBlocks)
        let call0 = Array(bytes[0..<block66Size])
        let call1 = Array(bytes[block66Size..<(2 * block66Size)])
        let block1 = try vm638840(magic: 0x42000003bf9, src1: call0, src2: call0, tables: tables)
        let block0 = try vm638840(magic: 0x42000003bf9, src1: call1, src2: call1, tables: tables)
        return Data(block0 + block1)
    }

    public static func builder6388f0Len32PrefinalSourcesFromWorkspace(workspaceSource: Data) throws -> Data {
        guard workspaceSource.count == builder6388f0WorkspaceSize else {
            throw FirstPairSourceSliceError.invalid6388f0WorkspaceLength(workspaceSource.count)
        }
        let tables = try cachedTables.get()
        let source = [UInt8](workspaceSource)
        let workspace = try vm638840(magic: 0x10a000006cd1, src1: source, src2: source, tables: tables)
        guard workspace.count == builder6388f0WorkspaceSize else {
            throw FirstPairSourceSliceError.invalid6388f0WorkspaceLength(workspace.count)
        }

        let firstPrefinal = Array(workspace[0..<block66Size])
        let updated = try vm6420d8(magic: 0x1000ca0100063f1, src1: workspace, src2: workspace, tables: tables)
        guard updated.count == builder6388f0WorkspaceSize else {
            throw FirstPairSourceSliceError.invalid6388f0WorkspaceLength(updated.count)
        }

        let secondPrefinal = Array(updated[0..<block66Size])
        return Data(firstPrefinal + secondPrefinal)
    }

    public static func builder6388f0Len32PrefinalSourcesFromStageInputs(
        stageASource: Data,
        stageBSource: Data
    ) throws -> Data {
        guard stageASource.count == builder6388f0StageSize else {
            throw FirstPairSourceSliceError.invalid6388f0StageLength(stageASource.count)
        }
        guard stageBSource.count == builder6388f0StageSize else {
            throw FirstPairSourceSliceError.invalid6388f0StageLength(stageBSource.count)
        }

        let tables = try cachedTables.get()
        let a = [UInt8](stageASource)
        let b = [UInt8](stageBSource)
        let stageA = try vm638840(magic: 0x11a000003e76, src1: a, src2: a, tables: tables)
        let stageB = try vm638840(magic: 0x11a000004f0c, src1: b, src2: stageA, tables: tables)
        let stageC = try vm638840(magic: 0x11a000004b16, src1: stageB, src2: stageA, tables: tables)
        let stageDSource = Array(stageC[0..<builder6388f0WorkspaceSize])
        let stageD = try vm638840(magic: 0x10a0000078bb, src1: stageDSource, src2: stageDSource, tables: tables)
        return try builder6388f0Len32PrefinalSourcesFromWorkspace(workspaceSource: Data(stageD))
    }

    public static func pack6388f0Twenty16To282(head16: Data, bodyBlocks16: Data) throws -> Data {
        guard head16.count == builder6388f0LaneBlockSize else {
            throw FirstPairSourceSliceError.invalid6388f0PackHeadLength(head16.count)
        }
        guard bodyBlocks16.count == (builder6388f0LaneBlockCount - 1) * builder6388f0LaneBlockSize else {
            throw FirstPairSourceSliceError.invalid6388f0PackBodyLength(bodyBlocks16.count)
        }

        let body = [UInt8](bodyBlocks16)
        var out = [UInt8](head16)
        out.reserveCapacity(builder6388f0StageSize)
        for offset in stride(from: 0, to: body.count, by: builder6388f0LaneBlockSize) {
            out.append(contentsOf: body[(offset + 2)..<(offset + builder6388f0LaneBlockSize)])
        }
        return Data(out)
    }

    public static func builder6388f0Len32StageInputsFromPackOutputs(
        stageBPackHead16: Data,
        stageBPackBody16: Data,
        stageAPackHead16: Data,
        stageAPackBody16: Data
    ) throws -> (stageASource: Data, stageBSource: Data) {
        let stageBPack = try pack6388f0Twenty16To282(head16: stageBPackHead16, bodyBlocks16: stageBPackBody16)
        let tables = try cachedTables.get()
        let stageBPackBytes = [UInt8](stageBPack)
        let stageBSource = try vm638840(
            magic: 0x11a000000a2c,
            src1: stageBPackBytes,
            src2: stageBPackBytes,
            tables: tables
        )
        let stageASource = try pack6388f0Twenty16To282(head16: stageAPackHead16, bodyBlocks16: stageAPackBody16)
        return (stageASource, Data(stageBSource))
    }

    public static func builder6388f0PackOutputsFromLaneBlocks(
        primaryLaneBlocks: Data,
        secondaryLaneBlocks: Data
    ) throws -> (
        stageBPackHead16: Data,
        stageBPackBody16: Data,
        stageAPackHead16: Data,
        stageAPackBody16: Data
    ) {
        guard primaryLaneBlocks.count == builder6388f0LaneBlocksSize else {
            throw FirstPairSourceSliceError.invalid6388f0LaneBlocksLength(primaryLaneBlocks.count)
        }
        guard secondaryLaneBlocks.count == builder6388f0LaneBlocksSize else {
            throw FirstPairSourceSliceError.invalid6388f0LaneBlocksLength(secondaryLaneBlocks.count)
        }

        let tables = try cachedTables.get()
        let primaryBytes = [UInt8](primaryLaneBlocks)
        let secondaryBytes = [UInt8](secondaryLaneBlocks)
        var primary: [[UInt8]] = []
        var secondary: [[UInt8]] = []
        primary.reserveCapacity(builder6388f0LaneBlockCount)
        secondary.reserveCapacity(builder6388f0LaneBlockCount)
        for offset in stride(from: 0, to: builder6388f0LaneBlocksSize, by: builder6388f0LaneBlockSize) {
            primary.append(Array(primaryBytes[offset..<(offset + builder6388f0LaneBlockSize)]))
            secondary.append(Array(secondaryBytes[offset..<(offset + builder6388f0LaneBlockSize)]))
        }

        let stageBPackHead = try vm638840(magic: 0x10000000388, src1: primary[0], src2: primary[0], tables: tables)
        var stageBPackBody: [UInt8] = []
        stageBPackBody.reserveCapacity((builder6388f0LaneBlockCount - 1) * builder6388f0LaneBlockSize)
        for block in primary.dropFirst() {
            stageBPackBody.append(contentsOf: try vm638840(magic: 0x10000003bd7, src1: block, src2: block, tables: tables))
        }

        let stageAPackHead = try vm638840(magic: 0x100000062d7, src1: secondary[0], src2: secondary[0], tables: tables)
        var stageAPackBody: [UInt8] = []
        stageAPackBody.reserveCapacity((builder6388f0LaneBlockCount - 1) * builder6388f0LaneBlockSize)
        for block in secondary.dropFirst() {
            stageAPackBody.append(contentsOf: try vm638840(magic: 0x10000008177, src1: block, src2: block, tables: tables))
        }

        return (
            Data(stageBPackHead),
            Data(stageBPackBody),
            Data(stageAPackHead),
            Data(stageAPackBody)
        )
    }

    public static func builder63c278InitialVectors(
        arg0: Data,
        arg1: Data
    ) throws -> (x1Vec44: [UInt64], x0Vec22: [UInt64]) {
        guard arg0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("63c278 arg0", arg0.count, builder63c278VectorBytes)
        }
        guard arg1.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("63c278 arg1", arg1.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let arg0Bytes = [UInt8](arg0)
        let arg1Bytes = [UInt8](arg1)

        var x1: [UInt64] = []
        x1.reserveCapacity(44)
        for index in 0..<builder63c278VectorWords {
            x1.append(try builder63c278X1Word(readUInt32LE(arg1Bytes, index * 4), index: index, tables: tables))
        }
        x1.append(contentsOf: repeatElement(0xb7059a553c133489, count: builder63c278VectorWords))

        var x0: [UInt64] = []
        x0.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            x0.append(try builder63c278X0Word(readUInt32LE(arg0Bytes, index * 4), index: index, tables: tables))
        }
        return (x1, x0)
    }

    public static func builder63c278SecondInitialVectors(
        arg0: Data,
        arg2: Data
    ) throws -> (x2Vec44: [UInt64], x0Vec22: [UInt64]) {
        guard arg0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("63c278 arg0", arg0.count, builder63c278VectorBytes)
        }
        guard arg2.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("63c278 arg2", arg2.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let arg0Bytes = [UInt8](arg0)
        let arg2Bytes = [UInt8](arg2)

        var x2: [UInt64] = []
        x2.reserveCapacity(44)
        for index in 0..<builder63c278VectorWords {
            x2.append(try builder63c278X2Word(readUInt32LE(arg2Bytes, index * 4), index: index, tables: tables))
        }
        x2.append(contentsOf: repeatElement(0x9a6e0b3eab651f3d, count: builder63c278VectorWords))

        var x0: [UInt64] = []
        x0.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            x0.append(try builder63c278X0BWord(readUInt32LE(arg0Bytes, index * 4), index: index, tables: tables))
        }
        return (x2, x0)
    }

    public static func builder63c278ScalarMixVector(
        x1Vec44: [UInt64],
        x0Vec22: [UInt64],
        scalar: UInt64
    ) throws -> [UInt64] {
        guard x1Vec44.count == 44 else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(x1Vec44.count)
        }
        guard x0Vec22.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(x0Vec22.count)
        }
        let tables = try cachedTables.get()
        var vec = x1Vec44
        let scalarMul = (scalar &* 0xc2f49ab55607d661) &+ 0x5cd21b4822401581
        let scalarAdd = (scalar &* 0x31979e72b90f9217) &+ 0x3a834f793d8d50d2

        var carry = vec[0]
        for index in 0..<builder63c278VectorWords {
            let seed = try builder63c278MixSeed(carry: carry, scalarMul: scalarMul, scalarAdd: scalarAdd, tables: tables)
            for lane in 0..<builder63c278VectorWords {
                let pos = index + lane
                vec[pos] = vec[pos] &+ seed.laneAdd &+ (x0Vec22[lane] &* seed.updateMul)
            }

            carry = try builder63c278NextCarry(updatedFirst: vec[index], updatedSecond: vec[index + 1], tables: tables)
            vec[index + 1] = carry
        }
        return vec
    }

    public static func builder63c278ScalarMix2Vector(
        x2Vec44: [UInt64],
        x0Vec22: [UInt64],
        scalar: UInt64
    ) throws -> [UInt64] {
        guard x2Vec44.count == 44 else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(x2Vec44.count)
        }
        guard x0Vec22.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(x0Vec22.count)
        }
        let tables = try cachedTables.get()
        var vec = x2Vec44
        let scalarMul = (scalar &* 0xd499812ba25ee663) &+ 0x261ebe70f821cbc3
        let scalarAdd = (scalar &* 0xb1af6fa1cb6e1d69) &+ 0xbfe73a2bd6da82dc

        var carry = vec[0]
        for index in 0..<builder63c278VectorWords {
            let seed = try builder63c278Mix2Seed(carry: carry, scalarMul: scalarMul, scalarAdd: scalarAdd, tables: tables)
            for lane in 0..<builder63c278VectorWords {
                let pos = index + lane
                vec[pos] = vec[pos] &+ seed.laneAdd &+ (x0Vec22[lane] &* seed.updateMul)
            }

            carry = try builder63c278NextCarry2(updatedFirst: vec[index], updatedSecond: vec[index + 1], tables: tables)
            vec[index + 1] = carry
        }
        return vec
    }

    public static func builder63c278Tail1U32Words(_ mixedVec44: [UInt64]) throws -> [UInt32] {
        guard mixedVec44.count == 44 else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(mixedVec44.count)
        }
        let tables = try cachedTables.get()
        var carry: UInt64 = 0x57078c52164039c3
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            carry = carry &* 0xea79f5006ed1ed3d
            carry = carry &+ (mixedVec44[builder63c278VectorWords + index] &* 0x66df92deb399335b)
            carry = carry &+ 0x09c9f7e39169d6f1

            let folded = try fold63c278(
                (carry &* 0x4a61801334a2066b) &+ 0x346cdb9fa10bc247,
                tableOffset: 0x3019f0,
                rounds: 7,
                tables: tables
            )
            let word = UInt32(
                (UInt64(UInt32(truncatingIfNeeded: carry)) &* UInt64(0x6d8d9d63)
                 &+ (UInt64(UInt32(truncatingIfNeeded: folded)) &* UInt64(0x70000000))
                 &+ UInt64(0xc780a908)) & 0xffff_ffff
            )
            let foldedTail = try fold63c278(folded, tableOffset: 0x3019f0, rounds: 9, tables: tables)
            carry = (folded &* 0xe3d2a03f1bfe297f)
                &+ (foldedTail &* 0x401d681000000000)
                &+ 0x7b8480dbcf98c453

            let tableOffset = (index & 7) * 4
            let mul = try u32TableWord63c278(0x123448 + tableOffset, tables: tables)
            let add = try u32TableWord63c278(0x123468 + tableOffset, tables: tables)
            out.append(UInt32((UInt64(word) &* UInt64(mul) &+ UInt64(add)) & 0xffff_ffff))
        }
        return out
    }

    public static func builder63c278Tail2U32Words(_ mixedVec44: [UInt64]) throws -> [UInt32] {
        guard mixedVec44.count == 44 else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(mixedVec44.count)
        }
        let tables = try cachedTables.get()
        var carry: UInt64 = 0x7b98879460aee9e2
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            carry = carry &* 0xf65fd3833526aa13
            carry = carry &+ (mixedVec44[builder63c278VectorWords + index] &* 0x806aa29ec1ed1481)
            carry = carry &+ 0xb4f29f8797e744b7

            let folded = try fold63c278(
                (carry &* 0xa05b2cf659a43c93) &+ 0x48da81dd905ece62,
                tableOffset: 0x301cf0,
                rounds: 7,
                tables: tables
            )
            let word = UInt32(
                (UInt64(UInt32(truncatingIfNeeded: carry)) &* UInt64(0x0080b9a9)
                 &+ (UInt64(UInt32(truncatingIfNeeded: folded)) &* UInt64(0xd0000000))
                 &+ UInt64(0xde4d224e)) & 0xffff_ffff
            )
            let foldedTail = try fold63c278(folded, tableOffset: 0x301cf0, rounds: 9, tables: tables)
            carry = (folded &* 0x3fc1e03941c67b59)
                &+ (foldedTail &* 0xe3984a7000000000)
                &+ 0x05975fb8f5057bb2

            let tableOffset = (index & 7) * 4
            let mul = try u32TableWord63c278(0x112628 + tableOffset, tables: tables)
            let add = try u32TableWord63c278(0x121928 + tableOffset, tables: tables)
            out.append(UInt32((UInt64(word) &* UInt64(mul) &+ UInt64(add)) & 0xffff_ffff))
        }
        return out
    }

    public static func builder63c278AccumulatorStreams(
        arg2: Data,
        tail2Words: [UInt32]
    ) throws -> (sp440Cumulative: [UInt64], sp4f0Words: [UInt64], sp5a0Words: [UInt64], sp390Cumulative: [UInt64]) {
        guard arg2.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("63c278 arg2", arg2.count, builder63c278VectorBytes)
        }
        guard tail2Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(tail2Words.count)
        }
        let tables = try cachedTables.get()
        let arg2Bytes = [UInt8](arg2)

        var sp5a0: [UInt64] = []
        var sp440: [UInt64] = []
        sp5a0.reserveCapacity(builder63c278VectorWords)
        sp440.reserveCapacity(builder63c278VectorWords)
        var runningA: UInt64 = 0
        for index in 0..<builder63c278VectorWords {
            let item = try builder63c278AccumAWord(readUInt32LE(arg2Bytes, index * 4), index: index, tables: tables)
            sp5a0.append(item)
            runningA = runningA &+ item
            sp440.append(runningA)
        }

        var sp4f0: [UInt64] = []
        var sp390: [UInt64] = []
        sp4f0.reserveCapacity(builder63c278VectorWords)
        sp390.reserveCapacity(builder63c278VectorWords)
        var runningB: UInt64 = 0
        for (index, word) in tail2Words.enumerated() {
            let item = try builder63c278AccumBWord(word, index: index, tables: tables)
            sp4f0.append(item)
            runningB = runningB &+ item
            sp390.append(runningB)
        }

        return (sp440, sp4f0, sp5a0, sp390)
    }

    public static func builder63c278BridgeConvolutionVector(
        sp440Cumulative: [UInt64],
        sp4f0Words: [UInt64],
        sp5a0Words: [UInt64],
        sp390Cumulative: [UInt64]
    ) throws -> [UInt64] {
        for stream in [sp440Cumulative, sp4f0Words, sp5a0Words, sp390Cumulative] where stream.count != builder63c278VectorWords {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(stream.count)
        }

        var out: [UInt64] = []
        out.reserveCapacity(44)
        for index in 0..<44 {
            let low = max(index - 21, 0)
            let high = min(index, 21)
            let mixed: UInt64

            if low > 21 {
                mixed = 0x67bdf132221fb4e9
            } else {
                let start = index - high
                var dot: UInt64 = 0
                for pos in start...high {
                    dot = dot &+ (sp4f0Words[index - pos] &* sp5a0Words[pos])
                }

                var spanA = sp440Cumulative[high]
                let spanB: UInt64
                if index >= 22 {
                    spanA = spanA &- sp440Cumulative[low - 1]
                    spanB = sp390Cumulative[index - low] &- sp390Cumulative[index - high - 1]
                } else {
                    spanB = sp390Cumulative[index - low]
                }

                mixed = 0x67bdf132221fb4e9
                    &+ (UInt64(high - low + 1) &* 0x1593d040a4114154)
                    &+ (dot &* 0x2edc06a97199e3ef)
                    &+ (spanA &* 0x0557cced2c1cc47e)
                    &+ (spanB &* 0xc1edf977b66f09ca)
            }

            out.append((mixed &* 0xb3bd694c1c94d1a7) &+ 0x2c0585771e81c36a)
        }
        return out
    }

    public static func builder63c278BridgeX0Vector(arg0: Data) throws -> [UInt64] {
        guard arg0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("63c278 arg0", arg0.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let arg0Bytes = [UInt8](arg0)
        var out: [UInt64] = []
        out.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            out.append(try builder63c278BridgeX0Word(readUInt32LE(arg0Bytes, index * 4), index: index, tables: tables))
        }
        return out
    }

    public static func builder63c278BridgeMixVector(
        sp230Vec44: [UInt64],
        x0Vec22: [UInt64],
        scalar: UInt64
    ) throws -> [UInt64] {
        guard sp230Vec44.count == 44 else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp230Vec44.count)
        }
        guard x0Vec22.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(x0Vec22.count)
        }
        let tables = try cachedTables.get()
        var vec = sp230Vec44
        let scalarMul = (scalar &* 0x5bcfc2db5b41aa8b) &+ 0xb0be584b9c560ceb
        let scalarAdd = (scalar &* 0x7cb9da0648140cfd) &+ 0xcb165f95963e265b

        var carry = vec[0]
        for index in 0..<builder63c278VectorWords {
            let seed = try builder63c278BridgeMixSeed(
                carry: carry,
                scalarMul: scalarMul,
                scalarAdd: scalarAdd,
                tables: tables
            )
            for lane in 0..<builder63c278VectorWords {
                let pos = index + lane
                vec[pos] = vec[pos] &+ seed.laneAdd &+ (x0Vec22[lane] &* seed.updateMul)
            }

            carry = try builder63c278BridgeNextCarry(updatedFirst: vec[index], updatedSecond: vec[index + 1], tables: tables)
            vec[index + 1] = carry
        }
        return vec
    }

    public static func builder63c278BridgeSP128Words(_ sp230Vec44: [UInt64]) throws -> [UInt32] {
        guard sp230Vec44.count == 44 else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp230Vec44.count)
        }
        let tables = try cachedTables.get()
        var carry: UInt64 = 0x18541ef2e5658ac6
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            carry = carry &* 0x590b8c9bda7aa7a5
            carry = carry &+ (sp230Vec44[builder63c278VectorWords + index] &* 0x93e68b973b124f01)
            carry = carry &+ 0x0357d31d6340b07a

            let folded = try fold63c278(
                (carry &* 0x052e2e9b238ffd17) &+ 0x7a84d77fc047bb5c,
                tableOffset: 0x302070,
                rounds: 7,
                tables: tables
            )
            let word = UInt32(
                (UInt64(UInt32(truncatingIfNeeded: carry)) &* UInt64(0xbca742b5)
                 &+ (UInt64(UInt32(truncatingIfNeeded: folded)) &* UInt64(0xd0000000))
                 &+ UInt64(0x74c20619)) & 0xffff_ffff
            )
            let foldedTail = try fold63c278(folded, tableOffset: 0x302070, rounds: 9, tables: tables)
            carry = (folded &* 0x9d12b2b955ef375b)
                &+ (foldedTail &* 0xa10c8a5000000000)
                &+ 0x5831e87503aab765

            let tableOffset = (index & 7) * 4
            let mul = try u32TableWord63c278(0x118568 + tableOffset, tables: tables)
            let add = try u32TableWord63c278(0x1234a8 + tableOffset, tables: tables)
            out.append(UInt32((UInt64(word) &* UInt64(mul) &+ UInt64(add)) & 0xffff_ffff))
        }
        return out
    }

    public static func builder63c278PrebranchInitialStreams(
        arg0: Data,
        tail1Words: [UInt32],
        sp128Words: [UInt32]
    ) throws -> (sp390Static: [UInt32], sp440Words: [UInt32], sp6b0Words: [UInt32], sp658Words: [UInt32]) {
        guard arg0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("63c278 arg0", arg0.count, builder63c278VectorBytes)
        }
        guard tail1Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(tail1Words.count)
        }
        guard sp128Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp128Words.count)
        }
        let tables = try cachedTables.get()
        let arg0Bytes = [UInt8](arg0)

        var sp390: [UInt32] = []
        var sp440: [UInt32] = []
        var sp6b0: [UInt32] = []
        var sp658: [UInt32] = []
        sp390.reserveCapacity(builder63c278VectorWords)
        sp440.reserveCapacity(builder63c278VectorWords)
        sp6b0.reserveCapacity(builder63c278VectorWords)
        sp658.reserveCapacity(builder63c278VectorWords)

        for index in 0..<builder63c278VectorWords {
            let tableOffset = (index & 7) * 4
            sp390.append(try foldTableU32Word63c278(0x3020f0 + index * 4, tables: tables))
            sp440.append(try u32TableAffine63c278(tail1Words[index], mulTable: 0x122228 + tableOffset, addTable: 0x11dd08 + tableOffset, tables: tables))
            sp6b0.append(try u32TableAffine63c278(sp128Words[index], mulTable: 0x1234c8 + tableOffset, addTable: 0x11b428 + tableOffset, tables: tables))
            sp658.append(try u32TableAffine63c278(readUInt32LE(arg0Bytes, index * 4), mulTable: 0x114968 + tableOffset, addTable: 0x11fda8 + tableOffset, tables: tables))
        }

        return (sp390, sp440, sp6b0, sp658)
    }

    public static func builder63c278PrebranchSP4F0Words(arg0: Data) throws -> [UInt32] {
        guard arg0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("63c278 arg0", arg0.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let arg0Bytes = [UInt8](arg0)
        let arg0Words = (0..<builder63c278VectorWords).map { readUInt32LE(arg0Bytes, $0 * 4) }

        let first = UInt32((UInt64(arg0Words[0]) &* UInt64(0x7193fc77) &+ UInt64(0x318e9b49)) & 0xffff_ffff)
        var state = try builder63c278PrebranchSP4F0State(from: first, tables: tables)
        var selected = try builder63c278PrebranchSP4F0FoldState(state, tables: tables)
        var carry = UInt32(
            (UInt64(state) &* UInt64(0x8e834ce3)
             &+ UInt64(selected &<< 31)
             &+ UInt64(0x0afac599)) & 0xffff_ffff
        )

        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)
        var index = 0
        while true {
            if index == builder63c278VectorWords - 1 {
                let storeValue = UInt32((UInt64(carry) &* UInt64(0x3f277405) &+ UInt64(0xa0c1d6f4)) & 0xffff_ffff)
                let tableOffset = (index * 4) & 0x1c
                out.append(try u32TableAffine63c278(storeValue, mulTable: 0x122248 + tableOffset, addTable: 0x1172a8 + tableOffset, tables: tables))
                break
            }

            let nextIndex = index + 1
            let nextTableOffset = (nextIndex & 7) * 4
            let value = try u32TableAffine63c278(
                arg0Words[nextIndex],
                mulTable: 0x11c3e8 + nextTableOffset,
                addTable: 0x11b448 + nextTableOffset,
                tables: tables
            )
            carry = UInt32((UInt64(carry) &* UInt64(0x3f277405) &+ UInt64(value) &* UInt64(0xa8000000)) & 0xffff_ffff)
            state = try builder63c278PrebranchSP4F0State(from: value, tables: tables)
            selected = try builder63c278PrebranchSP4F0FoldState(state, tables: tables)
            let word = UInt32(
                (UInt64(state) &* UInt64(0x8e834ce3)
                 &+ UInt64(selected &<< 31)
                 &+ UInt64(0x0afac599)) & 0xffff_ffff
            )
            carry = UInt32((UInt64(word) &* UInt64(0xb0000000) &+ UInt64(carry)) & 0xffff_ffff)
            let storeValue = carry &+ 0xc8c1d6f4
            let tableOffset = (index * 4) & 0x1c
            out.append(try u32TableAffine63c278(storeValue, mulTable: 0x122248 + tableOffset, addTable: 0x1172a8 + tableOffset, tables: tables))
            carry = word
            index = nextIndex
        }

        return out
    }

    public static func builder63c278PrebranchSP230Words(sp4f0Words: [UInt32]) throws -> [UInt32] {
        guard sp4f0Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp4f0Words.count)
        }
        let tables = try cachedTables.get()
        let q0 = try (0..<4).map { try u32TableWord63c278(0x125f20 + $0 * 4, tables: tables) }
        let q1 = try (0..<4).map { try u32TableWord63c278(0x125f30 + $0 * 4, tables: tables) }
        var out = q0 + q1 + q0 + q1 + q0 + Array(q1.prefix(2))

        for (index, word) in sp4f0Words.enumerated() {
            let tableOffset = (index & 7) * 4
            let mul = try u32TableWord63c278(0x11c408 + tableOffset, tables: tables)
            out[index] = UInt32((UInt64(word) &* UInt64(mul) &+ UInt64(out[index])) & 0xffff_ffff)
        }

        for index in 0..<builder63c278VectorWords {
            let tableOffset = (index & 7) * 4
            let staticWord = try foldTableU32Word63c278(0x302148 + index * 4, tables: tables)
            let mul = try u32TableWord63c278(0x118588 + tableOffset, tables: tables)
            out[index] = UInt32((UInt64(staticWord) &* UInt64(mul) &+ UInt64(out[index])) & 0xffff_ffff)
        }

        return out
    }

    public static func builder63c278PrebranchSP5A0Words(sp230Words: [UInt32]) throws -> [UInt32] {
        guard sp230Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp230Words.count)
        }
        let tables = try cachedTables.get()
        var carry: UInt32 = 0xa7964b7d
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)
        for (index, word) in sp230Words.enumerated() {
            carry = UInt32((UInt64(carry) &* UInt64(0x856c3a53) &+ UInt64(word)) & 0xffff_ffff)
            var folded = UInt32((UInt64(carry) &* UInt64(0x287caef9) &+ UInt64(0x0ac0f465)) & 0xffff_ffff)
            folded = try fold32ByNibbles63c278(folded, tableOffset: 0x302238, rounds: 7, tables: tables)
            let foldedTail = try foldTableU32Word63c278(0x302238 + Int(folded & 0x0f) * 4, tables: tables) &+ (folded >> 4)
            let nextPart = UInt32(
                (UInt64(carry) &* UInt64(0xd8018ba1)
                 &+ UInt64(folded) &* UInt64(0x70000000)
                 &+ UInt64(0x63f7e16a)) & 0xffff_ffff
            )
            let tail = UInt32((UInt64(folded) &* UInt64(0x20718073) &+ UInt64(foldedTail) &* UInt64(0xf8e7f8d0)) & 0xffff_ffff)

            let tableOffset = (index * 4) & 0x1c
            out.append(try u32TableAffine63c278(nextPart, mulTable: 0x11a028 + tableOffset, addTable: 0x115f48 + tableOffset, tables: tables))
            carry = tail &+ 0xe056c4a1
        }
        return out
    }

    public static func builder63c278BranchLoop(
        arg0: Data,
        sp390Words: [UInt32],
        sp440Words: [UInt32],
        sp6b0Words: [UInt32],
        sp658Words: [UInt32],
        sp5a0Words: [UInt32],
        maxIterations: Int = 2000
    ) throws -> (sp390: [UInt32], sp440: [UInt32], sp6b0: [UInt32], sp658: [UInt32]) {
        guard arg0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("63c278 arg0", arg0.count, builder63c278VectorBytes)
        }
        for stream in [sp390Words, sp440Words, sp6b0Words, sp658Words, sp5a0Words] where stream.count != builder63c278VectorWords {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(stream.count)
        }
        let tables = try cachedTables.get()
        var sp390 = sp390Words
        var sp440 = sp440Words
        var sp6b0 = sp6b0Words
        var sp658 = sp658Words
        let sp5a0 = sp5a0Words

        for _ in 0..<maxIterations {
            if try builder63c278TerminalSP658Ready(sp658, tables: tables) {
                return (sp390, sp440, sp6b0, sp658)
            }

            if (sp6b0[0] & 1) == 0 {
                sp6b0 = try builder63c278LoopUpdateSP6B0Even(sp6b0, tables: tables)
                sp440 = try builder63c278LoopUpdateSP440(sp440, sp5a0Words: sp5a0, tables: tables)
                continue
            }

            while (sp658[0] & 1) != 0 {
                sp658 = try builder63c278LoopUpdateSP658Odd(sp658, tables: tables)
                sp390 = try builder63c278LoopUpdateSP390(sp390, sp5a0Words: sp5a0, tables: tables)
            }

            if try builder63c278LoopSP658EvenUsesSuccessPath(sp658Words: sp658, sp6b0Words: sp6b0, tables: tables) {
                sp658 = try builder63c278LoopUpdateSP658EvenSuccess(sp658Words: sp658, sp6b0Words: sp6b0, tables: tables)
                if try builder63c278Predicate64D55C(sp440Words: sp440, sp390Words: sp390, tables: tables) == 0 {
                    sp390 = try builder63c278LoopUpdateSP390PredicateFalse(sp390Words: sp390, arg0: arg0, tables: tables)
                }
                sp390 = try builder63c278LoopUpdateSP390PredicateJoin(sp390Words: sp390, sp440Words: sp440, tables: tables)
            } else {
                sp6b0 = try builder63c278LoopUpdateSP6B0Failure(sp6b0Words: sp6b0, sp658Words: sp658, tables: tables)
                if try builder63c278Predicate64D55C(sp440Words: sp440, sp390Words: sp390, tables: tables) != 0 {
                    sp440 = try builder63c278LoopUpdateSP440PredicateTrue(sp440Words: sp440, arg0: arg0, tables: tables)
                }
                sp440 = try builder63c278LoopUpdateSP440PredicateJoin(sp440Words: sp440, sp390Words: sp390, tables: tables)
            }
        }

        throw FirstPairSourceSliceError.branchLoopDidNotTerminate(maxIterations)
    }

    public static func builder63c278FinalScheduleFromSP440U32(_ sp440Words: [UInt32]) throws -> [UInt32] {
        guard sp440Words.count >= builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp440Words.count)
        }
        let tables = try cachedTables.get()
        var staged: [UInt32] = []
        staged.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            staged.append(try u32TableAffine63c278(sp440Words[index], mulTable: 0x117308 + tableOffset, addTable: 0x11b508 + tableOffset, tables: tables))
        }

        var out: [UInt32] = []
        out.reserveCapacity(20)
        for index in 0..<20 {
            let tableOffset = (index * 4) & 0x1c
            out.append(try u32TableAffine63c278(staged[index], mulTable: 0x11f5e8 + tableOffset, addTable: 0x1154e8 + tableOffset, tables: tables))
        }
        return out
    }

    public static func builder63c278ScheduleWords(
        arg0: Data,
        arg1: Data,
        arg2: Data,
        scalar: UInt64
    ) throws -> [UInt32] {
        let initial = try builder63c278InitialVectors(arg0: arg0, arg1: arg1)
        let mixed = try builder63c278ScalarMixVector(x1Vec44: initial.x1Vec44, x0Vec22: initial.x0Vec22, scalar: scalar)
        let tail1 = try builder63c278Tail1U32Words(mixed)

        let second = try builder63c278SecondInitialVectors(arg0: arg0, arg2: arg2)
        let mixed2 = try builder63c278ScalarMix2Vector(x2Vec44: second.x2Vec44, x0Vec22: second.x0Vec22, scalar: scalar)
        let tail2 = try builder63c278Tail2U32Words(mixed2)

        let accum = try builder63c278AccumulatorStreams(arg2: arg2, tail2Words: tail2)
        let bridge = try builder63c278BridgeConvolutionVector(
            sp440Cumulative: accum.sp440Cumulative,
            sp4f0Words: accum.sp4f0Words,
            sp5a0Words: accum.sp5a0Words,
            sp390Cumulative: accum.sp390Cumulative
        )
        let bridgeX0 = try builder63c278BridgeX0Vector(arg0: arg0)
        let bridgeMixed = try builder63c278BridgeMixVector(sp230Vec44: bridge, x0Vec22: bridgeX0, scalar: scalar)
        let sp128 = try builder63c278BridgeSP128Words(bridgeMixed)

        let prebranch = try builder63c278PrebranchInitialStreams(arg0: arg0, tail1Words: tail1, sp128Words: sp128)
        let pre4f0 = try builder63c278PrebranchSP4F0Words(arg0: arg0)
        let pre230 = try builder63c278PrebranchSP230Words(sp4f0Words: pre4f0)
        let pre5a0 = try builder63c278PrebranchSP5A0Words(sp230Words: pre230)
        let final = try builder63c278BranchLoop(
            arg0: arg0,
            sp390Words: prebranch.sp390Static,
            sp440Words: prebranch.sp440Words,
            sp6b0Words: prebranch.sp6b0Words,
            sp658Words: prebranch.sp658Words,
            sp5a0Words: pre5a0
        )
        return try builder63c278FinalScheduleFromSP440U32(final.sp440)
    }

    public static func builder6388f0Next642f60InputsFrom64cd40Outputs(
        first64cd40Output: Data,
        second64cd40Output: Data,
        third64cd40Output: Data
    ) throws -> Builder6388f0Next642f60Inputs {
        let tables = try cachedTables.get()
        return Builder6388f0Next642f60Inputs(
            x0: try u32AffineBytes63c278(
                first64cd40Output,
                mulTable: builder6388f0Pre63Arg1MulTable,
                addTable: builder6388f0Pre63Arg1AddTable,
                label: "first 64cd40 output",
                tables: tables
            ),
            x1: try u32AffineBytes63c278(
                second64cd40Output,
                mulTable: builder6388f0Next642X1MulTable,
                addTable: builder6388f0Next642X1AddTable,
                label: "second 64cd40 output",
                tables: tables
            ),
            x2: try u32AffineBytes63c278(
                third64cd40Output,
                mulTable: builder6388f0Pre63Arg2MulTable,
                addTable: builder6388f0Pre63Arg2AddTable,
                label: "third 64cd40 output",
                tables: tables
            )
        )
    }

    public static func builder6388f0StreamStart642f60X0FromOut0Seed(_ out0Seed: Data) throws -> Data {
        let tables = try cachedTables.get()
        return try u32AffineBytes63c278(
            out0Seed,
            mulTable: builder6388f0StreamStartOut0To642f60X0MulTable,
            addTable: builder6388f0StreamStartOut0To642f60X0AddTable,
            label: "6388f0 stream-start out0 seed",
            tables: tables
        )
    }

    public static func builder6388f0StreamStart642f60X1FromOut1Seed(_ out1Seed: Data) throws -> Data {
        let tables = try cachedTables.get()
        return try u32AffineBytes63c278(
            out1Seed,
            mulTable: builder6388f0StreamStartOut1To642f60X1MulTable,
            addTable: builder6388f0StreamStartOut1To642f60X1AddTable,
            label: "6388f0 stream-start out1 seed",
            tables: tables
        )
    }

    public static func builder6388f0RecoverStreamStartOut0SeedFrom642f60X0(_ x0Source: Data) throws -> Data {
        let tables = try cachedTables.get()
        return try u32AffineInverseBytes63c278(
            x0Source,
            mulTable: builder6388f0StreamStartOut0To642f60X0MulTable,
            addTable: builder6388f0StreamStartOut0To642f60X0AddTable,
            label: "6388f0 stream-start 642f60 x0 source",
            tables: tables
        )
    }

    public static func builder6388f0RecoverStreamStartOut1SeedFrom642f60X1(_ x1Source: Data) throws -> Data {
        let tables = try cachedTables.get()
        return try u32AffineInverseBytes63c278(
            x1Source,
            mulTable: builder6388f0StreamStartOut1To642f60X1MulTable,
            addTable: builder6388f0StreamStartOut1To642f60X1AddTable,
            label: "6388f0 stream-start 642f60 x1 source",
            tables: tables
        )
    }

    public static func builder6421c0X0Streams(_ x0Source: Data) throws -> (raw: [UInt64], prefix: [UInt64]) {
        guard x0Source.count >= 20 * 4 else {
            throw FirstPairSourceSliceError.sourceTooShort("6421c0 x0 source", x0Source.count, 20 * 4)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x0Source)
        var raw: [UInt64] = []
        raw.reserveCapacity(20)
        for index in 0..<20 {
            let word = readUInt32LE(bytes, index * 4)
            let mixed: UInt32
            if index == 0 {
                mixed = word &* 0x3239bd21 &+ 0x5c47f2f0
            } else {
                let affine = try u32Affine63c278(
                    word,
                    index: index,
                    mulTable: builder6421c0X0MulTable,
                    addTable: builder6421c0X0AddTable,
                    tables: tables
                )
                mixed = affine &* 0x5da2e52f &+ 0x6605175e
            }
            let folded = try fold63c278(
                UInt64(mixed) &* 0x430e55e51aa99355 &+ 0x15551dd776f38e14,
                tableOffset: builder6421c0X0FoldTable,
                rounds: 8,
                tables: tables
            )
            raw.append(
                UInt64(mixed) &* 0xc788d39836400f55
                &+ folded &* 0xd50b73ff00000000
                &+ 0xce6055b08c097bf0
            )
        }
        return (raw, prefixSumsU64(raw))
    }

    public static func builder6421c0X1Streams(_ x1Source: Data) throws -> (raw: [UInt64], prefix: [UInt64]) {
        guard x1Source.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6421c0 x1 source", x1Source.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x1Source)
        var raw: [UInt64] = []
        raw.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            let word = readUInt32LE(bytes, index * 4)
            let mixed: UInt32
            if index == 0 {
                mixed = word &* 0x105085d7 &+ 0x841874d8
            } else {
                let affine = try u32Affine63c278(
                    word,
                    index: index,
                    mulTable: builder6421c0X1MulTable,
                    addTable: builder6421c0X1AddTable,
                    tables: tables
                )
                mixed = affine &* 0x97c9fb77 &+ 0x6b1b1a39
            }
            let folded = try fold63c278(
                UInt64(mixed) &* 0x8f1272d1ced32651 &+ 0x7eda487fd3a46989,
                tableOffset: builder6421c0X1FoldTable,
                rounds: 8,
                tables: tables
            )
            raw.append(
                UInt64(mixed) &* 0x9dcd2446c70edca3
                &+ folded &* 0xe9148d4d00000000
                &+ 0x2df1f5e9fb0ab4f8
            )
        }
        return (raw, prefixSumsU64(raw))
    }

    public static func builder6421c0X2Words(_ x2Source: Data) throws -> [UInt64] {
        guard x2Source.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6421c0 x2 source", x2Source.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x2Source)
        var out: [UInt64] = []
        out.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            let affine = try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: builder6421c0X2MulTable,
                addTable: builder6421c0X2AddTable,
                tables: tables
            )
            let mixed = affine &* 0x6819ef77 &+ 0x57cf46ce
            let folded = try fold63c278(
                UInt64(mixed) &* 0xc4e90084bd222fd1 &+ 0xf9e4937efa15a0b7,
                tableOffset: builder6421c0X2FoldTable,
                rounds: 8,
                tables: tables
            )
            out.append(
                UInt64(mixed) &* 0x06447e0a39c79467
                &+ folded &* 0xcfaf794900000000
                &+ 0xe882bfc48de82700
            )
        }
        return out
    }

    public static func builder6421c0ConvolutionWorkspace(
        x0Raw: [UInt64],
        x0Prefix: [UInt64],
        x1Raw: [UInt64],
        x1Prefix: [UInt64]
    ) throws -> Data {
        guard x0Raw.count == 20, x0Prefix.count == 20 else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(x0Raw.count)
        }
        guard x1Raw.count == builder63c278VectorWords, x1Prefix.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(x1Raw.count)
        }
        var out = Data()
        out.reserveCapacity(builder64cd40WorkspaceBytes)
        for index in 0..<builder64cd40WorkspaceWords {
            let low = max(0, index - (x1Raw.count - 1))
            let high = min(index, x0Raw.count - 1)
            let productSum: UInt64
            let x0Sum: UInt64
            let x1Sum: UInt64
            let count: Int
            if high >= low {
                var sum: UInt64 = 0
                for x0Index in low...high {
                    sum = sum &+ x0Raw[x0Index] &* x1Raw[index - x0Index]
                }
                productSum = sum
                x0Sum = rangeSumFromPrefix(x0Prefix, start: low, end: high)
                x1Sum = rangeSumFromPrefix(x1Prefix, start: index - high, end: index - low)
                count = high - low + 1
            } else {
                productSum = 0
                x0Sum = 0
                x1Sum = 0
                count = 0
            }
            let mixed = UInt64(count) &* 0xdd9e6926c32c9984
                &+ 0x7bf33cd7983bce3c
                &+ x0Sum &* 0xe703af65ab19ca84
                &+ productSum &* 0xe6337be2ad0561b9
                &+ x1Sum &* 0x1cd6868a83aeef79
            out.append(contentsOf: u64LEBytes(
                mixed &* 0x2e60fd6d05fe470b &+ 0xf48a714d4ddd3ee7
            ))
        }
        return out
    }

    public static func builder6421c0WorkspaceAfterUpdate(
        workspace: Data,
        x2Words: [UInt64],
        scalar: UInt64
    ) throws -> Data {
        guard workspace.count >= builder64cd40WorkspaceBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6421c0 workspace", workspace.count, builder64cd40WorkspaceBytes)
        }
        guard x2Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(x2Words.count)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](workspace)
        var words = (0..<builder64cd40WorkspaceWords).map { readUInt64LE(bytes, $0 * 8) }

        for base in 0..<builder63c278VectorWords {
            let params = try builder6421c0WorkspaceParams(
                scalar: scalar,
                firstWord: words[base],
                tables: tables
            )
            for (offset, word) in x2Words.enumerated() {
                let pos = base + offset
                words[pos] = words[pos] &+ params.broadcast &+ word &* params.multiplier
            }
            words[base + 1] = try builder6421c0RewriteSecondWord(
                first: words[base],
                second: words[base + 1],
                tables: tables
            )
        }
        return packUInt64LE64cd40(words)
    }

    public static func builder6421c0FinalU32Words(workspace: Data) throws -> [UInt32] {
        guard workspace.count >= builder64cd40WorkspaceBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6421c0 workspace", workspace.count, builder64cd40WorkspaceBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](workspace)
        let words = (0..<builder64cd40WorkspaceWords).map { readUInt64LE(bytes, $0 * 8) }
        var carry: UInt64 = 0x14ee1c03e369d629
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)

        for index in 0..<builder63c278VectorWords {
            let tailWord = words[builder63c278VectorWords + index]
            let mixed = carry &* 0x0338c0e89dc8ee71
                &+ tailWord &* 0x32afeb8e00ff3e85
                &+ 0xfc9f014fa6b572f5
            let folded7 = try fold63c278(
                mixed &* 0xea4b89dcd43400c5 &+ 0x3ea3d75ac0581688,
                tableOffset: builder6421c0FinalFoldTable,
                rounds: 7,
                tables: tables
            )
            let side = UInt32(truncatingIfNeeded:
                (mixed & 0xffff_ffff) &* 0x279eaf81
                &+ (folded7 & 0xffff_ffff) &* 0x30000000
                &+ 0xac5f152c
            )
            let folded = try fold63c278(
                folded7,
                tableOffset: builder6421c0FinalFoldTable,
                rounds: 9,
                tables: tables
            )
            carry = folded7 &* 0x571b49fe43ec4f5d
                &+ folded &* 0xc13b0a3000000000
                &+ 0x04e301c0d1003cfc
            let tableOffset = (index * 4) & 0x1c
            out.append(try u32TableAffine63c278(
                side,
                mulTable: builder6421c0FinalOutMulTable + tableOffset,
                addTable: builder6421c0FinalOutAddTable + tableOffset,
                tables: tables
            ))
        }
        return out
    }

    public static func builder6421c0OutputWords(
        x0Source: Data,
        x1Source: Data,
        x2Source: Data,
        scalar: UInt64
    ) throws -> [UInt32] {
        let x0Streams = try builder6421c0X0Streams(x0Source)
        let x1Streams = try builder6421c0X1Streams(x1Source)
        let x2Words = try builder6421c0X2Words(x2Source)
        let workspace = try builder6421c0ConvolutionWorkspace(
            x0Raw: x0Streams.raw,
            x0Prefix: x0Streams.prefix,
            x1Raw: x1Streams.raw,
            x1Prefix: x1Streams.prefix
        )
        let updated = try builder6421c0WorkspaceAfterUpdate(
            workspace: workspace,
            x2Words: x2Words,
            scalar: scalar
        )
        return try builder6421c0FinalU32Words(workspace: updated)
    }

    public static func builder6388f0HighSeedX0SourceFrom5bcf98Output(_ source70: Data) throws -> Data {
        guard source70.count >= 70 else {
            throw FirstPairSourceSliceError.sourceTooShort("6388f0 high x0 source input", source70.count, 70)
        }
        let tables = try cachedTables.get()
        let source = [UInt8](source70)
        var packedWords = [UInt32](repeating: 0, count: 18)
        for index in 0..<70 {
            let wordIndex = index / 4
            let shift = UInt32((index * 8) & 0x18)
            packedWords[wordIndex] |= UInt32(source[index]) << shift
        }

        var out: [UInt32] = []
        out.reserveCapacity(20)
        for index in 0..<20 {
            let bitOffset = index * 28
            let wordIndex = bitOffset >> 5
            let shift = UInt32(bitOffset & 0x1c)
            var value = packedWords[wordIndex] >> shift
            if shift != 0 {
                value |= packedWords[wordIndex + 1] << (32 - shift)
            }
            value &= 0x0fffffff
            value = value &* 0x83dcb233 &+ 0x774e86a1
            out.append(try u32Affine63c278(
                value,
                index: index,
                mulTable: builder6388f0HighSeedX0SourceMulTable,
                addTable: builder6388f0HighSeedX0SourceAddTable,
                tables: tables
            ))
        }
        return packUInt32LE(out)
    }

    public static func builder6388f0HighSeedStreamStartSeedsFrom5bcf98Outputs(
        firstOutput70: Data,
        secondOutput70: Data,
        x1Source: Data? = nil,
        x2Source: Data? = nil,
        scalar: UInt64? = nil
    ) throws -> Builder6388f0HighSeedStreamStartSeeds {
        let resolvedX1 = x1Source ?? highSeed6421c0X1Source
        let resolvedX2 = x2Source ?? highSeed6421c0X2Source
        let resolvedScalar = scalar ?? highSeed6421c0Scalar
        let out0 = try builder6421c0OutputWords(
            x0Source: builder6388f0HighSeedX0SourceFrom5bcf98Output(firstOutput70),
            x1Source: resolvedX1,
            x2Source: resolvedX2,
            scalar: resolvedScalar
        )
        let out1 = try builder6421c0OutputWords(
            x0Source: builder6388f0HighSeedX0SourceFrom5bcf98Output(secondOutput70),
            x1Source: resolvedX1,
            x2Source: resolvedX2,
            scalar: resolvedScalar
        )
        return Builder6388f0HighSeedStreamStartSeeds(
            out0: packUInt32LE(out0),
            out1: packUInt32LE(out1)
        )
    }

    public static func builder6388f0FirstPairHighSeedStreamStartSeedsFrom5bcf98Outputs(
        row0FirstOutput70: Data,
        row0SecondOutput70: Data,
        row59FirstOutput70: Data,
        row59SecondOutput70: Data,
        x1Source: Data? = nil,
        x2Source: Data? = nil,
        scalar: UInt64? = nil
    ) throws -> Builder6388f0FirstPairHighSeedStreamStartSeeds {
        Builder6388f0FirstPairHighSeedStreamStartSeeds(
            row0: try builder6388f0HighSeedStreamStartSeedsFrom5bcf98Outputs(
                firstOutput70: row0FirstOutput70,
                secondOutput70: row0SecondOutput70,
                x1Source: x1Source,
                x2Source: x2Source,
                scalar: scalar
            ),
            row59: try builder6388f0HighSeedStreamStartSeedsFrom5bcf98Outputs(
                firstOutput70: row59FirstOutput70,
                secondOutput70: row59SecondOutput70,
                x1Source: x1Source,
                x2Source: x2Source,
                scalar: scalar
            )
        )
    }

    public static func builder6388f0FirstPairStreamSeedsFrom5bcf98Outputs(
        row0Out4: Data,
        row0Out3: Data,
        row0Out2: Data,
        row0FirstOutput70: Data,
        row0SecondOutput70: Data,
        row59FirstOutput70: Data,
        row59SecondOutput70: Data,
        nullScalarWindow: Data = Data(),
        staticScalarWindow: Data = Data(),
        nullEntropy11A: Data = Data(),
        nullAttempts: Int = 0,
        x1Source: Data? = nil,
        x2Source: Data? = nil,
        scalar: UInt64? = nil
    ) throws -> Builder6388f0FirstPairStreamSeeds {
        let highSeeds = try builder6388f0FirstPairHighSeedStreamStartSeedsFrom5bcf98Outputs(
            row0FirstOutput70: row0FirstOutput70,
            row0SecondOutput70: row0SecondOutput70,
            row59FirstOutput70: row59FirstOutput70,
            row59SecondOutput70: row59SecondOutput70,
            x1Source: x1Source,
            x2Source: x2Source,
            scalar: scalar
        )
        return Builder6388f0FirstPairStreamSeeds(
            nullScalarWindow: nullScalarWindow,
            staticScalarWindow: staticScalarWindow,
            nullEntropy11A: nullEntropy11A,
            nullAttempts: nullAttempts,
            row0Out4: row0Out4,
            row0Out3: row0Out3,
            row0Out2: row0Out2,
            row0Out1: highSeeds.row0.out1,
            row0Out0: highSeeds.row0.out0,
            row59Out1: highSeeds.row59.out1,
            row59Out0: highSeeds.row59.out0
        )
    }

    public static func builder6388f0FirstPairStreamSeedsFromEntrySourceAnd5bcf98Outputs(
        entrySource: Data,
        row0FirstOutput70: Data,
        row0SecondOutput70: Data,
        row59FirstOutput70: Data,
        row59SecondOutput70: Data,
        nullScalarWindow: Data = Data(),
        staticScalarWindow: Data = Data(),
        nullEntropy11A: Data = Data(),
        nullAttempts: Int = 0,
        x1Source: Data? = nil,
        x2Source: Data? = nil,
        scalar: UInt64? = nil
    ) throws -> Builder6388f0FirstPairStreamSeeds {
        let low = try builder6388f0Row0LowSeedPreimagesFromEntrySource(entrySource)
        let resolvedStaticScalarWindow = staticScalarWindow.isEmpty
            ? try builder633fa8StaticScalarWindowFromEntrySource(entrySource)
            : staticScalarWindow
        return try builder6388f0FirstPairStreamSeedsFrom5bcf98Outputs(
            row0Out4: low.out4,
            row0Out3: low.out3,
            row0Out2: low.out2,
            row0FirstOutput70: row0FirstOutput70,
            row0SecondOutput70: row0SecondOutput70,
            row59FirstOutput70: row59FirstOutput70,
            row59SecondOutput70: row59SecondOutput70,
            nullScalarWindow: nullScalarWindow,
            staticScalarWindow: resolvedStaticScalarWindow,
            nullEntropy11A: nullEntropy11A,
            nullAttempts: nullAttempts,
            x1Source: x1Source,
            x2Source: x2Source,
            scalar: scalar
        )
    }

    public static func builder6388f0FirstPairStreamSeedsFromEntropyAnd5bcf98Outputs(
        entrySource: Data,
        row0FirstOutput70: Data,
        row0SecondOutput70: Data,
        row59FirstOutput70: Data,
        row59SecondOutput70: Data,
        nullEntropy11A: Data,
        x1Source: Data? = nil,
        x2Source: Data? = nil,
        scalar: UInt64? = nil
    ) throws -> Builder6388f0FirstPairStreamSeeds {
        let nullScalar = try builder633fa8NullScalarWindowFromEntropy(entropy11A: nullEntropy11A)
        return try builder6388f0FirstPairStreamSeedsFromEntrySourceAnd5bcf98Outputs(
            entrySource: entrySource,
            row0FirstOutput70: row0FirstOutput70,
            row0SecondOutput70: row0SecondOutput70,
            row59FirstOutput70: row59FirstOutput70,
            row59SecondOutput70: row59SecondOutput70,
            nullScalarWindow: nullScalar,
            nullEntropy11A: nullEntropy11A,
            nullAttempts: 1,
            x1Source: x1Source,
            x2Source: x2Source,
            scalar: scalar
        )
    }

    public static func builder6388f0FirstPairStreamSeedsFromEntropySourceAnd5bcf98Outputs(
        entrySource: Data,
        row0FirstOutput70: Data,
        row0SecondOutput70: Data,
        row59FirstOutput70: Data,
        row59SecondOutput70: Data,
        maxAttempts: Int = 64,
        x1Source: Data? = nil,
        x2Source: Data? = nil,
        scalar: UInt64? = nil,
        entropySource: (Int) throws -> Data
    ) throws -> Builder6388f0FirstPairStreamSeeds {
        let nullResult = try builder633fa8NullScalarWindowFromEntropySource(
            maxAttempts: maxAttempts,
            entropySource: entropySource
        )
        return try builder6388f0FirstPairStreamSeedsFromEntrySourceAnd5bcf98Outputs(
            entrySource: entrySource,
            row0FirstOutput70: row0FirstOutput70,
            row0SecondOutput70: row0SecondOutput70,
            row59FirstOutput70: row59FirstOutput70,
            row59SecondOutput70: row59SecondOutput70,
            nullScalarWindow: nullResult.scalarWindow,
            nullEntropy11A: nullResult.entropy11A,
            nullAttempts: nullResult.attempts,
            x1Source: x1Source,
            x2Source: x2Source,
            scalar: scalar
        )
    }

    public static func builder6388f0FirstPairStreamSeedsFromScalarsAndSensorPoints(
        entrySource: Data,
        nullScalarWindow: Data,
        staticScalarWindow: Data,
        row0SensorPointXYBE: Data,
        row59SensorPointXYBE: Data,
        nullEntropy11A: Data = Data(),
        nullAttempts: Int = 0,
        x1Source: Data? = nil,
        x2Source: Data? = nil,
        scalar: UInt64? = nil
    ) throws -> Builder6388f0FirstPairStreamSeeds {
        let low = try builder6388f0Row0LowSeedPreimagesFromEntrySource(entrySource)
        let row0High = try builder6388f0HighSeedStreamStartSeedsFromScalarP256(
            scalarWindowLE: nullScalarWindow,
            sensorPointXYBE: row0SensorPointXYBE,
            x1Source: x1Source,
            x2Source: x2Source,
            scalar: scalar
        )
        let row59High = try builder6388f0HighSeedStreamStartSeedsFromScalarP256(
            scalarWindowLE: staticScalarWindow,
            sensorPointXYBE: row59SensorPointXYBE,
            x1Source: x1Source,
            x2Source: x2Source,
            scalar: scalar
        )
        return Builder6388f0FirstPairStreamSeeds(
            nullScalarWindow: nullScalarWindow,
            staticScalarWindow: staticScalarWindow,
            nullEntropy11A: nullEntropy11A,
            nullAttempts: nullAttempts,
            row0Out4: low.out4,
            row0Out3: low.out3,
            row0Out2: low.out2,
            row0Out1: row0High.out1,
            row0Out0: row0High.out0,
            row59Out1: row59High.out1,
            row59Out0: row59High.out0
        )
    }

    public static func builder6388f0FirstPairStreamSeedsFromEntropyAndSensorPoints(
        entrySource: Data,
        nullEntropy11A: Data,
        row0SensorPointXYBE: Data,
        row59SensorPointXYBE: Data,
        x1Source: Data? = nil,
        x2Source: Data? = nil,
        scalar: UInt64? = nil
    ) throws -> Builder6388f0FirstPairStreamSeeds {
        let nullScalar = try builder633fa8NullScalarWindowFromEntropy(entropy11A: nullEntropy11A)
        let staticScalar = try builder633fa8StaticScalarWindowFromEntrySource(entrySource)
        return try builder6388f0FirstPairStreamSeedsFromScalarsAndSensorPoints(
            entrySource: entrySource,
            nullScalarWindow: nullScalar,
            staticScalarWindow: staticScalar,
            row0SensorPointXYBE: row0SensorPointXYBE,
            row59SensorPointXYBE: row59SensorPointXYBE,
            nullEntropy11A: nullEntropy11A,
            nullAttempts: 1,
            x1Source: x1Source,
            x2Source: x2Source,
            scalar: scalar
        )
    }

    public static func builder6388f0FirstPairStreamSeedsFromEntropySourceAndSensorPoints(
        entrySource: Data,
        row0SensorPointXYBE: Data,
        row59SensorPointXYBE: Data,
        maxAttempts: Int = 64,
        x1Source: Data? = nil,
        x2Source: Data? = nil,
        scalar: UInt64? = nil,
        entropySource: (Int) throws -> Data
    ) throws -> Builder6388f0FirstPairStreamSeeds {
        let nullResult = try builder633fa8NullScalarWindowFromEntropySource(
            maxAttempts: maxAttempts,
            entropySource: entropySource
        )
        let staticScalar = try builder633fa8StaticScalarWindowFromEntrySource(entrySource)
        return try builder6388f0FirstPairStreamSeedsFromScalarsAndSensorPoints(
            entrySource: entrySource,
            nullScalarWindow: nullResult.scalarWindow,
            staticScalarWindow: staticScalar,
            row0SensorPointXYBE: row0SensorPointXYBE,
            row59SensorPointXYBE: row59SensorPointXYBE,
            nullEntropy11A: nullResult.entropy11A,
            nullAttempts: nullResult.attempts,
            x1Source: x1Source,
            x2Source: x2Source,
            scalar: scalar
        )
    }

    public static func builder6388f0LowSeedCF0SeedsFromEntrySource(
        _ entrySource: Data
    ) throws -> Builder6388f0LowSeedCF0Seeds {
        guard entrySource.count >= builder6388f0LowSeedEntrySourceBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "6388f0 low-seed entry source",
                entrySource.count,
                builder6388f0LowSeedEntrySourceBytes
            )
        }

        let tables = try cachedTables.get()
        let source = [UInt8](entrySource)
        let entryHead = Array(source[0..<builder6388f0LowSeedBlockBytes])
        let entryTail = Array(source[builder6388f0LowSeedBlockBytes..<builder6388f0LowSeedEntrySourceBytes])

        let pre2S898 = try vm638840(
            magic: builder6388f0LowSeedEntryS898Magic,
            src1: entryHead,
            src2: entryHead,
            tables: tables
        )
        let pre2S78E = try vm638840(
            magic: builder6388f0LowSeedEntryS78EMagic,
            src1: entryTail,
            src2: entryTail,
            tables: tables
        )
        let phase1SeedCF0 = try vm641fcc(
            magic: builder6388f0LowSeedCF0Phase1SeedMagic,
            src: pre2S78E,
            tables: tables
        )
        let phase1 = try builder6388f0LowSeedPhaseFromCF0Seed(
            spec: builder6388f0LowSeedPhase1Spec,
            seedCF0: phase1SeedCF0,
            tables: tables
        )

        let pre2Static = try builder6388f0LowSeedStaticBlock(
            libOffset: builder6388f0LowSeedPrev2Static,
            tables: tables
        )
        let pre2BD0 = try vm638840(
            magic: builder6388f0LowSeedPrev2BD0Magic,
            src1: phase1.finalCF0,
            src2: pre2Static,
            tables: tables
        )
        let pre2S684 = try vm638840(
            magic: builder6388f0LowSeedPrev2S684Magic,
            src1: pre2BD0,
            src2: pre2BD0,
            tables: tables
        )
        let pre2S57A = try vm638840(
            magic: builder6388f0LowSeedMiddleMagic,
            src1: pre2S898,
            src2: pre2S684,
            tables: tables
        )
        let preS898 = try vm638840(
            magic: builder6388f0LowSeedTailLeftMagic,
            src1: pre2S78E,
            src2: pre2S78E,
            tables: tables
        )
        let preS78E = try vm638840(
            magic: builder6388f0LowSeedTailRightMagic,
            src1: pre2S57A,
            src2: pre2S57A,
            tables: tables
        )
        let phase2SeedCF0 = try vm641fcc(
            magic: builder6388f0LowSeedCF0Phase2SeedMagic,
            src: preS78E,
            tables: tables
        )
        let phase2 = try builder6388f0LowSeedPhaseFromCF0Seed(
            spec: builder6388f0LowSeedPhase2Spec,
            seedCF0: phase2SeedCF0,
            tables: tables
        )

        let preStatic = try builder6388f0LowSeedStaticBlock(
            libOffset: builder6388f0LowSeedPreStatic,
            tables: tables
        )
        let preBD0 = try vm638840(
            magic: builder6388f0LowSeedPreBD0Magic,
            src1: phase2.finalCF0,
            src2: preStatic,
            tables: tables
        )
        let prevS684 = try vm638840(
            magic: builder6388f0LowSeedPrevS684Magic,
            src1: preBD0,
            src2: preBD0,
            tables: tables
        )
        let prevS57A = try vm638840(
            magic: builder6388f0LowSeedMiddleMagic,
            src1: preS898,
            src2: prevS684,
            tables: tables
        )
        let seedS78E = try vm638840(
            magic: builder6388f0LowSeedTailRightMagic,
            src1: prevS57A,
            src2: prevS57A,
            tables: tables
        )
        let phase3SeedCF0 = try vm641fcc(
            magic: builder6388f0LowSeedCF0Phase3SeedMagic,
            src: seedS78E,
            tables: tables
        )

        return Builder6388f0LowSeedCF0Seeds(
            phase1: Data(phase1SeedCF0),
            phase2: Data(phase2SeedCF0),
            phase3: Data(phase3SeedCF0)
        )
    }

    public static func builder6388f0LowSeedTailPairFromEntrySource(
        _ entrySource: Data
    ) throws -> Builder6388f0LowSeedTailPair {
        let tables = try cachedTables.get()
        let seeds = try builder6388f0LowSeedCF0SeedsFromEntrySource(entrySource)
        let phase1 = try builder6388f0LowSeedPhaseFromCF0Seed(
            spec: builder6388f0LowSeedPhase1Spec,
            seedCF0: [UInt8](seeds.phase1),
            tables: tables
        )
        let phase2 = try builder6388f0LowSeedPhaseFromCF0Seed(
            spec: builder6388f0LowSeedPhase2Spec,
            seedCF0: [UInt8](seeds.phase2),
            tables: tables
        )
        let phase3 = try builder6388f0LowSeedPhaseFromCF0Seed(
            spec: builder6388f0LowSeedPhase3Spec,
            seedCF0: [UInt8](seeds.phase3),
            tables: tables
        )
        return try builder6388f0LowSeedTailPairFromEntryAndCF0(
            entrySource,
            pre2CF0: phase1.finalCF0,
            preCF0: phase2.finalCF0,
            tailCF0: phase3.finalCF0,
            tables: tables
        )
    }

    public static func builder6388f0LowSeedTailStageFromPair(
        _ pair: Builder6388f0LowSeedTailPair
    ) throws -> Data {
        let tables = try cachedTables.get()
        try require([UInt8](pair.left), count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed tail left")
        try require([UInt8](pair.right), count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed tail right")
        return Data(try vm638840(
            magic: builder6388f0LowSeedTailStageMagic,
            src1: [UInt8](pair.left),
            src2: [UInt8](pair.right),
            tables: tables
        ))
    }

    public static func builder6388f0LowSeedPreludeSourceFromTailStage(
        _ tailStage: Data
    ) throws -> Data {
        let tables = try cachedTables.get()
        let stageInput = [UInt8](tailStage)
        try require(stageInput, count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed tail stage")
        let stage = try vm638840(
            magic: builder6388f0LowSeedPreludeStageMagic,
            src1: stageInput,
            src2: stageInput,
            tables: tables
        )
        return Data(try vm638840(
            magic: builder6388f0LowSeedPreludeSourceMagic,
            src1: stage,
            src2: stage,
            tables: tables
        ))
    }

    public static func builder6388f0LowSeedBlocksFromPreludeSource(
        _ preludeSource: Data
    ) throws -> Data {
        let tables = try cachedTables.get()
        let prelude = [UInt8](preludeSource)
        try require(prelude, count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed prelude source")
        let expanded = try vm6420d8(
            magic: builder6388f0LowSeedPreludeMagic,
            src1: prelude,
            src2: prelude,
            tables: tables
        )
        guard expanded.count == builder6388f0LowSeedExpandedPreludeBytes else {
            throw FirstPairSourceSliceError.invalidLowSeedExpandedPreludeLength(expanded.count)
        }

        var out: [UInt8] = []
        out.reserveCapacity(builder6388f0LowSeedSeedBlocksBytes)
        for index in 0..<19 {
            let start = index * 0x0e
            let block = Array(expanded[start..<(start + 0x10)])
            out.append(contentsOf: try vm638840(
                magic: builder6388f0Row0SeedBlockMagic,
                src1: block,
                src2: block,
                tables: tables
            ))
        }
        let staticBlock = try builder6388f0LowLoopStaticBlock(
            libOffset: builder6388f0LowSeedStaticBlockOffset,
            byteCount: 0x10,
            tables: tables
        )
        out.append(contentsOf: try vm638840(
            magic: builder6388f0Row0SeedBlockMagic,
            src1: staticBlock,
            src2: staticBlock,
            tables: tables
        ))
        return Data(out)
    }

    public static func builder6388f0LowSeedLoopFromBlocks(
        _ seedBlocks: Data
    ) throws -> Builder6388f0LowSeedLoopResult {
        guard seedBlocks.count == builder6388f0LowSeedSeedBlocksBytes else {
            throw FirstPairSourceSliceError.invalidLowSeedSeedBlocksLength(seedBlocks.count)
        }
        let tables = try cachedTables.get()
        let blocks = [UInt8](seedBlocks)
        var scheduleWords: [UInt32] = []
        scheduleWords.reserveCapacity(20)
        var final6377f0: [UInt8] = []

        for outerIndex in 0..<20 {
            let lane = outerIndex & 7
            var cLane = try builder6388f0LowLoopStaticBlock(
                libOffset: builder6388f0LowLoopStaticCTable,
                byteCount: 0x10,
                tables: tables
            )
            cLane.append(contentsOf: [0x05, 0x04])

            let eSource = try builder6388f0LowLoopStaticBlock(
                libOffset: builder6388f0LowLoopStaticETable + builder6388f0LowLoopLaneBytes * lane,
                byteCount: builder6388f0LowLoopLaneBytes,
                tables: tables
            )
            var eLane = try vm638840(
                magic: builder6388f0LowLoopEInitMagic,
                src1: eSource,
                src2: eSource,
                tables: tables
            )
            let blockOffset = outerIndex * 0x10
            let block = Array(blocks[blockOffset..<(blockOffset + 0x10)])
            let dLane = try vm6420d8(
                magic: builder6388f0LowLoopDInitMagic,
                src1: block,
                src2: block,
                tables: tables
            )
            var bLane = try vm638840(
                magic: builder6388f0LowLoopBInitMagic,
                src1: eLane,
                src2: eLane,
                tables: tables
            )

            var aLane = [UInt8](repeating: 0, count: builder6388f0LowLoopLaneBytes)
            var tLane = [UInt8](repeating: 0, count: builder6388f0LowLoopLaneBytes)
            for _ in 0..<28 {
                let fLane = try vm638840(
                    magic: builder6388f0LowLoopFMagic,
                    src1: dLane,
                    src2: cLane,
                    tables: tables
                )
                let aSource = try builder6388f0LowLoopStaticBlock(
                    libOffset: builder6388f0LowLoopStaticATable,
                    byteCount: builder6388f0LowLoopLaneBytes,
                    tables: tables
                )
                aLane = try vm638840(
                    magic: builder6388f0LowLoopAMagic,
                    src1: aSource,
                    src2: fLane,
                    tables: tables
                )
                tLane = try vm638840(
                    magic: builder6388f0LowLoopTMagic,
                    src1: eLane,
                    src2: aLane,
                    tables: tables
                )
                bLane = try vm638840(
                    magic: builder6388f0LowLoopBMixMagic,
                    src1: bLane,
                    src2: tLane,
                    tables: tables
                )
                eLane = try vm638840(
                    magic: builder6388f0LowLoopEAdvanceMagic,
                    src1: eLane,
                    src2: eLane,
                    tables: tables
                )
                cLane = try vm638840(
                    magic: builder6388f0LowLoopCAdvanceMagic,
                    src1: cLane,
                    src2: cLane,
                    tables: tables
                )
            }

            final6377f0 = tLane
            let fLane = try vm638840(
                magic: builder6388f0LowLoopPostFMagic,
                src1: bLane,
                src2: eLane,
                tables: tables
            )
            let dSource = try builder6388f0LowLoopStaticBlock(
                libOffset: builder6388f0LowLoopStaticDTable + builder6388f0LowLoopLaneBytes * lane,
                byteCount: builder6388f0LowLoopLaneBytes,
                tables: tables
            )
            let postDLane = try vm638840(
                magic: builder6388f0LowLoopPostDMagic,
                src1: fLane,
                src2: dSource,
                tables: tables
            )
            var packELane = try vm641fcc(
                magic: builder6388f0LowLoopPostEMagic,
                src: postDLane,
                tables: tables
            )

            var packedLane = aLane
            packedLane.replaceSubrange(0..<4, with: [0, 0, 0, 0])
            var shift = 32
            for packIndex in 0..<8 {
                let cWord = try vm638840(
                    magic: builder6388f0LowLoopPackCMagic,
                    src1: packELane,
                    src2: packELane,
                    tables: tables
                )
                if shift >= 5 {
                    packELane = try vm6420d8(
                        magic: builder6388f0LowLoopPackEMagic,
                        src1: packELane,
                        src2: packELane,
                        tables: tables
                    )
                }
                let bWord = try vm638840(
                    magic: builder6388f0LowLoopPackBMagic,
                    src1: cWord,
                    src2: cWord,
                    tables: tables
                )
                let selected = Int(bWord[2]) ^ (Int(bWord[3]) << 3)
                let packed = try builder6388f0LowLoopStaticByte(
                    libOffset: builder6388f0LowLoopNibbleTable + selected,
                    tables: tables
                )
                var nibble = (packIndex & 1) == 0 ? (packed & 0x0f) : (packed >> 4)
                if shift < 4 {
                    let mask = shift == 0 ? 0 : UInt8((1 << shift) - 1)
                    nibble &= mask
                }

                let byteIndex = packIndex >> 1
                if (packIndex & 1) == 0 {
                    packedLane[byteIndex] = nibble
                } else {
                    packedLane[byteIndex] ^= nibble << 4
                }
                shift = max(shift - 4, 0)
            }
            scheduleWords.append(readUInt32LE(packedLane, 0))
        }

        return Builder6388f0LowSeedLoopResult(
            final6377f0: Data(final6377f0),
            scheduleWords: scheduleWords
        )
    }

    public static func builder6388f0Row0LowSeedPreimagesFromEntrySource(
        _ entrySource: Data
    ) throws -> Builder6388f0Row0LowSeedPreimages {
        let tables = try cachedTables.get()
        let seeds = try builder6388f0LowSeedCF0SeedsFromEntrySource(entrySource)
        let phase3 = try builder6388f0LowSeedPhaseFromCF0Seed(
            spec: builder6388f0LowSeedPhase3Spec,
            seedCF0: [UInt8](seeds.phase3),
            tables: tables
        )
        let tailStatic = try builder6388f0LowSeedStaticBlock(
            libOffset: builder6388f0LowSeedTailStatic,
            tables: tables
        )
        let tailBD0 = try vm638840(
            magic: builder6388f0LowSeedTailBD0Magic,
            src1: phase3.finalCF0,
            src2: tailStatic,
            tables: tables
        )
        let tailS684 = try vm638840(
            magic: builder6388f0LowSeedTailS684Magic,
            src1: tailBD0,
            src2: tailBD0,
            tables: tables
        )
        let pair = try builder6388f0LowSeedTailPairFromEntrySource(entrySource)
        let tailStage = try builder6388f0LowSeedTailStageFromPair(pair)
        let preludeSource = try builder6388f0LowSeedPreludeSourceFromTailStage(tailStage)
        let seedBlocks = try builder6388f0LowSeedBlocksFromPreludeSource(preludeSource)
        let loop = try builder6388f0LowSeedLoopFromBlocks(seedBlocks)

        let baseOut3 = Data(tailS684[204..<266]) + Data(pair.right.prefix(26))
        var out3 = Data(baseOut3.prefix(62))
        out3.append(loop.final6377f0)
        out3.append(Data(baseOut3.suffix(8)))
        return Builder6388f0Row0LowSeedPreimages(
            out4: Data(tailS684[116..<204]),
            out3: out3,
            out2: Data(pair.right[26..<114])
        )
    }

    public static func builder633fa8StaticPreludeSourceFromEntrySource(
        _ entrySource: Data
    ) throws -> Data {
        let pair = try builder6388f0LowSeedTailPairFromEntrySource(entrySource)
        let tailStage = try builder6388f0LowSeedTailStageFromPair(pair)
        return try builder6388f0LowSeedPreludeSourceFromTailStage(tailStage)
    }

    public static func builder633fa8StaticTailBoundaryFromEntrySource(
        _ entrySource: Data
    ) throws -> Builder633fa8TailBoundary {
        let preludeSource = try builder633fa8StaticPreludeSourceFromEntrySource(entrySource)
        return try builder633fa8TailBoundaryFromPreludeSource(preludeSource)
    }

    public static func builder633fa8TailBoundaryFromPreludeSource(
        _ preludeSource: Data
    ) throws -> Builder633fa8TailBoundary {
        let seedBlocks = try builder6388f0LowSeedBlocksFromPreludeSource(preludeSource)
        let loop = try builder6388f0LowSeedLoopFromBlocks(seedBlocks)
        return Builder633fa8TailBoundary(
            words3ab0: loop.scheduleWords,
            words3120: builder633fa8InvariantWords3120,
            words2dfc: builder633fa8InvariantWords2dfc,
            seed3110: builder633fa8InvariantSeed3110,
            preludeSource: preludeSource
        )
    }

    public static func builder633fa8ScalarWindowFromPreludeSource(
        _ preludeSource: Data
    ) throws -> Data {
        let boundary = try builder633fa8TailBoundaryFromPreludeSource(preludeSource)
        let qwords = try builder633fa8TailQwordsFromSources(
            words3ab0: boundary.words3ab0,
            words3120: boundary.words3120,
            words2dfc: boundary.words2dfc,
            seed3110: boundary.seed3110
        )
        let e10Words = try builder633fa8E10WordsFromTailQwords(qwords)
        return try builder633fa8ScalarWindowFromE10Words(e10Words)
    }

    public static func builder633fa8StaticScalarWindowFromEntrySource(
        _ entrySource: Data
    ) throws -> Data {
        let preludeSource = try builder633fa8StaticPreludeSourceFromEntrySource(entrySource)
        return try builder633fa8ScalarWindowFromPreludeSource(preludeSource)
    }

    public static func builder633fa8NullEntrySourcesFromInvariantEntry() throws -> Builder633fa8NullEntrySources {
        let (prologue, cursor) = try unpack3BitStream5bdd14(
            source: builder633fa8NullEntryBitsChecksSource,
            offset: 0,
            count: builder633fa8NullEntropyBytes
        )
        let checkBytes = builder633fa8ScalarWordCount * 4
        guard cursor + 2 * checkBytes <= builder633fa8NullEntryBitsChecksSource.count else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "633fa8 null entry checks",
                builder633fa8NullEntryBitsChecksSource.count,
                cursor + 2 * checkBytes
            )
        }
        let check1 = (0..<builder633fa8ScalarWordCount).map {
            readUInt32LE(builder633fa8NullEntryBitsChecksSource, cursor + $0 * 4)
        }
        let check2 = (0..<builder633fa8ScalarWordCount).map {
            readUInt32LE(builder633fa8NullEntryBitsChecksSource, cursor + checkBytes + $0 * 4)
        }
        return Builder633fa8NullEntrySources(
            prologueSource: Data(prologue),
            check1SourceWords: check1,
            check2SourceWords: check2
        )
    }

    public static func builder633fa8NullInitialFromEntropy(
        entropy11A: Data,
        prologueSource: Data
    ) throws -> Builder633fa8NullInitialResult {
        guard entropy11A.count == builder633fa8NullEntropyBytes else {
            throw FirstPairSourceSliceError.invalid633fa8NullEntropyLength(entropy11A.count)
        }
        guard prologueSource.count >= builder633fa8NullEntropyBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "633fa8 null prologue source",
                prologueSource.count,
                builder633fa8NullEntropyBytes
            )
        }
        let tables = try cachedTables.get()
        let maskedEntropy = [UInt8](entropy11A).map { $0 & 7 }
        let prologue = Array([UInt8](prologueSource).prefix(builder633fa8NullEntropyBytes))
        let cf0 = try vm638840(
            magic: builder633fa8NullInitialAMagic,
            src1: maskedEntropy,
            src2: prologue,
            tables: tables
        )
        let e10 = try vm638840(
            magic: builder633fa8NullInitialBMagic,
            src1: cf0,
            src2: cf0,
            tables: tables
        )
        guard e10.count >= builder633fa8NullEntropyBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "633fa8 null initial e10",
                e10.count,
                builder633fa8NullEntropyBytes
            )
        }

        let lastSeedInputEnd = (builder633fa8ScalarWordCount - 1) * builder633fa8NullSeedBlockStride +
            builder633fa8NullSeedBlockBytes
        guard e10.count >= lastSeedInputEnd else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "633fa8 null initial seed input source",
                e10.count,
                lastSeedInputEnd
            )
        }

        var seedInputs: [UInt8] = []
        seedInputs.reserveCapacity(builder633fa8ScalarWordCount * builder633fa8NullSeedBlockBytes)
        for index in 0..<builder633fa8ScalarWordCount {
            let start = index * builder633fa8NullSeedBlockStride
            seedInputs.append(contentsOf: e10[start..<(start + builder633fa8NullSeedBlockBytes)])
        }

        var seedBlocks: [UInt8] = []
        seedBlocks.reserveCapacity(builder633fa8ScalarWordCount * builder633fa8NullSeedBlockBytes)
        for index in 0..<builder633fa8ScalarWordCount {
            let start = index * builder633fa8NullSeedBlockBytes
            let block = Array(seedInputs[start..<(start + builder633fa8NullSeedBlockBytes)])
            seedBlocks.append(contentsOf: try vm638840(
                magic: builder633fa8NullSeedBlockMagic,
                src1: block,
                src2: block,
                tables: tables
            ))
        }

        return Builder633fa8NullInitialResult(
            maskedEntropy: Data(maskedEntropy),
            cf0: Data(cf0),
            e10: Data(e10),
            seedInputs: Data(seedInputs),
            seedBlocks: Data(seedBlocks)
        )
    }

    public static func builder633fa8NullFirstLoopFromBlocks(
        _ seedBlocks: Data
    ) throws -> Builder633fa8NullFirstLoopResult {
        guard seedBlocks.count == builder633fa8NullSeedBlocksBytes else {
            throw FirstPairSourceSliceError.invalid633fa8NullSeedBlocksLength(seedBlocks.count)
        }
        let tables = try cachedTables.get()
        let blocks = [UInt8](seedBlocks)
        var scheduleWords: [UInt32] = []
        scheduleWords.reserveCapacity(builder633fa8ScalarWordCount)
        var finalTLane: [UInt8] = []

        for outerIndex in 0..<builder633fa8ScalarWordCount {
            let lane = outerIndex & 7
            var cLane = try builder633fa8NullTableBlock(
                libOffset: builder633fa8NullLoopStaticCTable,
                byteCount: 0x10,
                tables: tables
            )
            cLane.append(contentsOf: [0x05, 0x05])

            let eSource = try builder633fa8NullTableBlock(
                libOffset: builder633fa8NullLoopStaticETable + builder633fa8NullLoopLaneBytes * lane,
                byteCount: builder633fa8NullLoopLaneBytes,
                tables: tables
            )
            var eLane = try vm638840(
                magic: builder633fa8NullLoopEInitMagic,
                src1: eSource,
                src2: eSource,
                tables: tables
            )
            let blockOffset = outerIndex * builder633fa8NullSeedBlockBytes
            let block = Array(blocks[blockOffset..<(blockOffset + builder633fa8NullSeedBlockBytes)])
            let dLane = try vm6420d8(
                magic: builder633fa8NullLoopDInitMagic,
                src1: block,
                src2: block,
                tables: tables
            )
            var bLane = try vm638840(
                magic: builder633fa8NullLoopBInitMagic,
                src1: eLane,
                src2: eLane,
                tables: tables
            )

            var aLane = [UInt8](repeating: 0, count: builder633fa8NullLoopLaneBytes)
            var tLane = [UInt8](repeating: 0, count: builder633fa8NullLoopLaneBytes)
            for _ in 0..<28 {
                let fLane = try vm638840(
                    magic: builder633fa8NullLoopFMagic,
                    src1: dLane,
                    src2: cLane,
                    tables: tables
                )
                let aSource = try builder633fa8NullTableBlock(
                    libOffset: builder633fa8NullLoopStaticATable,
                    byteCount: builder633fa8NullLoopLaneBytes,
                    tables: tables
                )
                aLane = try vm638840(
                    magic: builder633fa8NullLoopAMagic,
                    src1: aSource,
                    src2: fLane,
                    tables: tables
                )
                tLane = try vm638840(
                    magic: builder633fa8NullLoopTMagic,
                    src1: eLane,
                    src2: aLane,
                    tables: tables
                )
                bLane = try vm638840(
                    magic: builder633fa8NullLoopBMixMagic,
                    src1: bLane,
                    src2: tLane,
                    tables: tables
                )
                eLane = try vm638840(
                    magic: builder633fa8NullLoopEAdvanceMagic,
                    src1: eLane,
                    src2: eLane,
                    tables: tables
                )
                cLane = try vm638840(
                    magic: builder633fa8NullLoopCAdvanceMagic,
                    src1: cLane,
                    src2: cLane,
                    tables: tables
                )
            }

            finalTLane = tLane
            let fLane = try vm638840(
                magic: builder633fa8NullLoopPostFMagic,
                src1: bLane,
                src2: eLane,
                tables: tables
            )
            let dSource = try builder633fa8NullTableBlock(
                libOffset: builder633fa8NullLoopStaticDTable + builder633fa8NullLoopLaneBytes * lane,
                byteCount: builder633fa8NullLoopLaneBytes,
                tables: tables
            )
            let postDLane = try vm638840(
                magic: builder633fa8NullLoopPostDMagic,
                src1: fLane,
                src2: dSource,
                tables: tables
            )
            var packELane = try vm641fcc(
                magic: builder633fa8NullLoopPostEMagic,
                src: postDLane,
                tables: tables
            )

            var packedLane = aLane
            packedLane.replaceSubrange(0..<4, with: [0, 0, 0, 0])
            var shift = 32
            for packIndex in 0..<8 {
                let cWord = try vm638840(
                    magic: builder633fa8NullLoopPackCMagic,
                    src1: packELane,
                    src2: packELane,
                    tables: tables
                )
                if shift >= 5 {
                    packELane = try vm6420d8(
                        magic: builder633fa8NullLoopPackEMagic,
                        src1: packELane,
                        src2: packELane,
                        tables: tables
                    )
                }
                let bWord = try vm638840(
                    magic: builder633fa8NullLoopPackBMagic,
                    src1: cWord,
                    src2: cWord,
                    tables: tables
                )
                let selected = Int(bWord[2]) ^ (Int(bWord[3]) << 3)
                let packed = try builder633fa8NullNibbleByte(
                    libOffset: builder633fa8NullLoopNibbleTable + selected,
                    tables: tables
                )
                var nibble = (packIndex & 1) == 0 ? (packed & 0x0f) : (packed >> 4)
                if shift < 4 {
                    let mask = shift == 0 ? 0 : UInt8((1 << shift) - 1)
                    nibble &= mask
                }

                let byteIndex = packIndex >> 1
                if (packIndex & 1) == 0 {
                    packedLane[byteIndex] = nibble
                } else {
                    packedLane[byteIndex] ^= nibble << 4
                }
                shift = max(shift - 4, 0)
            }

            scheduleWords.append(readUInt32LE(packedLane, 0))
        }

        return Builder633fa8NullFirstLoopResult(
            finalTLane: Data(finalTLane),
            scheduleWords: scheduleWords
        )
    }

    public static func builder633fa8NullScheduleAcceptance(
        scheduleWords: [UInt32],
        check1SourceWords: [UInt32],
        check2SourceWords: [UInt32]
    ) throws -> Builder633fa8NullScheduleAcceptance {
        let tables = try cachedTables.get()
        let firstOK = try builder633fa8NullScheduleCheck(
            scheduleWords: scheduleWords,
            sourceWords: check1SourceWords,
            scheduleMulTable: builder633fa8NullCheck1ScheduleMulTable,
            sourceMulTable: builder633fa8NullCheck1SourceMulTable,
            addTable: builder633fa8NullCheck1AddTable,
            foldTable: builder633fa8NullCheck1FoldTable,
            target: builder633fa8NullCheck1Target,
            foldTarget: builder633fa8NullCheck1FoldTarget,
            tables: tables
        )
        let secondOK = try builder633fa8NullScheduleCheck(
            scheduleWords: scheduleWords,
            sourceWords: check2SourceWords,
            scheduleMulTable: builder633fa8NullCheck2ScheduleMulTable,
            sourceMulTable: builder633fa8NullCheck2SourceMulTable,
            addTable: builder633fa8NullCheck2AddTable,
            foldTable: builder633fa8NullCheck2FoldTable,
            target: builder633fa8NullCheck2Target,
            foldTarget: builder633fa8NullCheck2FoldTarget,
            tables: tables
        )
        return Builder633fa8NullScheduleAcceptance(firstOK: firstOK, secondOK: secondOK)
    }

    public static func builder633fa8NullPostAcceptBlocks(
        scheduleWords: [UInt32]
    ) throws -> Builder633fa8NullPostAcceptResult {
        guard scheduleWords.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalid633fa8WordCount(scheduleWords.count)
        }
        let tables = try cachedTables.get()
        let initCF0 = try builder633fa8NullTableBlock(
            libOffset: builder633fa8NullPostInitCF0Static,
            byteCount: builder633fa8NullSeedBlockBytes,
            tables: tables
        )
        let initBD0 = try builder633fa8NullTableBlock(
            libOffset: builder633fa8NullPostInitBD0Static,
            byteCount: builder633fa8NullSeedBlockBytes,
            tables: tables
        )
        let finalCF0Static = try builder633fa8NullTableBlock(
            libOffset: builder633fa8NullPostFinalCF0Static,
            byteCount: builder633fa8NullLoopLaneBytes,
            tables: tables
        )
        let finalBD0Static = try builder633fa8NullTableBlock(
            libOffset: builder633fa8NullPostFinalBD0Static,
            byteCount: builder633fa8NullLoopLaneBytes,
            tables: tables
        )

        var blocks4080: [UInt8] = []
        var blocks3f40: [UInt8] = []
        blocks4080.reserveCapacity(builder633fa8NullSeedBlocksBytes)
        blocks3f40.reserveCapacity(builder633fa8NullSeedBlocksBytes)

        for (index, scheduleWord) in scheduleWords.enumerated() {
            let tableOffset = (index * 4) & 0x1c
            let selector = scheduleWord
                &* (try u32TableWord63c278(builder633fa8NullPostKeyMulTable + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(builder633fa8NullPostKeyAddTable + tableOffset, tables: tables))
            var cf0State = initCF0
            var bd0State = initBD0

            for shift in [24, 16, 8, 0] {
                let cf0Source = [UInt8](repeating: 0, count: 3)
                    + [0x05]
                    + Array(cf0State[0..<8])
                    + Array(cf0State[8..<12])
                    + Array(cf0State[12..<14])
                let bd0Source = [UInt8](repeating: 0, count: 3)
                    + [0x03]
                    + Array(bd0State[0..<8])
                    + Array(bd0State[8..<12])
                    + Array(bd0State[12..<14])
                let cf0 = try vm638840(
                    magic: builder633fa8NullPostInitCF0Magic,
                    src1: cf0Source,
                    src2: cf0Source,
                    tables: tables
                )
                let bd0 = try vm638840(
                    magic: builder633fa8NullPostInitBD0Magic,
                    src1: bd0Source,
                    src2: bd0Source,
                    tables: tables
                )
                let byteValue = Int((selector >> UInt32(shift)) & 0xff)
                let cf0Row = try expand3BitPairTableRow633fa8Null(
                    try builder633fa8NullTableBlock(
                        libOffset: builder633fa8NullPostTableCF0 + byteValue * 9,
                        byteCount: 9,
                        tables: tables
                    )
                )
                let bd0Row = try expand3BitPairTableRow633fa8Null(
                    try builder633fa8NullTableBlock(
                        libOffset: builder633fa8NullPostTableBD0 + byteValue * 9,
                        byteCount: 9,
                        tables: tables
                    )
                )
                cf0State = try vm638840(
                    magic: builder633fa8NullPostMixCF0Magic,
                    src1: cf0,
                    src2: cf0Row,
                    tables: tables
                )
                bd0State = try vm638840(
                    magic: builder633fa8NullPostMixBD0Magic,
                    src1: bd0,
                    src2: bd0Row,
                    tables: tables
                )
            }

            let e10 = try vm638840(
                magic: builder633fa8NullPostFinalCF0Magic,
                src1: cf0State,
                src2: finalCF0Static,
                tables: tables
            )
            let ab0 = try vm638840(
                magic: builder633fa8NullPostFinalBD0Magic,
                src1: bd0State,
                src2: finalBD0Static,
                tables: tables
            )
            blocks4080.append(contentsOf: try vm638840(
                magic: builder633fa8NullPostBlock4080Magic,
                src1: e10,
                src2: e10,
                tables: tables
            ))
            blocks3f40.append(contentsOf: try vm638840(
                magic: builder633fa8NullPostBlock3f40Magic,
                src1: ab0,
                src2: ab0,
                tables: tables
            ))
        }

        return Builder633fa8NullPostAcceptResult(
            blocks4080: Data(blocks4080),
            blocks3f40: Data(blocks3f40)
        )
    }

    public static func builder633fa8NullPreludeSourceFromPostAccept(
        blocks4080: Data,
        blocks3f40: Data
    ) throws -> Data {
        guard blocks4080.count == builder633fa8NullSeedBlocksBytes else {
            throw FirstPairSourceSliceError.invalid633fa8NullPostAcceptBlocksLength("4080", blocks4080.count)
        }
        guard blocks3f40.count == builder633fa8NullSeedBlocksBytes else {
            throw FirstPairSourceSliceError.invalid633fa8NullPostAcceptBlocksLength("3f40", blocks3f40.count)
        }

        let tables = try cachedTables.get()
        let bytes4080 = [UInt8](blocks4080)
        let first4080Block = Array(bytes4080[0..<builder633fa8NullSeedBlockBytes])
        let first4080 = try vm638840(
            magic: builder633fa8NullPreludeFirst4080Magic,
            src1: first4080Block,
            src2: first4080Block,
            tables: tables
        )
        var rest4080: [UInt8] = []
        rest4080.reserveCapacity((builder633fa8ScalarWordCount - 1) * builder633fa8NullSeedBlockBytes)
        for index in 1..<builder633fa8ScalarWordCount {
            let start = index * builder633fa8NullSeedBlockBytes
            let block = Array(bytes4080[start..<(start + builder633fa8NullSeedBlockBytes)])
            rest4080.append(contentsOf: try vm638840(
                magic: builder633fa8NullPreludeRest4080Magic,
                src1: block,
                src2: block,
                tables: tables
            ))
        }
        let stitched4080 = try stitch633fa8NullPrelude11A(
            firstBlock: first4080,
            restBlocks: rest4080
        )
        let bd0 = try vm638840(
            magic: builder633fa8NullPreludeBD0Magic,
            src1: stitched4080,
            src2: stitched4080,
            tables: tables
        )

        let bytes3f40 = [UInt8](blocks3f40)
        let first3f40Block = Array(bytes3f40[0..<builder633fa8NullSeedBlockBytes])
        let first3f40 = try vm638840(
            magic: builder633fa8NullPreludeFirst3f40Magic,
            src1: first3f40Block,
            src2: first3f40Block,
            tables: tables
        )
        var rest3f40: [UInt8] = []
        rest3f40.reserveCapacity((builder633fa8ScalarWordCount - 1) * builder633fa8NullSeedBlockBytes)
        for index in 1..<builder633fa8ScalarWordCount {
            let start = index * builder633fa8NullSeedBlockBytes
            let block = Array(bytes3f40[start..<(start + builder633fa8NullSeedBlockBytes)])
            rest3f40.append(contentsOf: try vm638840(
                magic: builder633fa8NullPreludeRest3f40Magic,
                src1: block,
                src2: block,
                tables: tables
            ))
        }
        let stitched3f40 = try stitch633fa8NullPrelude11A(
            firstBlock: first3f40,
            restBlocks: rest3f40
        )
        let ab0 = try vm638840(
            magic: builder633fa8NullPreludeAB0Magic,
            src1: stitched3f40,
            src2: stitched3f40,
            tables: tables
        )
        let stage4080 = try vm638840(
            magic: builder633fa8NullPreludeStage4080Magic,
            src1: bd0,
            src2: ab0,
            tables: tables
        )
        let f40 = try vm638840(
            magic: builder633fa8NullPreludeF40Magic,
            src1: stage4080,
            src2: ab0,
            tables: tables
        )
        return Data(try vm638840(
            magic: builder633fa8NullPreludeSourceMagic,
            src1: f40,
            src2: f40,
            tables: tables
        ))
    }

    public static func builder633fa8NullPreludeSourceFromEntropy(
        entropy11A: Data
    ) throws -> Data {
        let sources = try builder633fa8NullEntrySourcesFromInvariantEntry()
        let initial = try builder633fa8NullInitialFromEntropy(
            entropy11A: entropy11A,
            prologueSource: sources.prologueSource
        )
        let loop = try builder633fa8NullFirstLoopFromBlocks(initial.seedBlocks)
        let acceptance = try builder633fa8NullScheduleAcceptance(
            scheduleWords: loop.scheduleWords,
            check1SourceWords: sources.check1SourceWords,
            check2SourceWords: sources.check2SourceWords
        )
        guard acceptance.firstOK && acceptance.secondOK else {
            throw FirstPairSourceSliceError.rejected633fa8NullEntropy
        }

        let postAccept = try builder633fa8NullPostAcceptBlocks(scheduleWords: loop.scheduleWords)
        return try builder633fa8NullPreludeSourceFromPostAccept(
            blocks4080: postAccept.blocks4080,
            blocks3f40: postAccept.blocks3f40
        )
    }

    public static func builder633fa8NullScalarWindowFromEntropy(
        entropy11A: Data
    ) throws -> Data {
        let preludeSource = try builder633fa8NullPreludeSourceFromEntropy(entropy11A: entropy11A)
        return try builder633fa8ScalarWindowFromPreludeSource(preludeSource)
    }

    public static func builder633fa8NullPublicEntrySourceFromEntropy(
        entropy11A: Data
    ) throws -> Data {
        let preludeSource = try builder633fa8NullPreludeSourceFromEntropy(entropy11A: entropy11A)
        let scalar = try builder633fa8ScalarWindowFromPreludeSource(preludeSource)
        return preludeSource + Data(scalar.prefix(0x10))
    }

    public static func builderProcess2P5PublicScalarWindowFromEntropy(
        entropy11A: Data
    ) throws -> Data {
        let qwords = try builderProcess2P5PublicScalarQwordsFromEntropy(entropy11A: entropy11A)
        let words = try builderProcess2P5PublicScalarWordsFromQwords(qwords)
        return try builderProcess2P5PublicScalarWindowFromWords(words)
    }

    public static func builderProcess2P5PublicKey65FromEntropy(
        entropy11A: Data
    ) throws -> Data {
        let scalarWindow = try builderProcess2P5PublicScalarWindowFromEntropy(entropy11A: entropy11A)
        let fixedPoint = Data(process2P5PublicFixedPointBE.dropFirst())
        let outputs = try builder5bcf98P256Outputs(
            scalarWindowLE: scalarWindow,
            sensorPointXYBE: fixedPoint
        )
        let xBE = Data(outputs.xOutput70.prefix(32).reversed())
        let yBE = Data(outputs.yOutput70.prefix(32).reversed())
        return Data([0x04]) + xBE + yBE
    }

    public static func builder633fa8NullScalarWindowFromEntropySource(
        maxAttempts: Int = 64,
        entropySource: (Int) throws -> Data
    ) throws -> Builder633fa8NullScalarResult {
        guard maxAttempts > 0 else {
            throw FirstPairSourceSliceError.invalid633fa8NullMaxAttempts(maxAttempts)
        }

        for attempt in 1...maxAttempts {
            let entropy = try entropySource(builder633fa8NullEntropyBytes)
            do {
                let scalar = try builder633fa8NullScalarWindowFromEntropy(entropy11A: entropy)
                return Builder633fa8NullScalarResult(
                    scalarWindow: scalar,
                    entropy11A: entropy,
                    attempts: attempt
                )
            } catch let error as FirstPairSourceSliceError where error == .rejected633fa8NullEntropy {
                continue
            }
        }
        throw FirstPairSourceSliceError.rejected633fa8NullEntropyAfterAttempts(maxAttempts)
    }

    public static func builder633fa8TailQwordsFromSources(
        words3ab0: [UInt32],
        words3120: [UInt32],
        words2dfc: [UInt32],
        seed3110: UInt64
    ) throws -> [UInt64] {
        guard words3ab0.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalid633fa8TailWordCount("3ab0", words3ab0.count)
        }
        guard words3120.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalid633fa8TailWordCount("3120", words3120.count)
        }
        guard words2dfc.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalid633fa8TailWordCount("2dfc", words2dfc.count)
        }

        let tables = try cachedTables.get()
        var stack = [UInt8](repeating: 0, count: builder633fa8TailStackBytes)

        var word = words3ab0[0] &* 0xc365675b &+ 0xe8f087b3
        var value = try builder633fa8TailStreamU64(
            word,
            wordMul: 0x39629fb00ae1a583,
            wordAdd: 0xc87e38ff2ae3bb2d,
            foldTable: builder633fa8TailAFoldTable,
            foldMul: 0xd0779b0b00000000,
            mixMul: 0x7168c55d8932925f,
            mixAdd: 0x9f10057a9662ab2d,
            tables: tables
        )
        writeUInt64LE(value, into: &stack, at: 0x3f40)
        writeUInt64LE(value, into: &stack, at: 0x3cf0)
        var prefix = value
        for index in 1..<builder633fa8ScalarWordCount {
            word = try u32Affine633fa8Tail(words3ab0[index], index: index, mulTable: 0x11fd08, addTable: 0x11fd28, tables: tables)
            word = word &* 0x6ebad499 &+ 0x8b060038
            value = try builder633fa8TailStreamU64(
                word,
                wordMul: 0x39629fb00ae1a583,
                wordAdd: 0xc87e38ff2ae3bb2d,
                foldTable: builder633fa8TailAFoldTable,
                foldMul: 0xd0779b0b00000000,
                mixMul: 0x7168c55d8932925f,
                mixAdd: 0x9f10057a9662ab2d,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x3f40 + index * 8)
            prefix = prefix &+ value
            writeUInt64LE(prefix, into: &stack, at: 0x3cf0 + index * 8)
        }

        word = words3120[0] &* 0x21753b73 &+ 0x9f972fa4
        value = try builder633fa8TailStreamU64(
            word,
            wordMul: 0xc16bd9358bd641f1,
            wordAdd: 0xdbd59c6303e46229,
            foldTable: builder633fa8TailBFoldTable,
            foldMul: 0xe919ac4d00000000,
            mixMul: 0x0eb018d832b73e83,
            mixAdd: 0x1f4e35decd254a8b,
            tables: tables
        )
        writeUInt64LE(value, into: &stack, at: 0x3e10)
        writeUInt64LE(value, into: &stack, at: 0x3bd0)
        prefix = value
        for index in 1..<builder633fa8ScalarWordCount {
            word = try u32Affine633fa8Tail(words3120[index], index: index, mulTable: 0x112528, addTable: 0x112548, tables: tables)
            word = word &* 0x740d5673 &+ 0xf3b4a3bc
            value = try builder633fa8TailStreamU64(
                word,
                wordMul: 0xc16bd9358bd641f1,
                wordAdd: 0xdbd59c6303e46229,
                foldTable: builder633fa8TailBFoldTable,
                foldMul: 0xe919ac4d00000000,
                mixMul: 0x0eb018d832b73e83,
                mixAdd: 0x1f4e35decd254a8b,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x3e10 + index * 8)
            prefix = prefix &+ value
            writeUInt64LE(prefix, into: &stack, at: 0x3bd0 + index * 8)
        }

        convolutionWorkspace633fa8Tail(
            stack: &stack,
            aVectorOffset: 0x3e10,
            aPrefixOffset: 0x3bd0,
            bVectorOffset: 0x3f40,
            bPrefixOffset: 0x3cf0,
            outOffset: 0x4080,
            length: builder633fa8ScalarWordCount,
            outputCount: 42,
            countMul: 0x88edcb9fcc5a504f,
            countAdd: 0xc50c4cfe6b90cc32,
            productMul: 0xb280f1fcde620b25,
            bPrefixMul: 0x24cc8b7736fa66cf,
            aPrefixMul: 0x0512ce98be108b3a5,
            finalMul: 0xe8cb5b6d2f40c331,
            finalAdd: 0xeb47abb56d203e7d
        )

        for (index, sourceWord) in words2dfc.enumerated() {
            word = try u32Affine633fa8Tail(sourceWord, index: index, mulTable: 0x11b268, addTable: 0x120e48, tables: tables)
            word = word &* 0x4890e04f &+ 0xc2cec971
            value = try builder633fa8TailStreamU64(
                word,
                wordMul: 0xe2d3ea4512d167e7,
                wordAdd: 0x00a7c876b324afde01,
                foldTable: builder633fa8TailCFoldTable,
                foldMul: 0xc4e79ba300000000,
                mixMul: 0xf5ea48539d50faeb,
                mixAdd: 0x37ffe0ce46814927,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x3f40 + index * 8)
        }

        let q = (0..<builder633fa8ScalarWordCount).map { readUInt64LE(stack, 0x3f40 + $0 * 8) }
        var x30 = readUInt64LE(stack, 0x4080)
        let seedA = seed3110 &* 0xac33be2f37df9899 &+ 0xf586b9c725fc2655
        let seedB = seed3110 &* 0xc460e481253db509 &+ 0x5642aeb8585a52eb

        for byteOffset in stride(from: 0, to: 0xb0, by: 8) {
            let position = 0x4080 + byteOffset
            var x10 = x30 &* seedA &+ seedB
            var folded = try fold633fa8Tail(
                x10 &* 0x09883223fa4660ed &+ 0x2d97cba42b4b302f,
                tableOffset: builder633fa8TailDFoldTable,
                rounds: 7,
                tables: tables
            )
            x10 = x10 &* 0x9c92333d4c3638c9
                &+ folded &* 0x718df58330000000
                &+ 0xdb9c322f9570a279

            let x7 = x10 &* 0x06192264fc57feaf &+ 0xe244b4f2265375bf
            let x21 = x10 &* 0x3fd0fde8a99b1d3c &+ 0x7bd7d5be27b1d17c
            let x3 = x7 &* q[8] &+ x21
            x30 = x7 &* q[0] &+ x21 &+ x30
            let x4 = x7 &* q[9] &+ x21

            folded = try fold633fa8Tail(
                x30 &* 0xa5ba351ba23facf5 &+ 0x0720c6fcb580eff2,
                tableOffset: builder633fa8TailEFoldTable,
                rounds: 7,
                tables: tables
            )
            var x12 = folded &* 0x9549f71510a8f0e7 &+ 0x2d3bf7a5dd39f0ab
            folded = try fold633fa8Tail(
                x12 &* 0xead4735c0bc5924d &+ 0x73beb11d9159837c,
                tableOffset: builder633fa8TailFFoldTable,
                rounds: 9,
                tables: tables
            )
            var x8Mix = x12 &* 0x7794ebcd6781608d &+ folded &* 0xafc58bf000000000

            let old08 = readUInt64LE(stack, position + 0x08)
            let old10 = readUInt64LE(stack, position + 0x10)
            var x13 = x7 &* q[1] &+ x21 &+ old08
            let x11 = x7 &* q[2] &+ x21 &+ old10
            writeUInt64LE(x30, into: &stack, at: position)
            writeUInt64LE(x13, into: &stack, at: position + 0x08)

            let acc13 = x7 &* q[13] &+ x21
            let old18 = readUInt64LE(stack, position + 0x18)
            let old20 = readUInt64LE(stack, position + 0x20)
            var x14 = x7 &* q[3] &+ x21 &+ old18
            let x15 = x7 &* q[4] &+ x21 &+ old20

            let old28 = readUInt64LE(stack, position + 0x28)
            let old30 = readUInt64LE(stack, position + 0x30)
            let x16 = x7 &* q[5] &+ x21 &+ old28
            var x17 = x7 &* q[6] &+ x21 &+ old30
            writeUInt64LE(x14, into: &stack, at: position + 0x18)
            writeUInt64LE(x15, into: &stack, at: position + 0x20)

            let old38 = readUInt64LE(stack, position + 0x38)
            let old40 = readUInt64LE(stack, position + 0x40)
            var acc15 = x7 &* q[14] &+ x21
            let x1 = x7 &* q[7] &+ x21 &+ old38
            let x16b = x3 &+ old40
            writeUInt64LE(x16, into: &stack, at: position + 0x28)
            writeUInt64LE(x17, into: &stack, at: position + 0x30)

            let old48 = readUInt64LE(stack, position + 0x48)
            let old50 = readUInt64LE(stack, position + 0x50)
            let acc0 = x7 &* q[15] &+ x21
            x14 = x4 &+ old48
            let acc2 = x7 &* q[10] &+ x21
            x17 = acc2 &+ old50
            writeUInt64LE(x1, into: &stack, at: position + 0x38)
            writeUInt64LE(x16b, into: &stack, at: position + 0x40)
            writeUInt64LE(x14, into: &stack, at: position + 0x48)
            writeUInt64LE(x17, into: &stack, at: position + 0x50)

            let old58 = readUInt64LE(stack, position + 0x58)
            let old60 = readUInt64LE(stack, position + 0x60)
            let acc12 = x7 &* q[11] &+ x21
            let acc30 = x7 &* q[12] &+ x21
            let acc14 = x7 &* q[16] &+ x21
            x12 = acc12 &+ old58
            x17 = acc30 &+ old60
            let acc1 = x7 &* q[17] &+ x21
            writeUInt64LE(x12, into: &stack, at: position + 0x58)
            writeUInt64LE(x17, into: &stack, at: position + 0x60)

            let old68 = readUInt64LE(stack, position + 0x68)
            let old70 = readUInt64LE(stack, position + 0x70)
            x13 = acc13 &+ old68
            x12 = acc15 &+ old70
            let acc16 = x7 &* q[18] &+ x21
            writeUInt64LE(x13, into: &stack, at: position + 0x68)
            writeUInt64LE(x12, into: &stack, at: position + 0x70)

            let old78 = readUInt64LE(stack, position + 0x78)
            let old80 = readUInt64LE(stack, position + 0x80)
            acc15 = x7 &* q[19] &+ x21
            x12 = acc0 &+ old78
            x13 = acc14 &+ old80
            writeUInt64LE(x12, into: &stack, at: position + 0x78)
            writeUInt64LE(x13, into: &stack, at: position + 0x80)

            x8Mix = x8Mix &* 0x56c495ec086d9247 &+ readUInt64LE(stack, position + 0x08)

            let old88 = readUInt64LE(stack, position + 0x88)
            let old90 = readUInt64LE(stack, position + 0x90)
            x12 = acc1 &+ old88
            x14 = acc16 &+ old90
            writeUInt64LE(x12, into: &stack, at: position + 0x88)
            writeUInt64LE(x14, into: &stack, at: position + 0x90)

            let old98 = readUInt64LE(stack, position + 0x98)
            x12 = acc15 &+ old98
            writeUInt64LE(x12, into: &stack, at: position + 0x98)

            x30 = x8Mix &+ 0xc387faf5615fb2e3
            writeUInt64LE(x30, into: &stack, at: position + 0x08)
            writeUInt64LE(x11, into: &stack, at: position + 0x10)
        }

        return (0..<builder633fa8ScalarWordCount).map { readUInt64LE(stack, 0x4130 + $0 * 8) }
    }

    public static func builder633fa8E10WordsFromTailQwords(
        _ tailQwords: [UInt64]
    ) throws -> [UInt32] {
        guard tailQwords.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalid633fa8QwordCount(tailQwords.count)
        }
        let tables = try cachedTables.get()
        var carry: UInt64 = builder633fa8E10InitialCarry
        var out: [UInt32] = []
        out.reserveCapacity(builder633fa8ScalarWordCount)
        for (index, qword) in tailQwords.enumerated() {
            let source = qword &* builder633fa8E10QwordMul
            carry = carry &* builder633fa8E10CarryMul &+ source
            carry = carry &+ builder633fa8E10CarryAdd

            let foldedSeed = carry &* builder633fa8E10FoldSeedMul &+ builder633fa8E10FoldSeedAdd
            var word = UInt32(carry & 0xffff_ffff) &* builder633fa8E10WordMul
            let folded7 = try fold633fa8Tail(
                foldedSeed,
                tableOffset: builder633fa8E10TailFoldTable,
                rounds: 7,
                tables: tables
            )
            word = word &+ (UInt32(folded7 & 0x0f) << 28) &+ builder633fa8E10WordAdd
            let folded16 = try fold633fa8Tail(
                folded7,
                tableOffset: builder633fa8E10TailFoldTable,
                rounds: 9,
                tables: tables
            )

            let tableOffset = (index * 4) & 0x1c
            word = word &* (try u32TableWord63c278(builder633fa8E10TailMulTable + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(builder633fa8E10TailAddTable + tableOffset, tables: tables))
            out.append(word)

            carry = folded7 &* builder633fa8E10NextCarryFolded7Mul
                &+ folded16 &* builder633fa8E10NextCarryFolded16Mul
                &+ builder633fa8E10NextCarryAdd
        }
        return out
    }

    public static func builder633fa8ScalarWindowFromE10Words(
        _ words: [UInt32]
    ) throws -> Data {
        guard words.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalid633fa8WordCount(words.count)
        }
        let tables = try cachedTables.get()
        var out = [UInt8](repeating: 0, count: builder633fa8ScalarWindowBytes)
        var accumulator: UInt64 = 0
        var bitCount = 0
        var outIndex = 0
        for (index, word) in words.enumerated() {
            let tableOffset = (index * 4) & 0x1c
            var value = UInt32(
                (
                    UInt64(word)
                    &* UInt64(try u32TableWord63c278(
                        builder633fa8ScalarPackMulTable + tableOffset,
                        tables: tables
                    ))
                    &+ UInt64(try u32TableWord63c278(
                        builder633fa8ScalarPackAddTable + tableOffset,
                        tables: tables
                    ))
                ) & 0xffff_ffff
            )
            value = value &* builder633fa8ScalarPackMul &+ builder633fa8ScalarPackAdd
            accumulator ^= UInt64(value) << UInt64(bitCount)
            bitCount += 28
            while bitCount > 16 && outIndex < builder633fa8ScalarWindowBytes - 1 {
                out[outIndex] = UInt8(accumulator & 0xff)
                accumulator >>= 8
                outIndex += 1
                bitCount -= 8
            }
        }
        if bitCount >= 1 && outIndex < builder633fa8ScalarWindowBytes - 1 {
            out[outIndex] = UInt8(accumulator & 0xff)
        }
        return Data(out)
    }

    public static func builder6388f0StreamStart642f60Inputs(
        out0Seed: Data,
        out1Seed: Data,
        x2Source: Data? = nil
    ) throws -> Builder6388f0Next642f60Inputs {
        let resolvedX2 = x2Source ?? streamStart642f60X2Source
        guard resolvedX2.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "6388f0 stream-start 642f60 x2 source",
                resolvedX2.count,
                builder63c278VectorBytes
            )
        }
        return Builder6388f0Next642f60Inputs(
            x0: try builder6388f0StreamStart642f60X0FromOut0Seed(out0Seed),
            x1: try builder6388f0StreamStart642f60X1FromOut1Seed(out1Seed),
            x2: Data(resolvedX2.prefix(builder63c278VectorBytes))
        )
    }

    public static func builder6388f0FirstPair642f60StreamStarts(
        row0Out0Seed: Data,
        row0Out1Seed: Data,
        row59Out0Seed: Data,
        row59Out1Seed: Data,
        x2Source: Data? = nil
    ) throws -> Builder6388f0FirstPair642f60Starts {
        Builder6388f0FirstPair642f60Starts(
            row0: try builder6388f0StreamStart642f60Inputs(
                out0Seed: row0Out0Seed,
                out1Seed: row0Out1Seed,
                x2Source: x2Source
            ),
            row59: try builder6388f0StreamStart642f60Inputs(
                out0Seed: row59Out0Seed,
                out1Seed: row59Out1Seed,
                x2Source: x2Source
            )
        )
    }

    public static func builder6388f0FirstPair642f60StreamStarts(
        seeds: Builder6388f0FirstPairStreamSeeds,
        x2Source: Data? = nil
    ) throws -> Builder6388f0FirstPair642f60Starts {
        try builder6388f0FirstPair642f60StreamStarts(
            row0Out0Seed: seeds.row0Out0,
            row0Out1Seed: seeds.row0Out1,
            row59Out0Seed: seeds.row59Out0,
            row59Out1Seed: seeds.row59Out1,
            x2Source: x2Source
        )
    }

    public static func builder6388f0SharedContextFromBundle() throws -> Data {
        let context = try RuntimeTable.firstPair6388f0SharedContext.load()
        guard context.count == builder6388f0SharedContextLength else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair6388f0SharedContext.rawValue,
                context.count
            )
        }
        return context
    }

    public static func builder6388f0CallerLoopTablesFromBundle() throws -> Builder6388f0CallerLoopTables {
        let interleaved = try RuntimeTable.firstPair6388f0CallerLoopInterleaved.load()
        guard interleaved.count == builder6388f0CallerLoopInterleavedLength else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair6388f0CallerLoopInterleaved.rawValue,
                interleaved.count
            )
        }

        var first = Data()
        var second = Data()
        first.reserveCapacity(builder6388f0CallerLoopTableBytes)
        second.reserveCapacity(builder6388f0CallerLoopTableBytes)
        for row in 0..<builder6388f0CallerLoopTableRows {
            let rowOffset = row * builder6388f0CallerLoopInterleavedRowBytes
            first.append(interleaved[rowOffset..<(rowOffset + builder6388f0CallerLoopRowBytes)])
            second.append(
                interleaved[
                    (rowOffset + builder6388f0CallerLoopRowBytes)..<(rowOffset + builder6388f0CallerLoopInterleavedRowBytes)
                ]
            )
        }
        return Builder6388f0CallerLoopTables(first: first, second: second)
    }

    public static func builder6388f0CallerContextFromLoopTables(
        _ loopTables: Builder6388f0CallerLoopTables
    ) throws -> Data {
        guard loopTables.first.count >= builder6388f0CallerLoopTableBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "6388f0 caller loop table 1",
                loopTables.first.count,
                builder6388f0CallerLoopTableBytes
            )
        }
        guard loopTables.second.count >= builder6388f0CallerLoopTableBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "6388f0 caller loop table 2",
                loopTables.second.count,
                builder6388f0CallerLoopTableBytes
            )
        }

        let shared = try builder6388f0SharedContextFromBundle()
        var context = [UInt8](repeating: 0, count: builder6388f0CallerContextLength)
        replace(&context, at: 0, with: [UInt8](shared))
        replace(
            &context,
            at: builder6388f0CallerLoopTable1ContextOffset,
            with: [UInt8](loopTables.first.prefix(builder6388f0CallerLoopTableBytes))
        )
        replace(
            &context,
            at: builder6388f0CallerLoopTable2ContextOffset,
            with: [UInt8](loopTables.second.prefix(builder6388f0CallerLoopTableBytes))
        )
        return Data(context)
    }

    public static func builder6388f0CallerContextFromBundle() throws -> Data {
        try builder6388f0CallerContextFromLoopTables(builder6388f0CallerLoopTablesFromBundle())
    }

    public static func builder642f60StageSP2A8WordsFromX1(_ x1Source: Data) throws -> [UInt32] {
        guard x1Source.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 x1 source", x1Source.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x1Source)
        var state: UInt32 = 0x373c5287
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)

        for index in 0..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            let word = readUInt32LE(bytes, index * 4)
            let mixed = try u32TableAffine63c278(
                word,
                mulTable: builder642f60SP2A8X1MulTable + tableOffset,
                addTable: builder642f60SP2A8X1AddTable + tableOffset,
                tables: tables
            ) &* 0x3c4be1d6
            state = state &* 0x92c1f72b &+ mixed &+ 0xb77cdf91

            var folded = state &* 0x52c0ee2f &+ 0xaec98dcc
            let sideBase = state &* 0x58fd5601
            folded = try fold32ByNibbles63c278(folded, tableOffset: builder642f60SP2A8FoldTable, rounds: 7, tables: tables)
            let side = sideBase &+ (folded &<< 28) &+ 0x79c97500
            let folded8 = try fold32ByNibbles63c278(folded, tableOffset: builder642f60SP2A8FoldTable, rounds: 1, tables: tables)

            let output = try u32TableAffine63c278(
                side,
                mulTable: builder642f60SP2A8OutMulTable + tableOffset,
                addTable: builder642f60SP2A8OutAddTable + tableOffset,
                tables: tables
            )
            out.append(output)
            state = folded &* 0x01d6d2ed &+ folded8 &* 0xe292d130 &+ 0x57678c8f
        }
        return out
    }

    public static func builder642f60StageSP300WordsFrom64bd0cOutput(_ output: Data) throws -> [UInt32] {
        try builder642f60AffineWordsFrom64bd0cOutput(
            output,
            mulTable: builder642f60SP300MulTable,
            addTable: builder642f60SP300AddTable,
            label: "642f60 first 64bd0c output"
        )
    }

    public static func builder642f60StageSP250WordsFrom64bd0cOutput(_ output: Data) throws -> [UInt32] {
        try builder642f60AffineWordsFrom64bd0cOutput(
            output,
            mulTable: builder642f60SP250MulTable,
            addTable: builder642f60SP250AddTable,
            label: "642f60 second 64bd0c output"
        )
    }

    public static func builder642f60StageSP148WordsFrom64bd0cOutput(_ output: Data) throws -> [UInt32] {
        try builder642f60AffineWordsFrom64bd0cOutput(
            output,
            mulTable: builder642f60SP148MulTable,
            addTable: builder642f60SP148AddTable,
            label: "642f60 third 64bd0c output"
        )
    }

    public static func builder642f60StageSPF0WordsFrom64bd0cOutput(_ output: Data) throws -> [UInt32] {
        try builder642f60AffineWordsFrom64bd0cOutput(
            output,
            mulTable: builder642f60SPF0MulTable,
            addTable: builder642f60SPF0AddTable,
            label: "642f60 fourth 64bd0c output"
        )
    }

    public static func builder642f60StageSP1A0WordsFrom64bd0cOutput(_ output: Data) throws -> [UInt32] {
        try builder642f60AffineWordsFrom64bd0cOutput(
            output,
            mulTable: builder642f60SP1A0MulTable,
            addTable: builder642f60SP1A0AddTable,
            label: "642f60 fifth 64bd0c output"
        )
    }

    public static func builder642f60StageSP1F8WordsFromX0(_ x0Source: Data) throws -> [UInt32] {
        guard x0Source.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 x0 source", x0Source.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x0Source)
        var state: UInt32 = 0x27b40eb7
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)

        for index in 0..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            let word = readUInt32LE(bytes, index * 4)
            let mixed = try u32TableAffine63c278(
                word,
                mulTable: builder642f60SP1F8X0MulTable + tableOffset,
                addTable: builder642f60SP1F8X0AddTable + tableOffset,
                tables: tables
            ) &* 0x8c0bfb6e
            state = state &* 0xcfb36435 &+ mixed &+ 0x11d2681d

            var folded = state &* 0xc337e20f &+ 0x69960635
            folded = try fold32ByNibbles63c278(folded, tableOffset: builder642f60SP1F8FoldTable, rounds: 7, tables: tables)
            let side = state &* 0x37e76a4d &+ folded &* 0xd0000000 &+ 0x0a2a2ce9
            let folded8 = try fold32ByNibbles63c278(folded, tableOffset: builder642f60SP1F8FoldTable, rounds: 1, tables: tables)

            let output = try u32TableAffine63c278(
                side,
                mulTable: builder642f60SP1F8OutMulTable + tableOffset,
                addTable: builder642f60SP1F8OutAddTable + tableOffset,
                tables: tables
            )
            out.append(output)
            state = folded &* 0x01e08913 &+ folded8 &* 0xe1f76ed0 &+ 0xe153bede
        }
        return out
    }

    public static func builder642f60First64bd0cWorkspaceFromX1(
        x1Source: Data,
        sp2a8Words: [UInt32]
    ) throws -> Data {
        guard x1Source.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 x1 source", x1Source.count, builder63c278VectorBytes)
        }
        guard sp2a8Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp2a8Words.count)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x1Source)
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder642f60FirstAWord(readUInt32LE(bytes, index * 4), index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder642f60FirstBWord(sp2a8Words[index], index: index, tables: tables)
        }
        return convolutionWorkspaceU64(
            aWords: aWords,
            bWords: bWords,
            baseAdd: 0xc69bed71f29f125a,
            countMul: 0x90f419f6ac783668,
            productMul: 0x4cb8f06bf0049b7d,
            sumAMul: 0x0f7eac37b6812618,
            sumBMul: 0xd1388a4d4ecb84f3,
            finalMul: 0xdacc0c3ac7084aad,
            finalAdd: 0x094d3bfe92d4e136
        )
    }

    public static func builder642f60Second64bd0cWorkspace(
        sp1f8Words: [UInt32],
        sp300Words: [UInt32]
    ) throws -> Data {
        guard sp1f8Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp1f8Words.count)
        }
        guard sp300Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp300Words.count)
        }
        let tables = try cachedTables.get()
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder642f60SecondAWord(sp1f8Words[index], index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder642f60SecondBWord(sp300Words[index], index: index, tables: tables)
        }
        return convolutionWorkspaceU64(
            aWords: aWords,
            bWords: bWords,
            baseAdd: 0x65de471500bb3121,
            countMul: 0x5b751607ca3bf450,
            productMul: 0xf90d1f20daf847f7,
            sumAMul: 0x3bd2bf8830ac06c7,
            sumBMul: 0x8510f1581a89dd50,
            finalMul: 0x95f22cc42a8e1323,
            finalAdd: 0x54b290ac63e72185
        )
    }

    public static func builder642f60Third64bd0cWorkspaceFromX2(_ x2Source: Data) throws -> Data {
        guard x2Source.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 x2 source", x2Source.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x2Source)
        let sourceWords = (0..<builder63c278VectorWords).map { index in
            readUInt32LE(bytes, index * 4)
        }
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder642f60ThirdAWord(sourceWords[index], index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder642f60ThirdBWord(sourceWords[index], index: index, tables: tables)
        }
        return convolutionWorkspaceU64(
            aWords: aWords,
            bWords: bWords,
            baseAdd: 0x5b1e432b74fd20f9,
            countMul: 0xd6a9de8138afb1c4,
            productMul: 0x491764cf27f996a7,
            sumAMul: 0x5f259b9e6d3d894f,
            sumBMul: 0x0634d81d5a7a1464,
            finalMul: 0x81b9bc3ed86899db,
            finalAdd: 0x7f3bdcb4320a4605
        )
    }

    public static func builder642f60Fourth64bd0cWorkspace(sp148Words: [UInt32]) throws -> Data {
        guard sp148Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp148Words.count)
        }
        let tables = try cachedTables.get()
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder642f60FourthAWord(sp148Words[index], index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder642f60FourthBWord(sp148Words[index], index: index, tables: tables)
        }
        return convolutionWorkspaceU64(
            aWords: aWords,
            bWords: bWords,
            baseAdd: 0xca87452057c62cf5,
            countMul: 0x33f7ea217636a2b0,
            productMul: 0x25c9902b9655a323,
            sumAMul: 0x5486edf9ebf09668,
            sumBMul: 0x9ae2908cd350c4ca,
            finalMul: 0xc84690dc7332d8bf,
            finalAdd: 0x2381c41e82ce093d
        )
    }

    public static func builder642f60MidStageSPA90WordsFromX0(_ x0Source: Data) throws -> [UInt64] {
        guard x0Source.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 x0 source", x0Source.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x0Source)
        var out: [UInt64] = []
        out.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            let affine = try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: builder642f60MidAX0MulTable,
                addTable: builder642f60MidAX0AddTable,
                tables: tables
            )
            let word = affine &* 0x3c1bc237 &+ 0xd6718b75
            let folded = try fold63c278(
                UInt64(word) &* 0x4570116131d5875b &+ 0x4ca880cd5cde550e,
                tableOffset: builder642f60MidAFoldTable,
                rounds: 8,
                tables: tables
            )
            out.append(
                UInt64(word) &* 0xc7860ccbc266aa3d
                &+ folded &* 0xbffb9fb900000000
                &+ 0x0bfdc66a47f4cadf
            )
        }
        return out
    }

    public static func builder642f60MidStageSP40WordsFromSPA90(_ spa90Words: [UInt64]) throws -> [UInt32] {
        guard spa90Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(spa90Words.count)
        }
        let tables = try cachedTables.get()
        var carry: UInt64 = 0xd2263697af87081f
        var out: [UInt32] = []
        out.reserveCapacity(builder64bd0cWorkspaceWords)

        for index in 0..<builder64bd0cWorkspaceWords {
            var low = max(0, index - 21)
            var high = min(index, 21)
            var accum: UInt64 = 0x4ca9f4732c4678da
            while high > low {
                let highWord = spa90Words[high]
                let lowWord = spa90Words[low]
                let left = highWord &* 0xb2358691225cfc35 &+ 0xdf9a7386fc929cb6
                accum = left &* lowWord
                    &+ highWord &* 0xdf9a7386fc929cb6
                    &+ accum
                    &+ 0xe1240ffc79c75054
                high -= 1
                low += 1
            }

            let mixed = accum &* 0x7047539999fd499e
            carry = carry &* 0x7d2900791bc15f17
            let state: UInt64
            if high == low {
                let center = spa90Words[high]
                let centerTerm = center &* 0xe6b5f1d6d357e2db &+ 0x7888b2a9570a9e54
                state = centerTerm &* center
                    &+ mixed
                    &+ carry
                    &+ 0xe771da0c03bd224c
            } else {
                state = mixed
                    &+ carry
                    &+ 0xb928102d38c55e60
            }

            let foldedInput = state &* 0x93dfdd33afa41fcb &+ 0xb5028820475851e2
            let folded7 = try fold63c278(
                foldedInput,
                tableOffset: builder642f60MidSP40FoldTable,
                rounds: 7,
                tables: tables
            )
            let folded16 = try fold63c278(
                folded7,
                tableOffset: builder642f60MidSP40FoldTable,
                rounds: 9,
                tables: tables
            )
            let side = (UInt32(truncatingIfNeeded: state) &* 0x6d4b301f)
                &+ (UInt32(truncatingIfNeeded: folded7) &* 0x30000000)
                &+ 0xb22b53c3
            carry = folded7 &* 0x33b21893aa33e715
                &+ folded16 &* 0x5cc18eb000000000
                &+ 0xd1af5299bbb3ce82

            let tableOffset = (index * 4) & 0x1c
            out.append(
                try u32TableAffine63c278(
                    side,
                    mulTable: builder642f60MidSP40OutMulTable + tableOffset,
                    addTable: builder642f60MidSP40OutAddTable + tableOffset,
                    tables: tables
                )
            )
        }
        return out
    }

    public static func builder642f60MidStageStreamsFromContextSPF0(
        contextSource: Data,
        spf0Words: [UInt32]
    ) throws -> (
        spa90Words: [UInt64],
        sp510Prefix: [UInt64],
        sp880Words: [UInt64],
        sp9e0Prefix: [UInt64]
    ) {
        guard contextSource.count >= 0x100 else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 context source", contextSource.count, 0x100)
        }
        guard spf0Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(spf0Words.count)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](contextSource)
        let contextWords = (0..<builder63c278VectorWords).map { index in
            readUInt32LE(bytes, 0xa8 + index * 4)
        }
        let spa90Words = try (0..<builder63c278VectorWords).map { index in
            try builder642f60MidContextStreamWord(contextWords[index], index: index, tables: tables)
        }
        let sp880Words = try (0..<builder63c278VectorWords).map { index in
            try builder642f60MidSPF0StreamWord(spf0Words[index], index: index, tables: tables)
        }
        return (
            spa90Words,
            prefixSumsU64(spa90Words),
            sp880Words,
            prefixSumsU64(sp880Words)
        )
    }

    public static func builder642f60MidStageSP670Words(
        spa90Words: [UInt64],
        sp510Prefix: [UInt64],
        sp880Words: [UInt64],
        sp9e0Prefix: [UInt64]
    ) throws -> [UInt64] {
        guard spa90Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(spa90Words.count)
        }
        guard sp510Prefix.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp510Prefix.count)
        }
        guard sp880Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp880Words.count)
        }
        guard sp9e0Prefix.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp9e0Prefix.count)
        }

        var out: [UInt64] = []
        out.reserveCapacity(builder64bd0cWorkspaceWords)
        for index in 0..<builder64bd0cWorkspaceWords {
            let start = max(0, index - 21)
            let end = min(index, 21)
            var productSum: UInt64 = 0
            if start <= end {
                for position in start...end {
                    productSum = productSum &+ spa90Words[position] &* sp880Words[index - position]
                }
            }
            let span = UInt64(start <= end ? end - start + 1 : 0)
            let sumA = rangeSumFromPrefix(sp510Prefix, start: start, end: end)
            let sumB = rangeSumFromPrefix(sp9e0Prefix, start: index - end, end: index - start)
            let mixed = span &* 0x268d985caf171be0
                &+ 0x91891dd268ac7a45
                &+ productSum &* 0xbc643695604233c9
                &+ sumA &* 0x55d047a51fd1fdd0
                &+ sumB &* 0x268318c9a7c7fd06
            out.append(mixed &* 0xc36e55bcdc7360d9 &+ 0x20aeeecb67e4d8ee)
        }
        return out
    }

    public static func builder642f60MidStageSPA90SP880FromSP40(
        sp40Words: [UInt32]
    ) throws -> (
        spa90Words: [UInt64],
        sp880Prefix: [UInt64],
        sideInit: UInt64
    ) {
        guard sp40Words.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp40Words.count)
        }
        let tables = try cachedTables.get()
        let spa90Words = try (0..<builder64bd0cWorkspaceWords).map { index in
            try builder642f60MidSP40BWord(sp40Words[index], index: index, tables: tables)
        }
        return (
            spa90Words,
            prefixSumsU64(spa90Words),
            0x9b3fe2a5f2a431c6
        )
    }

    public static func builder642f60MidStageStaticSP9E0SP7D0(
        sideInit: UInt64
    ) throws -> (
        sp9e0Words: [UInt64],
        sp7d0Prefix: [UInt64]
    ) {
        let tables = try cachedTables.get()
        var sp9e0Words: [UInt64] = [sideInit]
        sp9e0Words.reserveCapacity(builder63c278VectorWords)
        for index in 1..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            let source = try foldTableU32Word63c278(builder642f60MidStaticSrcTable + index * 4, tables: tables)
            let multiplier = try u32TableWord63c278(builder642f60MidStaticMulTable + tableOffset, tables: tables)
            let addend = try u32TableWord63c278(builder642f60MidStaticAddTable + tableOffset, tables: tables)
            let word = (source &* multiplier &+ addend) &* 0x8e3923f3 &+ 0xdcf87258
            let folded = try fold63c278(
                UInt64(word) &* 0x76e0c10d644166b9 &+ 0x9f48a8b2fd92040d,
                tableOffset: builder642f60MidStaticFoldTable,
                rounds: 8,
                tables: tables
            )
            sp9e0Words.append(
                UInt64(word) &* 0x5a02cb2433277ab9
                &+ folded &* 0xedf34bff00000000
                &+ 0x6f59c0117d1d1775
            )
        }
        return (
            sp9e0Words,
            prefixSumsU64(sp9e0Words)
        )
    }

    public static func builder642f60MidStageSP510Words(
        spa90Words: [UInt64],
        sp880Prefix: [UInt64],
        sp9e0Words: [UInt64],
        sp7d0Prefix: [UInt64]
    ) throws -> [UInt64] {
        guard spa90Words.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(spa90Words.count)
        }
        guard sp880Prefix.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp880Prefix.count)
        }
        guard sp9e0Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp9e0Words.count)
        }
        guard sp7d0Prefix.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp7d0Prefix.count)
        }

        var out: [UInt64] = []
        out.reserveCapacity(builder64bd0cWorkspaceWords)
        for index in 0..<builder64bd0cWorkspaceWords {
            let start = max(0, index - 21)
            let end = index
            var productSum: UInt64 = 0
            for position in start...end {
                productSum = productSum &+ spa90Words[position] &* sp9e0Words[index - position]
            }
            let span = end - start + 1
            let sumA = rangeSumFromPrefix(sp880Prefix, start: start, end: end)
            let sumB = sp7d0Prefix[span - 1]
            let mixed = productSum &* 0x29f4a886cd96e34d
                &+ UInt64(span) &* 0xfb27869a34fe306e
                &+ sumA &* 0x7228cc7a696bf425
                &+ sumB &* 0x4005e2eb6883e7de
            out.append(mixed &* 0x10af80ba2ba8ff03 &+ 0x603f2c10b20e1521)
        }
        return out
    }

    public static func builder642f60MidFifth64bd0cWorkspace(
        sp670Words: [UInt64],
        sp510Words: [UInt64]
    ) throws -> Data {
        guard sp670Words.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp670Words.count)
        }
        guard sp510Words.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp510Words.count)
        }
        var out = Data()
        out.reserveCapacity(builder64bd0cWorkspaceBytes)
        for index in 0..<builder64bd0cWorkspaceWords {
            out.append(
                contentsOf: u64LEBytes(
                    sp670Words[index] &* 0x311e50313531405d
                    &+ sp510Words[index] &* 0xc817dbca0a20eafd
                    &+ 0xc254ca1fa792908c
                )
            )
        }
        return out
    }

    public static func builder642f60SixthStreamsFromSP1A0(
        sp1a0Words: [UInt32]
    ) throws -> (
        spa90Words: [UInt64],
        sp670Prefix: [UInt64],
        sp880Words: [UInt64],
        sp510Prefix: [UInt64]
    ) {
        guard sp1a0Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp1a0Words.count)
        }
        let tables = try cachedTables.get()
        let spa90Words = try (0..<builder63c278VectorWords).map { index in
            try builder642f60SixthAWord(sp1a0Words[index], index: index, tables: tables)
        }
        let sp880Words = try (0..<builder63c278VectorWords).map { index in
            try builder642f60SixthBWord(sp1a0Words[index], index: index, tables: tables)
        }
        return (
            spa90Words,
            prefixSumsU64(spa90Words),
            sp880Words,
            prefixSumsU64(sp880Words)
        )
    }

    public static func builder642f60Sixth64bd0cWorkspace(
        spa90Words: [UInt64],
        sp670Prefix: [UInt64],
        sp880Words: [UInt64],
        sp510Prefix: [UInt64]
    ) throws -> Data {
        guard spa90Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(spa90Words.count)
        }
        guard sp670Prefix.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp670Prefix.count)
        }
        guard sp880Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp880Words.count)
        }
        guard sp510Prefix.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp510Prefix.count)
        }

        var out = Data()
        out.reserveCapacity(builder64bd0cWorkspaceBytes)
        for index in 0..<builder64bd0cWorkspaceWords {
            let start = max(0, index - 21)
            let end = min(index, 21)
            var productSum: UInt64 = 0
            if start <= end {
                for position in start...end {
                    productSum = productSum &+ spa90Words[position] &* sp880Words[index - position]
                }
            }
            let span = UInt64(start <= end ? end - start + 1 : 0)
            let sumA = rangeSumFromPrefix(sp670Prefix, start: start, end: end)
            let sumB = rangeSumFromPrefix(sp510Prefix, start: index - end, end: index - start)
            let mixed = span &* 0xc9579b83c731c3c0
                &+ 0x5c81c51b07a75dd5
                &+ productSum &* 0x5af5ce9c3c24da93
                &+ sumA &* 0x22758d71fea188c0
                &+ sumB &* 0xf1d0ed7a635c3b3f
            out.append(contentsOf: u64LEBytes(mixed &* 0xa731aa4721be8565 &+ 0x25f1b6bafa949dff))
        }
        return out
    }

    public static func builder642f60Out0SourceWords(
        sixthOutput: Data,
        contextSource: Data,
        sp250Words: [UInt32]
    ) throws -> [UInt32] {
        guard sixthOutput.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 sixth output", sixthOutput.count, builder63c278VectorBytes)
        }
        guard contextSource.count >= 0x208 else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 context source", contextSource.count, 0x208)
        }
        guard sp250Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp250Words.count)
        }
        let tables = try cachedTables.get()
        let baseWords = try u32WordsFromTableSegments(
            [
                (builder642f60Out0StaticQ0, 16),
                (builder642f60Out0StaticQ1, 16),
                (builder642f60Out0StaticQ0, 16),
                (builder642f60Out0StaticQ1, 16),
                (builder642f60Out0StaticQ0, 16),
                (builder642f60Out0StaticD1, 8),
            ],
            tables: tables
        )
        let sixthBytes = [UInt8](sixthOutput)
        let contextBytes = [UInt8](contextSource)
        return try (0..<builder63c278VectorWords).map { index in
            let tableOffset = (index * 4) & 0x1c
            let sixthWord = readUInt32LE(sixthBytes, index * 4)
            let contextWord = readUInt32LE(contextBytes, 0x1b0 + index * 4)
            var word = baseWords[index]
                &+ sixthWord &* (try u32TableWord63c278(builder642f60Out0SixthMulTable + tableOffset, tables: tables))
            word = word
                &+ contextWord &* (try u32TableWord63c278(builder642f60Out0ContextMulTable + tableOffset, tables: tables))
            let sp250Delta = sp250Words[index] &* (try u32TableWord63c278(
                builder642f60Out0SP250MulTable + tableOffset,
                tables: tables
            ))
            return word &+ sp250Delta &+ sp250Delta
        }
    }

    public static func builder642f60Out0WordsFromSource(_ sourceWords: [UInt32]) throws -> [UInt32] {
        guard sourceWords.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sourceWords.count)
        }
        let tables = try cachedTables.get()
        var state: UInt32 = 0xb326b224
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)
        for (index, word) in sourceWords.enumerated() {
            let tableOffset = (index * 4) & 0x1c
            state = state &* 0x3d98bc67 &+ word
            var folded7 = state &* 0xe98a6e39 &+ 0xa9ce435c
            folded7 = try fold32ByNibbles63c278(
                folded7,
                tableOffset: builder642f60Out0FoldTable,
                rounds: 7,
                tables: tables
            )
            let side = state &* 0x88625dcf
                &+ folded7 &* 0x90000000
                &+ 0x647eea94
            let folded8 = try fold32ByNibbles63c278(
                folded7,
                tableOffset: builder642f60Out0FoldTable,
                rounds: 1,
                tables: tables
            )
            out.append(
                try u32TableAffine63c278(
                    side,
                    mulTable: builder642f60Out0OutMulTable + tableOffset,
                    addTable: builder642f60Out0OutAddTable + tableOffset,
                    tables: tables
                )
            )
            state = folded7 &* 0x50717a0f
                &+ folded8 &* 0xf8e85f10
                &+ 0x119b9786
        }
        return out
    }

    public static func builder642f60SeventhSourceWords(
        sp250Words: [UInt32],
        contextSource: Data,
        out0Words: [UInt32]
    ) throws -> [UInt32] {
        guard sp250Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp250Words.count)
        }
        guard contextSource.count >= 0x260 else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 context source", contextSource.count, 0x260)
        }
        guard out0Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(out0Words.count)
        }
        let tables = try cachedTables.get()
        let baseWords = try u32WordsFromTableSegments(
            [
                (builder642f60SeventhStaticQ0, 16),
                (builder642f60SeventhStaticQ1, 16),
                (builder642f60SeventhStaticQ0, 16),
                (builder642f60SeventhStaticQ1, 16),
                (builder642f60SeventhStaticQ0, 16),
                (builder642f60SeventhStaticD1, 8),
            ],
            tables: tables
        )
        let contextBytes = [UInt8](contextSource)
        return try (0..<builder63c278VectorWords).map { index in
            let tableOffset = (index * 4) & 0x1c
            let contextWord = readUInt32LE(contextBytes, 0x208 + index * 4)
            return baseWords[index]
                &+ sp250Words[index] &* (try u32TableWord63c278(builder642f60SeventhSP250MulTable + tableOffset, tables: tables))
                &+ contextWord &* (try u32TableWord63c278(builder642f60SeventhContextMulTable + tableOffset, tables: tables))
                &+ out0Words[index] &* (try u32TableWord63c278(builder642f60SeventhOut0MulTable + tableOffset, tables: tables))
        }
    }

    public static func builder642f60SeventhStageSP148WordsFromSource(_ sourceWords: [UInt32]) throws -> [UInt32] {
        guard sourceWords.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sourceWords.count)
        }
        let tables = try cachedTables.get()
        var state: UInt32 = 0xf92a7de1
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)
        for (index, word) in sourceWords.enumerated() {
            let tableOffset = (index * 4) & 0x1c
            state = state &* 0x2bd72421 &+ word
            var folded7 = state &* 0x79766d05 &+ 0x22dc5eef
            folded7 = try fold32ByNibbles63c278(
                folded7,
                tableOffset: builder642f60SeventhSP148FoldTable,
                rounds: 7,
                tables: tables
            )
            let side = state &* 0x072b272d
                &+ folded7 &* 0x70000000
                &+ 0x63742f4b
            let folded8 = try fold32ByNibbles63c278(
                folded7,
                tableOffset: builder642f60SeventhSP148FoldTable,
                rounds: 1,
                tables: tables
            )
            out.append(
                try u32TableAffine63c278(
                    side,
                    mulTable: builder642f60SeventhSP148OutMulTable + tableOffset,
                    addTable: builder642f60SeventhSP148OutAddTable + tableOffset,
                    tables: tables
                )
            )
            state = folded7 &* 0x04d53e2d
                &+ folded8 &* 0xb2ac1d30
                &+ 0x1cf006eb
        }
        return out
    }

    public static func builder642f60SeventhStreams(
        sp1a0Words: [UInt32],
        sp148Words: [UInt32]
    ) throws -> (
        sp670Words: [UInt64],
        spa90Prefix: [UInt64],
        sp510Words: [UInt64],
        sp880Prefix: [UInt64]
    ) {
        guard sp1a0Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp1a0Words.count)
        }
        guard sp148Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp148Words.count)
        }
        let tables = try cachedTables.get()
        let sp670Words = try (0..<builder63c278VectorWords).map { index in
            try u64StreamWordFromU32Affine(
                sp1a0Words[index],
                index: index,
                mulTable: builder642f60SeventhAMulTable,
                addTable: builder642f60SeventhAAddTable,
                u32Mul: 0xf36a661d,
                u32Add: 0x55308919,
                foldMul: 0xce5ac3ad5b5dac97,
                foldAdd: 0x48dc073b21398a79,
                foldTable: builder642f60SeventhAFoldTable,
                linearMul: 0xfa62b370c3eadc41,
                foldedMul: 0xf45f1f1900000000,
                linearAdd: 0x6fc778fe52193dd5,
                tables: tables
            )
        }
        let sp510Words = try (0..<builder63c278VectorWords).map { index in
            try u64StreamWordFromU32Affine(
                sp148Words[index],
                index: index,
                mulTable: builder642f60SeventhBMulTable,
                addTable: builder642f60SeventhBAddTable,
                u32Mul: 0x84c35e4f,
                u32Add: 0xea2fdd20,
                foldMul: 0x1f41e4ec093ed9f7,
                foldAdd: 0x27d1733855de4d16,
                foldTable: builder642f60SeventhBFoldTable,
                linearMul: 0x9fac6b22392e3497,
                foldedMul: 0x09482d9f00000000,
                linearAdd: 0xf6042c7612dc729e,
                tables: tables
            )
        }
        return (
            sp670Words,
            [UInt64(0)] + prefixSumsU64(sp670Words),
            sp510Words,
            [UInt64(0)] + prefixSumsU64(sp510Words)
        )
    }

    public static func builder642f60SeventhSP9E0Words(
        sp670Words: [UInt64],
        spa90Prefix: [UInt64],
        sp510Words: [UInt64],
        sp880Prefix: [UInt64]
    ) throws -> [UInt32] {
        guard sp670Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp670Words.count)
        }
        guard spa90Prefix.count == builder63c278VectorWords + 1 else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(spa90Prefix.count)
        }
        guard sp510Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp510Words.count)
        }
        guard sp880Prefix.count == builder63c278VectorWords + 1 else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp880Prefix.count)
        }
        let tables = try cachedTables.get()
        var state: UInt64 = 0x8360a2c993f75737
        var out: [UInt32] = []
        out.reserveCapacity(builder64bd0cWorkspaceWords)

        for index in 0..<builder64bd0cWorkspaceWords {
            let start = max(0, index - (builder63c278VectorWords - 1))
            let end = min(index, builder63c278VectorWords - 1)
            let mixed: UInt64
            if start <= end {
                var productSum: UInt64 = 0
                for position in start...end {
                    productSum = productSum &+ sp670Words[position] &* sp510Words[index - position]
                }
                let span = UInt64(end - start + 1)
                let sumA = spa90Prefix[end + 1] &- spa90Prefix[start]
                let sumB = sp880Prefix[index - start + 1] &- sp880Prefix[index - end]
                mixed = state
                    &+ span &* 0x005dbd39bbb74611
                    &+ productSum &* 0x376b7bf8523b310f
                    &+ sumA &* 0x05844a4f0ab6c52b
                    &+ sumB &* 0xbcb254e552fa427d
            } else {
                mixed = state
            }

            let folded7 = try fold63c278(
                mixed &* 0x8db6469e177ed14b &+ 0x0980afdda9144775,
                tableOffset: builder642f60SeventhSP9E0FoldTable,
                rounds: 7,
                tables: tables
            )
            let folded8 = try fold63c278(
                folded7,
                tableOffset: builder642f60SeventhSP9E0FoldTable,
                rounds: 1,
                tables: tables
            )
            let folded16 = try fold63c278(
                folded8,
                tableOffset: builder642f60SeventhSP9E0FoldTable,
                rounds: 8,
                tables: tables
            )
            let side = UInt32(truncatingIfNeeded: mixed) &* 0xe15d12ad
                &+ UInt32(truncatingIfNeeded: folded7) &* 0x90000000
                &+ 0x07600fb6
            let tableOffset = (index * 4) & 0x1c
            out.append(
                try u32TableAffine63c278(
                    side,
                    mulTable: builder642f60SeventhSP9E0OutMulTable + tableOffset,
                    addTable: builder642f60SeventhSP9E0OutAddTable + tableOffset,
                    tables: tables
                )
            )
            state = folded7 &* 0xfac2e2a1bcc53063
                &+ folded16 &* 0x33acf9d000000000
                &+ 0x42e2c949e6b96dc1
        }
        return out
    }

    public static func builder642f60SeventhSPA90WordsFromSP300(_ sp300Words: [UInt32]) throws -> [UInt64] {
        guard sp300Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp300Words.count)
        }
        let tables = try cachedTables.get()
        return try (0..<builder63c278VectorWords).map { index in
            try u64StreamWordFromU32Affine(
                sp300Words[index],
                index: index,
                mulTable: builder642f60SeventhSP300MulTable,
                addTable: builder642f60SeventhSP300AddTable,
                u32Mul: 0x923b2603,
                u32Add: 0x0d7c3c6d,
                foldMul: 0x461236e7241ea4af,
                foldAdd: 0xc0bb06ebd489d8f1,
                foldTable: builder642f60SeventhSP300FoldTable,
                linearMul: 0x1925dd7dc803ae75,
                foldedMul: 0x6a8f4fe500000000,
                linearAdd: 0x52f0304276b65fde,
                tables: tables
            )
        }
    }

    public static func builder642f60SeventhSP7D0WordsFromSPA90(_ spa90Words: [UInt64]) throws -> [UInt32] {
        guard spa90Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(spa90Words.count)
        }
        let tables = try cachedTables.get()
        var state: UInt64 = 0xd71b81e668a07680
        var out: [UInt32] = []
        out.reserveCapacity(builder64bd0cWorkspaceWords)

        for index in 0..<builder64bd0cWorkspaceWords {
            let start = max(0, index - (builder63c278VectorWords - 1))
            let end = min(index, builder63c278VectorWords - 1)
            var pairAccumulator: UInt64 = 0xb616243568409e12
            var left = start
            var right = end

            if end > start {
                while true {
                    let endWord = spa90Words[right]
                    right -= 1
                    let product = endWord &* 0x3a825182ec92a9ef
                        &+ 0x975bbf5d33a0b7f4
                    var mixedPair = endWord &* 0x975bbf5d33a0b7f4
                        &+ pairAccumulator
                    let startWord = spa90Words[left]
                    left += 1
                    mixedPair = product &* startWord &+ mixedPair
                    pairAccumulator = mixedPair &+ 0x4657dd9b924a1870
                    if right <= left {
                        break
                    }
                }
            }

            pairAccumulator = pairAccumulator &* 0xc3c1f54f3c2cd4a6
            let scaledState = state &* 0x7f0a8f747ca98163
            let mixed: UInt64
            if right == left {
                let center = spa90Words[right]
                let centerMixed = center &* 0x8b03bdcc8a740e7d
                    &+ 0x25af1839607d5838
                mixed = centerMixed &* center
                    &+ pairAccumulator
                    &+ scaledState
                    &+ 0xe804eb7226c5f391
            } else {
                mixed = pairAccumulator
                    &+ scaledState
                    &+ 0x0bea08ebd101a741
            }

            let product = mixed &* 0x416e14010d9d6b21
            let firstFold = try foldTableU64Word63c278(
                builder642f60SeventhSP7D0FoldTable + Int(product & 0x0f) * 8,
                tables: tables
            ) &+ ((product &+ 0xe4602986bf1f9a80) >> 4)
            let folded7 = try fold63c278(
                firstFold,
                tableOffset: builder642f60SeventhSP7D0FoldTable,
                rounds: 6,
                tables: tables
            )
            let folded8 = try fold63c278(
                folded7,
                tableOffset: builder642f60SeventhSP7D0FoldTable,
                rounds: 1,
                tables: tables
            )
            let side = UInt32(truncatingIfNeeded: mixed) &* 0x3e3dcae5
                &+ UInt32(truncatingIfNeeded: folded7) &* 0xb0000000
                &+ 0x8a63e3dc
            let folded16 = try fold63c278(
                folded8,
                tableOffset: builder642f60SeventhSP7D0FoldTable,
                rounds: 8,
                tables: tables
            )
            let tableOffset = (index * 4) & 0x1c
            out.append(
                try u32TableAffine63c278(
                    side,
                    mulTable: builder642f60SeventhSP7D0OutMulTable + tableOffset,
                    addTable: builder642f60SeventhSP7D0OutAddTable + tableOffset,
                    tables: tables
                )
            )
            state = folded7 &* 0x38c35e2d317591eb
                &+ folded16 &* 0xe8a6e15000000000
                &+ 0x7cfc7c8b77dde511
        }
        return out
    }

    public static func builder642f60SeventhSource44Words(
        sp9e0Words: [UInt32],
        contextSource: Data,
        sp7d0Words: [UInt32]
    ) throws -> [UInt32] {
        guard sp9e0Words.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp9e0Words.count)
        }
        guard contextSource.count >= 0x418 else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 context source", contextSource.count, 0x418)
        }
        guard sp7d0Words.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp7d0Words.count)
        }
        let tables = try cachedTables.get()
        let contextBytes = [UInt8](contextSource)
        var out: [UInt32] = []
        out.reserveCapacity(builder64bd0cWorkspaceWords)
        for index in 0..<builder64bd0cWorkspaceWords {
            let tableOffset = (index * 4) & 0x1c
            let contextWord = readUInt32LE(contextBytes, 0x368 + index * 4)
            let sp7d0Delta = sp7d0Words[index] &* (try u32TableWord63c278(
                builder642f60SeventhSourceSP7D0MulTable + tableOffset,
                tables: tables
            ))
            out.append(
                try u32TableWord63c278(builder642f60SeventhSourceStaticTable + tableOffset, tables: tables)
                &+ sp9e0Words[index] &* (try u32TableWord63c278(
                    builder642f60SeventhSourceSP9E0MulTable + tableOffset,
                    tables: tables
                ))
                &+ contextWord &* (try u32TableWord63c278(
                    builder642f60SeventhSourceContext368MulTable + tableOffset,
                    tables: tables
                ))
                &+ sp7d0Delta
                &+ sp7d0Delta
            )
        }
        return out
    }

    public static func builder642f60SeventhSP40WordsFromSource44(_ sourceWords: [UInt32]) throws -> [UInt32] {
        guard sourceWords.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sourceWords.count)
        }
        let tables = try cachedTables.get()
        var state: UInt32 = 0xcfda05ba
        var out: [UInt32] = []
        out.reserveCapacity(builder64bd0cWorkspaceWords)
        for (index, word) in sourceWords.enumerated() {
            let tableOffset = (index * 4) & 0x1c
            state = state &* 0x0862c569 &+ word
            var folded7 = state &* 0x5e8a87f3 &+ 0x54d7c56f
            folded7 = try fold32ByNibbles63c278(
                folded7,
                tableOffset: builder642f60SeventhSP40FoldTable,
                rounds: 7,
                tables: tables
            )
            let side = state &* 0x12f83eed
                &+ (folded7 &<< 28)
                &+ 0x51f93a0a
            let folded8 = try foldTableU32Word63c278(
                builder642f60SeventhSP40FoldTable + Int(folded7 & 0x0f) * 4,
                tables: tables
            ) &+ (folded7 >> 4)
            out.append(
                try u32TableAffine63c278(
                    side,
                    mulTable: builder642f60SeventhSP40OutMulTable + tableOffset,
                    addTable: builder642f60SeventhSP40OutAddTable + tableOffset,
                    tables: tables
                )
            )
            state = folded7 &* 0x36a73103
                &+ folded8 &* 0x958cefd0
                &+ 0x9e56fff6
        }
        return out
    }

    public static func builder642f60Seventh64bd0cWorkspace(sp40Words: [UInt32]) throws -> Data {
        guard sp40Words.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp40Words.count)
        }
        let tables = try cachedTables.get()
        var out = Data()
        out.reserveCapacity(builder64bd0cWorkspaceBytes)
        for index in 0..<builder64bd0cWorkspaceWords {
            let word = try u64StreamWordFromU32Affine(
                sp40Words[index],
                index: index,
                mulTable: builder642f60SeventhWorkspaceMulTable,
                addTable: builder642f60SeventhWorkspaceAddTable,
                u32Mul: 0x2e6bbea3,
                u32Add: 0xe3db739a,
                foldMul: 0x40c95ec2845e4b0b,
                foldAdd: 0xb5edeaa67030b38d,
                foldTable: builder642f60SeventhWorkspaceFoldTable,
                linearMul: 0xa2d77df3e3f51135,
                foldedMul: 0x7122434100000000,
                linearAdd: 0xb3aefd596d371f14,
                tables: tables
            )
            out.append(contentsOf: u64LEBytes(word))
        }
        return out
    }

    public static func builder642f60Out1WordsFrom64bd0cOutput(_ output: Data) throws -> [UInt32] {
        try builder642f60AffineWordsFrom64bd0cOutput(
            output,
            mulTable: builder642f60Out1MulTable,
            addTable: builder642f60Out1AddTable,
            label: "642f60 output #1"
        )
    }

    public static func builder642f60EighthStreams(
        sp2a8Words: [UInt32],
        x2Source: Data
    ) throws -> (
        spa90Words: [UInt64],
        sp670Prefix: [UInt64],
        sp880Words: [UInt64],
        sp510Prefix: [UInt64]
    ) {
        guard sp2a8Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp2a8Words.count)
        }
        guard x2Source.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 x2 source", x2Source.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let x2Bytes = [UInt8](x2Source)
        let x2Words = (0..<builder63c278VectorWords).map { index in
            readUInt32LE(x2Bytes, index * 4)
        }
        let spa90Words = try (0..<builder63c278VectorWords).map { index in
            try builder642f60EighthAWord(sp2a8Words[index], index: index, tables: tables)
        }
        let sp880Words = try (0..<builder63c278VectorWords).map { index in
            try builder642f60EighthBWord(x2Words[index], index: index, tables: tables)
        }
        return (
            spa90Words,
            prefixSumsU64(spa90Words),
            sp880Words,
            prefixSumsU64(sp880Words)
        )
    }

    public static func builder642f60Eighth64bd0cWorkspace(
        spa90Words: [UInt64],
        sp670Prefix: [UInt64],
        sp880Words: [UInt64],
        sp510Prefix: [UInt64]
    ) throws -> Data {
        guard spa90Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(spa90Words.count)
        }
        guard sp670Prefix.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp670Prefix.count)
        }
        guard sp880Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp880Words.count)
        }
        guard sp510Prefix.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp510Prefix.count)
        }

        var out = Data()
        out.reserveCapacity(builder64bd0cWorkspaceBytes)
        for index in 0..<builder64bd0cWorkspaceWords {
            let start = max(0, index - (builder63c278VectorWords - 1))
            let end = min(index, builder63c278VectorWords - 1)
            let mixed: UInt64
            if start <= end {
                var productSum: UInt64 = 0
                for position in start...end {
                    productSum = productSum &+ spa90Words[position] &* sp880Words[index - position]
                }
                let span = UInt64(end - start + 1)
                let sumA = rangeSumFromPrefix(sp670Prefix, start: start, end: end)
                let sumB = rangeSumFromPrefix(sp510Prefix, start: index - end, end: index - start)
                mixed = span &* 0x05f89c998f88e9a2
                    &+ 0xe3449c12b03ff8d9
                    &+ productSum &* 0xeab93afc6984b71d
                    &+ sumA &* 0xc2592d51a5992a23
                    &+ sumB &* 0xf8e4c71d4c7a89de
            } else {
                mixed = 0xe3449c12b03ff8d9
            }
            out.append(contentsOf: u64LEBytes(mixed &* 0xca274927c26656e9 &+ 0x89706c698c29e887))
        }
        return out
    }

    public static func builder642f60Out2WordsFrom64bd0cOutput(_ output: Data) throws -> [UInt32] {
        try builder642f60AffineWordsFrom64bd0cOutput(
            output,
            mulTable: builder642f60Out2MulTable,
            addTable: builder642f60Out2AddTable,
            label: "642f60 output #2"
        )
    }

    public static func builder642f60Outputs(
        in0: Data,
        in1: Data,
        in2: Data,
        contextSource: Data
    ) throws -> Builder642f60Result {
        guard in0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 in0", in0.count, builder63c278VectorBytes)
        }
        guard in1.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 in1", in1.count, builder63c278VectorBytes)
        }
        guard in2.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 in2", in2.count, builder63c278VectorBytes)
        }
        guard contextSource.count >= 0x420 else {
            throw FirstPairSourceSliceError.sourceTooShort("642f60 context source", contextSource.count, 0x420)
        }

        let contextBytes = [UInt8](contextSource)
        let arg0 = Data(contextBytes[0x100..<0x158])
        let scalar = readUInt64LE(contextBytes, 0x418)

        let sp2a8Words = try builder642f60StageSP2A8WordsFromX1(in1)
        let firstOutput = packUInt32LE(try builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder642f60First64bd0cWorkspaceFromX1(
                x1Source: in1,
                sp2a8Words: sp2a8Words
            )
        ))
        let sp300Words = try builder642f60StageSP300WordsFrom64bd0cOutput(firstOutput)

        let sp1f8Words = try builder642f60StageSP1F8WordsFromX0(in0)
        let secondOutput = packUInt32LE(try builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder642f60Second64bd0cWorkspace(
                sp1f8Words: sp1f8Words,
                sp300Words: sp300Words
            )
        ))
        let sp250Words = try builder642f60StageSP250WordsFrom64bd0cOutput(secondOutput)

        let thirdOutput = packUInt32LE(try builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder642f60Third64bd0cWorkspaceFromX2(in2)
        ))
        let sp148Words = try builder642f60StageSP148WordsFrom64bd0cOutput(thirdOutput)

        let fourthOutput = packUInt32LE(try builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder642f60Fourth64bd0cWorkspace(sp148Words: sp148Words)
        ))
        let spf0Words = try builder642f60StageSPF0WordsFrom64bd0cOutput(fourthOutput)

        let midSPA90Words = try builder642f60MidStageSPA90WordsFromX0(in0)
        let midSP40Words = try builder642f60MidStageSP40WordsFromSPA90(midSPA90Words)
        let midStreams = try builder642f60MidStageStreamsFromContextSPF0(
            contextSource: contextSource,
            spf0Words: spf0Words
        )
        let midSP670Words = try builder642f60MidStageSP670Words(
            spa90Words: midStreams.spa90Words,
            sp510Prefix: midStreams.sp510Prefix,
            sp880Words: midStreams.sp880Words,
            sp9e0Prefix: midStreams.sp9e0Prefix
        )
        let midSP40B = try builder642f60MidStageSPA90SP880FromSP40(sp40Words: midSP40Words)
        let midStatic = try builder642f60MidStageStaticSP9E0SP7D0(sideInit: midSP40B.sideInit)
        let midSP510Words = try builder642f60MidStageSP510Words(
            spa90Words: midSP40B.spa90Words,
            sp880Prefix: midSP40B.sp880Prefix,
            sp9e0Words: midStatic.sp9e0Words,
            sp7d0Prefix: midStatic.sp7d0Prefix
        )

        let fifthOutput = packUInt32LE(try builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder642f60MidFifth64bd0cWorkspace(
                sp670Words: midSP670Words,
                sp510Words: midSP510Words
            )
        ))
        let sp1a0Words = try builder642f60StageSP1A0WordsFrom64bd0cOutput(fifthOutput)

        let sixthStreams = try builder642f60SixthStreamsFromSP1A0(sp1a0Words: sp1a0Words)
        let sixthOutput = packUInt32LE(try builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder642f60Sixth64bd0cWorkspace(
                spa90Words: sixthStreams.spa90Words,
                sp670Prefix: sixthStreams.sp670Prefix,
                sp880Words: sixthStreams.sp880Words,
                sp510Prefix: sixthStreams.sp510Prefix
            )
        ))

        let out0SourceWords = try builder642f60Out0SourceWords(
            sixthOutput: sixthOutput,
            contextSource: contextSource,
            sp250Words: sp250Words
        )
        let out0Words = try builder642f60Out0WordsFromSource(out0SourceWords)

        let seventhSourceWords = try builder642f60SeventhSourceWords(
            sp250Words: sp250Words,
            contextSource: contextSource,
            out0Words: out0Words
        )
        let seventhSP148Words = try builder642f60SeventhStageSP148WordsFromSource(seventhSourceWords)
        let seventhStreams = try builder642f60SeventhStreams(
            sp1a0Words: sp1a0Words,
            sp148Words: seventhSP148Words
        )
        let seventhSP9E0Words = try builder642f60SeventhSP9E0Words(
            sp670Words: seventhStreams.sp670Words,
            spa90Prefix: seventhStreams.spa90Prefix,
            sp510Words: seventhStreams.sp510Words,
            sp880Prefix: seventhStreams.sp880Prefix
        )
        let seventhSPA90Words = try builder642f60SeventhSPA90WordsFromSP300(sp300Words)
        let seventhSP7D0Words = try builder642f60SeventhSP7D0WordsFromSPA90(seventhSPA90Words)
        let seventhSource44Words = try builder642f60SeventhSource44Words(
            sp9e0Words: seventhSP9E0Words,
            contextSource: contextSource,
            sp7d0Words: seventhSP7D0Words
        )
        let seventhSP40Words = try builder642f60SeventhSP40WordsFromSource44(seventhSource44Words)
        let seventhOutput = packUInt32LE(try builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder642f60Seventh64bd0cWorkspace(sp40Words: seventhSP40Words)
        ))
        let out1Words = try builder642f60Out1WordsFrom64bd0cOutput(seventhOutput)

        let eighthStreams = try builder642f60EighthStreams(sp2a8Words: sp2a8Words, x2Source: in2)
        let eighthOutput = packUInt32LE(try builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder642f60Eighth64bd0cWorkspace(
                spa90Words: eighthStreams.spa90Words,
                sp670Prefix: eighthStreams.sp670Prefix,
                sp880Words: eighthStreams.sp880Words,
                sp510Prefix: eighthStreams.sp510Prefix
            )
        ))
        let out2Words = try builder642f60Out2WordsFrom64bd0cOutput(eighthOutput)

        return Builder642f60Result(
            out0: packUInt32LE(out0Words),
            out1: packUInt32LE(out1Words),
            out2: packUInt32LE(out2Words)
        )
    }

    public static func builder642f60OutputsFromBundledContext(
        in0: Data,
        in1: Data,
        in2: Data
    ) throws -> Builder642f60Result {
        let context = try builder6388f0SharedContextFromBundle()
        return try builder642f60Outputs(in0: in0, in1: in1, in2: in2, contextSource: context)
    }

    public static func builder64bd0cArg0U64Words(arg0: Data) throws -> [UInt64] {
        guard arg0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("64bd0c arg0", arg0.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](arg0)
        var out: [UInt64] = []
        out.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            let affine = try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: builder64bd0cArg0MulTable,
                addTable: builder64bd0cArg0AddTable,
                tables: tables
            )
            let word = affine &* 0x3e251f3f &+ 0xc80f68f4
            let folded = try fold63c278(
                UInt64(word) &* 0xf636dda3668409f3 &+ 0xa1898a9b9b0c347b,
                tableOffset: builder64bd0cArg0FoldTable,
                rounds: 8,
                tables: tables
            )
            out.append(
                UInt64(word) &* 0x57c9f2b4caac6659
                &+ folded &* 0xa43bca7d00000000
                &+ 0x6de2d7b43700ac09
            )
        }
        return out
    }

    public static func builder64bd0cWorkspaceAfterUpdate(
        arg0U64Words: [UInt64],
        scalar: UInt64,
        x2Workspace: Data
    ) throws -> Data {
        guard arg0U64Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(arg0U64Words.count)
        }
        guard x2Workspace.count >= builder64bd0cWorkspaceBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("64bd0c x2 workspace", x2Workspace.count, builder64bd0cWorkspaceBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x2Workspace)
        var x2Words = (0..<builder64bd0cWorkspaceWords).map { readUInt64LE(bytes, $0 * 8) }
        var carryWord = x2Words[0]
        for base in 0..<builder63c278VectorWords {
            let params = try builder64bd0cWorkspaceParams(
                scalar: scalar,
                firstX2Word: carryWord,
                tables: tables
            )
            for (offset, word) in arg0U64Words.enumerated() {
                let pos = base + offset
                x2Words[pos] = x2Words[pos] &+ params.broadcast &+ (word &* params.multiplier)
            }
            carryWord = try builder64bd0cRewriteSecondWord(
                first: x2Words[base],
                second: x2Words[base + 1],
                tables: tables
            )
            x2Words[base + 1] = carryWord
        }
        return packUInt64LE64cd40(x2Words)
    }

    public static func builder64bd0cFinalU32Words(x2Workspace: Data) throws -> [UInt32] {
        guard x2Workspace.count >= builder64bd0cWorkspaceBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("64bd0c x2 workspace", x2Workspace.count, builder64bd0cWorkspaceBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x2Workspace)
        let x2Words = (0..<builder64bd0cWorkspaceWords).map { readUInt64LE(bytes, $0 * 8) }
        var carry: UInt64 = 0xa8100bf8a7268389
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)

        for index in 0..<builder63c278VectorWords {
            let tailWord = x2Words[builder63c278VectorWords + index]
            let mixed = carry &* 0xdc6110b4d93c58f7 &+ tailWord &* 0x29221b50b5648139
            let foldedInput = mixed &+ 0x02ea5a475ff009a0
            var firstFold = try builder64bd0cFinalFirstFold(foldedInput, tables: tables)
            firstFold.folded = try fold63c278(
                firstFold.folded,
                tableOffset: builder64bd0cFinalFoldTable,
                rounds: 8,
                tables: tables
            )
            let nextCarry = firstFold.nextBase &* 0x1323954bb9644419
                &+ firstFold.folded &* 0x69bbbe7000000000
            let tableOffset = (index * 4) & 0x1c
            out.append(try u32TableAffine63c278(
                firstFold.side,
                mulTable: builder64bd0cFinalOutMulTable + tableOffset,
                addTable: builder64bd0cFinalOutAddTable + tableOffset,
                tables: tables
            ))
            carry = nextCarry &+ 0x7a8f00bf503f94fb
        }
        return out
    }

    public static func builder64bd0cOutputWords(
        arg0: Data,
        scalar: UInt64,
        x2Workspace: Data
    ) throws -> [UInt32] {
        let arg0Words = try builder64bd0cArg0U64Words(arg0: arg0)
        let updated = try builder64bd0cWorkspaceAfterUpdate(
            arg0U64Words: arg0Words,
            scalar: scalar,
            x2Workspace: x2Workspace
        )
        return try builder64bd0cFinalU32Words(x2Workspace: updated)
    }

    public static func builder64c524Arg0U64Words(arg0: Data) throws -> [UInt64] {
        guard arg0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("64c524 arg0", arg0.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](arg0)
        var out: [UInt64] = []
        out.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            let affine = try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: builder64c524Arg0MulTable,
                addTable: builder64c524Arg0AddTable,
                tables: tables
            )
            let word = affine &* 0xc0134d17 &+ 0x71ee3738
            let folded = try fold63c278(
                UInt64(word) &* 0x30f8c406f090e325 &+ 0x7a3d4622dcb83626,
                tableOffset: builder64c524Arg0FoldTable,
                rounds: 8,
                tables: tables
            )
            out.append(
                UInt64(word) &* 0x430cd374007356b5
                &+ folded &* 0xc0efe7af00000000
                &+ 0xe5faf13619f0e974
            )
        }
        return out
    }

    public static func builder64c524WorkspaceAfterUpdate(
        arg0U64Words: [UInt64],
        scalar: UInt64,
        x2Workspace: Data
    ) throws -> Data {
        guard arg0U64Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(arg0U64Words.count)
        }
        guard x2Workspace.count >= builder64c524WorkspaceBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("64c524 x2 workspace", x2Workspace.count, builder64c524WorkspaceBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x2Workspace)
        var x2Words = (0..<builder64c524WorkspaceWords).map { readUInt64LE(bytes, $0 * 8) }
        var carryWord = x2Words[0]
        for base in 0..<builder63c278VectorWords {
            let params = try builder64c524WorkspaceParams(
                scalar: scalar,
                firstX2Word: carryWord,
                tables: tables
            )
            for (offset, word) in arg0U64Words.enumerated() {
                let pos = base + offset
                x2Words[pos] = x2Words[pos] &+ params.broadcast &+ word &* params.multiplier
            }
            carryWord = try builder64c524RewriteSecondWord(
                first: x2Words[base],
                second: x2Words[base + 1],
                tables: tables
            )
            x2Words[base + 1] = carryWord
        }
        return packUInt64LE64cd40(x2Words)
    }

    public static func builder64c524FinalU32Words(x2Workspace: Data) throws -> [UInt32] {
        guard x2Workspace.count >= builder64c524WorkspaceBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("64c524 x2 workspace", x2Workspace.count, builder64c524WorkspaceBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x2Workspace)
        let x2Words = (0..<builder64c524WorkspaceWords).map { readUInt64LE(bytes, $0 * 8) }
        var carry: UInt64 = 0xa231ae9017976cb8
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)

        for index in 0..<builder63c278VectorWords {
            let tailWord = x2Words[builder63c278VectorWords + index]
            let foldedInput = carry &* 0xcd03684f066c56f1
                &+ tailWord &* 0x5691aa6f378a40d3
                &+ 0x1c0f700d822da380
            var firstFold = try builder64c524FinalFirstFold(foldedInput, tables: tables)
            firstFold.folded = try fold63c278(
                firstFold.folded,
                tableOffset: builder64c524FinalFoldTable,
                rounds: 8,
                tables: tables
            )
            let nextCarry = firstFold.nextBase &* 0xe9b2139140497c53
                &+ firstFold.folded &* 0xfb683ad000000000
            let tableOffset = (index * 4) & 0x1c
            out.append(try u32TableAffine63c278(
                firstFold.side,
                mulTable: builder64c524FinalOutMulTable + tableOffset,
                addTable: builder64c524FinalOutAddTable + tableOffset,
                tables: tables
            ))
            carry = nextCarry &+ 0xee51a1bedb406a0d
        }
        return out
    }

    public static func builder64c524OutputWords(
        arg0: Data,
        scalar: UInt64,
        x2Workspace: Data
    ) throws -> [UInt32] {
        let arg0Words = try builder64c524Arg0U64Words(arg0: arg0)
        let updated = try builder64c524WorkspaceAfterUpdate(
            arg0U64Words: arg0Words,
            scalar: scalar,
            x2Workspace: x2Workspace
        )
        return try builder64c524FinalU32Words(x2Workspace: updated)
    }

    public static func builder6473d0FirstStreamsFromIn2(_ in2: Data) throws -> (
        aWords: [UInt64],
        bWords: [UInt64],
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) {
        guard in2.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 in2 source", in2.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](in2)
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0FirstAWord(readUInt32LE(bytes, index * 4), index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0FirstBWord(readUInt32LE(bytes, index * 4), index: index, tables: tables)
        }
        return (aWords, bWords, prefixSumsU64(aWords), prefixSumsU64(bWords))
    }

    public static func builder6473d0First64c524Workspace(in2: Data) throws -> Data {
        let streams = try builder6473d0FirstStreamsFromIn2(in2)
        return convolutionWorkspaceU64(
            aWords: streams.aWords,
            bWords: streams.bWords,
            baseAdd: builder6473d0FirstConvBaseAdd,
            countMul: builder6473d0FirstConvCountMul,
            productMul: builder6473d0FirstConvProductMul,
            sumAMul: builder6473d0FirstConvSumAMul,
            sumBMul: builder6473d0FirstConvSumBMul,
            finalMul: builder6473d0FirstConvFinalMul,
            finalAdd: builder6473d0FirstConvFinalAdd
        )
    }

    public static func builder6473d0SP488WordsFrom64c524Output(_ output: Data) throws -> [UInt32] {
        guard output.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 64c524 output", output.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](output)
        return try (0..<builder63c278VectorWords).map { index in
            try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: builder6473d0SP488MulTable,
                addTable: builder6473d0SP488AddTable,
                tables: tables
            )
        }
    }

    public static func builder6473d0SecondStreams(
        out0Seed: Data,
        sp488Words: [UInt32]
    ) throws -> (
        aWords: [UInt64],
        bWords: [UInt64],
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) {
        guard out0Seed.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 out0 seed", out0Seed.count, builder63c278VectorBytes)
        }
        guard sp488Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp488Words.count)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](out0Seed)
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0SecondAWord(readUInt32LE(bytes, index * 4), index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0SecondBWord(sp488Words[index], index: index, tables: tables)
        }
        return (aWords, bWords, prefixSumsU64(aWords), prefixSumsU64(bWords))
    }

    public static func builder6473d0Second64c524Workspace(
        out0Seed: Data,
        sp488Words: [UInt32]
    ) throws -> Data {
        let streams = try builder6473d0SecondStreams(out0Seed: out0Seed, sp488Words: sp488Words)
        return convolutionWorkspaceU64(
            aWords: streams.aWords,
            bWords: streams.bWords,
            baseAdd: builder6473d0SecondConvBaseAdd,
            countMul: builder6473d0SecondConvCountMul,
            productMul: builder6473d0SecondConvProductMul,
            sumAMul: builder6473d0SecondConvSumAMul,
            sumBMul: builder6473d0SecondConvSumBMul,
            finalMul: builder6473d0SecondConvFinalMul,
            finalAdd: builder6473d0SecondConvFinalAdd
        )
    }

    public static func builder6473d0ThirdSourceWords(
        secondOutput: Data,
        contextSource: Data,
        in0: Data
    ) throws -> [UInt32] {
        guard secondOutput.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 second output", secondOutput.count, builder63c278VectorBytes)
        }
        guard contextSource.count >= 0x260 else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 context source", contextSource.count, 0x260)
        }
        guard in0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 in0 source", in0.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let baseWords = try u32WordsFromTableSegments(
            [
                (builder6473d0ThirdStaticQ0, 16),
                (builder6473d0ThirdStaticQ1, 16),
                (builder6473d0ThirdStaticQ0, 16),
                (builder6473d0ThirdStaticQ1, 16),
                (builder6473d0ThirdStaticQ0, 16),
                (builder6473d0ThirdStaticD1, 8),
            ],
            tables: tables
        )
        let secondBytes = [UInt8](secondOutput)
        let contextBytes = [UInt8](contextSource)
        let in0Bytes = [UInt8](in0)
        return try (0..<builder63c278VectorWords).map { index in
            let tableOffset = (index * 4) & 0x1c
            let secondWord = readUInt32LE(secondBytes, index * 4)
            let contextWord = readUInt32LE(contextBytes, 0x208 + index * 4)
            let in0Word = readUInt32LE(in0Bytes, index * 4)
            var word = baseWords[index]
                &+ secondWord &* (try u32TableWord63c278(builder6473d0ThirdSecondMulTable + tableOffset, tables: tables))
            word = word
                &+ contextWord &* (try u32TableWord63c278(builder6473d0ThirdContext208MulTable + tableOffset, tables: tables))
            return word
                &+ in0Word &* (try u32TableWord63c278(builder6473d0ThirdIn0MulTable + tableOffset, tables: tables))
        }
    }

    public static func builder6473d0ThirdSP430Words(sourceWords: [UInt32]) throws -> [UInt32] {
        guard sourceWords.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sourceWords.count)
        }
        let tables = try cachedTables.get()
        var state: UInt32 = builder6473d0ThirdSP430StateInit
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)
        for (index, word) in sourceWords.enumerated() {
            let tableOffset = (index * 4) & 0x1c
            state = state &* builder6473d0ThirdSP430StateMul &+ word
            var folded7 = state &* builder6473d0ThirdSP430FoldPreMul &+ builder6473d0ThirdSP430FoldPreAdd
            folded7 = try fold32ByNibbles63c278(
                folded7,
                tableOffset: builder6473d0ThirdSP430FoldTable,
                rounds: 7,
                tables: tables
            )
            let side = state &* builder6473d0ThirdSP430SideMul
                &- (folded7 &<< 28)
                &+ builder6473d0ThirdSP430SideAdd
            let folded8 = try fold32ByNibbles63c278(
                folded7,
                tableOffset: builder6473d0ThirdSP430FoldTable,
                rounds: 1,
                tables: tables
            )
            out.append(try u32TableAffine63c278(
                side,
                mulTable: builder6473d0ThirdSP430OutMulTable + tableOffset,
                addTable: builder6473d0ThirdSP430OutAddTable + tableOffset,
                tables: tables
            ))
            state = folded7 &* builder6473d0ThirdSP430NextFolded7Mul
                &+ folded8 &* builder6473d0ThirdSP430NextFolded8Mul
                &+ builder6473d0ThirdSP430NextAdd
        }
        return out
    }

    public static func builder6473d0ThirdStreams(
        in2: Data,
        sp488Words: [UInt32]
    ) throws -> (
        aWords: [UInt64],
        bWords: [UInt64],
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) {
        guard in2.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 in2 source", in2.count, builder63c278VectorBytes)
        }
        guard sp488Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp488Words.count)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](in2)
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0ThirdAWord(readUInt32LE(bytes, index * 4), index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0ThirdBWord(sp488Words[index], index: index, tables: tables)
        }
        return (aWords, bWords, prefixSumsU64(aWords), prefixSumsU64(bWords))
    }

    public static func builder6473d0Third64c524Workspace(
        in2: Data,
        sp488Words: [UInt32]
    ) throws -> Data {
        let streams = try builder6473d0ThirdStreams(in2: in2, sp488Words: sp488Words)
        return convolutionWorkspaceU64(
            aWords: streams.aWords,
            bWords: streams.bWords,
            baseAdd: builder6473d0ThirdConvBaseAdd,
            countMul: builder6473d0ThirdConvCountMul,
            productMul: builder6473d0ThirdConvProductMul,
            sumAMul: builder6473d0ThirdConvSumAMul,
            sumBMul: builder6473d0ThirdConvSumBMul,
            finalMul: builder6473d0ThirdConvFinalMul,
            finalAdd: builder6473d0ThirdConvFinalAdd
        )
    }

    public static func builder6473d0FourthStreams(
        out1Seed: Data,
        thirdOutput: Data
    ) throws -> (
        aWords: [UInt64],
        bWords: [UInt64],
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) {
        guard out1Seed.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 out1 seed", out1Seed.count, builder63c278VectorBytes)
        }
        guard thirdOutput.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 third output", thirdOutput.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let out1Bytes = [UInt8](out1Seed)
        let thirdBytes = [UInt8](thirdOutput)
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0FourthAWord(readUInt32LE(out1Bytes, index * 4), index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0FourthBWord(readUInt32LE(thirdBytes, index * 4), index: index, tables: tables)
        }
        return (aWords, bWords, prefixSumsU64(aWords), prefixSumsU64(bWords))
    }

    public static func builder6473d0Fourth64c524Workspace(
        out1Seed: Data,
        thirdOutput: Data
    ) throws -> Data {
        let streams = try builder6473d0FourthStreams(out1Seed: out1Seed, thirdOutput: thirdOutput)
        return convolutionWorkspaceU64(
            aWords: streams.aWords,
            bWords: streams.bWords,
            baseAdd: builder6473d0FourthConvBaseAdd,
            countMul: builder6473d0FourthConvCountMul,
            productMul: builder6473d0FourthConvProductMul,
            sumAMul: builder6473d0FourthConvSumAMul,
            sumBMul: builder6473d0FourthConvSumBMul,
            finalMul: builder6473d0FourthConvFinalMul,
            finalAdd: builder6473d0FourthConvFinalAdd
        )
    }

    public static func builder6473d0FifthSourceWords(
        fourthOutput: Data,
        contextSource: Data,
        in1: Data
    ) throws -> [UInt32] {
        guard fourthOutput.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 fourth output", fourthOutput.count, builder63c278VectorBytes)
        }
        guard contextSource.count >= 0x1b0 else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 context source", contextSource.count, 0x1b0)
        }
        guard in1.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 in1 source", in1.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let baseWords = try u32WordsFromTableSegments(
            [
                (builder6473d0FifthStaticQ0, 16),
                (builder6473d0FifthStaticQ1, 16),
                (builder6473d0FifthStaticQ0, 16),
                (builder6473d0FifthStaticQ1, 16),
                (builder6473d0FifthStaticQ0, 16),
                (builder6473d0FifthStaticD1, 8),
            ],
            tables: tables
        )
        let fourthBytes = [UInt8](fourthOutput)
        let contextBytes = [UInt8](contextSource)
        let in1Bytes = [UInt8](in1)
        return try (0..<builder63c278VectorWords).map { index in
            let tableOffset = (index * 4) & 0x1c
            let fourthWord = readUInt32LE(fourthBytes, index * 4)
            let contextWord = readUInt32LE(contextBytes, 0x158 + index * 4)
            let in1Word = readUInt32LE(in1Bytes, index * 4)
            var word = baseWords[index]
                &+ fourthWord &* (try u32TableWord63c278(builder6473d0FifthFourthMulTable + tableOffset, tables: tables))
            word = word
                &+ contextWord &* (try u32TableWord63c278(builder6473d0FifthContext158MulTable + tableOffset, tables: tables))
            return word
                &+ in1Word &* (try u32TableWord63c278(builder6473d0FifthIn1MulTable + tableOffset, tables: tables))
        }
    }

    public static func builder6473d0FifthSP3D8Words(sourceWords: [UInt32]) throws -> [UInt32] {
        guard sourceWords.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sourceWords.count)
        }
        let tables = try cachedTables.get()
        var state: UInt32 = builder6473d0FifthSP3D8StateInit
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)
        for (index, word) in sourceWords.enumerated() {
            let tableOffset = (index * 4) & 0x1c
            state = state &* builder6473d0FifthSP3D8StateMul &+ word
            var folded7 = state &* builder6473d0FifthSP3D8FoldPreMul &+ builder6473d0FifthSP3D8FoldPreAdd
            folded7 = try fold32ByNibbles63c278(
                folded7,
                tableOffset: builder6473d0FifthSP3D8FoldTable,
                rounds: 7,
                tables: tables
            )
            let side = state &* builder6473d0FifthSP3D8SideMul
                &+ folded7 &* builder6473d0FifthSP3D8SideFoldedMul
                &+ builder6473d0FifthSP3D8SideAdd
            let folded8 = try fold32ByNibbles63c278(
                folded7,
                tableOffset: builder6473d0FifthSP3D8FoldTable,
                rounds: 1,
                tables: tables
            )
            out.append(try u32TableAffine63c278(
                side,
                mulTable: builder6473d0FifthSP3D8OutMulTable + tableOffset,
                addTable: builder6473d0FifthSP3D8OutAddTable + tableOffset,
                tables: tables
            ))
            state = folded7 &* builder6473d0FifthSP3D8NextFolded7Mul
                &+ folded8 &* builder6473d0FifthSP3D8NextFolded8Mul
                &+ builder6473d0FifthSP3D8NextAdd
        }
        return out
    }

    public static func builder6473d0FifthStreams(
        sp430Words: [UInt32]
    ) throws -> (
        aWords: [UInt64],
        bWords: [UInt64],
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) {
        guard sp430Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp430Words.count)
        }
        let tables = try cachedTables.get()
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0FifthAWord(sp430Words[index], index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0FifthBWord(sp430Words[index], index: index, tables: tables)
        }
        return (aWords, bWords, prefixSumsU64(aWords), prefixSumsU64(bWords))
    }

    public static func builder6473d0Fifth64c524Workspace(
        sp430Words: [UInt32]
    ) throws -> Data {
        let streams = try builder6473d0FifthStreams(sp430Words: sp430Words)
        return convolutionWorkspaceU64(
            aWords: streams.aWords,
            bWords: streams.bWords,
            baseAdd: builder6473d0FifthConvBaseAdd,
            countMul: builder6473d0FifthConvCountMul,
            productMul: builder6473d0FifthConvProductMul,
            sumAMul: builder6473d0FifthConvSumAMul,
            sumBMul: builder6473d0FifthConvSumBMul,
            finalMul: builder6473d0FifthConvFinalMul,
            finalAdd: builder6473d0FifthConvFinalAdd
        )
    }

    public static func builder6473d0SixthSP380Words(fifthOutput: Data) throws -> [UInt32] {
        guard fifthOutput.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 fifth output", fifthOutput.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](fifthOutput)
        return try (0..<builder63c278VectorWords).map { index in
            try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: builder6473d0SixthSP380MulTable,
                addTable: builder6473d0SixthSP380AddTable,
                tables: tables
            )
        }
    }

    public static func builder6473d0SixthStreams(
        sp430Words: [UInt32],
        sp380Words: [UInt32]
    ) throws -> (
        aWords: [UInt64],
        bWords: [UInt64],
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) {
        guard sp430Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp430Words.count)
        }
        guard sp380Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp380Words.count)
        }
        let tables = try cachedTables.get()
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0SixthSP750Word(sp380Words[index], index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0SixthSP698Word(sp430Words[index], index: index, tables: tables)
        }
        return (aWords, bWords, prefixSumsU64(aWords), prefixSumsU64(bWords))
    }

    public static func builder6473d0Sixth64c524Workspace(
        sp430Words: [UInt32],
        sp380Words: [UInt32]
    ) throws -> Data {
        let streams = try builder6473d0SixthStreams(sp430Words: sp430Words, sp380Words: sp380Words)
        return convolutionWorkspaceU64(
            aWords: streams.aWords,
            bWords: streams.bWords,
            baseAdd: builder6473d0SixthConvBaseAdd,
            countMul: builder6473d0SixthConvCountMul,
            productMul: builder6473d0SixthConvProductMul,
            sumAMul: builder6473d0SixthConvSumAMul,
            sumBMul: builder6473d0SixthConvSumBMul,
            finalMul: builder6473d0SixthConvFinalMul,
            finalAdd: builder6473d0SixthConvFinalAdd
        )
    }

    public static func builder6473d0SeventhSP328Words(sixthOutput: Data) throws -> [UInt32] {
        guard sixthOutput.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 sixth output", sixthOutput.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](sixthOutput)
        return try (0..<builder63c278VectorWords).map { index in
            try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: builder6473d0SeventhSP328MulTable,
                addTable: builder6473d0SeventhSP328AddTable,
                tables: tables
            )
        }
    }

    public static func builder6473d0SeventhStreams(
        in0: Data,
        sp380Words: [UInt32]
    ) throws -> (
        aWords: [UInt64],
        bWords: [UInt64],
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) {
        guard in0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 in0", in0.count, builder63c278VectorBytes)
        }
        guard sp380Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp380Words.count)
        }
        let tables = try cachedTables.get()
        let in0Bytes = [UInt8](in0)
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0SeventhSP750Word(readUInt32LE(in0Bytes, index * 4), index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0SeventhSP698Word(sp380Words[index], index: index, tables: tables)
        }
        return (aWords, bWords, prefixSumsU64(aWords), prefixSumsU64(bWords))
    }

    public static func builder6473d0Seventh64c524Workspace(
        in0: Data,
        sp380Words: [UInt32]
    ) throws -> Data {
        let streams = try builder6473d0SeventhStreams(in0: in0, sp380Words: sp380Words)
        return convolutionWorkspaceU64(
            aWords: streams.aWords,
            bWords: streams.bWords,
            baseAdd: builder6473d0SeventhConvBaseAdd,
            countMul: builder6473d0SeventhConvCountMul,
            productMul: builder6473d0SeventhConvProductMul,
            sumAMul: builder6473d0SeventhConvSumAMul,
            sumBMul: builder6473d0SeventhConvSumBMul,
            finalMul: builder6473d0SeventhConvFinalMul,
            finalAdd: builder6473d0SeventhConvFinalAdd
        )
    }

    public static func builder6473d0EighthSP2D0Words(seventhOutput: Data) throws -> [UInt32] {
        guard seventhOutput.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 seventh output", seventhOutput.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](seventhOutput)
        return try (0..<builder63c278VectorWords).map { index in
            try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: builder6473d0EighthSP2D0MulTable,
                addTable: builder6473d0EighthSP2D0AddTable,
                tables: tables
            )
        }
    }

    public static func builder6473d0EighthStreams(
        sp3d8Words: [UInt32]
    ) throws -> (
        aWords: [UInt64],
        bWords: [UInt64],
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) {
        guard sp3d8Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp3d8Words.count)
        }
        let tables = try cachedTables.get()
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0EighthAWord(sp3d8Words[index], index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0EighthBWord(sp3d8Words[index], index: index, tables: tables)
        }
        return (aWords, bWords, prefixSumsU64(aWords), prefixSumsU64(bWords))
    }

    public static func builder6473d0Eighth64c524Workspace(
        sp3d8Words: [UInt32]
    ) throws -> Data {
        let streams = try builder6473d0EighthStreams(sp3d8Words: sp3d8Words)
        return convolutionWorkspaceU64(
            aWords: streams.aWords,
            bWords: streams.bWords,
            baseAdd: builder6473d0EighthConvBaseAdd,
            countMul: builder6473d0EighthConvCountMul,
            productMul: builder6473d0EighthConvProductMul,
            sumAMul: builder6473d0EighthConvSumAMul,
            sumBMul: builder6473d0EighthConvSumBMul,
            finalMul: builder6473d0EighthConvFinalMul,
            finalAdd: builder6473d0EighthConvFinalAdd
        )
    }

    public static func builder6473d0NinthFirstSourceWords(
        eighthOutput: Data,
        contextSource: Data,
        sp328Words: [UInt32],
        sp2d0Words: [UInt32]
    ) throws -> [UInt32] {
        guard eighthOutput.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 eighth output", eighthOutput.count, builder63c278VectorBytes)
        }
        guard contextSource.count >= 0x260 else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 context source", contextSource.count, 0x260)
        }
        guard sp328Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp328Words.count)
        }
        guard sp2d0Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp2d0Words.count)
        }
        let tables = try cachedTables.get()
        let baseWords = try u32WordsFromTableSegments(
            [
                (builder6473d0Ninth1StaticQ0, 16),
                (builder6473d0Ninth1StaticQ1, 16),
                (builder6473d0Ninth1StaticQ0, 16),
                (builder6473d0Ninth1StaticQ1, 16),
                (builder6473d0Ninth1StaticQ0, 16),
                (builder6473d0Ninth1StaticD1, 8),
            ],
            tables: tables
        )
        let eighthBytes = [UInt8](eighthOutput)
        let contextBytes = [UInt8](contextSource)
        return try (0..<builder63c278VectorWords).map { index in
            let tableOffset = (index * 4) & 0x1c
            let eighthWord = readUInt32LE(eighthBytes, index * 4)
            let contextWord = readUInt32LE(contextBytes, 0x208 + index * 4)
            let sp2d0Delta = sp2d0Words[index] &* (try u32TableWord63c278(
                builder6473d0Ninth1SP2D0MulTable + tableOffset,
                tables: tables
            ))
            return baseWords[index]
                &+ eighthWord &* (try u32TableWord63c278(builder6473d0Ninth1EighthMulTable + tableOffset, tables: tables))
                &+ contextWord &* (try u32TableWord63c278(builder6473d0Ninth1Context208MulTable + tableOffset, tables: tables))
                &+ sp328Words[index] &* (try u32TableWord63c278(builder6473d0Ninth1SP328MulTable + tableOffset, tables: tables))
                &+ sp2d0Delta
                &+ sp2d0Delta
        }
    }

    public static func builder6473d0NinthOut2Words(sourceWords: [UInt32]) throws -> [UInt32] {
        guard sourceWords.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sourceWords.count)
        }
        return try reducerU32Words63c278(
            sourceWords: sourceWords,
            stateInit: builder6473d0Ninth1Out3StateInit,
            stateMul: builder6473d0Ninth1Out3StateMul,
            foldPreMul: builder6473d0Ninth1Out3FoldPreMul,
            foldPreAdd: builder6473d0Ninth1Out3FoldPreAdd,
            foldTable: builder6473d0Ninth1Out3FoldTable,
            sideMul: builder6473d0Ninth1Out3SideMul,
            sideFoldedMul: builder6473d0Ninth1Out3SideFoldedMul,
            sideAdd: builder6473d0Ninth1Out3SideAdd,
            nextFolded7Mul: builder6473d0Ninth1Out3NextFolded7Mul,
            nextFolded8Mul: builder6473d0Ninth1Out3NextFolded8Mul,
            nextAdd: builder6473d0Ninth1Out3NextAdd,
            outMulTable: builder6473d0Ninth1Out3OutMulTable,
            outAddTable: builder6473d0Ninth1Out3OutAddTable
        )
    }

    public static func builder6473d0NinthSecondSourceWords(
        sp2d0Words: [UInt32],
        contextSource: Data,
        out2Words: [UInt32]
    ) throws -> [UInt32] {
        guard sp2d0Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp2d0Words.count)
        }
        guard contextSource.count >= 0x2b8 else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 context source", contextSource.count, 0x2b8)
        }
        guard out2Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(out2Words.count)
        }
        let tables = try cachedTables.get()
        let baseWords = try u32WordsFromTableSegments(
            [
                (builder6473d0Ninth2StaticQ0, 16),
                (builder6473d0Ninth2StaticQ1, 16),
                (builder6473d0Ninth2StaticQ0, 16),
                (builder6473d0Ninth2StaticQ1, 16),
                (builder6473d0Ninth2StaticQ0, 16),
                (builder6473d0Ninth2StaticD1, 8),
            ],
            tables: tables
        )
        let contextBytes = [UInt8](contextSource)
        return try (0..<builder63c278VectorWords).map { index in
            let tableOffset = (index * 4) & 0x1c
            let contextWord = readUInt32LE(contextBytes, 0x260 + index * 4)
            return baseWords[index]
                &+ sp2d0Words[index] &* (try u32TableWord63c278(builder6473d0Ninth2SP2D0MulTable + tableOffset, tables: tables))
                &+ contextWord &* (try u32TableWord63c278(builder6473d0Ninth2Context260MulTable + tableOffset, tables: tables))
                &+ out2Words[index] &* (try u32TableWord63c278(builder6473d0Ninth2Out2MulTable + tableOffset, tables: tables))
        }
    }

    public static func builder6473d0NinthSP278Words(sourceWords: [UInt32]) throws -> [UInt32] {
        guard sourceWords.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sourceWords.count)
        }
        return try reducerU32Words63c278(
            sourceWords: sourceWords,
            stateInit: builder6473d0Ninth2SP278StateInit,
            stateMul: builder6473d0Ninth2SP278StateMul,
            foldPreMul: builder6473d0Ninth2SP278FoldPreMul,
            foldPreAdd: builder6473d0Ninth2SP278FoldPreAdd,
            foldTable: builder6473d0Ninth2SP278FoldTable,
            sideMul: builder6473d0Ninth2SP278SideMul,
            sideFoldedMul: builder6473d0Ninth2SP278SideFoldedMul,
            sideAdd: builder6473d0Ninth2SP278SideAdd,
            nextFolded7Mul: builder6473d0Ninth2SP278NextFolded7Mul,
            nextFolded8Mul: builder6473d0Ninth2SP278NextFolded8Mul,
            nextAdd: builder6473d0Ninth2SP278NextAdd,
            outMulTable: builder6473d0Ninth2SP278OutMulTable,
            outAddTable: builder6473d0Ninth2SP278OutAddTable
        )
    }

    public static func builder6473d0NinthFirstStreams(
        sp3d8Words: [UInt32],
        sp278Words: [UInt32]
    ) throws -> (
        aWords: [UInt64],
        bWords: [UInt64],
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) {
        guard sp3d8Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp3d8Words.count)
        }
        guard sp278Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp278Words.count)
        }
        let tables = try cachedTables.get()
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try u64StreamWordFromU32Affine(
                sp3d8Words[index],
                index: index,
                mulTable: builder6473d0NinthSP3D8AMulTable,
                addTable: builder6473d0NinthSP3D8AAddTable,
                u32Mul: builder6473d0NinthSP3D8AU32Mul,
                u32Add: builder6473d0NinthSP3D8AU32Add,
                foldMul: builder6473d0NinthSP3D8AFoldMul,
                foldAdd: builder6473d0NinthSP3D8AFoldAdd,
                foldTable: builder6473d0NinthSP3D8AFoldTable,
                linearMul: builder6473d0NinthSP3D8ALinearMul,
                foldedMul: builder6473d0NinthSP3D8AFoldedMul,
                linearAdd: builder6473d0NinthSP3D8ALinearAdd,
                tables: tables
            )
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try u64StreamWordFromU32Affine(
                sp278Words[index],
                index: index,
                mulTable: builder6473d0NinthSP278BMulTable,
                addTable: builder6473d0NinthSP278BAddTable,
                u32Mul: builder6473d0NinthSP278BU32Mul,
                u32Add: builder6473d0NinthSP278BU32Add,
                foldMul: builder6473d0NinthSP278BFoldMul,
                foldAdd: builder6473d0NinthSP278BFoldAdd,
                foldTable: builder6473d0NinthSP278BFoldTable,
                linearMul: builder6473d0NinthSP278BLinearMul,
                foldedMul: builder6473d0NinthSP278BFoldedMul,
                linearAdd: builder6473d0NinthSP278BLinearAdd,
                tables: tables
            )
        }
        return (aWords, bWords, shiftedPrefixSumsU64(aWords), shiftedPrefixSumsU64(bWords))
    }

    public static func builder6473d0NinthSP1C8Words(
        aWords: [UInt64],
        bWords: [UInt64]
    ) throws -> [UInt32] {
        try convolutionReducerU32Words63c278(
            aWords: aWords,
            bWords: bWords,
            stateInit: builder6473d0NinthConv1StateInit,
            countMul: builder6473d0NinthConv1CountMul,
            productMul: builder6473d0NinthConv1ProductMul,
            sumAMul: builder6473d0NinthConv1SumAMul,
            sumBMul: builder6473d0NinthConv1SumBMul,
            foldPreMul: builder6473d0NinthConv1FoldPreMul,
            foldPreAdd: builder6473d0NinthConv1FoldPreAdd,
            foldTable: builder6473d0NinthConv1FoldTable,
            sideMul: builder6473d0NinthConv1SideMul,
            sideFoldedMul: builder6473d0NinthConv1SideFoldedMul,
            sideAdd: builder6473d0NinthConv1SideAdd,
            nextFolded8Mul: builder6473d0NinthConv1NextFolded8Mul,
            nextFolded16Mul: builder6473d0NinthConv1NextFolded16Mul,
            nextAdd: builder6473d0NinthConv1NextAdd,
            outMulTable: builder6473d0NinthConv1OutMulTable,
            outAddTable: builder6473d0NinthConv1OutAddTable
        )
    }

    public static func builder6473d0NinthSecondStreams(
        in1: Data,
        sp328Words: [UInt32]
    ) throws -> (
        aWords: [UInt64],
        bWords: [UInt64],
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) {
        guard in1.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 in1 source", in1.count, builder63c278VectorBytes)
        }
        guard sp328Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp328Words.count)
        }
        let tables = try cachedTables.get()
        let in1Bytes = [UInt8](in1)
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try u64StreamWordFromU32Affine(
                readUInt32LE(in1Bytes, index * 4),
                index: index,
                mulTable: builder6473d0NinthIn1AMulTable,
                addTable: builder6473d0NinthIn1AAddTable,
                u32Mul: builder6473d0NinthIn1AU32Mul,
                u32Add: builder6473d0NinthIn1AU32Add,
                foldMul: builder6473d0NinthIn1AFoldMul,
                foldAdd: builder6473d0NinthIn1AFoldAdd,
                foldTable: builder6473d0NinthIn1AFoldTable,
                linearMul: builder6473d0NinthIn1ALinearMul,
                foldedMul: builder6473d0NinthIn1AFoldedMul,
                linearAdd: builder6473d0NinthIn1ALinearAdd,
                tables: tables
            )
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try u64StreamWordFromU32Affine(
                sp328Words[index],
                index: index,
                mulTable: builder6473d0NinthSP328BMulTable,
                addTable: builder6473d0NinthSP328BAddTable,
                u32Mul: builder6473d0NinthSP328BU32Mul,
                u32Add: builder6473d0NinthSP328BU32Add,
                foldMul: builder6473d0NinthSP328BFoldMul,
                foldAdd: builder6473d0NinthSP328BFoldAdd,
                foldTable: builder6473d0NinthSP328BFoldTable,
                linearMul: builder6473d0NinthSP328BLinearMul,
                foldedMul: builder6473d0NinthSP328BFoldedMul,
                linearAdd: builder6473d0NinthSP328BLinearAdd,
                tables: tables
            )
        }
        return (aWords, bWords, shiftedPrefixSumsU64(aWords), shiftedPrefixSumsU64(bWords))
    }

    public static func builder6473d0NinthSP118Words(
        aWords: [UInt64],
        bWords: [UInt64]
    ) throws -> [UInt32] {
        try convolutionReducerU32Words63c278(
            aWords: aWords,
            bWords: bWords,
            stateInit: builder6473d0NinthConv2StateInit,
            countMul: builder6473d0NinthConv2CountMul,
            productMul: builder6473d0NinthConv2ProductMul,
            sumAMul: builder6473d0NinthConv2SumAMul,
            sumBMul: builder6473d0NinthConv2SumBMul,
            foldPreMul: builder6473d0NinthConv2FoldPreMul,
            foldPreAdd: builder6473d0NinthConv2FoldPreAdd,
            foldTable: builder6473d0NinthConv2FoldTable,
            sideMul: builder6473d0NinthConv2SideMul,
            sideFoldedMul: builder6473d0NinthConv2SideFoldedMul,
            sideAdd: builder6473d0NinthConv2SideAdd,
            nextFolded8Mul: builder6473d0NinthConv2NextFolded8Mul,
            nextFolded16Mul: builder6473d0NinthConv2NextFolded16Mul,
            nextAdd: builder6473d0NinthConv2NextAdd,
            outMulTable: builder6473d0NinthConv2OutMulTable,
            outAddTable: builder6473d0NinthConv2OutAddTable
        )
    }

    public static func builder6473d0NinthThirdSourceWords(
        sp1c8Words: [UInt32],
        contextSource: Data,
        sp118Words: [UInt32]
    ) throws -> [UInt32] {
        guard sp1c8Words.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp1c8Words.count)
        }
        guard contextSource.count >= 0x368 else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 context source", contextSource.count, 0x368)
        }
        guard sp118Words.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp118Words.count)
        }
        let tables = try cachedTables.get()
        let contextBytes = [UInt8](contextSource)
        return try (0..<builder64bd0cWorkspaceWords).map { index in
            let tableOffset = (index * 4) & 0x1c
            let contextWord = readUInt32LE(contextBytes, 0x2b8 + index * 4)
            return try u32TableWord63c278(builder6473d0Ninth3StaticTable + ((index & 7) * 4), tables: tables)
                &+ sp1c8Words[index] &* (try u32TableWord63c278(
                    builder6473d0Ninth3SP1C8MulTable + tableOffset,
                    tables: tables
                ))
                &+ contextWord &* (try u32TableWord63c278(
                    builder6473d0Ninth3Context2B8MulTable + tableOffset,
                    tables: tables
                ))
                &+ sp118Words[index] &* (try u32TableWord63c278(
                    builder6473d0Ninth3SP118MulTable + tableOffset,
                    tables: tables
                ))
        }
    }

    public static func builder6473d0NinthSP68Words(sourceWords: [UInt32]) throws -> [UInt32] {
        guard sourceWords.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sourceWords.count)
        }
        return try reducerU32Words63c278(
            sourceWords: sourceWords,
            stateInit: builder6473d0Ninth3SP68StateInit,
            stateMul: builder6473d0Ninth3SP68StateMul,
            foldPreMul: builder6473d0Ninth3SP68FoldPreMul,
            foldPreAdd: builder6473d0Ninth3SP68FoldPreAdd,
            foldTable: builder6473d0Ninth3SP68FoldTable,
            sideMul: builder6473d0Ninth3SP68SideMul,
            sideFoldedMul: builder6473d0Ninth3SP68SideFoldedMul,
            sideAdd: builder6473d0Ninth3SP68SideAdd,
            nextFolded7Mul: builder6473d0Ninth3SP68NextFolded7Mul,
            nextFolded8Mul: builder6473d0Ninth3SP68NextFolded8Mul,
            nextAdd: builder6473d0Ninth3SP68NextAdd,
            outMulTable: builder6473d0Ninth3SP68OutMulTable,
            outAddTable: builder6473d0Ninth3SP68OutAddTable
        )
    }

    public static func builder6473d0Ninth64c524Workspace(sp68Words: [UInt32]) throws -> Data {
        guard sp68Words.count == builder64bd0cWorkspaceWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp68Words.count)
        }
        let tables = try cachedTables.get()
        let words = try (0..<builder64bd0cWorkspaceWords).map { index in
            try u64StreamWordFromU32Affine(
                sp68Words[index],
                index: index,
                mulTable: builder6473d0NinthWorkspaceMulTable,
                addTable: builder6473d0NinthWorkspaceAddTable,
                u32Mul: builder6473d0NinthWorkspaceU32Mul,
                u32Add: builder6473d0NinthWorkspaceU32Add,
                foldMul: builder6473d0NinthWorkspaceFoldMul,
                foldAdd: builder6473d0NinthWorkspaceFoldAdd,
                foldTable: builder6473d0NinthWorkspaceFoldTable,
                linearMul: builder6473d0NinthWorkspaceLinearMul,
                foldedMul: builder6473d0NinthWorkspaceFoldedMul,
                linearAdd: builder6473d0NinthWorkspaceLinearAdd,
                tables: tables
            )
        }
        return packUInt64LE64cd40(words)
    }

    public static func builder6473d0TenthOut3Words(ninthOutput: Data) throws -> [UInt32] {
        guard ninthOutput.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 ninth output", ninthOutput.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](ninthOutput)
        return try (0..<builder63c278VectorWords).map { index in
            try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: builder6473d0TenthOut3MulTable,
                addTable: builder6473d0TenthOut3AddTable,
                tables: tables
            )
        }
    }

    public static func builder6473d0TenthStreams(
        in2: Data,
        sp430Words: [UInt32]
    ) throws -> (
        aWords: [UInt64],
        bWords: [UInt64],
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) {
        guard in2.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 in2 source", in2.count, builder63c278VectorBytes)
        }
        guard sp430Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp430Words.count)
        }
        let tables = try cachedTables.get()
        let in2Bytes = [UInt8](in2)
        let aWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0TenthAWord(readUInt32LE(in2Bytes, index * 4), index: index, tables: tables)
        }
        let bWords = try (0..<builder63c278VectorWords).map { index in
            try builder6473d0TenthBWord(sp430Words[index], index: index, tables: tables)
        }
        return (aWords, bWords, prefixSumsU64(aWords), prefixSumsU64(bWords))
    }

    public static func builder6473d0Tenth64c524Workspace(
        in2: Data,
        sp430Words: [UInt32]
    ) throws -> Data {
        let streams = try builder6473d0TenthStreams(in2: in2, sp430Words: sp430Words)
        return convolutionWorkspaceU64(
            aWords: streams.aWords,
            bWords: streams.bWords,
            baseAdd: builder6473d0TenthConvBaseAdd,
            countMul: builder6473d0TenthConvCountMul,
            productMul: builder6473d0TenthConvProductMul,
            sumAMul: builder6473d0TenthConvSumAMul,
            sumBMul: builder6473d0TenthConvSumBMul,
            finalMul: builder6473d0TenthConvFinalMul,
            finalAdd: builder6473d0TenthConvFinalAdd
        )
    }

    public static func builder6473d0FinalOut4Words(tenthOutput: Data) throws -> [UInt32] {
        guard tenthOutput.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 tenth output", tenthOutput.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](tenthOutput)
        return try (0..<builder63c278VectorWords).map { index in
            try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: builder6473d0FinalOut4MulTable,
                addTable: builder6473d0FinalOut4AddTable,
                tables: tables
            )
        }
    }

    public static func builder6473d0Outputs(
        in0: Data,
        in1: Data,
        in2: Data,
        contextSource: Data,
        out0Preimage: Data? = nil,
        out1Preimage: Data? = nil
    ) throws -> Builder6473d0Result {
        guard in0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 in0", in0.count, builder63c278VectorBytes)
        }
        guard in1.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 in1", in1.count, builder63c278VectorBytes)
        }
        guard in2.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 in2", in2.count, builder63c278VectorBytes)
        }
        guard contextSource.count >= 0x420 else {
            throw FirstPairSourceSliceError.sourceTooShort("6473d0 context source", contextSource.count, 0x420)
        }

        func resolvedPreimage(_ value: Data?, label: String) throws -> Data {
            guard let value else {
                return Data(repeating: 0, count: builder63c278VectorBytes)
            }
            guard value.count >= builder63c278VectorBytes else {
                throw FirstPairSourceSliceError.sourceTooShort(label, value.count, builder63c278VectorBytes)
            }
            return Data(value.prefix(builder63c278VectorBytes))
        }

        let contextBytes = [UInt8](contextSource)
        let arg0 = Data(contextBytes[0x100..<0x158])
        let scalar = readUInt64LE(contextBytes, 0x418)
        let out0Seed = try resolvedPreimage(out0Preimage, label: "6473d0 out0 preimage")
        let out1Seed = try resolvedPreimage(out1Preimage, label: "6473d0 out1 preimage")

        let firstOutput = packUInt32LE(try builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder6473d0First64c524Workspace(in2: in2)
        ))
        let sp488Words = try builder6473d0SP488WordsFrom64c524Output(firstOutput)

        let secondOutput = packUInt32LE(try builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder6473d0Second64c524Workspace(
                out0Seed: out0Seed,
                sp488Words: sp488Words
            )
        ))
        let thirdSourceWords = try builder6473d0ThirdSourceWords(
            secondOutput: secondOutput,
            contextSource: contextSource,
            in0: in0
        )
        let thirdSP430Words = try builder6473d0ThirdSP430Words(sourceWords: thirdSourceWords)

        let thirdOutput = packUInt32LE(try builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder6473d0Third64c524Workspace(
                in2: in2,
                sp488Words: sp488Words
            )
        ))
        let fourthOutput = packUInt32LE(try builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder6473d0Fourth64c524Workspace(
                out1Seed: out1Seed,
                thirdOutput: thirdOutput
            )
        ))
        let fifthSourceWords = try builder6473d0FifthSourceWords(
            fourthOutput: fourthOutput,
            contextSource: contextSource,
            in1: in1
        )
        let fifthSP3D8Words = try builder6473d0FifthSP3D8Words(sourceWords: fifthSourceWords)

        let fifthOutput = packUInt32LE(try builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder6473d0Fifth64c524Workspace(sp430Words: thirdSP430Words)
        ))
        let sixthSP380Words = try builder6473d0SixthSP380Words(fifthOutput: fifthOutput)
        let sixthOutput = packUInt32LE(try builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder6473d0Sixth64c524Workspace(
                sp430Words: thirdSP430Words,
                sp380Words: sixthSP380Words
            )
        ))
        let seventhSP328Words = try builder6473d0SeventhSP328Words(sixthOutput: sixthOutput)
        let seventhOutput = packUInt32LE(try builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder6473d0Seventh64c524Workspace(
                in0: in0,
                sp380Words: sixthSP380Words
            )
        ))
        let eighthSP2D0Words = try builder6473d0EighthSP2D0Words(seventhOutput: seventhOutput)
        let eighthOutput = packUInt32LE(try builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder6473d0Eighth64c524Workspace(sp3d8Words: fifthSP3D8Words)
        ))

        let out2Words = try builder6473d0NinthOut2Words(
            sourceWords: builder6473d0NinthFirstSourceWords(
                eighthOutput: eighthOutput,
                contextSource: contextSource,
                sp328Words: seventhSP328Words,
                sp2d0Words: eighthSP2D0Words
            )
        )
        let ninthSP278Words = try builder6473d0NinthSP278Words(
            sourceWords: builder6473d0NinthSecondSourceWords(
                sp2d0Words: eighthSP2D0Words,
                contextSource: contextSource,
                out2Words: out2Words
            )
        )
        let ninthFirstStreams = try builder6473d0NinthFirstStreams(
            sp3d8Words: fifthSP3D8Words,
            sp278Words: ninthSP278Words
        )
        let ninthSP1C8Words = try builder6473d0NinthSP1C8Words(
            aWords: ninthFirstStreams.aWords,
            bWords: ninthFirstStreams.bWords
        )
        let ninthSecondStreams = try builder6473d0NinthSecondStreams(
            in1: in1,
            sp328Words: seventhSP328Words
        )
        let ninthSP118Words = try builder6473d0NinthSP118Words(
            aWords: ninthSecondStreams.aWords,
            bWords: ninthSecondStreams.bWords
        )
        let ninthSP68Words = try builder6473d0NinthSP68Words(
            sourceWords: builder6473d0NinthThirdSourceWords(
                sp1c8Words: ninthSP1C8Words,
                contextSource: contextSource,
                sp118Words: ninthSP118Words
            )
        )
        let ninthOutput = packUInt32LE(try builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder6473d0Ninth64c524Workspace(sp68Words: ninthSP68Words)
        ))
        let out3Words = try builder6473d0TenthOut3Words(ninthOutput: ninthOutput)
        let tenthOutput = packUInt32LE(try builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: builder6473d0Tenth64c524Workspace(
                in2: in2,
                sp430Words: thirdSP430Words
            )
        ))
        let out4Words = try builder6473d0FinalOut4Words(tenthOutput: tenthOutput)

        return Builder6473d0Result(
            in0After: Data(in0.prefix(builder63c278VectorBytes)),
            in1After: Data(in1.prefix(builder63c278VectorBytes)),
            in2After: Data(in2.prefix(builder63c278VectorBytes)),
            out0: out0Seed,
            out1: out1Seed,
            out2: packUInt32LE(out2Words),
            out3: packUInt32LE(out3Words),
            out4: packUInt32LE(out4Words)
        )
    }

    public static func builder6473d0OutputsFromBundledContext(
        in0: Data,
        in1: Data,
        in2: Data,
        out0Preimage: Data? = nil,
        out1Preimage: Data? = nil
    ) throws -> Builder6473d0Result {
        let context = try builder6388f0SharedContextFromBundle()
        return try builder6473d0Outputs(
            in0: in0,
            in1: in1,
            in2: in2,
            contextSource: context,
            out0Preimage: out0Preimage,
            out1Preimage: out1Preimage
        )
    }

    public static func builder6473d0MinimalStack20FromPreimages(
        _ preimages: Builder6473d0OutputPreimages
    ) throws -> Data {
        var stack20 = [UInt8](repeating: 0, count: builder6473d0CallerStackPreimageBytes)
        let vectors: [(raw: Data, offset: Int, name: String)] = [
            (preimages.out4, 0x000, "out4"),
            (preimages.out3, 0x058, "out3"),
            (preimages.out2, 0x0b0, "out2"),
            (preimages.out1, 0x210, "out1"),
            (preimages.out0, 0x268, "out0"),
        ]

        for vector in vectors {
            guard vector.raw.count >= builder63c278VectorBytes else {
                throw FirstPairSourceSliceError.sourceTooShort(
                    "6473d0 \(vector.name) preimage",
                    vector.raw.count,
                    builder63c278VectorBytes
                )
            }
            replace(
                &stack20,
                at: vector.offset,
                with: [UInt8](vector.raw.prefix(builder63c278VectorBytes))
            )
        }
        return Data(stack20)
    }

    public static func builder6473d0PostVectors(_ result: Builder6473d0Result) -> [Int: Data] {
        [
            0x3708: result.out4,
            0x3760: result.out3,
            0x37b8: result.out2,
            0x3810: result.in2After,
            0x3868: result.in1After,
            0x38c0: result.in0After,
            0x3918: result.out1,
            0x3970: result.out0,
        ]
    }

    public static func builder6388f0First64cd40CallState(
        contextSource: Data,
        callerStack20: Data,
        postVectors: [Int: Data],
        entryIndex: Int
    ) throws -> Builder6388f0Caller64CallState {
        guard contextSource.count >= 0x420 else {
            throw FirstPairSourceSliceError.sourceTooShort("6388f0 caller context", contextSource.count, 0x420)
        }
        guard callerStack20.count >= builder6473d0CallerStackPreimageBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "6388f0 caller stack20",
                callerStack20.count,
                builder6473d0CallerStackPreimageBytes
            )
        }
        guard entryIndex >= 0 else {
            throw FirstPairSourceSliceError.invalid6388f0EntryIndex(entryIndex)
        }

        let tables = try cachedTables.get()
        let contextBytes = [UInt8](contextSource)
        var stack = [UInt8](repeating: 0, count: builder6388f0CallerStackBytes)
        try checkedReplace(&stack, at: 0x230, with: [UInt8](contextSource))
        try checkedReplace(&stack, at: 0x3708, with: [UInt8](callerStack20))
        for (offset, raw) in postVectors {
            try checkedReplace(&stack, at: offset, with: [UInt8](raw))
        }

        let loopSlot = entryIndex % builder6388f0CallerLoopTableRows
        let loopCounter = builder6388f0CallerLoopTableRows - 1 - loopSlot
        let pointerDelta = loopSlot * builder6388f0CallerLoopRowBytes

        let aMul: UInt64 = 0x5025a2599f75877f
        let aAdd: UInt64 = 0x4d8a8810a4bbc5a3
        let bMul: UInt64 = 0x23c3d48d0602f787
        let bAdd: UInt64 = 0x62917fc875cc9e6b
        let firstMixMul: UInt64 = 0x6f8d70f401079e5b
        let firstMixAdd: UInt64 = 0x31b3e556163432ed
        let callerMixMul: UInt64 = 0x30eef2ed3a43a4f9
        let callerMixAdd: UInt64 = 0x92ef60a176c7d6c9
        let firstFoldMul: UInt64 = 0x838e88db00000000
        let callerFoldMul: UInt64 = 0x37fd608100000000

        var firstSrcWord = readUInt32LE(stack, 0x38c0) &* 0xc938d835 &+ 0xe6fc451b
        var callerWord = readUInt32LE(stack, 0x6f8 + loopCounter * 0x58) &* 0xc955b06b &+ 0x454427df
        let firstB = try builder6388f0CallerStreamU64(
            word: firstSrcWord,
            wordMul: aMul,
            wordAdd: aAdd,
            foldTable: 0x300ef0,
            foldMul: firstFoldMul,
            mixMul: firstMixMul,
            mixAdd: firstMixAdd,
            tables: tables
        )
        let firstA = try builder6388f0CallerStreamU64(
            word: callerWord,
            wordMul: bMul,
            wordAdd: bAdd,
            foldTable: 0x300f70,
            foldMul: callerFoldMul,
            mixMul: callerMixMul,
            mixAdd: callerMixAdd,
            tables: tables
        )
        writeUInt64LE(firstB, into: &stack, at: 0x3b80)
        writeUInt64LE(firstB, into: &stack, at: 0x4130)
        writeUInt64LE(firstA, into: &stack, at: 0x39c8)
        writeUInt64LE(firstA, into: &stack, at: 0x4010)

        var prefixB = firstB
        for index in 1..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            var word = readUInt32LE(stack, 0x38c0 + index * 4)
            word = word &* (try u32TableWord63c278(0x112e28 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x117268 + tableOffset, tables: tables))
            word = word &* 0x56d9f19b &+ 0x64a9155b
            let value = try builder6388f0CallerStreamU64(
                word: word,
                wordMul: aMul,
                wordAdd: aAdd,
                foldTable: 0x300ef0,
                foldMul: firstFoldMul,
                mixMul: firstMixMul,
                mixAdd: firstMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x3b80 + index * 8)
            prefixB = prefixB &+ value
            writeUInt64LE(prefixB, into: &stack, at: 0x4130 + index * 8)
        }

        var prefixA = firstA
        var callerStream = 0x1aec - pointerDelta
        for index in 0..<(builder63c278VectorWords - 1) {
            let tableOffset = ((index + 1) & 7) * 4
            var word = readUInt32LE(stack, callerStream + index * 4)
            word = word &* (try u32TableWord63c278(0x117288 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x1205e8 + tableOffset, tables: tables))
            word = word &* 0x994a2aa3 &+ 0x7f433349
            let value = try builder6388f0CallerStreamU64(
                word: word,
                wordMul: bMul,
                wordAdd: bAdd,
                foldTable: 0x300f70,
                foldMul: callerFoldMul,
                mixMul: callerMixMul,
                mixAdd: callerMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x39d0 + index * 8)
            prefixA = prefixA &+ value
            writeUInt64LE(prefixA, into: &stack, at: 0x4018 + index * 8)
        }

        builder6388f0Convolution44(
            stack: &stack,
            aVecOffset: 0x39c8,
            aPrefixOffset: 0x4010,
            bVecOffset: 0x3b80,
            bPrefixOffset: 0x4130,
            outOffset: 0x3ce0,
            constants: (
                0x4079ef92755bf93a,
                0xb43c87132a6e84d1,
                0x129a56bce90af833,
                0x8de93a973ee9c82b,
                0xb3c2bc6591a8beaa,
                0xe6bf6d3dc98f10f7,
                0x632718706bc72397
            )
        )

        let cMul: UInt64 = 0x877a8a4a5f3b0f49
        let cAdd: UInt64 = 0xa24f4a31979cc775
        let dMul: UInt64 = 0xddfbefdc018359d5
        let dAdd: UInt64 = 0x7f589737aa46bdd5
        let cMixMul: UInt64 = 0x5a83f7862436b279
        let cMixAdd: UInt64 = 0x77cf4bf823a845d0
        let dMixMul: UInt64 = 0x080c881a27926eee7
        let dMixAdd: UInt64 = 0xeabaf4ef841c8c86
        let cFoldMul: UInt64 = 0xde34e64f00000000
        let dFoldMul: UInt64 = 0x438d983500000000

        firstSrcWord = readUInt32LE(stack, 0x37b8) &* 0xff9582fd &+ 0xfc52cb23
        callerWord = readUInt32LE(stack, 0x1b40 + loopCounter * 0x58) &* 0xad09fb4b &+ 0x4d566e95
        let firstC = try builder6388f0CallerStreamU64(
            word: firstSrcWord,
            wordMul: cMul,
            wordAdd: cAdd,
            foldTable: 0x300ff0,
            foldMul: cFoldMul,
            mixMul: cMixMul,
            mixAdd: cMixAdd,
            tables: tables
        )
        let firstD = try builder6388f0CallerStreamU64(
            word: callerWord,
            wordMul: dMul,
            wordAdd: dAdd,
            foldTable: 0x301070,
            foldMul: dFoldMul,
            mixMul: dMixMul,
            mixAdd: dMixAdd,
            tables: tables
        )
        writeUInt64LE(firstC, into: &stack, at: 0x39c8)
        writeUInt64LE(firstC, into: &stack, at: 0x4010)
        writeUInt64LE(firstD, into: &stack, at: 0x4130)
        writeUInt64LE(firstD, into: &stack, at: 0x3ef0)

        var prefixC = firstC
        for index in 1..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            var word = readUInt32LE(stack, 0x37b8 + index * 4)
            word = word &* (try u32TableWord63c278(0x1218c8 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x1221e8 + tableOffset, tables: tables))
            word = word &* 0x2c6e5d55 &+ 0x63f5202d
            let value = try builder6388f0CallerStreamU64(
                word: word,
                wordMul: cMul,
                wordAdd: cAdd,
                foldTable: 0x300ff0,
                foldMul: cFoldMul,
                mixMul: cMixMul,
                mixAdd: cMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x39c8 + index * 8)
            prefixC = prefixC &+ value
            writeUInt64LE(prefixC, into: &stack, at: 0x4010 + index * 8)
        }

        var prefixD = firstD
        callerStream = 0x2f34 - pointerDelta
        for index in 0..<(builder63c278VectorWords - 1) {
            let tableOffset = ((index + 1) & 7) * 4
            var word = readUInt32LE(stack, callerStream + index * 4)
            word = word &* (try u32TableWord63c278(0x119708 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x120608 + tableOffset, tables: tables))
            word = word &* 0x206cd1f3 &+ 0x867e396d
            let value = try builder6388f0CallerStreamU64(
                word: word,
                wordMul: dMul,
                wordAdd: dAdd,
                foldTable: 0x301070,
                foldMul: dFoldMul,
                mixMul: dMixMul,
                mixAdd: dMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x4138 + index * 8)
            prefixD = prefixD &+ value
            writeUInt64LE(prefixD, into: &stack, at: 0x3ef8 + index * 8)
        }

        builder6388f0Convolution44(
            stack: &stack,
            aVecOffset: 0x4130,
            aPrefixOffset: 0x3ef0,
            bVecOffset: 0x39c8,
            bPrefixOffset: 0x4010,
            outOffset: 0x3b80,
            constants: (
                0xd16513f43f99d2c0,
                0x5bdc507e86f7d211,
                0x49fd76daa54ce93b,
                0x4a15e654a01bea9e,
                0xe49b61c39c833ce0,
                0x9054b9a41de45a5b,
                0x9b016b93e5b24765
            )
        )

        for offset in stride(from: 0, to: 0x160, by: 0x10) {
            let firstA = readUInt64LE(stack, 0x3ce0 + offset)
            let secondA = readUInt64LE(stack, 0x3ce0 + offset + 8)
            let firstB = readUInt64LE(stack, 0x3b80 + offset)
            let secondB = readUInt64LE(stack, 0x3b80 + offset + 8)
            writeUInt64LE(
                firstA &* 0xb8bc9deccc0ade89
                &+ 0xc46ffd16f1b1756f
                &+ firstB &* 0x9c308b62a744c677,
                into: &stack,
                at: 0x39c8 + offset
            )
            writeUInt64LE(
                secondA &* 0xb8bc9deccc0ade89
                &+ 0xc46ffd16f1b1756f
                &+ secondB &* 0x9c308b62a744c677,
                into: &stack,
                at: 0x39c8 + offset + 8
            )
        }

        return Builder6388f0Caller64CallState(
            arg0: Data(stack[0x330..<0x388]),
            scalar: readUInt64LE(contextBytes, 0x418),
            x2Workspace: Data(stack[0x39c8..<0x3b28]),
            x3Preimage: Data(stack[0x3b28..<0x3b80]),
            stackWindow: Data(stack[0x3778..<0x42c8])
        )
    }

    public static func builder6388f0Second64cd40CallState(
        contextSource: Data,
        callerStack20: Data,
        postVectors: [Int: Data],
        first64cd40Output: Data,
        entryIndex: Int
    ) throws -> Builder6388f0Caller64CallState {
        guard contextSource.count >= 0x420 else {
            throw FirstPairSourceSliceError.sourceTooShort("6388f0 caller context", contextSource.count, 0x420)
        }
        guard callerStack20.count >= builder6473d0CallerStackPreimageBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "6388f0 caller stack20",
                callerStack20.count,
                builder6473d0CallerStackPreimageBytes
            )
        }
        guard first64cd40Output.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "first 64cd40 output",
                first64cd40Output.count,
                builder63c278VectorBytes
            )
        }
        guard entryIndex >= 0 else {
            throw FirstPairSourceSliceError.invalid6388f0EntryIndex(entryIndex)
        }

        let tables = try cachedTables.get()
        let contextBytes = [UInt8](contextSource)
        var stack = [UInt8](repeating: 0, count: builder6388f0CallerStackBytes)
        try checkedReplace(&stack, at: 0x230, with: [UInt8](contextSource))
        try checkedReplace(&stack, at: 0x3708, with: [UInt8](callerStack20))
        for (offset, raw) in postVectors {
            try checkedReplace(&stack, at: offset, with: [UInt8](raw))
        }
        try checkedReplace(&stack, at: 0x3b28, with: [UInt8](first64cd40Output.prefix(builder63c278VectorBytes)))

        let loopSlot = entryIndex % builder6388f0CallerLoopTableRows
        let loopCounter = builder6388f0CallerLoopTableRows - 1 - loopSlot
        let pointerDelta = loopSlot * builder6388f0CallerLoopRowBytes
        writeUInt32LE(readUInt32LE(stack, 0x6f8 + loopCounter * 0x58), into: &stack, at: 0x44)
        writeUInt32LE(readUInt32LE(stack, 0x1b40 + loopCounter * 0x58), into: &stack, at: 0x40)

        for index in 0..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            let word = readUInt32LE(stack, 0x3b28 + index * 4)
                &* (try foldTableU32Word63c278(0x300ff0 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x1184c8 + tableOffset, tables: tables))
            writeUInt32LE(word, into: &stack, at: 0x154 + index * 4)
        }

        var callerWord = readUInt32LE(stack, 0x44) &* 0xa2e10181 &+ 0xd0b84b4a
        var postWord = readUInt32LE(stack, 0x3868) &* 0xea9bc62b &+ 0x295fb23d
        var callerWordMul: UInt64 = 0x67eb8e340bf68edd
        var callerWordAdd: UInt64 = 0x7194bb146d6a6c98
        var callerMixMul: UInt64 = 0x412cb68339b36b19
        var callerMixAdd: UInt64 = 0xe7c0e7165633369b
        var callerFoldMul: UInt64 = 0xf883fc9300000000
        var postWordMul: UInt64 = 0x1e34bf9de310fbcb
        var postWordAdd: UInt64 = 0xe80eb386bd2c7669
        var postMixMul: UInt64 = 0x3f2d22f0405cf24f
        var postMixAdd: UInt64 = 0x316c36e4735ae9bc
        var postFoldMul: UInt64 = 0xa4e2a4f300000000

        var callerValue = try builder6388f0CallerStreamU64(
            word: callerWord,
            wordMul: callerWordMul,
            wordAdd: callerWordAdd,
            foldTable: 0x3013f0,
            foldMul: callerFoldMul,
            mixMul: callerMixMul,
            mixAdd: callerMixAdd,
            tables: tables
        )
        var postValue = try builder6388f0CallerStreamU64(
            word: postWord,
            wordMul: postWordMul,
            wordAdd: postWordAdd,
            foldTable: 0x301370,
            foldMul: postFoldMul,
            mixMul: postMixMul,
            mixAdd: postMixAdd,
            tables: tables
        )
        writeUInt64LE(callerValue, into: &stack, at: 0x4130)
        writeUInt64LE(callerValue, into: &stack, at: 0x3ef0)
        writeUInt64LE(postValue, into: &stack, at: 0x3b80)
        writeUInt64LE(postValue, into: &stack, at: 0x4010)

        var prefixPost = postValue
        for index in 1..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            var word = readUInt32LE(stack, 0x3868 + index * 4)
            word = word &* (try u32TableWord63c278(0x11c3c8 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x11d4c8 + tableOffset, tables: tables))
            word = word &* 0xc99643bb &+ 0xac352509
            let value = try builder6388f0CallerStreamU64(
                word: word,
                wordMul: postWordMul,
                wordAdd: postWordAdd,
                foldTable: 0x301370,
                foldMul: postFoldMul,
                mixMul: postMixMul,
                mixAdd: postMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x3b80 + index * 8)
            prefixPost = prefixPost &+ value
            writeUInt64LE(prefixPost, into: &stack, at: 0x4010 + index * 8)
        }

        var prefixCaller = callerValue
        var callerStream = 0x1aec - pointerDelta
        for index in 0..<(builder63c278VectorWords - 1) {
            let tableOffset = ((index + 1) & 7) * 4
            var word = readUInt32LE(stack, callerStream + index * 4)
            word = word &* (try u32TableWord63c278(0x1125e8 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x118f08 + tableOffset, tables: tables))
            word = word &* 0x31bbe0b7 &+ 0x3fe25e18
            let value = try builder6388f0CallerStreamU64(
                word: word,
                wordMul: callerWordMul,
                wordAdd: callerWordAdd,
                foldTable: 0x3013f0,
                foldMul: callerFoldMul,
                mixMul: callerMixMul,
                mixAdd: callerMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x4138 + index * 8)
            prefixCaller = prefixCaller &+ value
            writeUInt64LE(prefixCaller, into: &stack, at: 0x3ef8 + index * 8)
        }

        builder6388f0Convolution44(
            stack: &stack,
            aVecOffset: 0x4130,
            aPrefixOffset: 0x3ef0,
            bVecOffset: 0x3b80,
            bPrefixOffset: 0x4010,
            outOffset: 0x3ce0,
            constants: (
                0x31387af6df27bc34,
                0x5e7eda1d7e652662,
                0xdc67c7dbf68b7273,
                0x8f98298f0679fa22,
                0x662a1479caab56ce,
                0x26efbb4b51cdc6b5,
                0xc5b3a8b6b472e5d3
            )
        )

        callerWord = readUInt32LE(stack, 0x40) &* 0x63dc1441 &+ 0xda7427c7
        postWord = readUInt32LE(stack, 0x3760) &* 0xe609bd27 &+ 0x93c1ccd4
        callerWordMul = 0xdca944fb28ac47f7
        callerWordAdd = 0xd57d3e716bf087fc
        callerMixMul = 0xb241122944abe41d
        callerMixAdd = 0xeb98df0f724a8bc5
        callerFoldMul = 0xd584887500000000
        postWordMul = 0x86835750d0f2d33d
        postWordAdd = 0x93d6710e2805c2cd
        postMixMul = 0x37836d2c6f35aeaf
        postMixAdd = 0xabfb5017ca2ca427
        postFoldMul = 0x749f87a500000000

        callerValue = try builder6388f0CallerStreamU64(
            word: callerWord,
            wordMul: callerWordMul,
            wordAdd: callerWordAdd,
            foldTable: 0x3014f0,
            foldMul: callerFoldMul,
            mixMul: callerMixMul,
            mixAdd: callerMixAdd,
            tables: tables
        )
        postValue = try builder6388f0CallerStreamU64(
            word: postWord,
            wordMul: postWordMul,
            wordAdd: postWordAdd,
            foldTable: 0x301470,
            foldMul: postFoldMul,
            mixMul: postMixMul,
            mixAdd: postMixAdd,
            tables: tables
        )
        writeUInt64LE(callerValue, into: &stack, at: 0x4010)
        writeUInt64LE(callerValue, into: &stack, at: 0x3e40)
        writeUInt64LE(postValue, into: &stack, at: 0x4130)
        writeUInt64LE(postValue, into: &stack, at: 0x3ef0)

        prefixPost = postValue
        for index in 1..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            var word = readUInt32LE(stack, 0x3760 + index * 4)
            word = word &* (try u32TableWord63c278(0x11e588 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x122a68 + tableOffset, tables: tables))
            word = word &* 0x712dee2f &+ 0xecb470d1
            let value = try builder6388f0CallerStreamU64(
                word: word,
                wordMul: postWordMul,
                wordAdd: postWordAdd,
                foldTable: 0x301470,
                foldMul: postFoldMul,
                mixMul: postMixMul,
                mixAdd: postMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x4130 + index * 8)
            prefixPost = prefixPost &+ value
            writeUInt64LE(prefixPost, into: &stack, at: 0x3ef0 + index * 8)
        }

        prefixCaller = callerValue
        callerStream = 0x2f34 - pointerDelta
        for index in 0..<(builder63c278VectorWords - 1) {
            let tableOffset = ((index + 1) & 7) * 4
            var word = readUInt32LE(stack, callerStream + index * 4)
            word = word &* (try u32TableWord63c278(0x120628 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x122a88 + tableOffset, tables: tables))
            word = word &* 0x26f75f39 &+ 0x1c4c83fc
            let value = try builder6388f0CallerStreamU64(
                word: word,
                wordMul: callerWordMul,
                wordAdd: callerWordAdd,
                foldTable: 0x3014f0,
                foldMul: callerFoldMul,
                mixMul: callerMixMul,
                mixAdd: callerMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x4018 + index * 8)
            prefixCaller = prefixCaller &+ value
            writeUInt64LE(prefixCaller, into: &stack, at: 0x3e48 + index * 8)
        }

        builder6388f0Convolution44(
            stack: &stack,
            aVecOffset: 0x4010,
            aPrefixOffset: 0x3e40,
            bVecOffset: 0x4130,
            bPrefixOffset: 0x3ef0,
            outOffset: 0x3b80,
            constants: (
                0xf8f0e2182e743120,
                0x2ea75adafa845934,
                0x49eba04bc8aba147,
                0x2ae8b5655df9be65,
                0xcc8eaf52163f5260,
                0xfee73c0f7de3fa41,
                0x7572d2a401ed3b6a
            )
        )

        for offset in stride(from: 0, to: 0x160, by: 0x10) {
            let firstA = readUInt64LE(stack, 0x3ce0 + offset)
            let secondA = readUInt64LE(stack, 0x3ce0 + offset + 8)
            let firstB = readUInt64LE(stack, 0x3b80 + offset)
            let secondB = readUInt64LE(stack, 0x3b80 + offset + 8)
            writeUInt64LE(
                firstA &* 0xf6ebf5f38b50e6e5
                &+ 0x08494646ffdad49a
                &+ firstB &* 0x26f0954510cb129f,
                into: &stack,
                at: 0x39c8 + offset
            )
            writeUInt64LE(
                secondA &* 0xf6ebf5f38b50e6e5
                &+ 0x08494646ffdad49a
                &+ secondB &* 0x26f0954510cb129f,
                into: &stack,
                at: 0x39c8 + offset + 8
            )
        }

        return Builder6388f0Caller64CallState(
            arg0: Data(stack[0x330..<0x388]),
            scalar: readUInt64LE(contextBytes, 0x418),
            x2Workspace: Data(stack[0x39c8..<0x3b28]),
            x3Preimage: Data(stack[0x3b28..<0x3b80]),
            stackWindow: Data(stack[0x3778..<0x42c8])
        )
    }

    public static func builder6388f0Third64cd40CallState(
        contextSource: Data,
        callerStack20: Data,
        postVectors: [Int: Data],
        second64cd40Output: Data,
        entryIndex: Int
    ) throws -> Builder6388f0Caller64CallState {
        guard contextSource.count >= 0x420 else {
            throw FirstPairSourceSliceError.sourceTooShort("6388f0 caller context", contextSource.count, 0x420)
        }
        guard callerStack20.count >= builder6473d0CallerStackPreimageBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "6388f0 caller stack20",
                callerStack20.count,
                builder6473d0CallerStackPreimageBytes
            )
        }
        guard second64cd40Output.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "second 64cd40 output",
                second64cd40Output.count,
                builder63c278VectorBytes
            )
        }
        guard entryIndex >= 0 else {
            throw FirstPairSourceSliceError.invalid6388f0EntryIndex(entryIndex)
        }

        let tables = try cachedTables.get()
        let contextBytes = [UInt8](contextSource)
        var stack = [UInt8](repeating: 0, count: builder6388f0CallerStackBytes)
        try checkedReplace(&stack, at: 0x230, with: [UInt8](contextSource))
        try checkedReplace(&stack, at: 0x3708, with: [UInt8](callerStack20))
        for (offset, raw) in postVectors {
            try checkedReplace(&stack, at: offset, with: [UInt8](raw))
        }
        try checkedReplace(&stack, at: 0x3b28, with: [UInt8](second64cd40Output.prefix(builder63c278VectorBytes)))

        let loopSlot = entryIndex % builder6388f0CallerLoopTableRows
        let loopCounter = builder6388f0CallerLoopTableRows - 1 - loopSlot
        let pointerDelta = loopSlot * builder6388f0CallerLoopRowBytes
        writeUInt32LE(readUInt32LE(stack, 0x6f8 + loopCounter * 0x58), into: &stack, at: 0x44)
        writeUInt32LE(readUInt32LE(stack, 0x1b40 + loopCounter * 0x58), into: &stack, at: 0x40)

        for index in 0..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            let word = readUInt32LE(stack, 0x3b28 + index * 4)
                &* (try u32TableWord63c278(0x114948 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x1184e8 + tableOffset, tables: tables))
            writeUInt32LE(word, into: &stack, at: 0xfc + index * 4)
        }

        var callerWord = readUInt32LE(stack, 0x44) &* 0x52b341e9 &+ 0x8fe4704a
        var postWord = readUInt32LE(stack, 0x3810) &* 0xb1c3b83d &+ 0x4ac96e8d
        var callerWordMul: UInt64 = 0xc601c25eb7863abb
        var callerWordAdd: UInt64 = 0x8a9ac40e5bfb780d
        var callerMixMul: UInt64 = 0xe76d920aeec9873d
        var callerMixAdd: UInt64 = 0x63d22c2ddb82d5a1
        var callerFoldMul: UInt64 = 0x9897ad9900000000
        var postWordMul: UInt64 = 0x16aacea9a72f0c45
        var postWordAdd: UInt64 = 0xe952bbc97872445c
        var postMixMul: UInt64 = 0x9c887c5c45db1a3b
        var postMixAdd: UInt64 = 0x6536302ead1b2169
        var postFoldMul: UInt64 = 0x7db1cb8100000000

        var callerValue = try builder6388f0CallerStreamU64(
            word: callerWord,
            wordMul: callerWordMul,
            wordAdd: callerWordAdd,
            foldTable: 0x3015f0,
            foldMul: callerFoldMul,
            mixMul: callerMixMul,
            mixAdd: callerMixAdd,
            tables: tables
        )
        var postValue = try builder6388f0CallerStreamU64(
            word: postWord,
            wordMul: postWordMul,
            wordAdd: postWordAdd,
            foldTable: 0x301570,
            foldMul: postFoldMul,
            mixMul: postMixMul,
            mixAdd: postMixAdd,
            tables: tables
        )
        writeUInt64LE(callerValue, into: &stack, at: 0x4130)
        writeUInt64LE(callerValue, into: &stack, at: 0x3ef0)
        writeUInt64LE(postValue, into: &stack, at: 0x3b80)
        writeUInt64LE(postValue, into: &stack, at: 0x4010)

        var prefixPost = postValue
        for index in 1..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            var word = readUInt32LE(stack, 0x3810 + index * 4)
            word = word &* (try u32TableWord63c278(0x120648 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x122208 + tableOffset, tables: tables))
            word = word &* 0xad44242b &+ 0x28772583
            let value = try builder6388f0CallerStreamU64(
                word: word,
                wordMul: postWordMul,
                wordAdd: postWordAdd,
                foldTable: 0x301570,
                foldMul: postFoldMul,
                mixMul: postMixMul,
                mixAdd: postMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x3b80 + index * 8)
            prefixPost = prefixPost &+ value
            writeUInt64LE(prefixPost, into: &stack, at: 0x4010 + index * 8)
        }

        var prefixCaller = callerValue
        var callerStream = 0x1aec - pointerDelta
        for index in 0..<(builder63c278VectorWords - 1) {
            let tableOffset = ((index + 1) & 7) * 4
            var word = readUInt32LE(stack, callerStream + index * 4)
            word = word &* (try u32TableWord63c278(0x119728 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x1218e8 + tableOffset, tables: tables))
            word = word &* 0xb7911189 &+ 0x50798488
            let value = try builder6388f0CallerStreamU64(
                word: word,
                wordMul: callerWordMul,
                wordAdd: callerWordAdd,
                foldTable: 0x3015f0,
                foldMul: callerFoldMul,
                mixMul: callerMixMul,
                mixAdd: callerMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x4138 + index * 8)
            prefixCaller = prefixCaller &+ value
            writeUInt64LE(prefixCaller, into: &stack, at: 0x3ef8 + index * 8)
        }

        builder6388f0Convolution44(
            stack: &stack,
            aVecOffset: 0x4130,
            aPrefixOffset: 0x3ef0,
            bVecOffset: 0x3b80,
            bPrefixOffset: 0x4010,
            outOffset: 0x3ce0,
            constants: (
                0x02949f32b4f07fd8,
                0xbea7dd815afcbcc1,
                0x7611b37d7c8f4475,
                0xb4709b2cff94859c,
                0xde2dc8d44e8f4662,
                0x3b985d4b603f64d9,
                0x9a4acc2ae823c739
            )
        )

        callerWord = readUInt32LE(stack, 0x40) &* 0x10aa89f9 &+ 0x5f38d605
        postWord = readUInt32LE(stack, 0x3708) &* 0x49dc9b53 &+ 0x4de59f05
        callerWordMul = 0x8b7f3e328f16058b
        callerWordAdd = 0xc7947e77ef912670
        callerMixMul = 0x272b96c7a7cb8ff9
        callerMixAdd = 0x7dff808a85cebcac
        callerFoldMul = 0xbcbba6f500000000
        postWordMul = 0x4cea0abb01866b97
        postWordAdd = 0xd8436bdaf28ca051
        postMixMul = 0x4c0e84f7d0089f9b
        postMixAdd = 0xb5d5f7a06307c689
        postFoldMul = 0x832f036300000000

        callerValue = try builder6388f0CallerStreamU64FirstNibbleBeforeAdd(
            word: callerWord,
            wordMul: callerWordMul,
            wordAdd: callerWordAdd,
            foldTable: 0x3016f0,
            foldMul: callerFoldMul,
            mixMul: callerMixMul,
            mixAdd: callerMixAdd,
            tables: tables
        )
        postValue = try builder6388f0CallerStreamU64(
            word: postWord,
            wordMul: postWordMul,
            wordAdd: postWordAdd,
            foldTable: 0x301670,
            foldMul: postFoldMul,
            mixMul: postMixMul,
            mixAdd: postMixAdd,
            tables: tables
        )
        writeUInt64LE(callerValue, into: &stack, at: 0x4010)
        writeUInt64LE(callerValue, into: &stack, at: 0x3e40)
        writeUInt64LE(postValue, into: &stack, at: 0x4130)
        writeUInt64LE(postValue, into: &stack, at: 0x3ef0)

        prefixPost = postValue
        for index in 1..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            var word = readUInt32LE(stack, 0x3708 + index * 4)
            word = word &* (try u32TableWord63c278(0x115f28 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x118508 + tableOffset, tables: tables))
            word = word &* 0x68c9b103 &+ 0x45ce4a73
            let value = try builder6388f0CallerStreamU64(
                word: word,
                wordMul: postWordMul,
                wordAdd: postWordAdd,
                foldTable: 0x301670,
                foldMul: postFoldMul,
                mixMul: postMixMul,
                mixAdd: postMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x4130 + index * 8)
            prefixPost = prefixPost &+ value
            writeUInt64LE(prefixPost, into: &stack, at: 0x3ef0 + index * 8)
        }

        prefixCaller = callerValue
        callerStream = 0x2f34 - pointerDelta
        for index in 0..<(builder63c278VectorWords - 1) {
            let tableOffset = ((index + 1) & 7) * 4
            var word = readUInt32LE(stack, callerStream + index * 4)
            word = word &* (try u32TableWord63c278(0x115468 + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(0x118528 + tableOffset, tables: tables))
            word = word &* 0xf6c4e17d &+ 0x0882a9cf
            let value = try builder6388f0CallerStreamU64FirstNibbleBeforeAdd(
                word: word,
                wordMul: callerWordMul,
                wordAdd: callerWordAdd,
                foldTable: 0x3016f0,
                foldMul: callerFoldMul,
                mixMul: callerMixMul,
                mixAdd: callerMixAdd,
                tables: tables
            )
            writeUInt64LE(value, into: &stack, at: 0x4018 + index * 8)
            prefixCaller = prefixCaller &+ value
            writeUInt64LE(prefixCaller, into: &stack, at: 0x3e48 + index * 8)
        }

        builder6388f0Convolution44(
            stack: &stack,
            aVecOffset: 0x4010,
            aPrefixOffset: 0x3e40,
            bVecOffset: 0x4130,
            bPrefixOffset: 0x3ef0,
            outOffset: 0x3b80,
            constants: (
                0x638b8c646690163a,
                0x96f60e030a9158de,
                0x59ee1b3f304ea615,
                0x3a17e3aa11527f5e,
                0xcf4a3bc55798adef,
                0x15bcf2fe3c06e5af,
                0xcc8339ef4cba9cd0
            )
        )

        for offset in stride(from: 0, to: 0x160, by: 0x10) {
            let firstA = readUInt64LE(stack, 0x3ce0 + offset)
            let secondA = readUInt64LE(stack, 0x3ce0 + offset + 8)
            let firstB = readUInt64LE(stack, 0x3b80 + offset)
            let secondB = readUInt64LE(stack, 0x3b80 + offset + 8)
            writeUInt64LE(
                firstA &* 0x929296759110b0a3
                &+ 0x0ede13af97827959
                &+ firstB &* 0x70b7f6eaabceff57,
                into: &stack,
                at: 0x39c8 + offset
            )
            writeUInt64LE(
                secondA &* 0x929296759110b0a3
                &+ 0x0ede13af97827959
                &+ secondB &* 0x70b7f6eaabceff57,
                into: &stack,
                at: 0x39c8 + offset + 8
            )
        }

        return Builder6388f0Caller64CallState(
            arg0: Data(stack[0x330..<0x388]),
            scalar: readUInt64LE(contextBytes, 0x418),
            x2Workspace: Data(stack[0x39c8..<0x3b28]),
            x3Preimage: Data(stack[0x3b28..<0x3b80]),
            stackWindow: Data(stack[0x3778..<0x42c8])
        )
    }

    public static func builder6388f0Call64Call(
        _ state: Builder6388f0Caller64CallState
    ) throws -> Builder6388f0Caller64Call {
        let output = packUInt32LE(try builder64cd40OutputWords(
            arg0: state.arg0,
            scalar: state.scalar,
            x2Workspace: state.x2Workspace
        ))
        return Builder6388f0Caller64Call(
            arg0: state.arg0,
            scalar: state.scalar,
            x2Workspace: state.x2Workspace,
            x3Preimage: state.x3Preimage,
            stackWindow: state.stackWindow,
            output: output
        )
    }

    public static func builder6388f0SeededCaller64Row(
        index: Int,
        current642f60: Builder6388f0Next642f60Inputs,
        preimages: Builder6473d0OutputPreimages,
        contextSource: Data? = nil
    ) throws -> Builder6388f0SeededCaller64Row {
        let context: Data
        if let contextSource {
            context = contextSource
        } else {
            context = try builder6388f0CallerContextFromBundle()
        }

        let after642f60 = try builder642f60Outputs(
            in0: current642f60.x0,
            in1: current642f60.x1,
            in2: current642f60.x2,
            contextSource: context
        )
        let after6473d0 = try builder6473d0Outputs(
            in0: after642f60.out0,
            in1: after642f60.out1,
            in2: after642f60.out2,
            contextSource: context,
            out0Preimage: preimages.out0,
            out1Preimage: preimages.out1
        )
        let minimalStack20 = try builder6473d0MinimalStack20FromPreimages(preimages)
        let postVectors = builder6473d0PostVectors(after6473d0)

        let first64cd40 = try builder6388f0Call64Call(
            builder6388f0First64cd40CallState(
                contextSource: context,
                callerStack20: minimalStack20,
                postVectors: postVectors,
                entryIndex: index
            )
        )
        let second64cd40 = try builder6388f0Call64Call(
            builder6388f0Second64cd40CallState(
                contextSource: context,
                callerStack20: minimalStack20,
                postVectors: postVectors,
                first64cd40Output: first64cd40.output,
                entryIndex: index
            )
        )
        let third64cd40 = try builder6388f0Call64Call(
            builder6388f0Third64cd40CallState(
                contextSource: context,
                callerStack20: minimalStack20,
                postVectors: postVectors,
                second64cd40Output: second64cd40.output,
                entryIndex: index
            )
        )
        let next642f60 = try builder6388f0Next642f60InputsFrom64cd40Outputs(
            first64cd40Output: first64cd40.output,
            second64cd40Output: second64cd40.output,
            third64cd40Output: third64cd40.output
        )

        return Builder6388f0SeededCaller64Row(
            index: index,
            current642f60: current642f60,
            preimages: preimages,
            after642f60: after642f60,
            after6473d0: after6473d0,
            minimalStack20: minimalStack20,
            first64cd40: first64cd40,
            second64cd40: second64cd40,
            third64cd40: third64cd40,
            next642f60: next642f60
        )
    }

    public static func builder6388f0SeededCaller64Rows(
        starts: Builder6388f0FirstPair642f60Starts,
        row0LowPreimages: Builder6473d0OutputPreimages,
        contextSource: Data? = nil,
        limit: Int = 118,
        x2Source: Data? = nil
    ) throws -> [Builder6388f0SeededCaller64Row] {
        guard limit >= 0, limit <= builder6388f0FirstPairStreamRows else {
            throw FirstPairSourceSliceError.invalid6388f0RowLimit(limit)
        }

        let context: Data
        if let contextSource {
            context = contextSource
        } else {
            context = try builder6388f0CallerContextFromBundle()
        }

        let row0Out0 = try builder6388f0RecoverStreamStartOut0SeedFrom642f60X0(starts.row0.x0)
        let row0Out1 = try builder6388f0RecoverStreamStartOut1SeedFrom642f60X1(starts.row0.x1)
        let row59Out0 = try builder6388f0RecoverStreamStartOut0SeedFrom642f60X0(starts.row59.x0)
        let row59Out1 = try builder6388f0RecoverStreamStartOut1SeedFrom642f60X1(starts.row59.x1)

        let row0Start = try builder6388f0StreamStart642f60Inputs(
            out0Seed: row0Out0,
            out1Seed: row0Out1,
            x2Source: x2Source
        )
        let row59Start = try builder6388f0StreamStart642f60Inputs(
            out0Seed: row59Out0,
            out1Seed: row59Out1,
            x2Source: x2Source
        )

        var rows: [Builder6388f0SeededCaller64Row] = []
        rows.reserveCapacity(limit)
        var previous6473d0: Builder6473d0Result?
        var carried642f60: Builder6388f0Next642f60Inputs?
        var activeOut0Seed: Data?
        var activeOut1Seed: Data?

        for index in 0..<limit {
            let current642f60: Builder6388f0Next642f60Inputs
            let preimages: Builder6473d0OutputPreimages

            if index == 0 {
                current642f60 = row0Start
                activeOut0Seed = row0Out0
                activeOut1Seed = row0Out1
                preimages = Builder6473d0OutputPreimages(
                    out4: row0LowPreimages.out4,
                    out3: row0LowPreimages.out3,
                    out2: row0LowPreimages.out2,
                    out1: row0Out1,
                    out0: row0Out0
                )
            } else if index == builder6388f0CallerLoopTableRows {
                guard let previous6473d0 else {
                    throw FirstPairSourceSliceError.invalid6388f0EntryIndex(index)
                }
                current642f60 = row59Start
                activeOut0Seed = row59Out0
                activeOut1Seed = row59Out1
                preimages = Builder6473d0OutputPreimages(
                    out4: previous6473d0.out4,
                    out3: previous6473d0.out3,
                    out2: previous6473d0.out2,
                    out1: row59Out1,
                    out0: row59Out0
                )
            } else {
                guard
                    let carried642f60,
                    let previous6473d0,
                    let activeOut0Seed,
                    let activeOut1Seed
                else {
                    throw FirstPairSourceSliceError.invalid6388f0EntryIndex(index)
                }
                current642f60 = carried642f60
                preimages = Builder6473d0OutputPreimages(
                    out4: previous6473d0.out4,
                    out3: previous6473d0.out3,
                    out2: previous6473d0.out2,
                    out1: activeOut1Seed,
                    out0: activeOut0Seed
                )
            }

            let row = try builder6388f0SeededCaller64Row(
                index: index,
                current642f60: current642f60,
                preimages: preimages,
                contextSource: context
            )
            rows.append(row)
            previous6473d0 = row.after6473d0
            carried642f60 = row.next642f60
        }
        return rows
    }

    public static func builder6388f0SeededCaller64RowsFromFirstPairStreamSeeds(
        seeds: Builder6388f0FirstPairStreamSeeds,
        contextSource: Data? = nil,
        limit: Int = 118,
        x2Source: Data? = nil
    ) throws -> [Builder6388f0SeededCaller64Row] {
        let starts = try builder6388f0FirstPair642f60StreamStarts(
            seeds: seeds,
            x2Source: x2Source
        )
        let row0LowPreimages = Builder6473d0OutputPreimages(
            out4: seeds.row0Out4,
            out3: seeds.row0Out3,
            out2: seeds.row0Out2,
            out1: seeds.row0Out1,
            out0: seeds.row0Out0
        )
        return try builder6388f0SeededCaller64Rows(
            starts: starts,
            row0LowPreimages: row0LowPreimages,
            contextSource: contextSource,
            limit: limit,
            x2Source: x2Source
        )
    }

    public static func builder6388f0Seeded63c278SchedulesFromRows(
        rows: [Builder6388f0SeededCaller64Row]
    ) throws -> Builder6388f0Seeded63c278Schedules {
        try builder6388f0Seeded63c278SchedulesFromRows(
            rows: rows,
            arg0: pre63c278Arg0Source,
            scalar: pre63c278Scalar
        )
    }

    public static func builder6388f0Seeded63c278SchedulesFromRows(
        rows: [Builder6388f0SeededCaller64Row],
        arg0: Data,
        scalar: UInt64
    ) throws -> Builder6388f0Seeded63c278Schedules {
        guard rows.count >= builder6388f0FirstPairStreamRows else {
            throw FirstPairSourceSliceError.invalid6388f0RowLimit(rows.count)
        }
        guard arg0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("63c278 arg0", arg0.count, builder63c278VectorBytes)
        }
        let arg0Prefix = Data(arg0.prefix(builder63c278VectorBytes))

        func stream(rowIndex: Int) throws -> Builder6388f0Seeded63c278Stream {
            let row = rows[rowIndex]
            let arg1 = row.next642f60.x0
            let arg2 = row.next642f60.x2
            return Builder6388f0Seeded63c278Stream(
                rowIndex: rowIndex,
                arg0: arg0Prefix,
                arg1: arg1,
                arg2: arg2,
                scalar: scalar,
                scheduleWords: try builder63c278ScheduleWords(
                    arg0: arg0Prefix,
                    arg1: arg1,
                    arg2: arg2,
                    scalar: scalar
                )
            )
        }

        return Builder6388f0Seeded63c278Schedules(
            first: try stream(rowIndex: builder6388f0CallerLoopTableRows - 1),
            second: try stream(rowIndex: builder6388f0FirstPairStreamRows - 1)
        )
    }

    public static func builder64cd40Arg0U64Words(arg0: Data) throws -> [UInt64] {
        guard arg0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("64cd40 arg0", arg0.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](arg0)
        var out: [UInt64] = []
        out.reserveCapacity(builder63c278VectorWords)
        for index in 0..<builder63c278VectorWords {
            let affine = try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: 0x123e08,
                addTable: 0x123428,
                tables: tables
            )
            let word = (affine &* 0x8c2231af) &+ 0x6d97daf4
            var folded = (UInt64(word) &* 0xeb7e2c45742037f1) &+ 0x3363481bcd8bcd54
            folded = try fold63c278(folded, tableOffset: 0x3010f0, rounds: 8, tables: tables)
            out.append(
                (UInt64(word) &* 0x92d397b84a615e45)
                &+ (folded &* 0x73db406b00000000)
                &+ 0xbdc443456d026c77
            )
        }
        return out
    }

    public static func builder64cd40WorkspaceAfterUpdate(
        arg0U64Words: [UInt64],
        scalar: UInt64,
        x2Workspace: Data
    ) throws -> Data {
        guard arg0U64Words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(arg0U64Words.count)
        }
        guard x2Workspace.count >= builder64cd40WorkspaceBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("64cd40 x2 workspace", x2Workspace.count, builder64cd40WorkspaceBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x2Workspace)
        var x2Words = (0..<builder64cd40WorkspaceWords).map { readUInt64LE(bytes, $0 * 8) }
        var carryWord = x2Words[0]
        for base in 0..<builder63c278VectorWords {
            let params = try builder64cd40WorkspaceParams(
                scalar: scalar,
                firstX2Word: carryWord,
                tables: tables
            )
            for (offset, word) in arg0U64Words.enumerated() {
                let pos = base + offset
                let product = word &* params.multiplier
                x2Words[pos] = x2Words[pos] &+ params.broadcast &+ product
            }
            carryWord = try builder64cd40RewriteSecondWord(
                first: x2Words[base],
                second: x2Words[base + 1],
                tables: tables
            )
            x2Words[base + 1] = carryWord
        }
        return packUInt64LE64cd40(x2Words)
    }

    public static func builder64cd40FinalU32Words(x2Workspace: Data) throws -> [UInt32] {
        guard x2Workspace.count >= builder64cd40WorkspaceBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("64cd40 x2 workspace", x2Workspace.count, builder64cd40WorkspaceBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](x2Workspace)
        let x2Words = (0..<builder64cd40WorkspaceWords).map { readUInt64LE(bytes, $0 * 8) }
        var carry: UInt64 = 0x0b784750d9181757
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)

        for index in 0..<builder63c278VectorWords {
            let tailWord = x2Words[builder63c278VectorWords + index]
            let mixed = (carry &* 0xcaaf4f9d292a519d) &+ (tailWord &* 0x28d4341977190ea5)
            let foldedInput = mixed &+ 0x593214d4b8068287
            var foldedParts = try builder64cd40FinalFirstFold(foldedInput, tables: tables)
            for _ in 0..<8 {
                foldedParts.folded = try foldTableU64Word63c278(
                    0x3012f0 + Int(foldedParts.folded & 0x0f) * 8,
                    tables: tables
                ) &+ (foldedParts.folded >> 4)
            }
            let nextCarry = (foldedParts.nextBase &* 0xda8179ca5c614737)
                &+ (foldedParts.folded &* 0x39eb8c9000000000)
            let tableOffset = (index * 4) & 0x1c
            out.append(try u32TableAffine63c278(
                foldedParts.side,
                mulTable: 0x11c3a8 + tableOffset,
                addTable: 0x11dce8 + tableOffset,
                tables: tables
            ))
            carry = nextCarry &+ 0xd2a88419cf931098
        }
        return out
    }

    public static func builder64cd40OutputWords(
        arg0: Data,
        scalar: UInt64,
        x2Workspace: Data
    ) throws -> [UInt32] {
        let arg0Words = try builder64cd40Arg0U64Words(arg0: arg0)
        let updated = try builder64cd40WorkspaceAfterUpdate(
            arg0U64Words: arg0Words,
            scalar: scalar,
            x2Workspace: x2Workspace
        )
        return try builder64cd40FinalU32Words(x2Workspace: updated)
    }

    public static func builder6388f0LaneBlocksFromScheduleWords(
        _ scheduleWords: [UInt32]
    ) throws -> (primaryLaneBlocks: Data, secondaryLaneBlocks: Data) {
        guard scheduleWords.count == builder6388f0LaneBlockCount else {
            throw FirstPairSourceSliceError.invalid6388f0ScheduleWordCount(scheduleWords.count)
        }
        let tables = try cachedTables.get()
        let primaryStatic = try checkedSlice(
            tables.laneTables6388f0,
            builder6388f0LanePrimaryStaticOffset,
            builder6388f0LaneTableExpandedSize,
            RuntimeTable.firstPair6388f0LaneTables.rawValue
        )
        let secondaryStatic = try checkedSlice(
            tables.laneTables6388f0,
            builder6388f0LaneSecondaryStaticOffset,
            builder6388f0LaneTableExpandedSize,
            RuntimeTable.firstPair6388f0LaneTables.rawValue
        )

        var primaryLanes: [UInt8] = []
        var secondaryLanes: [UInt8] = []
        primaryLanes.reserveCapacity(builder6388f0LaneBlocksSize)
        secondaryLanes.reserveCapacity(builder6388f0LaneBlocksSize)

        for (index, word) in scheduleWords.enumerated() {
            let selector = try selector6388f0(index: index, scheduleWord: word, tables: tables)
            var primaryState = try checkedSlice(
                tables.laneTables6388f0,
                builder6388f0LaneAInitOffset,
                builder6388f0LaneBlockSize,
                RuntimeTable.firstPair6388f0LaneTables.rawValue
            )
            primaryState.append(contentsOf: [0x05, 0x04])
            var secondaryState = try checkedSlice(
                tables.laneTables6388f0,
                builder6388f0LaneBInitOffset,
                builder6388f0LaneBlockSize,
                RuntimeTable.firstPair6388f0LaneTables.rawValue
            )
            secondaryState.append(contentsOf: [0x05, 0x02])

            for shift in [24, 16, 8, 0] {
                let primaryPrimer = try lanePrefixed6388f0(prefixWord: 0x03000000, state18: primaryState)
                primaryState = try vm638840(
                    magic: 0x1200000712f,
                    src1: primaryPrimer,
                    src2: primaryPrimer,
                    tables: tables
                )

                let secondaryPrimer = try lanePrefixed6388f0(prefixWord: 0x01000000, state18: secondaryState)
                secondaryState = try vm638840(
                    magic: 0x120000003aa,
                    src1: secondaryPrimer,
                    src2: secondaryPrimer,
                    tables: tables
                )

                let selectorByte = UInt8((selector >> UInt32(shift)) & 0xff)
                primaryState = try vm638840(
                    magic: 0x1200000551a,
                    src1: primaryState,
                    src2: try laneTable6388f0Expand(
                        tableOffset: builder6388f0LaneATableOffset,
                        selectorByte: selectorByte,
                        tables: tables
                    ),
                    tables: tables
                )
                secondaryState = try vm638840(
                    magic: 0x12000000c60,
                    src1: secondaryState,
                    src2: try laneTable6388f0Expand(
                        tableOffset: builder6388f0LaneBTableOffset,
                        selectorByte: selectorByte,
                        tables: tables
                    ),
                    tables: tables
                )
            }

            let primarySource = try vm638840(
                magic: 0x12000003d45,
                src1: primaryState,
                src2: primaryStatic,
                tables: tables
            )
            let secondarySource = try vm638840(
                magic: 0x12000005e9d,
                src1: secondaryState,
                src2: secondaryStatic,
                tables: tables
            )
            primaryLanes.append(
                contentsOf: try vm638840(
                    magic: 0x10000000214,
                    src1: primarySource,
                    src2: primarySource,
                    tables: tables
                )
            )
            secondaryLanes.append(
                contentsOf: try vm638840(
                    magic: 0x10000003231,
                    src1: secondarySource,
                    src2: secondarySource,
                    tables: tables
                )
            )
        }

        return (Data(primaryLanes), Data(secondaryLanes))
    }

    public static func deriveFrom6388f0InternalStreams(
        firstInternalBlocks: Data,
        secondInternalBlocks: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let firstRaw = try builder6388f0FinalRawBlocks(internalBlocks: firstInternalBlocks)
        let secondRaw = try builder6388f0FinalRawBlocks(internalBlocks: secondInternalBlocks)
        return try deriveFrom64d774RawStreams(
            firstRawBlocks: firstRaw,
            secondRawBlocks: secondRaw,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0PrefinalLen32Streams(
        firstPrefinalBlocks: Data,
        secondPrefinalBlocks: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let firstInternal = try builder6388f0PrefinalLen32InternalBlocks(prefinalSourceBlocks: firstPrefinalBlocks)
        let secondInternal = try builder6388f0PrefinalLen32InternalBlocks(prefinalSourceBlocks: secondPrefinalBlocks)
        return try deriveFrom6388f0InternalStreams(
            firstInternalBlocks: firstInternal,
            secondInternalBlocks: secondInternal,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0WorkspaceLen32Streams(
        firstWorkspaceSource: Data,
        secondWorkspaceSource: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let firstPrefinal = try builder6388f0Len32PrefinalSourcesFromWorkspace(workspaceSource: firstWorkspaceSource)
        let secondPrefinal = try builder6388f0Len32PrefinalSourcesFromWorkspace(workspaceSource: secondWorkspaceSource)
        return try deriveFrom6388f0PrefinalLen32Streams(
            firstPrefinalBlocks: firstPrefinal,
            secondPrefinalBlocks: secondPrefinal,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0StageLen32Streams(
        firstStageASource: Data,
        firstStageBSource: Data,
        secondStageASource: Data,
        secondStageBSource: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let firstPrefinal = try builder6388f0Len32PrefinalSourcesFromStageInputs(
            stageASource: firstStageASource,
            stageBSource: firstStageBSource
        )
        let secondPrefinal = try builder6388f0Len32PrefinalSourcesFromStageInputs(
            stageASource: secondStageASource,
            stageBSource: secondStageBSource
        )
        return try deriveFrom6388f0PrefinalLen32Streams(
            firstPrefinalBlocks: firstPrefinal,
            secondPrefinalBlocks: secondPrefinal,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0PackLen32Streams(
        firstStageBPackHead16: Data,
        firstStageBPackBody16: Data,
        firstStageAPackHead16: Data,
        firstStageAPackBody16: Data,
        secondStageBPackHead16: Data,
        secondStageBPackBody16: Data,
        secondStageAPackHead16: Data,
        secondStageAPackBody16: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let firstStage = try builder6388f0Len32StageInputsFromPackOutputs(
            stageBPackHead16: firstStageBPackHead16,
            stageBPackBody16: firstStageBPackBody16,
            stageAPackHead16: firstStageAPackHead16,
            stageAPackBody16: firstStageAPackBody16
        )
        let secondStage = try builder6388f0Len32StageInputsFromPackOutputs(
            stageBPackHead16: secondStageBPackHead16,
            stageBPackBody16: secondStageBPackBody16,
            stageAPackHead16: secondStageAPackHead16,
            stageAPackBody16: secondStageAPackBody16
        )
        return try deriveFrom6388f0StageLen32Streams(
            firstStageASource: firstStage.stageASource,
            firstStageBSource: firstStage.stageBSource,
            secondStageASource: secondStage.stageASource,
            secondStageBSource: secondStage.stageBSource,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0LaneLen32Streams(
        firstPrimaryLaneBlocks: Data,
        firstSecondaryLaneBlocks: Data,
        secondPrimaryLaneBlocks: Data,
        secondSecondaryLaneBlocks: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let firstPack = try builder6388f0PackOutputsFromLaneBlocks(
            primaryLaneBlocks: firstPrimaryLaneBlocks,
            secondaryLaneBlocks: firstSecondaryLaneBlocks
        )
        let secondPack = try builder6388f0PackOutputsFromLaneBlocks(
            primaryLaneBlocks: secondPrimaryLaneBlocks,
            secondaryLaneBlocks: secondSecondaryLaneBlocks
        )
        return try deriveFrom6388f0PackLen32Streams(
            firstStageBPackHead16: firstPack.stageBPackHead16,
            firstStageBPackBody16: firstPack.stageBPackBody16,
            firstStageAPackHead16: firstPack.stageAPackHead16,
            firstStageAPackBody16: firstPack.stageAPackBody16,
            secondStageBPackHead16: secondPack.stageBPackHead16,
            secondStageBPackBody16: secondPack.stageBPackBody16,
            secondStageAPackHead16: secondPack.stageAPackHead16,
            secondStageAPackBody16: secondPack.stageAPackBody16,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0ScheduleLen32Streams(
        firstScheduleWords: [UInt32],
        secondScheduleWords: [UInt32],
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let firstLanes = try builder6388f0LaneBlocksFromScheduleWords(firstScheduleWords)
        let secondLanes = try builder6388f0LaneBlocksFromScheduleWords(secondScheduleWords)
        return try deriveFrom6388f0LaneLen32Streams(
            firstPrimaryLaneBlocks: firstLanes.primaryLaneBlocks,
            firstSecondaryLaneBlocks: firstLanes.secondaryLaneBlocks,
            secondPrimaryLaneBlocks: secondLanes.primaryLaneBlocks,
            secondSecondaryLaneBlocks: secondLanes.secondaryLaneBlocks,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom63c278ScheduleInputs(
        arg0: Data,
        firstArg1: Data,
        firstArg2: Data,
        secondArg1: Data,
        secondArg2: Data,
        scalar: UInt64,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let firstSchedule = try builder63c278ScheduleWords(
            arg0: arg0,
            arg1: firstArg1,
            arg2: firstArg2,
            scalar: scalar
        )
        let secondSchedule = try builder63c278ScheduleWords(
            arg0: arg0,
            arg1: secondArg1,
            arg2: secondArg2,
            scalar: scalar
        )
        return try deriveFrom6388f0ScheduleLen32Streams(
            firstScheduleWords: firstSchedule,
            secondScheduleWords: secondSchedule,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFromPre63c278ScheduleInputs(
        firstArg1: Data,
        firstArg2: Data,
        secondArg1: Data,
        secondArg2: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        try deriveFrom63c278ScheduleInputs(
            arg0: pre63c278Arg0Source,
            firstArg1: firstArg1,
            firstArg2: firstArg2,
            secondArg1: secondArg1,
            secondArg2: secondArg2,
            scalar: pre63c278Scalar,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0SeededCaller64Rows(
        rows: [Builder6388f0SeededCaller64Row],
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        try deriveFrom6388f0SeededCaller64Rows(
            rows: rows,
            arg0: pre63c278Arg0Source,
            scalar: pre63c278Scalar,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0SeededCaller64Rows(
        rows: [Builder6388f0SeededCaller64Row],
        arg0: Data,
        scalar: UInt64,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let schedules = try builder6388f0Seeded63c278SchedulesFromRows(
            rows: rows,
            arg0: arg0,
            scalar: scalar
        )
        return try deriveFrom6388f0ScheduleLen32Streams(
            firstScheduleWords: schedules.first.scheduleWords,
            secondScheduleWords: schedules.second.scheduleWords,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0FirstPairStreamSeeds(
        seeds: Builder6388f0FirstPairStreamSeeds,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        try deriveFrom6388f0FirstPairStreamSeeds(
            seeds: seeds,
            arg0: pre63c278Arg0Source,
            scalar: pre63c278Scalar,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0FirstPairStreamSeeds(
        seeds: Builder6388f0FirstPairStreamSeeds,
        arg0: Data,
        scalar: UInt64,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let rows = try builder6388f0SeededCaller64RowsFromFirstPairStreamSeeds(seeds: seeds)
        return try deriveFrom6388f0SeededCaller64Rows(
            rows: rows,
            arg0: arg0,
            scalar: scalar,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0FirstPairEntropyAndSensorPoints(
        entrySource: Data,
        nullEntropy11A: Data,
        row0SensorPointXYBE: Data,
        row59SensorPointXYBE: Data,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let seeds = try builder6388f0FirstPairStreamSeedsFromEntropyAndSensorPoints(
            entrySource: entrySource,
            nullEntropy11A: nullEntropy11A,
            row0SensorPointXYBE: row0SensorPointXYBE,
            row59SensorPointXYBE: row59SensorPointXYBE
        )
        return try deriveFrom6388f0FirstPairStreamSeeds(
            seeds: seeds,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom6388f0FirstPairEntropySourceAndSensorPoints(
        entrySource: Data,
        row0SensorPointXYBE: Data,
        row59SensorPointXYBE: Data,
        maxAttempts: Int = 64,
        src4: Data = Data([0, 0, 0, 1]),
        offset: Int = 0,
        length: Int = 0x10,
        entropySource: (Int) throws -> Data
    ) throws -> Data {
        let seeds = try builder6388f0FirstPairStreamSeedsFromEntropySourceAndSensorPoints(
            entrySource: entrySource,
            row0SensorPointXYBE: row0SensorPointXYBE,
            row59SensorPointXYBE: row59SensorPointXYBE,
            maxAttempts: maxAttempts,
            entropySource: entropySource
        )
        return try deriveFrom6388f0FirstPairStreamSeeds(
            seeds: seeds,
            src4: src4,
            offset: offset,
            length: length
        )
    }

    public static func deriveFrom679f48Context(
        _ context: Data,
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        let finalized = try finalize679f48ToSecondDF80(context: context)
        return try deriveFromFinalized679f48Context(finalized, offset: offset, length: length)
    }

    public static func finalize679f48ToSecondDF80(context: Data) throws -> Data {
        guard context.count >= context679f48Size else {
            throw FirstPairSourceSliceError.sourceTooShort("679f48 context", context.count, context679f48Size)
        }
        let tables = try cachedTables.get()
        var ctx = [UInt8](context)
        let contextLength = readUInt64LE(ctx, 0)
        guard contextLength <= UInt64(Int.max) else {
            throw FirstPairSourceSliceError.invalidContextLength(Int.max)
        }
        let low = Int(contextLength & 0x0f)
        var blockIndex = readUInt32LE(ctx, 0x110)
        guard blockIndex <= 4 else {
            throw FirstPairSourceSliceError.invalid679f48BlockIndex(blockIndex)
        }

        let slot = 0x08 + Int(blockIndex) * block66Size
        if low != 0 {
            let padIndex = low ^ 0x0f
            let pad1 = try checkedSlice(
                tables.finalizerTables,
                finalizerDD7CPadOffset + padIndex * block66Size,
                block66Size,
                RuntimeTable.firstPairFinalizerTables.rawValue
            )
            let pad2 = try checkedSlice(
                tables.finalizerTables,
                finalizerPad2Offset + padIndex * block66Size,
                block66Size,
                RuntimeTable.firstPairFinalizerTables.rawValue
            )
            let current = try checkedSlice(ctx, slot, block66Size, "679f48 finalizer context")
            let mixed = try vm67cc18(magic: 0x42000005702, src1: current, src2: pad1, tables: tables)
            replace(
                &ctx,
                at: slot,
                with: try vm67cc18(magic: 0x42000005c47, src1: mixed, src2: pad2, tables: tables)
            )
        } else {
            let staticBlock = try checkedSlice(
                tables.finalizerTables,
                finalizerZeroLowBlockOffset,
                block66Size,
                RuntimeTable.firstPairFinalizerTables.rawValue
            )
            replace(
                &ctx,
                at: slot,
                with: try vm67cc18(magic: 0x42000000ffb, src1: staticBlock, src2: staticBlock, tables: tables)
            )
        }

        if low > 7 || blockIndex <= 2 {
            blockIndex += 1
            writeUInt32LE(blockIndex, into: &ctx, at: 0x110)
            if blockIndex == 4 {
                let transformed = try df80Transform(
                    state: Data(ctx[0x114..<0x1a4]),
                    blocks: Data(ctx[0x08..<0x110])
                )
                replace(&ctx, at: 0x114, with: [UInt8](transformed))
                blockIndex = 0
                writeUInt32LE(0, into: &ctx, at: 0x110)
            }

            if blockIndex <= 3 {
                let staticBlock = try checkedSlice(
                    tables.finalizerTables,
                    finalizerStaticBlockOffset,
                    block66Size,
                    RuntimeTable.firstPairFinalizerTables.rawValue
                )
                while blockIndex < 4 {
                    let fillSlot = 0x08 + Int(blockIndex) * block66Size
                    replace(
                        &ctx,
                        at: fillSlot,
                        with: try vm67cc18(
                            magic: 0x42000005d9d,
                            src1: staticBlock,
                            src2: staticBlock,
                            tables: tables
                        )
                    )
                    blockIndex += 1
                    writeUInt32LE(blockIndex, into: &ctx, at: 0x110)
                }
            }
        }

        writeUInt64LE(contextLength << 3, into: &ctx, at: 0)
        let finalLength = try final679f48LengthBlock(contextLength: Int(contextLength))
        let finalMixed = try vm67cc18(
            magic: 0x420000040aa,
            src1: [UInt8](finalLength),
            src2: Array(ctx[0xce..<0x110]),
            tables: tables
        )
        replace(&ctx, at: 0xce, with: finalMixed)
        let transformed = try df80Transform(
            state: Data(ctx[0x114..<0x1a4]),
            blocks: Data(ctx[0x08..<0x110])
        )
        replace(&ctx, at: 0x114, with: [UInt8](transformed))
        return Data(ctx)
    }

    public static func df80Transform(state: Data, blocks: Data) throws -> Data {
        let workspace = try df80InitialWorkspace(blocks: blocks)
        let schedule = try df80ExpandedSchedule(initialWorkspace: workspace)
        return try df80CompressState(state: state, schedule: schedule)
    }

    public static func df80CompressState(state: Data, schedule: Data) throws -> Data {
        guard state.count == df80StateSize else {
            throw FirstPairSourceSliceError.invalidDF80StateLength(state.count)
        }
        guard schedule.count == df80ScheduleSize else {
            throw FirstPairSourceSliceError.invalidDF80ScheduleLength(schedule.count)
        }
        let tables = try cachedTables.get()
        let stateBytes = [UInt8](state)
        let scheduleBytes = [UInt8](schedule)
        var original: [[UInt8]] = []
        original.reserveCapacity(8)
        for start in stride(from: 0, to: df80StateSize, by: df80WordSize) {
            original.append(Array(stateBytes[start..<(start + df80WordSize)]))
        }

        var s0 = try vm67cc18(magic: 0x1200000189d, src1: original[0], src2: original[0], tables: tables)
        var s1 = try vm67cc18(magic: 0x12000001e60, src1: original[1], src2: original[1], tables: tables)
        var s2 = try vm67cc18(magic: 0x1200000152d, src1: original[2], src2: original[2], tables: tables)
        var s3 = try vm67cc18(magic: 0x120000029ed, src1: original[3], src2: original[3], tables: tables)
        var s4 = try vm67cc18(magic: 0x120000040ec, src1: original[4], src2: original[4], tables: tables)
        var s5 = try vm67cc18(magic: 0x120000036ed, src1: original[5], src2: original[5], tables: tables)
        var s6 = try vm67cc18(magic: 0x12000003423, src1: original[6], src2: original[6], tables: tables)
        var s7 = try vm67cc18(magic: 0x12000004056, src1: original[7], src2: original[7], tables: tables)

        let staticB = try checkedSlice(
            tables.df80RoundTables,
            df80ScheduleSize,
            df80WordSize,
            RuntimeTable.firstPairDF80RoundTables.rawValue
        )

        for offset in stride(from: 0, to: df80ScheduleSize, by: df80WordSize) {
            let word = Array(scheduleBytes[offset..<(offset + df80WordSize)])
            let roundA = try checkedSlice(
                tables.df80RoundTables,
                offset,
                df80WordSize,
                RuntimeTable.firstPairDF80RoundTables.rawValue
            )

            var tmp80 = try vm67cecc(magic: 0x0c00f000c01a40, src1: s4, src2: s4, tables: tables)
            var tmp58 = try packDF80Zeros12Marker3(src: s4)
            var tmp22 = try vm67cc18(magic: 0x120000032dc, src1: tmp58, src2: tmp58, tables: tables)
            let mix10 = try vm67cc18(magic: 0x12000001105, src1: tmp22, src2: tmp80, tables: tables)

            tmp22 = try vm67cecc(magic: 0x1800c0018050f7, src1: s4, src2: s4, tables: tables)
            tmp80 = try vm67cc18(magic: 0x12000002cc3, src1: s4, src2: s4, tables: tables)
            tmp58 = try packDF80Zeros8Zero6(src: tmp80)
            var t64 = try vm67cc18(magic: 0x120000030c4, src1: tmp58, src2: tmp58, tables: tables)
            let mix14 = try vm67cc18(magic: 0x12000001251, src1: t64, src2: tmp22, tables: tables)

            let mix15 = try vm67cecc(magic: 0x34005003403785, src1: s4, src2: s4, tables: tables)
            tmp80 = try vm67cc18(magic: 0x120000025a0, src1: s4, src2: s4, tables: tables)
            tmp58 = try packDF80Zeros2Marker6(src: tmp80)
            let mix17 = try vm67cc18(magic: 0x12000000d92, src1: tmp58, src2: tmp58, tables: tables)
            let mix18 = try vm67cc18(magic: 0x120000026f3, src1: mix17, src2: mix15, tables: tables)
            let mix19 = try vm67cc18(magic: 0x12000000e82, src1: mix10, src2: mix14, tables: tables)
            var t76 = try vm67cc18(magic: 0x120000023ee, src1: mix18, src2: mix19, tables: tables)
            t76 = try vm67cc18(magic: 0x120000043a5, src1: s7, src2: t76, tables: tables)

            t64 = try vm67cc18(magic: 0x12000005386, src1: roundA, src2: word, tables: tables)
            let t52 = try vm67cc18(magic: 0x12000004501, src1: t76, src2: t64, tables: tables)

            tmp58 = try vm67cc18(magic: 0x12000000ce4, src1: s4, src2: s5, tables: tables)
            tmp80 = try vm67cc18(magic: 0x12000003aa4, src1: staticB, src2: s4, tables: tables)
            tmp22 = try vm67cc18(magic: 0x12000000f71, src1: tmp80, src2: s6, tables: tables)
            let t40 = try vm67cc18(magic: 0x120000020bc, src1: tmp58, src2: tmp22, tables: tables)
            let tmp92 = try vm67cc18(magic: 0x12000000aa6, src1: t52, src2: t40, tables: tables)

            tmp80 = try vm67cecc(magic: 0x04011000404984, src1: s0, src2: s0, tables: tables)
            tmp58 = try packDF80Zeros14Marker1(src: s0)
            tmp22 = try vm67cc18(magic: 0x1200000190b, src1: tmp58, src2: tmp58, tables: tables)
            let t2e = try vm67cc18(magic: 0x12000003cd1, src1: tmp22, src2: tmp80, tables: tables)

            tmp22 = try vm67cecc(magic: 0x1c00b001c048a7, src1: s0, src2: s0, tables: tables)
            tmp80 = try vm67cc18(magic: 0x12000003683, src1: s0, src2: s0, tables: tables)
            tmp58 = try packDF80Zeros9(src: tmp80)
            tmp58 = try vm67cc18(magic: 0x120000017b1, src1: tmp58, src2: tmp58, tables: tables)
            let t1c = try vm67cc18(magic: 0x12000000d5e, src1: tmp58, src2: tmp22, tables: tables)

            tmp80 = try vm67cecc(magic: 0x2c007002c000ba, src1: s0, src2: s0, tables: tables)
            tmp58 = try packDF80Zeros4Marker3(src: s0)
            tmp22 = try vm67cc18(magic: 0x120000001fd, src1: tmp58, src2: tmp58, tables: tables)
            let tmp34First = try vm67cc18(magic: 0x12000006062, src1: tmp22, src2: tmp80, tables: tables)

            tmp80 = try vm67cc18(magic: 0x12000004ffb, src1: t2e, src2: t1c, tables: tables)
            tmp58 = try vm67cc18(magic: 0x120000032ca, src1: tmp34First, src2: tmp80, tables: tables)

            tmp22 = try vm67cc18(magic: 0x12000000d08, src1: s0, src2: s1, tables: tables)
            let tmp34 = try vm67cc18(magic: 0x120000019b6, src1: s0, src2: s2, tables: tables)
            let t2eSecond = try vm67cc18(magic: 0x12000004352, src1: s1, src2: s2, tables: tables)
            let t1cSecond = try vm67cc18(magic: 0x12000000f5f, src1: tmp22, src2: tmp34, tables: tables)
            tmp80 = try vm67cc18(magic: 0x12000004010, src1: t2eSecond, src2: t1cSecond, tables: tables)
            let tmpa4 = try vm67cc18(magic: 0x120000035d7, src1: tmp58, src2: tmp80, tables: tables)

            let newS7 = try vm67cc18(magic: 0x12000003bc0, src1: s6, src2: s6, tables: tables)
            let newS6 = try vm67cc18(magic: 0x120000042aa, src1: s5, src2: s5, tables: tables)
            let newS5 = try vm67cc18(magic: 0x120000042bc, src1: s4, src2: s4, tables: tables)
            let newS4 = try vm67cc18(magic: 0x12000006050, src1: s3, src2: tmp92, tables: tables)
            let newS3 = try vm67cc18(magic: 0x120000047c5, src1: s2, src2: s2, tables: tables)
            let newS2 = try vm67cc18(magic: 0x12000004e83, src1: s1, src2: s1, tables: tables)
            let newS1 = try vm67cc18(magic: 0x120000055c9, src1: s0, src2: s0, tables: tables)
            let newS0 = try vm67cc18(magic: 0x12000002088, src1: tmp92, src2: tmpa4, tables: tables)

            s0 = newS0
            s1 = newS1
            s2 = newS2
            s3 = newS3
            s4 = newS4
            s5 = newS5
            s6 = newS6
            s7 = newS7
        }

        var out: [UInt8] = []
        out.reserveCapacity(df80StateSize)
        out.append(contentsOf: try vm67cc18(magic: 0x12000001eb4, src1: original[0], src2: s0, tables: tables))
        out.append(contentsOf: try vm67cc18(magic: 0x12000005b5b, src1: original[1], src2: s1, tables: tables))
        out.append(contentsOf: try vm67cc18(magic: 0x120000042e6, src1: original[2], src2: s2, tables: tables))
        out.append(contentsOf: try vm67cc18(magic: 0x12000000b94, src1: original[3], src2: s3, tables: tables))
        out.append(contentsOf: try vm67cc18(magic: 0x1200000383a, src1: original[4], src2: s4, tables: tables))
        out.append(contentsOf: try vm67cc18(magic: 0x12000003581, src1: original[5], src2: s5, tables: tables))
        out.append(contentsOf: try vm67cc18(magic: 0x12000004dea, src1: original[6], src2: s6, tables: tables))
        out.append(contentsOf: try vm67cc18(magic: 0x12000000dd8, src1: original[7], src2: s7, tables: tables))
        return Data(out)
    }

    public static func df80ExpandedSchedule(initialWorkspace: Data) throws -> Data {
        guard initialWorkspace.count == df80InitialWorkspaceSize else {
            throw FirstPairSourceSliceError.invalidDF80WorkspaceLength(initialWorkspace.count)
        }
        let tables = try cachedTables.get()
        var schedule = [UInt8](initialWorkspace) + [UInt8](repeating: 0, count: df80DerivedScheduleSize)

        for offset in stride(from: 0, to: df80DerivedScheduleSize, by: df80WordSize) {
            let w0 = Array(schedule[offset..<(offset + df80WordSize)])
            let w1 = Array(schedule[(offset + 0x12)..<(offset + 0x24)])
            let w9 = Array(schedule[(offset + 0xa2)..<(offset + 0xb4)])
            let w14 = Array(schedule[(offset + 0xfc)..<(offset + 0x10e)])

            var tmp22 = try vm67cecc(magic: 0x2400900240463c, src1: w14, src2: w14, tables: tables)
            var tmp80 = try vm67cc18(magic: 0x12000005af5, src1: w14, src2: w14, tables: tables)
            var tmp58 = try packDF80Zeros6Marker(0x06, src: tmp80)
            var tmp34 = try vm67cc18(magic: 0x12000005ddf, src1: tmp58, src2: tmp58, tables: tables)
            var tmpa4 = try vm67cc18(magic: 0x12000000523, src1: tmp34, src2: tmp22, tables: tables)

            tmp22 = try vm67cecc(magic: 0x2800800280004a, src1: w14, src2: w14, tables: tables)
            tmp80 = try vm67cc18(magic: 0x12000002717, src1: w14, src2: w14, tables: tables)
            tmp58 = try packDF80Zeros5Marker6(src: tmp80)
            tmp34 = try vm67cc18(magic: 0x1200000304e, src1: tmp58, src2: tmp58, tables: tables)
            tmp58 = try vm67cc18(magic: 0x120000016d7, src1: tmp34, src2: tmp22, tables: tables)

            tmp80 = try vm67cecc(magic: 0x1400d001403ea3, src1: w14, src2: w14, tables: tables)
            tmp22 = try vm67cc18(magic: 0x120000037a4, src1: tmpa4, src2: tmp58, tables: tables)
            let tmp92 = try vm67cc18(magic: 0x120000034f0, src1: tmp80, src2: tmp22, tables: tables)
            tmpa4 = try vm67cc18(magic: 0x1200000050b, src1: tmp92, src2: w9, tables: tables)

            tmp22 = try vm67cecc(magic: 0x1000e0010042f8, src1: w1, src2: w1, tables: tables)
            tmp80 = try vm67cc18(magic: 0x12000000251, src1: w1, src2: w1, tables: tables)
            tmp58 = try packDF80Zeros11Marker5(src: tmp80)
            tmp34 = try vm67cc18(magic: 0x12000005e68, src1: tmp58, src2: tmp58, tables: tables)
            let tmp118 = try vm67cc18(magic: 0x12000004120, src1: tmp34, src2: tmp22, tables: tables)

            tmp80 = try vm67cecc(magic: 0x24009002402391, src1: w1, src2: w1, tables: tables)
            tmp58 = try packDF80Zeros6Marker(0x07, src: w1)
            tmp22 = try vm67cc18(magic: 0x12000000da4, src1: tmp58, src2: tmp58, tables: tables)
            tmp34 = try vm67cc18(magic: 0x12000003e91, src1: tmp22, src2: tmp80, tables: tables)

            tmp80 = try vm67cecc(magic: 0x08010000802f7e, src1: w1, src2: w1, tables: tables)
            tmp22 = try vm67cc18(magic: 0x120000041ea, src1: tmp118, src2: tmp34, tables: tables)
            tmp58 = try vm67cc18(magic: 0x12000000846, src1: tmp80, src2: tmp22, tables: tables)
            tmp80 = try vm67cc18(magic: 0x120000019ea, src1: tmp58, src2: w0, tables: tables)
            let derived = try vm67cc18(magic: 0x12000003ac8, src1: tmpa4, src2: tmp80, tables: tables)
            replace(&schedule, at: offset + df80InitialWorkspaceSize, with: derived)
        }

        return Data(schedule)
    }

    public static func df80InitialWorkspace(blocks: Data) throws -> Data {
        guard blocks.count == df80InputBlockCount * block66Size else {
            throw FirstPairSourceSliceError.invalidDF80BlockLength(blocks.count)
        }
        let tables = try cachedTables.get()
        let blockBytes = [UInt8](blocks)
        var workspace = [UInt8](repeating: 0, count: df80InitialWorkspaceSize)

        for index in 0..<df80InputBlockCount {
            let start = index * block66Size
            let dst = index * df80InitialWorkspaceStride
            let src = Array(blockBytes[start..<(start + block66Size)])
            let sideA = try vm67cc18(magic: 0x22000002444, src1: src, src2: src, tables: tables)
            let sideB = try vm67cecc(magic: 0x22008004942, src1: src, src2: src, tables: tables)

            replace(
                &workspace,
                at: dst + 0x36,
                with: try vm67cc18(magic: 0x12000000dea, src1: sideA, src2: sideA, tables: tables)
            )
            replace(
                &workspace,
                at: dst + 0x24,
                with: try vm67cecc(magic: 0x12004003dcd, src1: sideA, src2: sideA, tables: tables)
            )
            replace(
                &workspace,
                at: dst + 0x12,
                with: try vm67cc18(magic: 0x120000052bb, src1: sideB, src2: sideB, tables: tables)
            )
            replace(
                &workspace,
                at: dst,
                with: try vm67cecc(magic: 0x12004003d69, src1: sideB, src2: sideB, tables: tables)
            )
        }

        return Data(workspace)
    }

    public static func final679f48LengthBlock(contextLength: Int) throws -> Data {
        guard contextLength >= 0 else {
            throw FirstPairSourceSliceError.invalidContextLength(contextLength)
        }
        let tables = try cachedTables.get()
        let bitLength = UInt64(contextLength) << 3
        let sideA = try expandU64Trits(bitLength, tableOffset: 0, tables: tables)
        let sideB = try expandU64Trits(bitLength, tableOffset: 0x300, tables: tables)

        let foldedA = try fold48To34(firstMagic: 0x600000051d, tailMagic: 0x6000002556, src48: sideA, tables: tables)
        let laneA = try vm67cecc(magic: 0x800220000010a1, src1: foldedA, src2: foldedA, tables: tables)

        let foldedB = try fold48To34(firstMagic: 0x60000018af, tailMagic: 0x6000005ee6, src48: sideB, tables: tables)
        let laneB = try vm67cecc(magic: 0x80022000004224, src1: foldedB, src2: foldedB, tables: tables)

        let mixed = try vm67cc18(magic: 0x420000007c0, src1: laneA, src2: laneB, tables: tables)
        return Data(try vm67d524(magic: 0xc03f000c0192f, src: mixed, tables: tables))
    }

    public static func phase5RawKeyFrom67cc18Sources(
        sourceChunks: Data,
        offset: Int = 0
    ) throws -> Data {
        let source = try deriveFrom67cc18Sources(sourceChunks: sourceChunks, offset: offset, length: 0x10)
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFrom67a960Inputs(
        src1: Data,
        src2: Data,
        offset: Int = 0
    ) throws -> Data {
        let source = try deriveFrom67a960Inputs(src1: src1, src2: src2, offset: offset, length: 0x10)
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFromFinalized679f48Context(
        _ context: Data,
        offset: Int = 0
    ) throws -> Data {
        let source = try deriveFromFinalized679f48Context(context, offset: offset, length: 0x10)
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFrom64de54EncodedBlocks(
        encodedBlocks: Data,
        offset: Int = 0
    ) throws -> Data {
        let source = try derive64de54Slice(encodedBlocks: encodedBlocks, offset: offset, length: 0x10)
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFrom6388f0ScheduleLen32Streams(
        firstScheduleWords: [UInt32],
        secondScheduleWords: [UInt32],
        offset: Int = 0
    ) throws -> Data {
        let source = try deriveFrom6388f0ScheduleLen32Streams(
            firstScheduleWords: firstScheduleWords,
            secondScheduleWords: secondScheduleWords,
            offset: offset,
            length: 0x10
        )
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFrom63c278ScheduleInputs(
        arg0: Data,
        firstArg1: Data,
        firstArg2: Data,
        secondArg1: Data,
        secondArg2: Data,
        scalar: UInt64,
        offset: Int = 0
    ) throws -> Data {
        let source = try deriveFrom63c278ScheduleInputs(
            arg0: arg0,
            firstArg1: firstArg1,
            firstArg2: firstArg2,
            secondArg1: secondArg1,
            secondArg2: secondArg2,
            scalar: scalar,
            offset: offset,
            length: 0x10
        )
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFromPre63c278ScheduleInputs(
        firstArg1: Data,
        firstArg2: Data,
        secondArg1: Data,
        secondArg2: Data,
        offset: Int = 0
    ) throws -> Data {
        let source = try deriveFromPre63c278ScheduleInputs(
            firstArg1: firstArg1,
            firstArg2: firstArg2,
            secondArg1: secondArg1,
            secondArg2: secondArg2,
            offset: offset,
            length: 0x10
        )
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFrom6388f0SeededCaller64Rows(
        rows: [Builder6388f0SeededCaller64Row],
        offset: Int = 0
    ) throws -> Data {
        let source = try deriveFrom6388f0SeededCaller64Rows(
            rows: rows,
            offset: offset,
            length: 0x10
        )
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFrom6388f0SeededCaller64Rows(
        rows: [Builder6388f0SeededCaller64Row],
        arg0: Data,
        scalar: UInt64,
        offset: Int = 0
    ) throws -> Data {
        let source = try deriveFrom6388f0SeededCaller64Rows(
            rows: rows,
            arg0: arg0,
            scalar: scalar,
            offset: offset,
            length: 0x10
        )
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFrom6388f0FirstPairStreamSeeds(
        seeds: Builder6388f0FirstPairStreamSeeds,
        offset: Int = 0
    ) throws -> Data {
        let source = try deriveFrom6388f0FirstPairStreamSeeds(
            seeds: seeds,
            offset: offset,
            length: 0x10
        )
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFrom6388f0FirstPairStreamSeeds(
        seeds: Builder6388f0FirstPairStreamSeeds,
        arg0: Data,
        scalar: UInt64,
        offset: Int = 0
    ) throws -> Data {
        let source = try deriveFrom6388f0FirstPairStreamSeeds(
            seeds: seeds,
            arg0: arg0,
            scalar: scalar,
            offset: offset,
            length: 0x10
        )
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFrom6388f0FirstPairEntropyAndSensorPoints(
        entrySource: Data,
        nullEntropy11A: Data,
        row0SensorPointXYBE: Data,
        row59SensorPointXYBE: Data,
        offset: Int = 0
    ) throws -> Data {
        let source = try deriveFrom6388f0FirstPairEntropyAndSensorPoints(
            entrySource: entrySource,
            nullEntropy11A: nullEntropy11A,
            row0SensorPointXYBE: row0SensorPointXYBE,
            row59SensorPointXYBE: row59SensorPointXYBE,
            offset: offset,
            length: 0x10
        )
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func phase5RawKeyFrom6388f0FirstPairEntropySourceAndSensorPoints(
        entrySource: Data,
        row0SensorPointXYBE: Data,
        row59SensorPointXYBE: Data,
        maxAttempts: Int = 64,
        offset: Int = 0,
        entropySource: (Int) throws -> Data
    ) throws -> Data {
        let source = try deriveFrom6388f0FirstPairEntropySourceAndSensorPoints(
            entrySource: entrySource,
            row0SensorPointXYBE: row0SensorPointXYBE,
            row59SensorPointXYBE: row59SensorPointXYBE,
            maxAttempts: maxAttempts,
            offset: offset,
            length: 0x10,
            entropySource: entropySource
        )
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func deriveFrom67cc18Sources(
        sourceChunks: Data,
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        guard sourceChunks.count % block66Size == 0 else {
            throw FirstPairSourceSliceError.invalidEncodedBlockLength(sourceChunks.count)
        }
        let tables = try cachedTables.get()
        let source = [UInt8](sourceChunks)
        var encoded: [UInt8] = []
        encoded.reserveCapacity(source.count)
        for start in stride(from: 0, to: source.count, by: block66Size) {
            let chunk = Array(source[start..<(start + block66Size)])
            encoded.append(contentsOf: try vm67cc18(magic: 0x420000059c9, src1: chunk, src2: chunk, tables: tables))
        }
        return try derive64de54Slice(encodedBlocks: Data(encoded), offset: offset, length: length)
    }

    public static func deriveFrom67a960Inputs(
        src1: Data,
        src2: Data,
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        guard src1.count == scratch130Size, src2.count == scratch130Size else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "67a960 sources",
                min(src1.count, src2.count),
                scratch130Size
            )
        }
        let tables = try cachedTables.get()
        let source67a978 = try vm67cc18(
            magic: 0x1c0012000003b1c,
            src1: [UInt8](src1),
            src2: [UInt8](src2),
            tables: tables
        )
        return try deriveFrom67a978Source(source: Data(source67a978), offset: offset, length: length)
    }

    public static func deriveFromFinalized679f48Context(
        _ context: Data,
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        guard context.count >= context679f48Size else {
            throw FirstPairSourceSliceError.sourceTooShort("679f48 context", context.count, context679f48Size)
        }
        let tables = try cachedTables.get()
        let (src1, src2) = try postDF80_67a960Inputs(context: [UInt8](context), tables: tables)
        return try deriveFrom67a960Inputs(src1: Data(src1), src2: Data(src2), offset: offset, length: length)
    }

    public static func deriveFrom67a978Source(
        source: Data,
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        guard source.count == scratch130Size else {
            throw FirstPairSourceSliceError.sourceTooShort("67a978 source", source.count, scratch130Size)
        }
        let tables = try cachedTables.get()
        let source67a990 = try vm67cc18(
            magic: 0x82000000477,
            src1: [UInt8](source),
            src2: [UInt8](source),
            tables: tables
        )
        return try deriveFrom67a990Source(source: Data(source67a990), offset: offset, length: length)
    }

    public static func deriveFrom67a990Source(
        source: Data,
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        guard source.count == scratch130Size else {
            throw FirstPairSourceSliceError.sourceTooShort("67a990 source", source.count, scratch130Size)
        }
        let tables = try cachedTables.get()
        let window = try vm67cc18(
            magic: 0x82000003c2d,
            src1: [UInt8](source),
            src2: [UInt8](source),
            tables: tables
        )
        let chunks = try final67cc18Sources(fromOverlapWindow: window, tables: tables)
        return try deriveFrom67cc18Sources(sourceChunks: Data(chunks), offset: offset, length: length)
    }

    public static func derive64de54Slice(
        encodedBlocks: Data,
        offset: Int = 0,
        length: Int = 0x10
    ) throws -> Data {
        guard offset >= 0, length >= 0 else {
            throw FirstPairSourceSliceError.invalidSlice(offset: offset, length: length)
        }
        guard encodedBlocks.count % block66Size == 0 else {
            throw FirstPairSourceSliceError.invalidEncodedBlockLength(encodedBlocks.count)
        }

        let tables = try cachedTables.get()
        let source = [UInt8](encodedBlocks)
        var sourceBlocks: [[UInt8]] = []
        sourceBlocks.reserveCapacity(source.count / block66Size)
        for start in stride(from: 0, to: source.count, by: block66Size) {
            sourceBlocks.append(Array(source[start..<(start + block66Size)]))
        }
        if sourceBlocks.isEmpty && length > 0 {
            throw FirstPairSourceSliceError.emptySource
        }

        let expanded = try sourceBlocks.map {
            try vm64e2b8(magic: 0x42000000106, src1: $0, src2: $0, tables: tables)
        }

        let startBlock = offset >> 4
        let lowNibble = offset & 0x0f
        let outBlocks = (length + 0x0f) >> 4
        var stageBlocks: [[UInt8]] = []
        stageBlocks.reserveCapacity(outBlocks)

        for outIndex in 0..<outBlocks {
            let idx = startBlock + outIndex
            guard idx < expanded.count else {
                throw FirstPairSourceSliceError.sliceStartsPastSource(idx)
            }

            let scratchSrc2 = shiftedScratch(expanded[idx])
            let scratch: [UInt8]
            if idx + 1 < expanded.count {
                var src1 = expanded[idx + 1]
                src1.append(contentsOf: repeatElement(0, count: 64))
                scratch = try vm64e2b8(
                    magic: 0x100042000000148,
                    src1: src1,
                    src2: scratchSrc2,
                    tables: tables
                )
            } else {
                scratch = try vm64e2b8(
                    magic: 0x82000000084,
                    src1: scratchSrc2,
                    src2: scratchSrc2,
                    tables: tables
                )
            }

            var shifted = scratch
            for _ in 0..<(16 - lowNibble) {
                shifted = try vm64e17c(src0: shifted, src1: shifted, tables: tables)
            }
            stageBlocks.append(
                try vm64e2b8(magic: 0x42000000000, src1: shifted, src2: shifted, tables: tables)
            )
        }

        var out: [UInt8] = []
        out.reserveCapacity(stageBlocks.count * block66Size)
        for block in stageBlocks {
            out.append(contentsOf: try vm64e2b8(magic: 0x42000000042, src1: block, src2: block, tables: tables))
        }
        return Data(out)
    }

    private static func final67cc18Sources(fromOverlapWindow window: [UInt8], tables: SourceTables) throws -> [UInt8] {
        try require(window, count: scratch130Size, label: "67a990 overlap window")
        let firstSrc = Array(window[0x40..<(0x40 + block66Size)])
        let secondSrc = Array(window[0..<block66Size])
        var out = try vm67cc18(magic: 0x420000054c3, src1: firstSrc, src2: firstSrc, tables: tables)
        out.append(contentsOf: try vm67cc18(magic: 0x420000054c3, src1: secondSrc, src2: secondSrc, tables: tables))
        return out
    }

    private static func postDF80_67a960Inputs(
        context: [UInt8],
        tables: SourceTables
    ) throws -> (src1: [UInt8], src2: [UInt8]) {
        try require(context, count: context679f48Size, label: "679f48 context")
        let state = Array(context[0x114..<0x1a4])

        var buf3b0 = [UInt8](repeating: 0, count: scratch130Size)
        var buf320 = [UInt8](repeating: 0, count: scratch130Size)
        var buf3e = [UInt8](repeating: 0, count: scratch130Size)
        var bufd = [UInt8](repeating: 0, count: scratch130Size)

        buf3b0[15] = 6
        replace(&buf3b0, at: 16, with: Array(state[0x5a..<0x6c]))
        replace(
            &buf3e,
            at: 0,
            with: try vm67cc18(
                magic: 0x40012000002ba3,
                src1: Array(context[0x180..<(0x180 + 34)]),
                src2: Array(buf3b0[0..<34]),
                tables: tables
            )
        )

        buf320[15] = 6
        replace(&buf320, at: 16, with: Array(state[0x36..<0x48]))
        replace(
            &buf3b0,
            at: 0x20,
            with: try vm67cc18(
                magic: 0x4001200000255c,
                src1: Array(context[0x15c..<(0x15c + 34)]),
                src2: Array(buf320[0..<34]),
                tables: tables
            )
        )

        replace(&buf3b0, at: 0, with: [UInt8](repeating: 0, count: 31))
        buf3b0[31] = 7
        replace(
            &bufd,
            at: 0,
            with: try vm67cc18(
                magic: 0x80022000000ca2,
                src1: Array(buf3e[0..<66]),
                src2: Array(buf3b0[0..<66]),
                tables: tables
            )
        )

        replace(&buf3b0, at: 0, with: [UInt8](repeating: 0, count: 16))
        replace(&buf3b0, at: 16, with: Array(state[0x12..<0x24]))
        replace(
            &buf3e,
            at: 0,
            with: try vm67cc18(
                magic: 0x40012000005f0e,
                src1: Array(context[0x138..<(0x138 + 34)]),
                src2: Array(buf3b0[0..<34]),
                tables: tables
            )
        )

        replace(&buf3b0, at: 0, with: [UInt8](repeating: 0, count: 31))
        buf3b0[31] = 7
        replace(&buf3b0, at: 32, with: Array(state[0..<0x12]))
        replace(
            &buf320,
            at: 0x40,
            with: try vm67cc18(
                magic: 0x400220000013d9,
                src1: Array(buf3e[0..<50]),
                src2: Array(buf3b0[0..<50]),
                tables: tables
            )
        )

        replace(&buf320, at: 0, with: [UInt8](repeating: 0, count: 0x40))
        replace(
            &buf3b0,
            at: 0x10,
            with: try vm67cc18(
                magic: 0xc00420000016e9,
                src1: Array(bufd[0..<114]),
                src2: Array(buf320[0..<114]),
                tables: tables
            )
        )
        replace(&buf3b0, at: 0, with: [UInt8](repeating: 0, count: 15))
        buf3b0[15] = 1

        var src1 = Array(context[0x192..<0x1a4])
        src1.append(contentsOf: repeatElement(0, count: 112))
        return (src1, buf3b0)
    }

    private static func replace(_ dst: inout [UInt8], at offset: Int, with src: [UInt8]) {
        for i in src.indices {
            dst[offset + i] = src[i]
        }
    }

    private static func checkedReplace(_ dst: inout [UInt8], at offset: Int, with src: [UInt8]) throws {
        guard offset >= 0, offset + src.count <= dst.count else {
            throw FirstPairSourceSliceError.invalidSlice(offset: offset, length: src.count)
        }
        replace(&dst, at: offset, with: src)
    }

    private static func seed67aa8cInitialWords(context: inout [UInt8], tables: SourceTables) throws {
        for spec in aa8cInitialReducerSpecs {
            let window = Array(context[spec.srcOffset..<(spec.srcOffset + df80WordSize)])
            let reduced = try reducer67ea28Word(
                try vm67cecc(magic: spec.magic, src1: window, src2: window, tables: tables),
                tables: tables
            )
            replace(&context, at: spec.dstOffset, with: reduced)
        }
    }

    private static func reducer67ea28Word(_ src: [UInt8], tables: SourceTables) throws -> [UInt8] {
        let tmp18 = try vm67cc18(magic: 0x120000048e2, src1: src, src2: src, tables: tables)
        var state18 = try vm67d524(magic: 0xc00f000c0578e, src: tmp18, tables: tables)

        var packed: UInt32 = 0
        var outShift: UInt32 = 0
        var bitBudget = 0x20
        for roundIndex in 0..<8 {
            let scratch4 = try vm67cc18(magic: 0x40000033d7, src1: state18, src2: state18, tables: tables)
            if bitBudget >= 5 {
                state18 = try vm67cecc(magic: 0x8010000805f94, src1: state18, src2: state18, tables: tables)
            }

            let tmp4 = try vm67cc18(magic: 0x4000004513, src1: scratch4, src2: scratch4, tables: tables)
            let tableIndex = Int(tmp4[2]) ^ (Int(tmp4[3]) << 3)
            guard tableIndex < tables.reducer67ea28Nibble.count else {
                throw FirstPairSourceSliceError.tableReadOutOfBounds(
                    RuntimeTable.firstPairReducer67ea28Nibble.rawValue,
                    tableIndex
                )
            }
            let tableByte = tables.reducer67ea28Nibble[tableIndex]
            let nibble = (roundIndex & 1) == 0 ? UInt32(tableByte & 0x0f) : UInt32(tableByte >> 4)

            let mask: UInt32
            if bitBudget >= 4 {
                mask = UInt32.max
                bitBudget -= 4
            } else {
                mask = bitBudget == 0 ? 0 : UInt32((1 << bitBudget) - 1)
                bitBudget = 0
            }

            packed |= (nibble & mask) << outShift
            outShift += 4
        }

        return [
            UInt8(packed & 0xff),
            UInt8((packed >> 8) & 0xff),
            UInt8((packed >> 16) & 0xff),
            UInt8((packed >> 24) & 0xff),
        ]
    }

    private static func update67eb94Blocks(wordsLE: [[UInt8]], tables: SourceTables) throws -> [UInt8] {
        guard wordsLE.count == 8 else {
            throw FirstPairSourceSliceError.sourceTooShort("67eb94 words", wordsLE.count, 8)
        }

        var blocks: [UInt8] = []
        blocks.reserveCapacity(df80StateSize)
        for (word, magic) in zip(wordsLE, eb94UpdateMagics) {
            let expanded = try expand67ed24(wordLE: word, tables: tables)
            blocks.append(contentsOf: try vm67cc18(magic: magic, src1: expanded, src2: expanded, tables: tables))
        }
        return blocks
    }

    private static func constructor67076cBlocks(rawDescriptorBlocks: Data, magic: UInt64) throws -> Data {
        guard rawDescriptorBlocks.count % block66Size == 0 else {
            throw FirstPairSourceSliceError.invalidEncodedBlockLength(rawDescriptorBlocks.count)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](rawDescriptorBlocks)
        var out: [UInt8] = []
        out.reserveCapacity(rawDescriptorBlocks.count)
        for start in stride(from: 0, to: bytes.count, by: block66Size) {
            let block = Array(bytes[start..<(start + block66Size)])
            out.append(contentsOf: try vm67076c(magic: magic, src1: block, src2: block, tables: tables))
        }
        return Data(out)
    }

    private static func expand67ed24(wordLE: [UInt8], tables: SourceTables) throws -> [UInt8] {
        try require(wordLE, count: 4, label: "67ed24 word")
        let sideA = try expandWordTrits(wordLE, tableOffset: expand67ed24AOffset, tables: tables)
        let sideB = try expandWordTrits(wordLE, tableOffset: expand67ed24BOffset, tables: tables)

        let foldedA = try fold24To18(firstMagic: 0x600000133b, tailMagic: 0x6000003479, src24: sideA, tables: tables)
        let wideA = try vm67cecc(magic: 0x40012000000028, src1: foldedA, src2: foldedA, tables: tables)

        let foldedB = try fold24To18(firstMagic: 0x6000004936, tailMagic: 0x6000000000, src24: sideB, tables: tables)
        let wideB = try vm67cecc(magic: 0x40012000004683, src1: foldedB, src2: foldedB, tables: tables)

        let mixed = try vm67cc18(magic: 0x22000004d74, src1: wideA, src2: wideB, tables: tables)
        return try vm67d524(magic: 0xc01f000c05d34, src: mixed, tables: tables)
    }

    private static func expandWordTrits(
        _ wordLE: [UInt8],
        tableOffset: Int,
        tables: SourceTables
    ) throws -> [UInt8] {
        try require(wordLE, count: 4, label: "67ed24 word")
        var out: [UInt8] = []
        out.reserveCapacity(24)
        for byte in wordLE[0..<4] {
            let index = tableOffset + Int(byte) * 3
            let packed = try checkedSlice(
                tables.finalizerTables,
                index,
                3,
                RuntimeTable.firstPairFinalizerTables.rawValue
            )
            for value in packed {
                out.append(value & 7)
                out.append(value >> 3)
            }
        }
        return out
    }

    private static func fold24To18(
        firstMagic: UInt64,
        tailMagic: UInt64,
        src24: [UInt8],
        tables: SourceTables
    ) throws -> [UInt8] {
        try require(src24, count: 24, label: "67ed24 fold source")
        var out = try vm67cc18(magic: firstMagic, src1: src24, src2: src24, tables: tables)
        var tail: [UInt8] = []
        tail.reserveCapacity(18)
        for offset in stride(from: 6, through: 18, by: 6) {
            let src = Array(src24[offset..<src24.count])
            tail.append(contentsOf: try vm67cc18(magic: tailMagic, src1: src, src2: src, tables: tables))
        }
        out.append(contentsOf: tail[2..<6])
        out.append(contentsOf: tail[8..<12])
        out.append(contentsOf: tail[14..<18])
        return out
    }

    private static func expandRawByte67d630(
        _ byte: UInt8,
        tableOffset: Int,
        tables: SourceTables
    ) throws -> [UInt8] {
        let index = tableOffset + Int(byte) * 3
        let packed = try checkedSlice(
            tables.seedTables679f48,
            index,
            3,
            RuntimeTable.firstPair679f48SeedTables.rawValue
        )
        var out: [UInt8] = []
        out.reserveCapacity(6)
        for value in packed {
            out.append(value & 7)
            out.append(value >> 3)
        }
        return out
    }

    private static func fold96To66(
        firstMagic: UInt64,
        tailMagic: UInt64,
        src96: [UInt8],
        tables: SourceTables
    ) throws -> [UInt8] {
        try require(src96, count: 0x60, label: "67d630 fold source")
        let padded = src96 + [UInt8](repeating: 0, count: 0x60)
        let first = try vm67cc18(
            magic: firstMagic,
            src1: Array(padded[0..<0x60]),
            src2: Array(padded[0..<0x60]),
            tables: tables
        )
        var out = Array(first[0..<6])
        for offset in stride(from: 6, to: 0x60, by: 6) {
            let src = Array(padded[offset..<(offset + 0x60)])
            let chunk = try vm67cc18(magic: tailMagic, src1: src, src2: src, tables: tables)
            out.append(contentsOf: chunk[2..<6])
        }
        return out
    }

    private static func shift67dd7cRemainder(_ block66: [UInt8], tables: SourceTables) throws -> [UInt8] {
        try require(block66, count: block66Size, label: "67dd7c remainder block")
        let shifted = [UInt8]([0, 0, 0, 3]) + Array(block66[0..<0x3e])
        return try vm67cc18(magic: 0x42000001974, src1: shifted, src2: shifted, tables: tables)
    }

    private static func packDF80Zeros6Marker(_ marker: UInt8, src: [UInt8]) throws -> [UInt8] {
        try require(src, count: 11, label: "67df80 pack")
        return [UInt8](repeating: 0, count: 6) + [marker] + Array(src[0..<11])
    }

    private static func packDF80Zeros5Marker6(src: [UInt8]) throws -> [UInt8] {
        try require(src, count: 12, label: "67df80 pack")
        return [UInt8](repeating: 0, count: 5) + [6] + Array(src[0..<12])
    }

    private static func packDF80Zeros11Marker5(src: [UInt8]) throws -> [UInt8] {
        try require(src, count: 6, label: "67df80 pack")
        return [UInt8](repeating: 0, count: 11) + [5] + Array(src[0..<6])
    }

    private static func packDF80Zeros12Marker3(src: [UInt8]) throws -> [UInt8] {
        try require(src, count: 5, label: "67df80 pack")
        return [UInt8](repeating: 0, count: 12) + [3] + Array(src[0..<5])
    }

    private static func packDF80Zeros8Zero6(src: [UInt8]) throws -> [UInt8] {
        try require(src, count: 8, label: "67df80 pack")
        return [UInt8](repeating: 0, count: 9) + [6] + Array(src[0..<8])
    }

    private static func packDF80Zeros2Marker6(src: [UInt8]) throws -> [UInt8] {
        try require(src, count: 15, label: "67df80 pack")
        return [0, 0, 6] + Array(src[0..<15])
    }

    private static func packDF80Zeros14Marker1(src: [UInt8]) throws -> [UInt8] {
        try require(src, count: 3, label: "67df80 pack")
        return [UInt8](repeating: 0, count: 14) + [1] + Array(src[0..<3])
    }

    private static func packDF80Zeros9(src: [UInt8]) throws -> [UInt8] {
        try require(src, count: 9, label: "67df80 pack")
        return [UInt8](repeating: 0, count: 9) + Array(src[0..<9])
    }

    private static func packDF80Zeros4Marker3(src: [UInt8]) throws -> [UInt8] {
        try require(src, count: 13, label: "67df80 pack")
        return [UInt8](repeating: 0, count: 4) + [3] + Array(src[0..<13])
    }

    private static func builder63c278X1Word(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w0 = try u32Affine63c278(
            word,
            index: index,
            mulTable: 0x115488,
            addTable: 0x121908,
            tables: tables
        )
        let w = (w0 &* 0x30316c9d) &+ 0xe533e221
        var folded = (UInt64(w) &* 0x74ddf8a53c239deb) &+ 0xc98ef94d2aa6d2f9
        folded = try fold63c278(folded, tableOffset: 0x301770, rounds: 8, tables: tables)
        folded = folded &* 0xff444fcf00000000
        return (UInt64(w) &* 0xdda5a8135a0bc9fb) &+ folded &+ 0x8031c96ed30bf85e
    }

    private static func builder63c278X0Word(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w0 = try u32Affine63c278(
            word,
            index: index,
            mulTable: 0x11a9a8,
            addTable: 0x122aa8,
            tables: tables
        )
        let w = (w0 &* 0x707fe555) &+ 0x1d759ee3
        var folded = (UInt64(w) &* 0xc7e623dc4156435d) &+ 0xa7268272249650e4
        folded = try fold63c278(folded, tableOffset: 0x3017f0, rounds: 8, tables: tables)
        folded = folded &* 0xd70f3ef300000000
        return (UInt64(w) &* 0x1defa278095a88b9) &+ folded &+ 0xc8066dafe659e3dd
    }

    private static func builder63c278X2Word(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w0 = try u32Affine63c278(
            word,
            index: index,
            mulTable: 0x11f588,
            addTable: 0x123488,
            tables: tables
        )
        let w = (w0 &* 0xe41d161f) &+ 0xb12fcee1
        var folded = (UInt64(w) &* 0xf3402af2c5c78103) &+ 0x81b5a02882be6230
        folded = try fold63c278(folded, tableOffset: 0x301a70, rounds: 8, tables: tables)
        folded = folded &* 0xc69af5ab00000000
        return (UInt64(w) &* 0x057da4120776f3ff) &+ folded &+ 0x7d7d6bb0e7cd07d3
    }

    private static func builder63c278X0BWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w0 = try u32Affine63c278(
            word,
            index: index,
            mulTable: 0x118f28,
            addTable: 0x118548,
            tables: tables
        )
        let w = (w0 &* 0x4dce977f) &+ 0x7275db64
        var folded = (UInt64(w) &* 0x3125dbf4f55c0c6d) &+ 0x1167036e8591663c
        folded = try fold63c278(folded, tableOffset: 0x301af0, rounds: 8, tables: tables)
        folded = folded &* 0xee1902df00000000
        return (UInt64(w) &* 0x41108caa0013530d) &+ folded &+ 0x2ce8cc914f903207
    }

    private static func builder63c278MixSeed(
        carry: UInt64,
        scalarMul: UInt64,
        scalarAdd: UInt64,
        tables: SourceTables
    ) throws -> (updateMul: UInt64, laneAdd: UInt64) {
        let mixed = (carry &* scalarMul) &+ scalarAdd
        var folded = (mixed &* 0xe56ee0d2dabe3103) &+ 0xe1a57f65c01b39ac
        folded = try fold63c278(folded, tableOffset: 0x301870, rounds: 7, tables: tables)
        folded = folded &* 0x43cf3bc9b0000000
        let seed = (mixed &* 0x47b2ca50a9011f2f) &+ folded &+ 0xa9ccf36f06c69525
        return (
            (seed &* 0x707f1c911d72472d) &+ 0x20d7bce79675ce2e,
            (seed &* 0x62d17dd555b3e7b5) &+ 0xa95e929c3eca7e5e
        )
    }

    private static func builder63c278NextCarry(
        updatedFirst: UInt64,
        updatedSecond: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        var folded = (updatedFirst &* 0x500a38540d22b25b) &+ 0xae9b83bb74900f1e
        folded = try fold63c278(folded, tableOffset: 0x3018f0, rounds: 7, tables: tables)
        let carryMix = (folded &* 0x6e12b4b0721da33b) &+ 0x15fb45ff71081e4e
        var folded2 = (carryMix &* 0xb926d0a2f88df903) &+ 0x0931eca912f88a4c7
        folded2 = try fold63c278(folded2, tableOffset: 0x301970, rounds: 9, tables: tables)
        folded2 = folded2 &* 0x30cbc3f000000000
        let mixed2 = (carryMix &* 0x025241c2cd0d8443) &+ folded2
        return (mixed2 &* 0x8074fb50d5400883) &+ updatedSecond &+ 0x9a2a45734b3e5fb0
    }

    private static func builder63c278Mix2Seed(
        carry: UInt64,
        scalarMul: UInt64,
        scalarAdd: UInt64,
        tables: SourceTables
    ) throws -> (updateMul: UInt64, laneAdd: UInt64) {
        let mixed = (carry &* scalarMul) &+ scalarAdd
        var folded = (mixed &* 0x126e65dcb0b83de1) &+ 0x5454202b530d9481
        folded = try fold63c278(folded, tableOffset: 0x301b70, rounds: 7, tables: tables)
        folded = folded &* 0x3d2ffccf90000000
        let seed = (mixed &* 0x4c89449a165d8427) &+ folded &+ 0x654ba76b767a427c
        return (
            (seed &* 0x564d78f55b5eefab) &+ 0xf24aa781d14548f5,
            (seed &* 0xeb7cfc7c768d163c) &+ 0x09afd4171a0c7a44
        )
    }

    private static func builder63c278NextCarry2(
        updatedFirst: UInt64,
        updatedSecond: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        var folded = (updatedFirst &* 0xbca4dd7019310b05) &+ 0x088f442397943c2a
        folded = try fold63c278(folded, tableOffset: 0x301bf0, rounds: 7, tables: tables)
        let carryMix = (folded &* 0x727c48215454885b) &+ 0xcaf590adfa7e603b
        var folded2 = (carryMix &* 0xfb3565409b501139) &+ 0x74b39dd74e3ac2ed
        folded2 = try fold63c278(folded2, tableOffset: 0x301c70, rounds: 9, tables: tables)
        folded2 = folded2 &* 0x0081c49000000000
        let mixed2 = (carryMix &* 0xf4d598a4fa80dabf) &+ folded2
        return (mixed2 &* 0x0d5f48e79ddef1c9) &+ updatedSecond &+ 0x9506d95873fe6ec8
    }

    private static func builder63c278AccumAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w0 = try u32Affine63c278(
            word,
            index: index,
            mulTable: 0x11a9c8,
            addTable: 0x120f28,
            tables: tables
        )
        let w = (w0 &* 0x2545ee53) &+ 0xf74fe193
        var folded = (UInt64(w) &* 0x69289ee9a98801f5) &+ 0x89bfbb0b1b21e854
        folded = try fold63c278(folded, tableOffset: 0x301d70, rounds: 8, tables: tables)
        return (UInt64(w) &* 0x12f7e0136d4dad87)
            &+ (folded &* 0x9917c7f500000000)
            &+ 0xf80d0f670554b0a4
    }

    private static func builder63c278AccumBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w0 = try u32Affine63c278(
            word,
            index: index,
            mulTable: 0x11bbe8,
            addTable: 0x121948,
            tables: tables
        )
        let w = (w0 &* 0x7dd1ecf7) &+ 0xdc8c9dae
        var folded = (UInt64(w) &* 0xf13beb213918d361) &+ 0xa1220647c9883100
        folded = try fold63c278(folded, tableOffset: 0x301df0, rounds: 8, tables: tables)
        return (UInt64(w) &* 0x952e2be9091d60c7)
            &+ (folded &* 0xd89eb2d900000000)
            &+ 0x54e3b2cc004948be
    }

    private static func builder63c278BridgeX0Word(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w0 = try u32Affine63c278(
            word,
            index: index,
            mulTable: 0x11cd88,
            addTable: 0x112e48,
            tables: tables
        )
        let w = (w0 &* 0x1c8f15cf) &+ 0x05d1107b
        var folded = (UInt64(w) &* 0x19d189b1be9d480b) &+ 0xd2bafb34c1909b26
        folded = try fold63c278(folded, tableOffset: 0x301e70, rounds: 8, tables: tables)
        folded = folded &* 0x2ece929d00000000
        return (UInt64(w) &* 0x7529d4f2739a8b41) &+ folded &+ 0xdb7158ce45fcb750
    }

    private static func builder63c278BridgeMixSeed(
        carry: UInt64,
        scalarMul: UInt64,
        scalarAdd: UInt64,
        tables: SourceTables
    ) throws -> (updateMul: UInt64, laneAdd: UInt64) {
        let mixed = (carry &* scalarMul) &+ scalarAdd
        var folded = (mixed &* 0x34af0af1bbce60dd) &+ 0x61b88589a4883d43
        folded = try fold63c278(folded, tableOffset: 0x301ef0, rounds: 7, tables: tables)
        folded = folded &* 0x2da4669430000000
        let seed = (mixed &* 0x8f5055af84d40129) &+ folded &+ 0x7bf63147a7179819
        return (
            (seed &* 0xdb5bb72dd36c07a9) &+ 0x155c3f0a68fbcfe1,
            (seed &* 0x0ee832c1be220ab1) &+ 0xcc246f1fe68886a9
        )
    }

    private static func builder63c278BridgeNextCarry(
        updatedFirst: UInt64,
        updatedSecond: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        var folded = (updatedFirst &* 0x060c229ff67c02fb) &+ 0xab8d83e0c2b70611
        folded = try fold63c278(folded, tableOffset: 0x301f70, rounds: 7, tables: tables)
        let carryMix = (folded &* 0x6a605d1236fbedd7) &+ 0xfd36e0ea31dbe67c
        var folded2 = (carryMix &* 0x57a20a77f75734e1) &+ 0x4cc594baeecf3eca
        folded2 = try fold63c278(folded2, tableOffset: 0x301ff0, rounds: 9, tables: tables)
        folded2 = folded2 &* 0x9c0c689000000000
        let mixed2 = (carryMix &* 0x1e0bc5b08daead97) &+ folded2
        return (mixed2 &* 0x93bd22efcdeacdc3) &+ updatedSecond &+ 0xc175492c1e8124ac
    }

    private static func builder63c278PrebranchSP4F0FoldState(_ state: UInt32, tables: SourceTables) throws -> UInt32 {
        var folded = UInt32((UInt64(state) &* UInt64(0x3dbef531) &+ UInt64(0x554aacd3)) & 0xffff_ffff)
        folded = try fold32ByNibbles63c278(folded, tableOffset: 0x3021f8, rounds: 7, tables: tables)
        let selected = try u32TableWord63c278(0x122ac8 + Int(folded & 7) * 4, tables: tables)
        return selected &+ (folded >> 3)
    }

    private static func builder63c278PrebranchSP4F0State(from word: UInt32, tables: SourceTables) throws -> UInt32 {
        let half = word >> 1
        let bitTable = try u32TableWord63c278(0x126850 + Int(word & 1) * 4, tables: tables)
        return UInt32((UInt64(half) &* UInt64(0x0c949fdb) &+ UInt64(bitTable)) & 0xffff_ffff)
    }

    private struct BranchAffine63c278Params {
        let arg0Mul: UInt32
        let arg0Add: UInt32
        let halfMul: UInt32
        let bitTable: Int
        let preMul: UInt32
        let preAdd: UInt32
        let wordMul: UInt32
        let wordAdd: UInt32
        let foldTable: Int
        let selectTable: Int
        let argMulTable: Int
        let argAddTable: Int
        let carryMul: UInt32
        let valueMul: UInt32
        let nextMul: UInt32
        let loopAdd: UInt32
        let finalAdd: UInt32
        let outMulTable: Int
        let outAddTable: Int
    }

    private struct StageReducerStream63c278 {
        let words: [UInt32]
        let mulTable: Int
    }

    private struct StageReducer63c278Params {
        let carry: UInt32
        let carryMul: UInt32
        let preMul: UInt32
        let preAdd: UInt32
        let foldTable: Int
        let reduceMul: UInt32
        let sideMul: UInt32
        let reduceAdd: UInt32
        let folded7Mul: UInt32
        let folded8Mul: UInt32
        let nextAdd: UInt32
        let outMulTable: Int
        let outAddTable: Int
    }

    private static func builder63c278LoopUpdateSP658Odd(_ words: [UInt32], tables: SourceTables) throws -> [UInt32] {
        try branchAffineUpdate63c278(
            words,
            params: BranchAffine63c278Params(
                arg0Mul: 0x33f71427, arg0Add: 0x58500b33, halfMul: 0x2cb60683,
                bitTable: 0x126a48, preMul: 0xc4fb260b, preAdd: 0xf348f6f7,
                wordMul: 0x2b1d86b1, wordAdd: 0xfa05b11d,
                foldTable: 0x302378, selectTable: 0x112648,
                argMulTable: 0x117ba8, argAddTable: 0x11cde8,
                carryMul: 0xa822376d, valueMul: 0xb8000000, nextMul: 0x30000000,
                loopAdd: 0x24e24246, finalAdd: 0x14e24246,
                outMulTable: 0x1206a8, outAddTable: 0x11b468
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopSP658EvenUsesSuccessPath(
        sp658Words: [UInt32],
        sp6b0Words: [UInt32],
        tables: SourceTables
    ) throws -> Bool {
        for stream in [sp658Words, sp6b0Words] where stream.count != builder63c278VectorWords {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(stream.count)
        }
        for index in stride(from: builder63c278VectorWords - 1, through: 0, by: -1) {
            let tableOffset = (index * 4) & 0x1c
            let check = UInt32(
                (UInt64(sp658Words[index]) &* UInt64(try u32TableWord63c278(0x1154c8 + tableOffset, tables: tables))
                 &+ UInt64(sp6b0Words[index]) &* UInt64(try u32TableWord63c278(0x1172c8 + tableOffset, tables: tables))
                 &+ UInt64(try u32TableWord63c278(0x11c468 + tableOffset, tables: tables))) & 0xffff_ffff
            )
            if check != 0x59262fed {
                let folded = try fold32ByNibbles63c278(check, tableOffset: 0x302478, rounds: 7, tables: tables)
                return (folded & 0x0f) == 0x0d
            }
        }
        return true
    }

    private static func builder63c278LoopUpdateSP658EvenSuccess(
        sp658Words: [UInt32],
        sp6b0Words: [UInt32],
        tables: SourceTables
    ) throws -> [UInt32] {
        try stageReducer63c278(
            staticWords: staticPatternWords63c278(q0: 0x125a70, q1: 0x125940, tail: 0x126ce0, tables: tables),
            streams: [
                StageReducerStream63c278(words: sp658Words, mulTable: 0x11b4c8),
                StageReducerStream63c278(words: sp6b0Words, mulTable: 0x122b08),
            ],
            params: StageReducer63c278Params(
                carry: 0x6238179a, carryMul: 0x2cb31cf5,
                preMul: 0xeaa360b5, preAdd: 0x7dcae1fd,
                foldTable: 0x3025b8, reduceMul: 0x354589c9,
                sideMul: 0xb0000000, reduceAdd: 0xb0b43182,
                folded7Mul: 0x6f16c509, folded8Mul: 0x0e93af70,
                nextAdd: 0x29fd0d1c,
                outMulTable: 0x11d508, outAddTable: 0x123508
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopUpdateSP6B0Even(_ words: [UInt32], tables: SourceTables) throws -> [UInt32] {
        try branchAffineUpdate63c278(
            words,
            params: BranchAffine63c278Params(
                arg0Mul: 0x96928029, arg0Add: 0x666d5b3a, halfMul: 0x27acf74d,
                bitTable: 0x126a18, preMul: 0x84602417, preAdd: 0xf95f2c9d,
                wordMul: 0x4bd20bc9, wordAdd: 0x3a0734ca,
                foldTable: 0x302278, selectTable: 0x11cda8,
                argMulTable: 0x11c428, argAddTable: 0x119748,
                carryMul: 0x96d2d627, valueMul: 0x98000000, nextMul: 0x90000000,
                loopAdd: 0x2f40aa3d, finalAdd: 0x3f40aa3d,
                outMulTable: 0x117b68, outAddTable: 0x121968
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopUpdateSP440Odd(_ words: [UInt32], tables: SourceTables) throws -> [UInt32] {
        try branchAffineUpdate63c278(
            words,
            params: BranchAffine63c278Params(
                arg0Mul: 0x28f734a3, arg0Add: 0x7fc88b1c, halfMul: 0xb00c4591,
                bitTable: 0x126780, preMul: 0x059e578d, preAdd: 0x33273af5,
                wordMul: 0x9d8dd89f, wordAdd: 0xa52d9347,
                foldTable: 0x3022b8, selectTable: 0x113708,
                argMulTable: 0x11d4e8, argAddTable: 0x11c448,
                carryMul: 0xd470f3b3, valueMul: 0xe8000000, nextMul: 0xd0000000,
                loopAdd: 0xadcd0df0, finalAdd: 0x65cd0df0,
                outMulTable: 0x11cdc8, outAddTable: 0x117b88
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopSP440EvenSP4F0Words(_ words: [UInt32], tables: SourceTables) throws -> [UInt32] {
        try branchAffineUpdate63c278(
            words,
            params: BranchAffine63c278Params(
                arg0Mul: 0x5888f7f5, arg0Add: 0xbbf0e3d5, halfMul: 0x642326db,
                bitTable: 0x126858, preMul: 0x246654c1, preAdd: 0x2e782dc3,
                wordMul: 0x1101c103, wordAdd: 0x183fafb9,
                foldTable: 0x3022f8, selectTable: 0x1154a8,
                argMulTable: 0x11a9e8, argAddTable: 0x122268,
                carryMul: 0x4d140725, valueMul: 0xa8000000, nextMul: 0xb0000000,
                loopAdd: 0x6fe563d6, finalAdd: 0x8fe563d6,
                outMulTable: 0x11dd28, outAddTable: 0x120f48
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopUpdateSP440Even(
        sp440Words: [UInt32],
        sp5a0Words: [UInt32],
        tables: SourceTables
    ) throws -> [UInt32] {
        let sp4f0 = try builder63c278LoopSP440EvenSP4F0Words(sp440Words, tables: tables)
        return try stageReducer63c278(
            staticWords: staticPatternWords63c278(q0: 0x124f10, q1: 0x125930, tail: 0x126cd8, tables: tables),
            streams: [
                StageReducerStream63c278(words: sp4f0, mulTable: 0x114988),
                StageReducerStream63c278(words: sp5a0Words, mulTable: 0x11aa08),
            ],
            params: StageReducer63c278Params(
                carry: 0xd3f16146, carryMul: 0x84bb8555,
                preMul: 0xd3dd75bb, preAdd: 0x4bdc02a1,
                foldTable: 0x302338, reduceMul: 0x26bbb9ff,
                sideMul: 0x30000000, reduceAdd: 0xe8f27692,
                folded7Mul: 0xef9fd9a7, folded8Mul: 0x06026590,
                nextAdd: 0x613a18d6,
                outMulTable: 0x120688, outAddTable: 0x1185a8
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopUpdateSP440(
        _ words: [UInt32],
        sp5a0Words: [UInt32],
        tables: SourceTables
    ) throws -> [UInt32] {
        if (words[0] & 1) != 0 {
            return try builder63c278LoopUpdateSP440Odd(words, tables: tables)
        }
        return try builder63c278LoopUpdateSP440Even(sp440Words: words, sp5a0Words: sp5a0Words, tables: tables)
    }

    private static func builder63c278LoopUpdateSP390Even(_ words: [UInt32], tables: SourceTables) throws -> [UInt32] {
        try branchAffineUpdate63c278(
            words,
            params: BranchAffine63c278Params(
                arg0Mul: 0x5b7c4419, arg0Add: 0xd8c9cb43, halfMul: 0xa30de075,
                bitTable: 0x1267f0, preMul: 0x936efced, preAdd: 0x32c3c0a7,
                wordMul: 0x88e44053, wordAdd: 0xc35d94bb,
                foldTable: 0x3023b8, selectTable: 0x1149a8,
                argMulTable: 0x11b488, argAddTable: 0x119768,
                carryMul: 0x14c37dcd, valueMul: 0x18000000, nextMul: 0x30000000,
                loopAdd: 0xe4da180f, finalAdd: 0xccda180f,
                outMulTable: 0x1168e8, outAddTable: 0x11a048
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopSP390OddSP4F0Words(_ words: [UInt32], tables: SourceTables) throws -> [UInt32] {
        try branchAffineUpdate63c278(
            words,
            params: BranchAffine63c278Params(
                arg0Mul: 0x8e39b739, arg0Add: 0x7c6d92a6, halfMul: 0xdca8620d,
                bitTable: 0x126940, preMul: 0x17c4f57f, preAdd: 0x5b647db4,
                wordMul: 0xb0fff815, wordAdd: 0x831b4fff,
                foldTable: 0x3023f8, selectTable: 0x123e28,
                argMulTable: 0x11f5a8, argAddTable: 0x11bc08,
                carryMul: 0x19f6ba67, valueMul: 0xb8000000, nextMul: 0x90000000,
                loopAdd: 0x85a9b64d, finalAdd: 0xb5a9b64d,
                outMulTable: 0x117bc8, outAddTable: 0x116908
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopUpdateSP390Odd(
        sp390Words: [UInt32],
        sp5a0Words: [UInt32],
        tables: SourceTables
    ) throws -> [UInt32] {
        let sp4f0 = try builder63c278LoopSP390OddSP4F0Words(sp390Words, tables: tables)
        return try stageReducer63c278(
            staticWords: staticPatternWords63c278(q0: 0x126330, q1: 0x126020, tail: 0x126a10, tables: tables),
            streams: [
                StageReducerStream63c278(words: sp4f0, mulTable: 0x11ce08),
                StageReducerStream63c278(words: sp5a0Words, mulTable: 0x122ae8),
            ],
            params: StageReducer63c278Params(
                carry: 0x1cd91585, carryMul: 0x1a4cb35b,
                preMul: 0x5137a735, preAdd: 0x3e9907e2,
                foldTable: 0x302438, reduceMul: 0x38fc5a19,
                sideMul: 0xb0000000, reduceAdd: 0x0f3d7c5d,
                folded7Mul: 0xa81b54e7, folded8Mul: 0x7e4ab190,
                nextAdd: 0x767d913c,
                outMulTable: 0x11a068, outAddTable: 0x11b4a8
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopUpdateSP390(
        _ words: [UInt32],
        sp5a0Words: [UInt32],
        tables: SourceTables
    ) throws -> [UInt32] {
        if (words[0] & 1) != 0 {
            return try builder63c278LoopUpdateSP390Odd(sp390Words: words, sp5a0Words: sp5a0Words, tables: tables)
        }
        return try builder63c278LoopUpdateSP390Even(words, tables: tables)
    }

    private static func builder63c278LoopUpdateSP390PredicateFalse(
        sp390Words: [UInt32],
        arg0: Data,
        tables: SourceTables
    ) throws -> [UInt32] {
        let arg0Words = try arg0Words63c278(arg0)
        return try stageReducer63c278(
            staticWords: staticPatternWords63c278(q0: 0x126040, q1: 0x126600, tail: 0x126740, tables: tables),
            streams: [
                StageReducerStream63c278(words: sp390Words, mulTable: 0x11b4e8),
                StageReducerStream63c278(words: arg0Words, mulTable: 0x11bc28),
            ],
            params: StageReducer63c278Params(
                carry: 0x6306d080, carryMul: 0x90b4d58b,
                preMul: 0x323154f1, preAdd: 0x154382ee,
                foldTable: 0x3025f8, reduceMul: 0x30b9cbfb,
                sideMul: 0x50000000, reduceAdd: 0x61849d3d,
                folded7Mul: 0x1fb5a053, folded8Mul: 0x04a5fad0,
                nextAdd: 0x002fe7ef,
                outMulTable: 0x117be8, outAddTable: 0x1172e8
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopUpdateSP390PredicateJoin(
        sp390Words: [UInt32],
        sp440Words: [UInt32],
        tables: SourceTables
    ) throws -> [UInt32] {
        try stageReducer63c278(
            staticWords: staticPatternWords63c278(q0: 0x124d90, q1: 0x125c10, tail: 0x126998, tables: tables),
            streams: [
                StageReducerStream63c278(words: sp390Words, mulTable: 0x11dd48),
                StageReducerStream63c278(words: sp440Words, mulTable: 0x122288),
            ],
            params: StageReducer63c278Params(
                carry: 0xd554336d, carryMul: 0x43e12a11,
                preMul: 0xfd350b93, preAdd: 0xc2fdb2e2,
                foldTable: 0x302638, reduceMul: 0x419ce971,
                sideMul: 0x50000000, reduceAdd: 0x967ae928,
                folded7Mul: 0xcbd75deb, folded8Mul: 0x428a2150,
                nextAdd: 0x27f798a1,
                outMulTable: 0x118f48, outAddTable: 0x11ec28
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopUpdateSP6B0Failure(
        sp6b0Words: [UInt32],
        sp658Words: [UInt32],
        tables: SourceTables
    ) throws -> [UInt32] {
        try stageReducer63c278(
            staticWords: staticPatternWords63c278(q0: 0x1256b0, q1: 0x125f40, tail: 0x1268d8, tables: tables),
            streams: [
                StageReducerStream63c278(words: sp6b0Words, mulTable: 0x1149c8),
                StageReducerStream63c278(words: sp658Words, mulTable: 0x11f5c8),
            ],
            params: StageReducer63c278Params(
                carry: 0x2b0fe6d9, carryMul: 0x346b3047,
                preMul: 0xe8d292cb, preAdd: 0x6376b766,
                foldTable: 0x3024b8, reduceMul: 0xd98513db,
                sideMul: 0xf0000000, reduceAdd: 0x8af9de6d,
                folded7Mul: 0x74f0e285, folded8Mul: 0xb0f1d7b0,
                nextAdd: 0x6ac588e9,
                outMulTable: 0x11fdc8, outAddTable: 0x115f68
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopUpdateSP440PredicateTrue(
        sp440Words: [UInt32],
        arg0: Data,
        tables: SourceTables
    ) throws -> [UInt32] {
        let arg0Words = try arg0Words63c278(arg0)
        return try stageReducer63c278(
            staticWords: staticPatternWords63c278(q0: 0x124f20, q1: 0x125a00, tail: 0x126c68, tables: tables),
            streams: [
                StageReducerStream63c278(words: sp440Words, mulTable: 0x112668),
                StageReducerStream63c278(words: arg0Words, mulTable: 0x116928),
            ],
            params: StageReducer63c278Params(
                carry: 0x43bff476, carryMul: 0x8123c767,
                preMul: 0xbc55d64f, preAdd: 0x3db88f4f,
                foldTable: 0x302538, reduceMul: 0xb7e919a9,
                sideMul: 0x90000000, reduceAdd: 0xd881235b,
                folded7Mul: 0x239e1779, folded8Mul: 0xc61e8870,
                nextAdd: 0xa1d86ec1,
                outMulTable: 0x113728, outAddTable: 0x116948
            ),
            tables: tables
        )
    }

    private static func builder63c278LoopUpdateSP440PredicateJoin(
        sp440Words: [UInt32],
        sp390Words: [UInt32],
        tables: SourceTables
    ) throws -> [UInt32] {
        try stageReducer63c278(
            staticWords: staticPatternWords63c278(q0: 0x125440, q1: 0x126030, tail: 0x1267b8, tables: tables),
            streams: [
                StageReducerStream63c278(words: sp440Words, mulTable: 0x114068),
                StageReducerStream63c278(words: sp390Words, mulTable: 0x11c488),
            ],
            params: StageReducer63c278Params(
                carry: 0xf35277e4, carryMul: 0x3ae4bb05,
                preMul: 0x130a19eb, preAdd: 0x624d99a5,
                foldTable: 0x302578, reduceMul: 0x53cea2cf,
                sideMul: 0x30000000, reduceAdd: 0x81d9862e,
                folded7Mul: 0x53c4f527, folded8Mul: 0xc3b0ad90,
                nextAdd: 0x59871186,
                outMulTable: 0x120f68, outAddTable: 0x11a088
            ),
            tables: tables
        )
    }

    private static func builder63c278Predicate64D55C(
        sp440Words: [UInt32],
        sp390Words: [UInt32],
        tables: SourceTables
    ) throws -> Int {
        for stream in [sp440Words, sp390Words] where stream.count < builder63c278VectorWords {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(stream.count)
        }
        for index in stride(from: builder63c278VectorWords - 1, through: 0, by: -1) {
            let tableOffset = (index * 4) & 0x1c
            let check = UInt32(
                (UInt64(sp440Words[index]) &* UInt64(try u32TableWord63c278(0x11fde8 + tableOffset, tables: tables))
                 &+ UInt64(sp390Words[index]) &* UInt64(try u32TableWord63c278(0x1206c8 + tableOffset, tables: tables))
                 &+ UInt64(try u32TableWord63c278(0x1185c8 + tableOffset, tables: tables))) & 0xffff_ffff
            )
            if check != 0x213734c0 {
                let folded = try fold32ByNibbles63c278(check, tableOffset: 0x3024f8, rounds: 7, tables: tables)
                return (folded & 0x0f) != 0 ? 1 : 0
            }
        }
        return 0
    }

    private static func builder63c278TerminalSP658Ready(_ sp658Words: [UInt32], tables: SourceTables) throws -> Bool {
        guard sp658Words.count >= builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(sp658Words.count)
        }
        if UInt32((UInt64(sp658Words[0]) &* UInt64(0x04dc738d)) & 0xffff_ffff) != 0x49f4222f {
            return false
        }

        for index in 1..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            let check = UInt32(
                (UInt64(try foldTableU32Word63c278(0x3021a0 + index * 4, tables: tables))
                 &* UInt64(try u32TableWord63c278(0x1234e8 + tableOffset, tables: tables))
                 &+ UInt64(sp658Words[index])
                 &* UInt64(try u32TableWord63c278(0x120668 + tableOffset, tables: tables))
                 &+ UInt64(try u32TableWord63c278(0x11e5a8 + tableOffset, tables: tables))) & 0xffff_ffff
            )
            if check != 0x0a2c3abe {
                return false
            }
        }
        return true
    }

    private static func branchAffineUpdate63c278(
        _ words: [UInt32],
        params: BranchAffine63c278Params,
        tables: SourceTables
    ) throws -> [UInt32] {
        guard words.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(words.count)
        }
        let first = UInt32((UInt64(words[0]) &* UInt64(params.arg0Mul) &+ UInt64(params.arg0Add)) & 0xffff_ffff)
        let firstState = try branchState63c278(from: first, halfMul: params.halfMul, bitTable: params.bitTable, tables: tables)
        var carry = try branchWord63c278(state: firstState, params: params, tables: tables)

        var out = [UInt32](repeating: 0, count: builder63c278VectorWords)
        for index in 0..<(builder63c278VectorWords - 1) {
            let nextIndex = index + 1
            let nextTableOffset = (nextIndex & 7) * 4
            let value = try u32TableAffine63c278(
                words[nextIndex],
                mulTable: params.argMulTable + nextTableOffset,
                addTable: params.argAddTable + nextTableOffset,
                tables: tables
            )
            let state = try branchState63c278(from: value, halfMul: params.halfMul, bitTable: params.bitTable, tables: tables)
            let word = try branchWord63c278(state: state, params: params, tables: tables)
            carry = UInt32(
                (UInt64(carry) &* UInt64(params.carryMul)
                 &+ UInt64(value) &* UInt64(params.valueMul)
                 &+ UInt64(word) &* UInt64(params.nextMul)) & 0xffff_ffff
            )
            let storeValue = carry &+ params.loopAdd
            let tableOffset = (index * 4) & 0x1c
            out[index] = try u32TableAffine63c278(
                storeValue,
                mulTable: params.outMulTable + tableOffset,
                addTable: params.outAddTable + tableOffset,
                tables: tables
            )
            carry = word
        }

        let finalStore = UInt32((UInt64(carry) &* UInt64(params.carryMul) &+ UInt64(params.finalAdd)) & 0xffff_ffff)
        let finalOffset = ((builder63c278VectorWords - 1) * 4) & 0x1c
        out[builder63c278VectorWords - 1] = try u32TableAffine63c278(
            finalStore,
            mulTable: params.outMulTable + finalOffset,
            addTable: params.outAddTable + finalOffset,
            tables: tables
        )
        return out
    }

    private static func branchWord63c278(
        state: UInt32,
        params: BranchAffine63c278Params,
        tables: SourceTables
    ) throws -> UInt32 {
        let preFold = UInt32((UInt64(state) &* UInt64(params.preMul) &+ UInt64(params.preAdd)) & 0xffff_ffff)
        let select = try branchSelectBit63c278(value: preFold, foldTable: params.foldTable, selectTable: params.selectTable, tables: tables)
        return UInt32(
            (UInt64(state) &* UInt64(params.wordMul)
             &+ UInt64(params.wordAdd)
             &+ UInt64(select)) & 0xffff_ffff
        )
    }

    private static func branchSelectBit63c278(
        value: UInt32,
        foldTable: Int,
        selectTable: Int,
        tables: SourceTables
    ) throws -> UInt32 {
        let folded = try fold32ByNibbles63c278(value, tableOffset: foldTable, rounds: 7, tables: tables)
        let selected = try u32TableWord63c278(selectTable + Int(folded & 7) * 4, tables: tables) &+ (folded >> 3)
        return selected &<< 31
    }

    private static func branchState63c278(
        from word: UInt32,
        halfMul: UInt32,
        bitTable: Int,
        tables: SourceTables
    ) throws -> UInt32 {
        let bit = try u32TableWord63c278(bitTable + Int(word & 1) * 4, tables: tables)
        return UInt32((UInt64(word >> 1) &* UInt64(halfMul) &+ UInt64(bit)) & 0xffff_ffff)
    }

    private static func staticPatternWords63c278(q0: Int, q1: Int, tail: Int, tables: SourceTables) throws -> [UInt32] {
        let q0Words = try (0..<4).map { try u32TableWord63c278(q0 + $0 * 4, tables: tables) }
        let q1Words = try (0..<4).map { try u32TableWord63c278(q1 + $0 * 4, tables: tables) }
        let tailWords = try (0..<2).map { try u32TableWord63c278(tail + $0 * 4, tables: tables) }
        return q0Words + q1Words + q0Words + q1Words + q0Words + tailWords
    }

    private static func stageReducer63c278(
        staticWords: [UInt32],
        streams: [StageReducerStream63c278],
        params: StageReducer63c278Params,
        tables: SourceTables
    ) throws -> [UInt32] {
        guard staticWords.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(staticWords.count)
        }
        var sp230 = staticWords
        for stream in streams {
            guard stream.words.count == builder63c278VectorWords else {
                throw FirstPairSourceSliceError.invalid63c278VectorWordCount(stream.words.count)
            }
            for (index, word) in stream.words.enumerated() {
                let tableOffset = (index & 7) * 4
                let mul = try u32TableWord63c278(stream.mulTable + tableOffset, tables: tables)
                sp230[index] = UInt32((UInt64(sp230[index]) &+ UInt64(word) &* UInt64(mul)) & 0xffff_ffff)
            }
        }

        var carry = params.carry
        var out: [UInt32] = []
        out.reserveCapacity(builder63c278VectorWords)
        for (index, word) in sp230.enumerated() {
            carry = UInt32((UInt64(carry) &* UInt64(params.carryMul) &+ UInt64(word)) & 0xffff_ffff)
            var folded7 = UInt32((UInt64(carry) &* UInt64(params.preMul) &+ UInt64(params.preAdd)) & 0xffff_ffff)
            folded7 = try fold32ByNibbles63c278(folded7, tableOffset: params.foldTable, rounds: 7, tables: tables)
            let folded8 = try foldTableU32Word63c278(params.foldTable + Int(folded7 & 0x0f) * 4, tables: tables) &+ (folded7 >> 4)
            let stage = UInt32(
                (UInt64(carry) &* UInt64(params.reduceMul)
                 &+ UInt64(folded7) &* UInt64(params.sideMul)
                 &+ UInt64(params.reduceAdd)) & 0xffff_ffff
            )
            let nextCarry = UInt32(
                (UInt64(folded7) &* UInt64(params.folded7Mul)
                 &+ UInt64(folded8) &* UInt64(params.folded8Mul)) & 0xffff_ffff
            )
            let tableOffset = (index * 4) & 0x1c
            out.append(try u32TableAffine63c278(stage, mulTable: params.outMulTable + tableOffset, addTable: params.outAddTable + tableOffset, tables: tables))
            carry = nextCarry &+ params.nextAdd
        }
        return out
    }

    private static func builder6421c0WorkspaceParams(
        scalar: UInt64,
        firstWord: UInt64,
        tables: SourceTables
    ) throws -> (multiplier: UInt64, broadcast: UInt64) {
        let seedA = scalar &* 0x5509a203390f347f &+ 0x32f1fb0a9d874bf4
        let seedB = scalar &* 0x4c2221c00f3005fb &+ 0x0ff14ba0b2a5c7ba
        var mixed = firstWord &* seedA &+ seedB
        let folded = try fold63c278(
            mixed &* 0x473c6a74e974ae65 &+ 0xadebeda263d28433,
            tableOffset: builder6421c0WorkspaceFoldTable,
            rounds: 7,
            tables: tables
        )
        mixed = mixed &* 0xef65aceeafea45e9
            &+ folded &* 0x5fe62b0cb0000000
            &+ 0xd7d1a2ac976837c3
        return (
            mixed &* 0x9c52396943c088f7 &+ 0x8983840ba934a2f1,
            mixed &* 0x0fd36815b245b0f2 &+ 0x3aa2f36c3a09d43e
        )
    }

    private static func builder6421c0RewriteSecondWord(
        first: UInt64,
        second: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        let folded = try fold63c278(
            first &* 0x12c340b4b411bb8d &+ 0xab10f2a46110bceb,
            tableOffset: builder6421c0RewriteFold1Table,
            rounds: 7,
            tables: tables
        )
        var mixed = folded &* 0xcfdc2f8d3b1f41e3 &+ 0x317484327c6f968a
        let folded2 = try fold63c278(
            mixed &* 0xeefa3d8f20f54f35 &+ 0x483345b5f608f667,
            tableOffset: builder6421c0RewriteFold2Table,
            rounds: 9,
            tables: tables
        )
        mixed = mixed &* 0x6b6283330fe2b923
            &+ folded2 &* 0x6214609000000000
        return mixed &* 0x8d48d385aeebeb5d &+ second &+ 0x71783af05ec8119f
    }

    private static func builder64bd0cWorkspaceParams(
        scalar: UInt64,
        firstX2Word: UInt64,
        tables: SourceTables
    ) throws -> (multiplier: UInt64, broadcast: UInt64) {
        let seedA = scalar &* 0x9cbd06d772de1901 &+ 0x34e214bca24f560c
        let seedB = scalar &* 0xbe4812554b30ebf8 &+ 0xc770490f6d646597
        var mixed = seedA &* firstX2Word &+ seedB
        var folded = mixed &* 0x213ec1d8d1bc2d9b &+ 0x3cda12a384db6d3b
        folded = try fold63c278(folded, tableOffset: builder64bd0cWorkspaceFold1Table, rounds: 7, tables: tables)
        mixed = mixed &* 0x91ab7a47a981923b
            &+ folded &* 0x0ed61381f0000000
            &+ 0xab62fec0d215095b
        return (
            mixed &* 0x8493b5edc5e368a1 &+ 0x6f8e182c75ab0bb8,
            mixed &* 0x2698148ddd26a50e &+ 0x740f3b32b62a7210
        )
    }

    private static func builder64bd0cRewriteSecondWord(
        first: UInt64,
        second: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        var folded = first &* 0xe121bd3e759b23f3 &+ 0x8c105c11c96e758b
        folded = try fold63c278(folded, tableOffset: builder64bd0cRewriteFold1Table, rounds: 7, tables: tables)
        var mixed = folded &* 0x4afc5649aee85307 &+ 0xdc13fe8d315ad1a7
        var folded2 = mixed &* 0x7c64ef86eb0d2547 &+ 0x95549ebb3b944abe
        folded2 = try fold63c278(folded2, tableOffset: builder64bd0cRewriteFold2Table, rounds: 9, tables: tables)
        mixed = mixed &* 0xd9ef08a678eb7ba3
            &+ folded2 &* 0x8e62b3b000000000
        return mixed &* 0x3352cbd4c2b4f2ef &+ second &+ 0x793cd011929995d8
    }

    private static func builder64bd0cFinalFirstFold(
        _ value: UInt64,
        tables: SourceTables
    ) throws -> (nextBase: UInt64, side: UInt32, folded: UInt64) {
        var folded = value &* 0xbfeaa39c4f3a2fdf &+ 0xb07328e69628c835
        var side = UInt32(truncatingIfNeeded: value) &* 0x48daeaa5
        folded = try fold63c278(folded, tableOffset: builder64bd0cFinalFoldTable, rounds: 7, tables: tables)
        side = side &+ UInt32(truncatingIfNeeded: folded) &* 0x50000000
        let nextBase = folded
        folded = try fold63c278(folded, tableOffset: builder64bd0cFinalFoldTable, rounds: 1, tables: tables)
        return (nextBase, side &+ 0xdfea4892, folded)
    }

    private static func builder64c524WorkspaceParams(
        scalar: UInt64,
        firstX2Word: UInt64,
        tables: SourceTables
    ) throws -> (multiplier: UInt64, broadcast: UInt64) {
        let seedA = scalar &* 0x37225d56e2d37ae5 &+ 0x3d01a097518f54bc
        let seedB = scalar &* 0xd03e88ab453ae68b &+ 0x5ca5b123c7ddda97
        var mixed = seedA &* firstX2Word &+ seedB
        var folded = mixed &* 0x4355499b9de8f281 &+ 0xd616e418c4bc0066
        folded = try fold63c278(folded, tableOffset: builder64c524WorkspaceFold1Table, rounds: 7, tables: tables)
        mixed = mixed &* 0x65dd922c973ea261
            &+ folded &* 0xb2b8c001f0000000
            &+ 0x457dafb763ad58f5
        return (
            mixed &* 0x9fdf9fbdfb76ed77 &+ 0x14646b0029e6e968,
            mixed &* 0x55fb9010c9586c69 &+ 0x63292bd5dae78b98
        )
    }

    private static func builder64c524RewriteSecondWord(
        first: UInt64,
        second: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        var folded = first &* 0xe191957128574e8d &+ 0xca735f7e01db7229
        folded = try fold63c278(folded, tableOffset: builder64c524RewriteFold1Table, rounds: 7, tables: tables)
        var mixed = folded &* 0xc0759fa984b4b32b &+ 0x4e00c393f4ad1417
        var folded2 = mixed &* 0x2ca78080bf929d71 &+ 0x489c8bdec6559298
        folded2 = try fold63c278(folded2, tableOffset: builder64c524RewriteFold2Table, rounds: 9, tables: tables)
        mixed = mixed &* 0x21a1db1ac0ca1e41
            &+ folded2 &* 0x3659a2f000000000
        return mixed &* 0x1685e929cba4a88f &+ second &+ 0x56570c70d17acce1
    }

    private static func builder64c524FinalFirstFold(
        _ value: UInt64,
        tables: SourceTables
    ) throws -> (nextBase: UInt64, side: UInt32, folded: UInt64) {
        let product = value &* 0x2d5e3aab4210238b
        var side = UInt32(truncatingIfNeeded: value) &* 0x6773f057
        var folded = try foldTableU64Word63c278(
            builder64c524FinalFoldTable + Int(product & 0x0f) * 8,
            tables: tables
        ) &+ ((product &+ 0x04d30efa28ce4180) >> 4)
        folded = try fold63c278(folded, tableOffset: builder64c524FinalFoldTable, rounds: 6, tables: tables)
        side = side &+ UInt32(truncatingIfNeeded: folded) &* 0xb0000000
        let nextBase = folded
        folded = try fold63c278(folded, tableOffset: builder64c524FinalFoldTable, rounds: 1, tables: tables)
        return (nextBase, side &+ 0xc5960ad5, folded)
    }

    private static func builder64cd40WorkspaceParams(
        scalar: UInt64,
        firstX2Word: UInt64,
        tables: SourceTables
    ) throws -> (multiplier: UInt64, broadcast: UInt64) {
        let seedA = (scalar &* 0x697d0ecbc60d5d0f) &+ 0x937857c2eed8d2b4
        let seedB = (scalar &* 0xbc235eb940a876dd) &+ 0x18b363a938b968b2
        var mixed = (seedA &* firstX2Word) &+ seedB
        var folded = (mixed &* 0x10adb81e27dd69a7) &+ 0xe7f726c1fe72a787
        folded = try fold63c278(folded, tableOffset: 0x301170, rounds: 7, tables: tables)
        mixed = (mixed &* 0x411310f58c3cbf15)
            &+ (folded &* 0xc72468f1d0000000)
            &+ 0x9d21e3104874d274
        return (
            (mixed &* 0x0b7281fc87cf2277) &+ 0x719b343dac285e92,
            (mixed &* 0x71031cfa7b36346e) &+ 0x0c7018d77bac9e24
        )
    }

    private static func builder64cd40RewriteSecondWord(
        first: UInt64,
        second: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        var folded = (first &* 0x4fec946356180ba9) &+ 0xcd7ac1129eab2dd8
        folded = try fold63c278(folded, tableOffset: 0x3011f0, rounds: 7, tables: tables)
        var mixed = (folded &* 0x1eb04e8030fffbd7) &+ 0xaee6470479c51db3
        var folded2 = (mixed &* 0x8d796f74dc90608d) &+ 0x9ac49f51ec349615
        folded2 = try fold63c278(folded2, tableOffset: 0x301270, rounds: 9, tables: tables)
        mixed = (mixed &* 0xf9e1d6a0ce988cf5)
            &+ (folded2 &* 0x1cc37f7000000000)
        return (mixed &* 0x87f365d52d3aa373) &+ second &+ 0x41b4561d4c674238
    }

    private static func builder64cd40FinalFirstFold(
        _ value: UInt64,
        tables: SourceTables
    ) throws -> (nextBase: UInt64, side: UInt32, folded: UInt64) {
        let product = value &* 0x947905173900b973
        var side = UInt32((UInt64(UInt32(truncatingIfNeeded: value)) &* UInt64(0x8f376f21)) & 0xffff_ffff)
        var folded = try foldTableU64Word63c278(
            0x3012f0 + Int(product & 0x0f) * 8,
            tables: tables
        ) &+ ((product &+ 0x0c4fdbc2f625a640) >> 4)
        for _ in 0..<6 {
            folded = try foldTableU64Word63c278(
                0x3012f0 + Int(folded & 0x0f) * 8,
                tables: tables
            ) &+ (folded >> 4)
        }
        side = side &+ UInt32((UInt64(UInt32(truncatingIfNeeded: folded)) &* UInt64(0x50000000)) & 0xffff_ffff)
        let nextBase = folded
        folded = try foldTableU64Word63c278(
            0x3012f0 + Int(folded & 0x0f) * 8,
            tables: tables
        ) &+ (folded >> 4)
        return (nextBase, side &+ 0x06ae2bd7, folded)
    }

    private static func u32AffineBytes63c278(
        _ input: Data,
        mulTable: Int,
        addTable: Int,
        label: String,
        tables: SourceTables
    ) throws -> Data {
        guard input.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(label, input.count, builder63c278VectorBytes)
        }
        let bytes = [UInt8](input)
        var out: [UInt8] = []
        out.reserveCapacity(builder63c278VectorBytes)
        for index in 0..<builder63c278VectorWords {
            let tableOffset = (index * 4) & 0x1c
            let word = try u32TableAffine63c278(
                readUInt32LE(bytes, index * 4),
                mulTable: mulTable + tableOffset,
                addTable: addTable + tableOffset,
                tables: tables
            )
            out.append(contentsOf: u32LEBytes(word))
        }
        return Data(out)
    }

    private static func packUInt64LE64cd40(_ words: [UInt64]) -> Data {
        var out = Data()
        out.reserveCapacity(words.count * 8)
        for word in words {
            out.append(contentsOf: u64LEBytes(word))
        }
        return out
    }

    private static func packUInt32LE(_ words: [UInt32]) -> Data {
        var out = Data()
        out.reserveCapacity(words.count * 4)
        for word in words {
            out.append(contentsOf: u32LEBytes(word))
        }
        return out
    }

    private static func builder642f60AffineWordsFrom64bd0cOutput(
        _ output: Data,
        mulTable: Int,
        addTable: Int,
        label: String
    ) throws -> [UInt32] {
        guard output.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(label, output.count, builder63c278VectorBytes)
        }
        let tables = try cachedTables.get()
        let bytes = [UInt8](output)
        return try (0..<builder63c278VectorWords).map { index in
            try u32Affine63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: mulTable,
                addTable: addTable,
                tables: tables
            )
        }
    }

    private static func builder642f60FirstAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0x7a6bdb55 &+ 0x6f457678
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60FirstAMulTable,
                addTable: builder642f60FirstAAddTable,
                tables: tables
            ) &* 0x9935dc8f &+ 0x8faec549
        }
        let folded = try fold63c278(
            UInt64(w) &* 0x62170eaa882a1aad &+ 0xfcded5c74336bb62,
            tableOffset: builder642f60FirstAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0x1ae027ac75efae5d
            &+ folded &* 0x6a59778f00000000
            &+ 0x272a0fcbb9692010
    }

    private static func builder642f60FirstBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0x8a0c43a1 &+ 0xe1069988
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60FirstBMulTable,
                addTable: builder642f60FirstBAddTable,
                tables: tables
            ) &* 0x8fce17f9 &+ 0x9aa95d9c
        }
        let folded = try fold63c278(
            UInt64(w) &* 0x91c0e3def121255d &+ 0x50be110705349aea,
            tableOffset: builder642f60FirstBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0x861960b1d03ace7f
            &+ folded &* 0x7f5bb67500000000
            &+ 0x4a2faf413913b4a2
    }

    private static func builder642f60SecondAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0xcce32bdb &+ 0x79dae932
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60SecondAMulTable,
                addTable: builder642f60SecondAAddTable,
                tables: tables
            ) &* 0x7bd77a89 &+ 0x0d07fa2a
        }
        let folded = try fold63c278(
            UInt64(w) &* 0x0a0b1df06a7b196d &+ 0xfd9f62e38b4829f7,
            tableOffset: builder642f60SecondAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0xb1bf8eba2d4b2a69
            &+ folded &* 0xb6b0ac9300000000
            &+ 0x381faa6c090fdcd8
    }

    private static func builder642f60SecondBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0x9affbc41 &+ 0x96a579e0
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60SecondBMulTable,
                addTable: builder642f60SecondBAddTable,
                tables: tables
            ) &* 0x3749a60d &+ 0xb803d34c
        }
        let folded = try fold63c278(
            UInt64(w) &* 0xa5ffca145f08d59b &+ 0x8ce0b7edd5a16ba2,
            tableOffset: builder642f60SecondBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0xabe6b5e1333dcc8f
            &+ folded &* 0xfbd091e300000000
            &+ 0x1df38d76faeb4ead
    }

    private static func builder642f60ThirdAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0x92a36947 &+ 0xab2632fc
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60ThirdAMulTable,
                addTable: builder642f60ThirdAAddTable,
                tables: tables
            ) &* 0xe77cb783 &+ 0x000f1f23
        }
        let folded = try fold63c278FirstNibbleBeforeAdd(
            UInt64(w) &* 0xaf7f459e89cfb7e5,
            addend: 0x5c6139b5f80c5a20,
            tableOffset: builder642f60ThirdAFoldTable,
            tables: tables
        )
        return UInt64(w) &* 0x796b8710218eb0c5
            &+ folded &* 0x7224389f00000000
            &+ 0x086af43c0726c3a9
    }

    private static func builder642f60ThirdBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0x032a79c5 &+ 0x8da26e96
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60ThirdBMulTable,
                addTable: builder642f60ThirdBAddTable,
                tables: tables
            ) &* 0xb13f4189 &+ 0x2b7b0e41
        }
        let folded = try fold63c278(
            UInt64(w) &* 0x3144f0ff41a1df83 &+ 0x3d414cbf18310011,
            tableOffset: builder642f60ThirdBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0x861a1f875b2dc69b
            &+ folded &* 0xf0b786f700000000
            &+ 0x63b83ae085557472
    }

    private static func builder642f60FourthAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0x9a4392db &+ 0x0d1015ea
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60FourthAMulTable,
                addTable: builder642f60FourthAAddTable,
                tables: tables
            ) &* 0x97151be3 &+ 0x70bf5e2b
        }
        let folded = try fold63c278(
            UInt64(w) &* 0xcf0e32fa8d969f65 &+ 0x61afec1284e66a8c,
            tableOffset: builder642f60FourthAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0x610ca66bd199f2b5
            &+ folded &* 0xde6166ef00000000
            &+ 0x50d31e15d8b1af56
    }

    private static func builder642f60FourthBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0x2ac5e1c1 &+ 0x957be66c
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60FourthBMulTable,
                addTable: builder642f60FourthBAddTable,
                tables: tables
            ) &* 0xee64b1f5 &+ 0x5df44367
        }
        let folded = try fold63c278(
            UInt64(w) &* 0x013aed389aef9cd9 &+ 0x9ac1ba0fa43555a1,
            tableOffset: builder642f60FourthBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0x3ca485be7caa6cf3
            &+ folded &* 0xcec7175500000000
            &+ 0x44d63f7b1e64fe52
    }

    private static func builder642f60MidContextStreamWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0xef8a98c3 &+ 0x5251f797
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60MidContextMulTable,
                addTable: builder642f60MidContextAddTable,
                tables: tables
            ) &* 0x9198bbe1 &+ 0x96d49925
        }
        let folded = try fold63c278(
            UInt64(w) &* 0x10aca1fefeaea819 &+ 0x791f2f89d18f0bcc,
            tableOffset: builder642f60MidContextFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0x7e3d39fbe4db207b
            &+ folded &* 0xf948d04d00000000
            &+ 0xefba822749ae8302
    }

    private static func builder642f60MidSPF0StreamWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0x833f922f &+ 0xb8f79a5c
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60MidSPF0MulTable,
                addTable: builder642f60MidSPF0AddTable,
                tables: tables
            ) &* 0xe9ed5087 &+ 0x99a662bc
        }
        let folded = try fold63c278(
            UInt64(w) &* 0x9445eb5f6cc20c37 &+ 0x2e115166fc9d38de,
            tableOffset: builder642f60MidSPF0FoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0x76037a61bba475bd
            &+ folded &* 0x7a18645500000000
            &+ 0xeb599af66ebe44f8
    }

    private static func builder642f60MidSP40BWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0x68f1c9c3 &+ 0x75e3de3d
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60MidSP40BMulTable,
                addTable: builder642f60MidSP40BAddTable,
                tables: tables
            ) &* 0x603eaaa7 &+ 0xf3704eb8
        }
        let folded = try fold63c278(
            UInt64(w) &* 0x339d03216c178183 &+ 0xccccddb48073e82d,
            tableOffset: builder642f60MidSP40BFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0x6255799ade203b13
            &+ folded &* 0x504804cf00000000
            &+ 0xece1b0fccff7a5d6
    }

    private static func builder642f60SixthAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0xe12f8e63 &+ 0xed30a70d
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60SixthAMulTable,
                addTable: builder642f60SixthAAddTable,
                tables: tables
            ) &* 0x61e5762b &+ 0xd79521cb
        }
        let folded = try fold63c278(
            UInt64(w) &* 0x5ebafd23d4800453 &+ 0xfce166cf66e4ed89,
            tableOffset: builder642f60SixthAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0xfe6b40e82ac2cfad
            &+ folded &* 0x4b28a40100000000
            &+ 0x5ffded7fc281e70c
    }

    private static func builder642f60SixthBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0x5f8eb06b &+ 0x71dd9075
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60SixthBMulTable,
                addTable: builder642f60SixthBAddTable,
                tables: tables
            ) &* 0x32ca6d69 &+ 0x5b73a719
        }
        let folded = try fold63c278(
            UInt64(w) &* 0xf82a21269cc1d1db &+ 0xd1172c1561159fb2,
            tableOffset: builder642f60SixthBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0xad5daa3cdd561923
            &+ folded &* 0x5a9053a700000000
            &+ 0x06054c9125875977
    }

    private static func reducerU32Words63c278(
        sourceWords: [UInt32],
        stateInit: UInt32,
        stateMul: UInt32,
        foldPreMul: UInt32,
        foldPreAdd: UInt32,
        foldTable: Int,
        sideMul: UInt32,
        sideFoldedMul: UInt32,
        sideAdd: UInt32,
        nextFolded7Mul: UInt32,
        nextFolded8Mul: UInt32,
        nextAdd: UInt32,
        outMulTable: Int,
        outAddTable: Int
    ) throws -> [UInt32] {
        let tables = try cachedTables.get()
        var state = stateInit
        var out: [UInt32] = []
        out.reserveCapacity(sourceWords.count)
        for (index, word) in sourceWords.enumerated() {
            let tableOffset = (index * 4) & 0x1c
            state = state &* stateMul &+ word
            var folded7 = state &* foldPreMul &+ foldPreAdd
            folded7 = try fold32ByNibbles63c278(
                folded7,
                tableOffset: foldTable,
                rounds: 7,
                tables: tables
            )
            let side = state &* sideMul
                &+ folded7 &* sideFoldedMul
                &+ sideAdd
            let folded8 = try fold32ByNibbles63c278(
                folded7,
                tableOffset: foldTable,
                rounds: 1,
                tables: tables
            )
            out.append(try u32TableAffine63c278(
                side,
                mulTable: outMulTable + tableOffset,
                addTable: outAddTable + tableOffset,
                tables: tables
            ))
            state = folded7 &* nextFolded7Mul
                &+ folded8 &* nextFolded8Mul
                &+ nextAdd
        }
        return out
    }

    private static func convolutionReducerU32Words63c278(
        aWords: [UInt64],
        bWords: [UInt64],
        stateInit: UInt64,
        countMul: UInt64,
        productMul: UInt64,
        sumAMul: UInt64,
        sumBMul: UInt64,
        foldPreMul: UInt64,
        foldPreAdd: UInt64,
        foldTable: Int,
        sideMul: UInt32,
        sideFoldedMul: UInt32,
        sideAdd: UInt32,
        nextFolded8Mul: UInt64,
        nextFolded16Mul: UInt64,
        nextAdd: UInt64,
        outMulTable: Int,
        outAddTable: Int
    ) throws -> [UInt32] {
        guard aWords.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(aWords.count)
        }
        guard bWords.count == builder63c278VectorWords else {
            throw FirstPairSourceSliceError.invalid63c278VectorWordCount(bWords.count)
        }
        let tables = try cachedTables.get()
        let aPrefix = prefixSumsU64(aWords)
        let bPrefix = prefixSumsU64(bWords)
        var state = stateInit
        var out: [UInt32] = []
        out.reserveCapacity(builder64bd0cWorkspaceWords)

        for index in 0..<builder64bd0cWorkspaceWords {
            let start = max(0, index - (builder63c278VectorWords - 1))
            let end = min(index, builder63c278VectorWords - 1)
            var productSum: UInt64 = 0
            if start <= end {
                for position in start...end {
                    productSum = productSum &+ aWords[position] &* bWords[index - position]
                }
            }
            let span = start <= end ? UInt64(end - start + 1) : 0
            let sumA = rangeSumFromPrefix(aPrefix, start: start, end: end)
            let sumB = rangeSumFromPrefix(bPrefix, start: index - end, end: index - start)
            let mixed = state
                &+ span &* countMul
                &+ productSum &* productMul
                &+ sumA &* sumAMul
                &+ sumB &* sumBMul
            let foldedSeed = mixed &* foldPreMul &+ foldPreAdd
            let folded7 = try fold63c278(foldedSeed, tableOffset: foldTable, rounds: 7, tables: tables)
            let folded16 = try fold63c278(foldedSeed, tableOffset: foldTable, rounds: 16, tables: tables)
            let side = UInt32(truncatingIfNeeded: mixed) &* sideMul
                &+ UInt32(truncatingIfNeeded: folded7) &* sideFoldedMul
                &+ sideAdd
            let tableOffset = (index * 4) & 0x1c
            out.append(
                try u32TableAffine63c278(
                    side,
                    mulTable: outMulTable + tableOffset,
                    addTable: outAddTable + tableOffset,
                    tables: tables
                )
            )
            state = folded7 &* nextFolded8Mul
                &+ folded16 &* nextFolded16Mul
                &+ nextAdd
        }
        return out
    }

    private static func builder6388f0CallerStreamU64(
        word: UInt32,
        wordMul: UInt64,
        wordAdd: UInt64,
        foldTable: Int,
        foldMul: UInt64,
        mixMul: UInt64,
        mixAdd: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        let folded = try fold63c278(
            UInt64(word) &* wordMul &+ wordAdd,
            tableOffset: foldTable,
            rounds: 8,
            tables: tables
        )
        return folded &* foldMul
            &+ UInt64(word) &* mixMul
            &+ mixAdd
    }

    private static func builder6388f0CallerStreamU64FirstNibbleBeforeAdd(
        word: UInt32,
        wordMul: UInt64,
        wordAdd: UInt64,
        foldTable: Int,
        foldMul: UInt64,
        mixMul: UInt64,
        mixAdd: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        let product = UInt64(word) &* wordMul
        let folded = try fold63c278FirstNibbleBeforeAdd(
            product,
            addend: wordAdd,
            tableOffset: foldTable,
            tables: tables
        )
        return folded &* foldMul
            &+ UInt64(word) &* mixMul
            &+ mixAdd
    }

    private static func builder6388f0Convolution44(
        stack: inout [UInt8],
        aVecOffset: Int,
        aPrefixOffset: Int,
        bVecOffset: Int,
        bPrefixOffset: Int,
        outOffset: Int,
        constants: (
            countMul: UInt64,
            countAdd: UInt64,
            productMul: UInt64,
            bPrefixMul: UInt64,
            aPrefixMul: UInt64,
            finalMul: UInt64,
            finalAdd: UInt64
        )
    ) {
        let aVec = (0..<builder63c278VectorWords).map { readUInt64LE(stack, aVecOffset + $0 * 8) }
        let aPrefix = (0..<builder63c278VectorWords).map { readUInt64LE(stack, aPrefixOffset + $0 * 8) }
        let bVec = (0..<builder63c278VectorWords).map { readUInt64LE(stack, bVecOffset + $0 * 8) }
        let bPrefix = (0..<builder63c278VectorWords).map { readUInt64LE(stack, bPrefixOffset + $0 * 8) }

        for index in 0..<builder64cd40WorkspaceWords {
            let low = max(0, index - (builder63c278VectorWords - 1))
            let high = min(index, builder63c278VectorWords - 1)
            if low > high {
                writeUInt64LE(
                    constants.countAdd &* constants.finalMul &+ constants.finalAdd,
                    into: &stack,
                    at: outOffset + index * 8
                )
                continue
            }

            var productSum: UInt64 = 0
            for bIndex in low...high {
                productSum = productSum &+ aVec[index - bIndex] &* bVec[bIndex]
            }

            var aSum = aPrefix[index - low]
            let previousAIndex = index - high - 1
            if previousAIndex >= 0 {
                aSum = aSum &- aPrefix[previousAIndex]
            }

            var bSum = bPrefix[high]
            if low > 0 {
                bSum = bSum &- bPrefix[low - 1]
            }

            let count = UInt64(high - low + 1)
            var out = count &* constants.countMul &+ constants.countAdd
            out = out &+ productSum &* constants.productMul
            out = out &+ bSum &* constants.bPrefixMul
            out = out &+ aSum &* constants.aPrefixMul
            out = out &* constants.finalMul &+ constants.finalAdd
            writeUInt64LE(out, into: &stack, at: outOffset + index * 8)
        }
    }

    private static func u64StreamWordFromU32Affine(
        _ word: UInt32,
        index: Int,
        mulTable: Int,
        addTable: Int,
        u32Mul: UInt32,
        u32Add: UInt32,
        foldMul: UInt64,
        foldAdd: UInt64,
        foldTable: Int,
        linearMul: UInt64,
        foldedMul: UInt64,
        linearAdd: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        let affine = try u32Affine63c278(
            word,
            index: index,
            mulTable: mulTable,
            addTable: addTable,
            tables: tables
        )
        let w = affine &* u32Mul &+ u32Add
        let folded = try fold63c278(
            UInt64(w) &* foldMul &+ foldAdd,
            tableOffset: foldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* linearMul
            &+ folded &* foldedMul
            &+ linearAdd
    }

    private static func builder6473d0TenthAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0TenthA0U32Mul &+ builder6473d0TenthA0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0TenthAMulTable,
                addTable: builder6473d0TenthAAddTable,
                tables: tables
            ) &* builder6473d0TenthAU32Mul &+ builder6473d0TenthAU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0TenthAFoldMul &+ builder6473d0TenthAFoldAdd,
            tableOffset: builder6473d0TenthAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0TenthALinearMul
            &+ folded &* builder6473d0TenthAFoldedMul
            &+ builder6473d0TenthALinearAdd
    }

    private static func builder6473d0TenthBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0TenthB0U32Mul &+ builder6473d0TenthB0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0TenthBMulTable,
                addTable: builder6473d0TenthBAddTable,
                tables: tables
            ) &* builder6473d0TenthBU32Mul &+ builder6473d0TenthBU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0TenthBFoldMul &+ builder6473d0TenthBFoldAdd,
            tableOffset: builder6473d0TenthBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0TenthBLinearMul
            &+ folded &* builder6473d0TenthBFoldedMul
            &+ builder6473d0TenthBLinearAdd
    }

    private static func builder642f60EighthAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0xcbb0f5d5 &+ 0xbc0ef378
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60EighthAMulTable,
                addTable: builder642f60EighthAAddTable,
                tables: tables
            ) &* 0xf4ade1bb &+ 0x14498d6f
        }
        let folded = try fold63c278(
            UInt64(w) &* 0x9e47779cb45c572f &+ 0x4d028e31657373f8,
            tableOffset: builder642f60EighthAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0xa08be5a120f8c447
            &+ folded &* 0xc729619700000000
            &+ 0x6e392c9a885df52c
    }

    private static func builder642f60EighthBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* 0x667888b5 &+ 0x8f0d98ae
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder642f60EighthBMulTable,
                addTable: builder642f60EighthBAddTable,
                tables: tables
            ) &* 0xea2a6db9 &+ 0x0a1fb246
        }
        let folded = try fold63c278(
            UInt64(w) &* 0x5642541b8c3e3bb7 &+ 0x9965e0d235e6c59b,
            tableOffset: builder642f60EighthBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* 0xb84f64edab558edd
            &+ folded &* 0x82850df500000000
            &+ 0xe5d3a90393662e86
    }

    private static func builder6473d0FirstAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0FirstA0U32Mul &+ builder6473d0FirstA0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0FirstAMulTable,
                addTable: builder6473d0FirstAAddTable,
                tables: tables
            ) &* builder6473d0FirstAU32Mul &+ builder6473d0FirstAU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0FirstAFoldMul &+ builder6473d0FirstAFoldAdd,
            tableOffset: builder6473d0FirstAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0FirstALinearMul
            &+ folded &* builder6473d0FirstAFoldedMul
            &+ builder6473d0FirstALinearAdd
    }

    private static func builder6473d0FirstBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0FirstB0U32Mul &+ builder6473d0FirstB0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0FirstBMulTable,
                addTable: builder6473d0FirstBAddTable,
                tables: tables
            ) &* builder6473d0FirstBU32Mul &+ builder6473d0FirstBU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0FirstBFoldMul &+ builder6473d0FirstBFoldAdd,
            tableOffset: builder6473d0FirstBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0FirstBLinearMul
            &+ folded &* builder6473d0FirstBFoldedMul
            &+ builder6473d0FirstBLinearAdd
    }

    private static func builder6473d0SecondAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0SecondA0U32Mul &+ builder6473d0SecondA0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0SecondAMulTable,
                addTable: builder6473d0SecondAAddTable,
                tables: tables
            ) &* builder6473d0SecondAU32Mul &+ builder6473d0SecondAU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0SecondAFoldMul &+ builder6473d0SecondAFoldAdd,
            tableOffset: builder6473d0SecondAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0SecondALinearMul
            &+ folded &* builder6473d0SecondAFoldedMul
            &+ builder6473d0SecondALinearAdd
    }

    private static func builder6473d0SecondBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0SecondB0U32Mul &+ builder6473d0SecondB0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0SecondBMulTable,
                addTable: builder6473d0SecondBAddTable,
                tables: tables
            ) &* builder6473d0SecondBU32Mul &+ builder6473d0SecondBU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0SecondBFoldMul &+ builder6473d0SecondBFoldAdd,
            tableOffset: builder6473d0SecondBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0SecondBLinearMul
            &+ folded &* builder6473d0SecondBFoldedMul
            &+ builder6473d0SecondBLinearAdd
    }

    private static func builder6473d0ThirdAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0ThirdA0U32Mul &+ builder6473d0ThirdA0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0ThirdAMulTable,
                addTable: builder6473d0ThirdAAddTable,
                tables: tables
            ) &* builder6473d0ThirdAU32Mul &+ builder6473d0ThirdAU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0ThirdAFoldMul &+ builder6473d0ThirdAFoldAdd,
            tableOffset: builder6473d0ThirdAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0ThirdALinearMul
            &+ folded &* builder6473d0ThirdAFoldedMul
            &+ builder6473d0ThirdALinearAdd
    }

    private static func builder6473d0ThirdBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0ThirdB0U32Mul &+ builder6473d0ThirdB0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0ThirdBMulTable,
                addTable: builder6473d0ThirdBAddTable,
                tables: tables
            ) &* builder6473d0ThirdBU32Mul &+ builder6473d0ThirdBU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0ThirdBFoldMul &+ builder6473d0ThirdBFoldAdd,
            tableOffset: builder6473d0ThirdBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0ThirdBLinearMul
            &+ folded &* builder6473d0ThirdBFoldedMul
            &+ builder6473d0ThirdBLinearAdd
    }

    private static func builder6473d0FourthAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0FourthA0U32Mul &+ builder6473d0FourthA0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0FourthAMulTable,
                addTable: builder6473d0FourthAAddTable,
                tables: tables
            ) &* builder6473d0FourthAU32Mul &+ builder6473d0FourthAU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0FourthAFoldMul &+ builder6473d0FourthAFoldAdd,
            tableOffset: builder6473d0FourthAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0FourthALinearMul
            &+ folded &* builder6473d0FourthAFoldedMul
            &+ builder6473d0FourthALinearAdd
    }

    private static func builder6473d0FourthBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0FourthB0U32Mul &+ builder6473d0FourthB0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0FourthBMulTable,
                addTable: builder6473d0FourthBAddTable,
                tables: tables
            ) &* builder6473d0FourthBU32Mul &+ builder6473d0FourthBU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0FourthBFoldMul &+ builder6473d0FourthBFoldAdd,
            tableOffset: builder6473d0FourthBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0FourthBLinearMul
            &+ folded &* builder6473d0FourthBFoldedMul
            &+ builder6473d0FourthBLinearAdd
    }

    private static func builder6473d0FifthAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0FifthA0U32Mul &+ builder6473d0FifthA0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0FifthAMulTable,
                addTable: builder6473d0FifthAAddTable,
                tables: tables
            ) &* builder6473d0FifthAU32Mul &+ builder6473d0FifthAU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0FifthAFoldMul &+ builder6473d0FifthAFoldAdd,
            tableOffset: builder6473d0FifthAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0FifthALinearMul
            &+ folded &* builder6473d0FifthAFoldedMul
            &+ builder6473d0FifthALinearAdd
    }

    private static func builder6473d0FifthBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0FifthB0U32Mul &+ builder6473d0FifthB0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0FifthBMulTable,
                addTable: builder6473d0FifthBAddTable,
                tables: tables
            ) &* builder6473d0FifthBU32Mul &+ builder6473d0FifthBU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0FifthBFoldMul &+ builder6473d0FifthBFoldAdd,
            tableOffset: builder6473d0FifthBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0FifthBLinearMul
            &+ folded &* builder6473d0FifthBFoldedMul
            &+ builder6473d0FifthBLinearAdd
    }

    private static func builder6473d0SixthAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0SixthA0U32Mul &+ builder6473d0SixthA0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0SixthAMulTable,
                addTable: builder6473d0SixthAAddTable,
                tables: tables
            ) &* builder6473d0SixthAU32Mul &+ builder6473d0SixthAU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0SixthAFoldMul &+ builder6473d0SixthAFoldAdd,
            tableOffset: builder6473d0SixthAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0SixthALinearMul
            &+ folded &* builder6473d0SixthAFoldedMul
            &+ builder6473d0SixthALinearAdd
    }

    private static func builder6473d0SixthBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0SixthB0U32Mul &+ builder6473d0SixthB0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0SixthBMulTable,
                addTable: builder6473d0SixthBAddTable,
                tables: tables
            ) &* builder6473d0SixthBU32Mul &+ builder6473d0SixthBU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0SixthBFoldMul &+ builder6473d0SixthBFoldAdd,
            tableOffset: builder6473d0SixthBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0SixthBLinearMul
            &+ folded &* builder6473d0SixthBFoldedMul
            &+ builder6473d0SixthBLinearAdd
    }

    private static func builder6473d0SixthSP750Word(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0SixthB0U32Mul &+ builder6473d0SixthB0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0SixthAMulTable,
                addTable: builder6473d0SixthAAddTable,
                tables: tables
            ) &* builder6473d0SixthAU32Mul &+ builder6473d0SixthAU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0SixthBFoldMul &+ builder6473d0SixthBFoldAdd,
            tableOffset: builder6473d0SixthBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0SixthBLinearMul
            &+ folded &* builder6473d0SixthBFoldedMul
            &+ builder6473d0SixthBLinearAdd
    }

    private static func builder6473d0SixthSP698Word(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0SixthA0U32Mul &+ builder6473d0SixthA0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0SixthBMulTable,
                addTable: builder6473d0SixthBAddTable,
                tables: tables
            ) &* builder6473d0SixthBU32Mul &+ builder6473d0SixthBU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0SixthAFoldMul &+ builder6473d0SixthAFoldAdd,
            tableOffset: builder6473d0SixthAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0SixthALinearMul
            &+ folded &* builder6473d0SixthAFoldedMul
            &+ builder6473d0SixthALinearAdd
    }

    private static func builder6473d0SeventhSP750Word(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0SeventhSP750A0U32Mul &+ builder6473d0SeventhSP750A0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0SeventhSP750MulTable,
                addTable: builder6473d0SeventhSP750AddTable,
                tables: tables
            ) &* builder6473d0SeventhSP750U32Mul &+ builder6473d0SeventhSP750U32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0SeventhSP750FoldMul &+ builder6473d0SeventhSP750FoldAdd,
            tableOffset: builder6473d0SeventhSP750FoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0SeventhSP750LinearMul
            &+ folded &* builder6473d0SeventhSP750FoldedMul
            &+ builder6473d0SeventhSP750LinearAdd
    }

    private static func builder6473d0SeventhSP698Word(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0SeventhSP698A0U32Mul &+ builder6473d0SeventhSP698A0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0SeventhSP698MulTable,
                addTable: builder6473d0SeventhSP698AddTable,
                tables: tables
            ) &* builder6473d0SeventhSP698U32Mul &+ builder6473d0SeventhSP698U32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0SeventhSP698FoldMul &+ builder6473d0SeventhSP698FoldAdd,
            tableOffset: builder6473d0SeventhSP698FoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0SeventhSP698LinearMul
            &+ folded &* builder6473d0SeventhSP698FoldedMul
            &+ builder6473d0SeventhSP698LinearAdd
    }

    private static func builder6473d0EighthAWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0EighthA0U32Mul &+ builder6473d0EighthA0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0EighthAMulTable,
                addTable: builder6473d0EighthAAddTable,
                tables: tables
            ) &* builder6473d0EighthAU32Mul &+ builder6473d0EighthAU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0EighthAFoldMul &+ builder6473d0EighthAFoldAdd,
            tableOffset: builder6473d0EighthAFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0EighthALinearMul
            &+ folded &* builder6473d0EighthAFoldedMul
            &+ builder6473d0EighthALinearAdd
    }

    private static func builder6473d0EighthBWord(_ word: UInt32, index: Int, tables: SourceTables) throws -> UInt64 {
        let w: UInt32
        if index == 0 {
            w = word &* builder6473d0EighthB0U32Mul &+ builder6473d0EighthB0U32Add
        } else {
            w = try u32Affine63c278(
                word,
                index: index,
                mulTable: builder6473d0EighthBMulTable,
                addTable: builder6473d0EighthBAddTable,
                tables: tables
            ) &* builder6473d0EighthBU32Mul &+ builder6473d0EighthBU32Add
        }
        let folded = try fold63c278(
            UInt64(w) &* builder6473d0EighthBFoldMul &+ builder6473d0EighthBFoldAdd,
            tableOffset: builder6473d0EighthBFoldTable,
            rounds: 8,
            tables: tables
        )
        return UInt64(w) &* builder6473d0EighthBLinearMul
            &+ folded &* builder6473d0EighthBFoldedMul
            &+ builder6473d0EighthBLinearAdd
    }

    private static func convolutionWorkspaceU64(
        aWords: [UInt64],
        bWords: [UInt64],
        baseAdd: UInt64,
        countMul: UInt64,
        productMul: UInt64,
        sumAMul: UInt64,
        sumBMul: UInt64,
        finalMul: UInt64,
        finalAdd: UInt64
    ) -> Data {
        let aPrefix = prefixSumsU64(aWords)
        let bPrefix = prefixSumsU64(bWords)
        var out = Data()
        out.reserveCapacity(44 * 8)

        for index in 0..<44 {
            let start = max(0, index - 21)
            let end = min(index, 21)
            if start > end {
                out.append(contentsOf: u64LEBytes(baseAdd &* finalMul &+ finalAdd))
                continue
            }
            var productSum: UInt64 = 0
            for pos in start...end {
                productSum = productSum &+ (aWords[pos] &* bWords[index - pos])
            }
            let sumA = rangeSumFromPrefix(aPrefix, start: start, end: end)
            let sumB = rangeSumFromPrefix(bPrefix, start: index - end, end: index - start)
            let mixed = UInt64(end - start + 1) &* countMul
                &+ baseAdd
                &+ productSum &* productMul
                &+ sumA &* sumAMul
                &+ sumB &* sumBMul
            out.append(contentsOf: u64LEBytes(mixed &* finalMul &+ finalAdd))
        }
        return out
    }

    private static func prefixSumsU64(_ words: [UInt64]) -> [UInt64] {
        var total: UInt64 = 0
        var out: [UInt64] = []
        out.reserveCapacity(words.count)
        for word in words {
            total = total &+ word
            out.append(total)
        }
        return out
    }

    private static func shiftedPrefixSumsU64(_ words: [UInt64]) -> [UInt64] {
        var total: UInt64 = 0
        var out: [UInt64] = [0]
        out.reserveCapacity(words.count + 1)
        for word in words {
            total = total &+ word
            out.append(total)
        }
        return out
    }

    private static func rangeSumFromPrefix(_ prefix: [UInt64], start: Int, end: Int) -> UInt64 {
        if start > end {
            return 0
        }
        let total = prefix[end]
        if start == 0 {
            return total
        }
        return total &- prefix[start - 1]
    }

    private static func arg0Words63c278(_ arg0: Data) throws -> [UInt32] {
        guard arg0.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort("63c278 arg0", arg0.count, builder63c278VectorBytes)
        }
        let bytes = [UInt8](arg0)
        return (0..<builder63c278VectorWords).map { readUInt32LE(bytes, $0 * 4) }
    }

    private static func u32Affine63c278(
        _ word: UInt32,
        index: Int,
        mulTable: Int,
        addTable: Int,
        tables: SourceTables
    ) throws -> UInt32 {
        let tableOffset = (index * 4) & 0x1c
        let multiplier = try u32TableWord63c278(mulTable + tableOffset, tables: tables)
        let addend = try u32TableWord63c278(addTable + tableOffset, tables: tables)
        return UInt32((UInt64(word) &* UInt64(multiplier) &+ UInt64(addend)) & 0xffff_ffff)
    }

    private static func u32Affine633fa8Tail(
        _ word: UInt32,
        index: Int,
        mulTable: Int,
        addTable: Int,
        tables: SourceTables
    ) throws -> UInt32 {
        let tableOffset = (index * 4) & 0x1c
        let multiplier = try u32TableWord633fa8Tail(mulTable + tableOffset, tables: tables)
        let addend = try u32TableWord633fa8Tail(addTable + tableOffset, tables: tables)
        return UInt32((UInt64(word) &* UInt64(multiplier) &+ UInt64(addend)) & 0xffff_ffff)
    }

    private static func u32AffineInverse63c278(
        _ word: UInt32,
        index: Int,
        mulTable: Int,
        addTable: Int,
        tables: SourceTables
    ) throws -> UInt32 {
        let tableOffset = (index * 4) & 0x1c
        let multiplier = try u32TableWord63c278(mulTable + tableOffset, tables: tables)
        guard multiplier & 1 == 1 else {
            throw FirstPairSourceSliceError.nonInvertibleAffineMultiplier(Int(multiplier))
        }
        let addend = try u32TableWord63c278(addTable + tableOffset, tables: tables)
        let inverse = modularInverseOddUInt32(multiplier)
        return (word &- addend) &* inverse
    }

    private static func u32TableAffine63c278(
        _ word: UInt32,
        mulTable: Int,
        addTable: Int,
        tables: SourceTables
    ) throws -> UInt32 {
        let multiplier = try u32TableWord63c278(mulTable, tables: tables)
        let addend = try u32TableWord63c278(addTable, tables: tables)
        return UInt32((UInt64(word) &* UInt64(multiplier) &+ UInt64(addend)) & 0xffff_ffff)
    }

    private static func u32AffineInverseBytes63c278(
        _ input: Data,
        mulTable: Int,
        addTable: Int,
        label: String,
        tables: SourceTables
    ) throws -> Data {
        guard input.count >= builder63c278VectorBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(label, input.count, builder63c278VectorBytes)
        }
        let bytes = [UInt8](input)
        var out: [UInt8] = []
        out.reserveCapacity(builder63c278VectorBytes)
        for index in 0..<builder63c278VectorWords {
            let word = try u32AffineInverse63c278(
                readUInt32LE(bytes, index * 4),
                index: index,
                mulTable: mulTable,
                addTable: addTable,
                tables: tables
            )
            out.append(contentsOf: u32LEBytes(word))
        }
        return Data(out)
    }

    private static func modularInverseOddUInt32(_ value: UInt32) -> UInt32 {
        var inverse = value
        for _ in 0..<5 {
            inverse = inverse &* (2 &- value &* inverse)
        }
        return inverse
    }

    private static func u32TableWord63c278(_ absoluteOffset: Int, tables: SourceTables) throws -> UInt32 {
        let relative = absoluteOffset - table63c278U32Base
        guard relative >= 0, relative + 4 <= tables.u32Tables63c278.count else {
            throw FirstPairSourceSliceError.tableReadOutOfBounds(
                RuntimeTable.firstPair63c278U32Tables.rawValue,
                absoluteOffset
            )
        }
        return readUInt32LE(tables.u32Tables63c278, relative)
    }

    private static func u32TableWord633fa8Tail(_ absoluteOffset: Int, tables: SourceTables) throws -> UInt32 {
        if absoluteOffset >= table63c278U32Base {
            return try u32TableWord63c278(absoluteOffset, tables: tables)
        }
        let relative = absoluteOffset - table633fa8TailU32LowBase
        guard relative >= 0, relative + 4 <= tables.tailU32LowTables633fa8.count else {
            throw FirstPairSourceSliceError.tableReadOutOfBounds(
                RuntimeTable.firstPair633fa8TailU32LowTables.rawValue,
                absoluteOffset
            )
        }
        return readUInt32LE(tables.tailU32LowTables633fa8, relative)
    }

    private static func foldTableU32Word63c278(_ absoluteOffset: Int, tables: SourceTables) throws -> UInt32 {
        let relative = absoluteOffset - table63c278FoldBase
        guard relative >= 0, relative + 4 <= tables.foldTables63c278.count else {
            throw FirstPairSourceSliceError.tableReadOutOfBounds(
                RuntimeTable.firstPair63c278FoldTables.rawValue,
                absoluteOffset
            )
        }
        return readUInt32LE(tables.foldTables63c278, relative)
    }

    private static func foldTableU64Word63c278(_ absoluteOffset: Int, tables: SourceTables) throws -> UInt64 {
        let relative = absoluteOffset - table63c278FoldBase
        guard relative >= 0, relative + 8 <= tables.foldTables63c278.count else {
            throw FirstPairSourceSliceError.tableReadOutOfBounds(
                RuntimeTable.firstPair63c278FoldTables.rawValue,
                absoluteOffset
            )
        }
        return readUInt64LE(tables.foldTables63c278, relative)
    }

    private static func u32WordsFromTableSegments(
        _ segments: [(offset: Int, byteCount: Int)],
        tables: SourceTables
    ) throws -> [UInt32] {
        var out: [UInt32] = []
        for segment in segments {
            precondition(segment.byteCount % 4 == 0)
            for offset in stride(from: 0, to: segment.byteCount, by: 4) {
                out.append(try u32TableWord63c278(segment.offset + offset, tables: tables))
            }
        }
        return out
    }

    private static func fold63c278(
        _ value: UInt64,
        tableOffset: Int,
        rounds: Int,
        tables: SourceTables
    ) throws -> UInt64 {
        var folded = value
        for _ in 0..<rounds {
            let relative = tableOffset - table63c278FoldBase + Int(folded & 0x0f) * 8
            guard relative >= 0, relative + 8 <= tables.foldTables63c278.count else {
                throw FirstPairSourceSliceError.tableReadOutOfBounds(
                    RuntimeTable.firstPair63c278FoldTables.rawValue,
                    tableOffset
                )
            }
            folded = readUInt64LE(tables.foldTables63c278, relative) &+ (folded >> 4)
        }
        return folded
    }

    private static func fold633fa8Tail(
        _ value: UInt64,
        tableOffset: Int,
        rounds: Int,
        tables: SourceTables
    ) throws -> UInt64 {
        var folded = value
        for _ in 0..<rounds {
            let relative = tableOffset - table633fa8TailFoldBase + Int(folded & 0x0f) * 8
            guard relative >= 0, relative + 8 <= tables.tailFoldTables633fa8.count else {
                throw FirstPairSourceSliceError.tableReadOutOfBounds(
                    RuntimeTable.firstPair633fa8TailFoldTables.rawValue,
                    tableOffset
                )
            }
            folded = readUInt64LE(tables.tailFoldTables633fa8, relative) &+ (folded >> 4)
        }
        return folded
    }

    private static func builderProcess2P5PublicScalarQwordsFromEntropy(
        entropy11A: Data
    ) throws -> [UInt64] {
        let x1Source = try builder633fa8NullPublicEntrySourceFromEntropy(entropy11A: entropy11A)
        let aSourceWords = try builderProcess2P5PublicASourceWordsFromEntryArgSource(x1Source)
        let bSourceWords = process2P5PublicBSourceStaticWords
        let initialWorkspace = try builderProcess2P5PublicInitialWorkspaceFromSourceWords(
            aSourceWords: aSourceWords,
            bSourceWords: bSourceWords
        )
        let table35d8 = try builderProcess2P5PublicTable35d8FromSourceWords(
            builder633fa8InvariantWords2dfc
        )
        let lowPrefix = try builderProcess2P5PublicLowPrefixFromTable(
            table35d8,
            seed80: builder633fa8InvariantSeed3110
        )

        var highStack = [UInt8](repeating: 0, count: 0x360 + 42 * 8)
        let repeated = table35d8[7]
        for offset in [0x140, 0x148, 0x150, 0x158, 0x160, 0x168, 0x170] {
            writeUInt64LE(repeated, into: &highStack, at: offset)
        }
        for (index, value) in initialWorkspace.enumerated() {
            writeUInt64LE(value, into: &highStack, at: 0x360 + index * 8)
        }

        return try builderProcess2P5PublicQwordsFromPreframe(
            lowPrefix: lowPrefix,
            highStack: highStack
        )
    }

    private static func builderProcess2P5PublicASourceWordsFromEntryArgSource(
        _ source11A: Data
    ) throws -> [UInt32] {
        guard source11A.count == 0x11a else {
            throw FirstPairSourceSliceError.invalidProcess2P5PublicSourceLength(source11A.count)
        }
        let tables = try cachedTables.get()
        let source = [UInt8](source11A)
        let prelude = try vm6420d8(
            magic: process2P5PublicASourceInitialMagic,
            src1: source,
            src2: source,
            tables: tables
        )
        try require(prelude, count: 0x10a, label: "process2(5) public prelude")

        var seedInputs: [UInt8] = []
        seedInputs.reserveCapacity(builder633fa8ScalarWordCount * 0x10)
        for index in 0..<19 {
            let start = index * 0x0e
            seedInputs.append(contentsOf: prelude[start..<(start + 0x10)])
        }
        seedInputs.append(contentsOf: try process2P5PublicTableBlock(
            libOffset: process2P5PublicASourceStaticTailBlock,
            byteCount: 0x10,
            tables: tables
        ))

        var seedBlocks: [UInt8] = []
        seedBlocks.reserveCapacity(builder633fa8ScalarWordCount * 0x10)
        for index in 0..<builder633fa8ScalarWordCount {
            let start = index * 0x10
            let block = Array(seedInputs[start..<(start + 0x10)])
            seedBlocks.append(contentsOf: try vm638840(
                magic: process2P5PublicASourceBlockMagic,
                src1: block,
                src2: block,
                tables: tables
            ))
        }

        var initCLane = try process2P5PublicTableBlock(
            libOffset: process2P5PublicASourceStaticCTable,
            byteCount: 0x10,
            tables: tables
        )
        initCLane.append(contentsOf: [0x06, 0x06])
        let staticALane = try process2P5PublicTableBlock(
            libOffset: process2P5PublicASourceStaticATable,
            byteCount: 0x12,
            tables: tables
        )

        var out: [UInt32] = []
        out.reserveCapacity(builder633fa8ScalarWordCount)
        for outerIndex in 0..<builder633fa8ScalarWordCount {
            let lane = outerIndex & 7
            let eSource = try process2P5PublicTableBlock(
                libOffset: process2P5PublicASourceStaticETable + 0x12 * lane,
                byteCount: 0x12,
                tables: tables
            )
            let dSource = try process2P5PublicTableBlock(
                libOffset: process2P5PublicASourceStaticDTable + 0x12 * lane,
                byteCount: 0x12,
                tables: tables
            )
            let blockOffset = outerIndex * 0x10
            let block = Array(seedBlocks[blockOffset..<(blockOffset + 0x10)])

            var bLane = try vm638840(
                magic: process2P5PublicASourceBInitMagic,
                src1: eSource,
                src2: eSource,
                tables: tables
            )
            let dLaneInitial = try vm6420d8(
                magic: process2P5PublicASourceDInitMagic,
                src1: block,
                src2: block,
                tables: tables
            )
            var eLane = try vm638840(
                magic: process2P5PublicASourcePrebridgeMagic,
                src1: bLane,
                src2: bLane,
                tables: tables
            )
            var cLane = initCLane

            for _ in 0..<28 {
                let fLane = try vm638840(
                    magic: process2P5PublicASourceFMagic,
                    src1: dLaneInitial,
                    src2: cLane,
                    tables: tables
                )
                let aLane = try vm638840(
                    magic: process2P5PublicASourceAMagic,
                    src1: staticALane,
                    src2: fLane,
                    tables: tables
                )
                let tLane = try vm638840(
                    magic: process2P5PublicASourceTMagic,
                    src1: bLane,
                    src2: aLane,
                    tables: tables
                )
                eLane = try vm638840(
                    magic: process2P5PublicASourceBMixMagic,
                    src1: eLane,
                    src2: tLane,
                    tables: tables
                )
                bLane = try vm638840(
                    magic: process2P5PublicASourceEAdvanceMagic,
                    src1: bLane,
                    src2: bLane,
                    tables: tables
                )
                cLane = try vm638840(
                    magic: process2P5PublicASourceCAdvanceMagic,
                    src1: cLane,
                    src2: cLane,
                    tables: tables
                )
            }

            let fLane = try vm638840(
                magic: process2P5PublicASourcePostFMagic,
                src1: eLane,
                src2: bLane,
                tables: tables
            )
            let dLane = try vm638840(
                magic: process2P5PublicASourcePostDMagic,
                src1: fLane,
                src2: dSource,
                tables: tables
            )
            var packELane = try vm641fcc(
                magic: process2P5PublicASourcePostEMagic,
                src: dLane,
                tables: tables
            )

            var packedLane = [UInt8](repeating: 0, count: 4)
            var shift = 32
            for packIndex in 0..<8 {
                let cWord = try vm638840(
                    magic: process2P5PublicASourcePackCMagic,
                    src1: packELane,
                    src2: packELane,
                    tables: tables
                )
                if shift >= 5 {
                    packELane = try vm6420d8(
                        magic: process2P5PublicASourcePackEMagic,
                        src1: packELane,
                        src2: packELane,
                        tables: tables
                    )
                }
                let bWord = try vm638840(
                    magic: process2P5PublicASourcePackBMagic,
                    src1: cWord,
                    src2: cWord,
                    tables: tables
                )

                let selected = Int(bWord[2]) ^ (Int(bWord[3]) << 3)
                let packed = try process2P5PublicTableByte(
                    libOffset: process2P5PublicASourceNibbleTable + selected,
                    tables: tables
                )
                var nibble = (packIndex & 1) == 0 ? (packed & 0x0f) : (packed >> 4)
                if shift < 4 {
                    let mask = shift == 0 ? 0 : UInt8((1 << shift) - 1)
                    nibble &= mask
                }

                let byteIndex = packIndex >> 1
                if (packIndex & 1) == 0 {
                    packedLane[byteIndex] = nibble
                } else {
                    packedLane[byteIndex] ^= nibble << 4
                }
                shift = max(shift - 4, 0)
            }

            out.append(readUInt32LE(packedLane, 0))
        }
        return out
    }

    private static func builderProcess2P5PublicInitialWorkspaceFromSourceWords(
        aSourceWords: [UInt32],
        bSourceWords: [UInt32]
    ) throws -> [UInt64] {
        let (aPrefix, bPrefix) = try builderProcess2P5PublicInitialPrefixesFromSourceWords(
            aSourceWords: aSourceWords,
            bSourceWords: bSourceWords
        )
        return try builderProcess2P5PublicInitialWorkspaceFromPrefixes(
            aPrefix: aPrefix,
            bPrefix: bPrefix
        )
    }

    private static func builderProcess2P5PublicInitialPrefixesFromSourceWords(
        aSourceWords: [UInt32],
        bSourceWords: [UInt32]
    ) throws -> ([UInt64], [UInt64]) {
        guard aSourceWords.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalidProcess2P5PublicWordCount("A-prefix", aSourceWords.count)
        }
        guard bSourceWords.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalidProcess2P5PublicWordCount("B-prefix", bSourceWords.count)
        }
        let tables = try cachedTables.get()

        var aValues: [UInt64] = []
        aValues.reserveCapacity(builder633fa8ScalarWordCount)
        var word = aSourceWords[0]
            &* process2P5PublicPrefixAInitWordMul
            &+ process2P5PublicPrefixAInitWordAdd
        aValues.append(try builderProcess2P5PublicPrefixQword(
            word,
            foldTable: process2P5PublicPrefixAFoldTable,
            qwordMul: process2P5PublicPrefixAQwordMul,
            qwordAdd: process2P5PublicPrefixAQwordAdd,
            foldMul: process2P5PublicPrefixAFoldMul,
            finalMul: process2P5PublicPrefixAFinalMul,
            finalAdd: process2P5PublicPrefixAFinalAdd,
            tables: tables
        ))
        for index in 1..<builder633fa8ScalarWordCount {
            let tableOffset = (index << 2) & 0x1c
            word = aSourceWords[index]
                &* (try u32TableWord63c278(process2P5PublicPrefixAWordMulTable + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(process2P5PublicPrefixAWordAddTable + tableOffset, tables: tables))
            word = word
                &* process2P5PublicPrefixAWordMul
                &+ process2P5PublicPrefixAWordAdd
            aValues.append(try builderProcess2P5PublicPrefixQword(
                word,
                foldTable: process2P5PublicPrefixAFoldTable,
                qwordMul: process2P5PublicPrefixAQwordMul,
                qwordAdd: process2P5PublicPrefixAQwordAdd,
                foldMul: process2P5PublicPrefixAFoldMul,
                finalMul: process2P5PublicPrefixAFinalMul,
                finalAdd: process2P5PublicPrefixAFinalAdd,
                tables: tables
            ))
        }

        var bValues: [UInt64] = []
        bValues.reserveCapacity(builder633fa8ScalarWordCount)
        word = bSourceWords[0]
            &* process2P5PublicPrefixBInitWordMul
            &+ process2P5PublicPrefixBInitWordAdd
        bValues.append(try builderProcess2P5PublicPrefixQword(
            word,
            foldTable: process2P5PublicPrefixBFoldTable,
            qwordMul: process2P5PublicPrefixBQwordMul,
            qwordAdd: process2P5PublicPrefixBQwordAdd,
            foldMul: process2P5PublicPrefixBFoldMul,
            finalMul: process2P5PublicPrefixBFinalMul,
            finalAdd: process2P5PublicPrefixBFinalAdd,
            tables: tables
        ))
        for index in 1..<builder633fa8ScalarWordCount {
            let tableOffset = (index & 7) << 2
            word = bSourceWords[index]
                &* (try u32TableWord63c278(process2P5PublicPrefixBWordMulTable + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(process2P5PublicPrefixBWordAddTable + tableOffset, tables: tables))
            word = word
                &* process2P5PublicPrefixBWordMul
                &+ process2P5PublicPrefixBWordAdd
            bValues.append(try builderProcess2P5PublicPrefixQword(
                word,
                foldTable: process2P5PublicPrefixBFoldTable,
                qwordMul: process2P5PublicPrefixBQwordMul,
                qwordAdd: process2P5PublicPrefixBQwordAdd,
                foldMul: process2P5PublicPrefixBFoldMul,
                finalMul: process2P5PublicPrefixBFinalMul,
                finalAdd: process2P5PublicPrefixBFinalAdd,
                tables: tables
            ))
        }

        return (cumulativeQwords(aValues), cumulativeQwords(bValues))
    }

    private static func builderProcess2P5PublicInitialWorkspaceFromPrefixes(
        aPrefix: [UInt64],
        bPrefix: [UInt64]
    ) throws -> [UInt64] {
        guard aPrefix.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalidProcess2P5PublicQwordCount("A-prefix", aPrefix.count)
        }
        guard bPrefix.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalidProcess2P5PublicQwordCount("B-prefix", bPrefix.count)
        }

        let aVec = diffCumulativeQwords(aPrefix)
        let bVec = diffCumulativeQwords(bPrefix)
        let constants = process2P5PublicInitWorkspaceConstants
        var out: [UInt64] = []
        out.reserveCapacity(42)
        for index in 0..<42 {
            let low = max(0, index - 19)
            let high = min(index, 19)
            let productSum: UInt64
            let aSum: UInt64
            let bSum: UInt64
            let count: Int
            if low <= high {
                var product: UInt64 = 0
                for bIndex in low...high {
                    product = product &+ aVec[index - bIndex] &* bVec[bIndex]
                }
                productSum = product

                var aWindow = aPrefix[index - low]
                if index - high - 1 >= 0 {
                    aWindow = aWindow &- aPrefix[index - high - 1]
                }
                aSum = aWindow

                var bWindow = bPrefix[high]
                if low != 0 {
                    bWindow = bWindow &- bPrefix[low - 1]
                }
                bSum = bWindow
                count = high - low + 1
            } else {
                productSum = 0
                aSum = 0
                bSum = 0
                count = 0
            }

            var value = UInt64(count) &* constants.countMul &+ constants.countAdd
            value = value &+ productSum &* constants.productMul
            value = value &+ bSum &* constants.bPrefixMul
            value = value &+ aSum &* constants.aPrefixMul
            value = value &* constants.finalMul &+ constants.finalAdd
            out.append(value)
        }
        return out
    }

    private static func builderProcess2P5PublicTable35d8FromSourceWords(
        _ sourceWords: [UInt32]
    ) throws -> [UInt64] {
        guard sourceWords.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalidProcess2P5PublicWordCount("table35d8", sourceWords.count)
        }
        let tables = try cachedTables.get()
        var out: [UInt64] = []
        out.reserveCapacity(builder633fa8ScalarWordCount)
        for (index, sourceWord) in sourceWords.enumerated() {
            let tableOffset = (index << 2) & 0x1c
            var word = sourceWord
                &* (try u32TableWord63c278(process2P5PublicTableU32MulTable + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(process2P5PublicTableU32AddTable + tableOffset, tables: tables))
            word = word
                &* process2P5PublicTableWordMul
                &+ process2P5PublicTableWordAdd

            var qword = UInt64(word)
                &* process2P5PublicTableQwordMul
                &+ process2P5PublicTableQwordAdd
            qword = try foldProcess2P5Public(
                qword,
                tableOffset: process2P5PublicTableFoldTable,
                rounds: 8,
                tables: tables
            )
            let folded = qword &* process2P5PublicTableFoldMul
            out.append(
                UInt64(word) &* process2P5PublicTableFinalMul
                &+ folded
                &+ process2P5PublicTableFinalAdd
            )
        }
        return out
    }

    private static func builderProcess2P5PublicLowPrefixFromTable(
        _ qwords35d8: [UInt64],
        seed80: UInt64
    ) throws -> [UInt8] {
        guard qwords35d8.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalidProcess2P5PublicQwordCount("low-prefix table", qwords35d8.count)
        }
        var out = [UInt8](repeating: 0, count: 0xb0)
        writeUInt64LE(
            seed80 &* process2P5PublicLowA8Mul &+ process2P5PublicLowA8Add,
            into: &out,
            at: 0xa8
        )
        writeUInt64LE(
            seed80 &* process2P5PublicLow80Mul &+ process2P5PublicLow80Add,
            into: &out,
            at: 0x80
        )
        for (lowOffset, tableIndex) in process2P5PublicLowCopyOffsets {
            writeUInt64LE(qwords35d8[tableIndex], into: &out, at: lowOffset)
        }
        return out
    }

    private static func builderProcess2P5PublicQwordsFromPreframe(
        lowPrefix: [UInt8],
        highStack: [UInt8]
    ) throws -> [UInt64] {
        let workspaces = try builderProcess2P5PublicQwordWorkspacesFromPreframe(
            lowPrefix: lowPrefix,
            highStack: highStack
        )
        return Array(workspaces[workspaces.count - 1][22..<42])
    }

    private static func builderProcess2P5PublicQwordWorkspacesFromPreframe(
        lowPrefix: [UInt8],
        highStack: [UInt8]
    ) throws -> [[UInt64]] {
        try require(lowPrefix, count: 0xb0, label: "process2(5) qword low prefix")
        try require(highStack, count: 0x360 + 42 * 8, label: "process2(5) qword high stack")
        let tables = try cachedTables.get()

        let low28 = readUInt64LE(lowPrefix, 0x28)
        let low30 = readUInt64LE(lowPrefix, 0x30)
        let low38 = readUInt64LE(lowPrefix, 0x38)
        let low40 = readUInt64LE(lowPrefix, 0x40)
        let low48 = readUInt64LE(lowPrefix, 0x48)
        let low50 = readUInt64LE(lowPrefix, 0x50)
        let low58 = readUInt64LE(lowPrefix, 0x58)
        let low60 = readUInt64LE(lowPrefix, 0x60)
        let low68 = readUInt64LE(lowPrefix, 0x68)
        let low70 = readUInt64LE(lowPrefix, 0x70)
        let low78 = readUInt64LE(lowPrefix, 0x78)
        let low80 = readUInt64LE(lowPrefix, 0x80)
        let low88 = readUInt64LE(lowPrefix, 0x88)
        let low90 = readUInt64LE(lowPrefix, 0x90)
        let lowA8 = readUInt64LE(lowPrefix, 0xa8)

        var workspace = (0..<42).map { readUInt64LE(highStack, 0x360 + $0 * 8) }
        var x22 = workspace[0]
        let x6 = readUInt64LE(highStack, 0x140)
        let x19 = readUInt64LE(highStack, 0x148)
        let x21 = readUInt64LE(highStack, 0x150)
        let x23 = readUInt64LE(highStack, 0x158)
        let x24 = readUInt64LE(highStack, 0x160)
        let x26 = readUInt64LE(highStack, 0x168)
        let x28 = readUInt64LE(highStack, 0x170)

        var workspaces = [workspace]
        workspaces.reserveCapacity(23)
        for index in 0..<22 {
            let reg15 = low88
            let reg2 = low50
            let reg1 = low58
            var reg4 = low40
            var reg3 = low48

            var state = x22 &* lowA8 &+ low80
            var folded = try foldProcess2P5Public(
                state &* 0x87d6a191657cf88b &+ 0x55ab3c8b3f81c5ea,
                tableOffset: process2P5PublicQwordFoldTableA,
                rounds: 7,
                tables: tables
            )
            state = state &* 0x5513e20130c294ff
                &+ folded &* 0x097f450230000000
                &+ 0x65416d6b1d6e1cbc
            let x27 = state &* 0xde9a0217389253bb &+ 0x7368784697fb3dc5
            let x20 = state &* 0x0421be0fdc09a97cf &+ 0x492946def7da33b1

            reg3 = x27 &* reg3 &+ x20
            let x22Head = x27 &* low90 &+ x20 &+ x22
            reg4 = x27 &* reg4 &+ x20

            folded = try foldProcess2P5Public(
                x22Head &* 0xe991db2a5d2a7fad &+ 0xddaca38024dd36cd,
                tableOffset: process2P5PublicQwordFoldTableB,
                rounds: 7,
                tables: tables
            )
            let x12 = folded &* 0xcf053a359e1d9b81 &+ 0xcfa9a29b5752d274
            folded = try foldProcess2P5Public(
                x12 &* 0x71795e15d000819b &+ 0xf0c1332200ddc903,
                tableOffset: process2P5PublicQwordFoldTableC,
                rounds: 9,
                tables: tables
            )

            let old = Array(workspace[index..<(index + 20)])
            var out = [UInt64](repeating: 0, count: 20)
            out[0] = x22Head
            out[1] = x27 &* reg15 &+ x20 &+ old[1]
            out[2] = x27 &* low78 &+ x20 &+ old[2]
            let acc13 = x27 &* x6 &+ x20
            out[3] = x27 &* low70 &+ x20 &+ old[3]
            out[4] = x27 &* low68 &+ x20 &+ old[4]
            out[5] = x27 &* low60 &+ x20 &+ old[5]
            out[6] = x27 &* reg1 &+ x20 &+ old[6]
            let acc15 = x27 &* x19 &+ x20
            out[7] = x27 &* reg2 &+ x20 &+ old[7]
            out[8] = reg3 &+ old[8]
            let acc0 = x27 &* x21 &+ x20
            out[9] = reg4 &+ old[9]
            let acc2 = x27 &* low38 &+ x20
            out[10] = acc2 &+ old[10]
            let acc12 = x27 &* low30 &+ x20
            out[11] = acc12 &+ old[11]
            let acc22 = x27 &* low28 &+ x20
            out[12] = acc22 &+ old[12]
            let acc14 = x27 &* x23 &+ x20
            let acc1 = x27 &* x24 &+ x20
            out[13] = acc13 &+ old[13]
            out[14] = acc15 &+ old[14]
            let acc16 = x27 &* x26 &+ x20
            let acc15Tail = x27 &* x28 &+ x20
            out[15] = acc0 &+ old[15]
            out[16] = acc14 &+ old[16]

            var finalAcc = folded &* 0x7a1cf7b000000000
                &+ x12 &* 0x85a6c1a6777a6587
            finalAcc = finalAcc &* 0xbf59bd30f12b2173 &+ out[1]
            out[17] = acc1 &+ old[17]
            out[18] = acc16 &+ old[18]
            out[19] = acc15Tail &+ old[19]
            x22 = finalAcc &+ 0x0ba9328bc380f3f5
            out[1] = x22

            for (outIndex, value) in out.enumerated() {
                workspace[index + outIndex] = value
            }
            workspaces.append(workspace)
        }
        return workspaces
    }

    private static func builderProcess2P5PublicScalarWordsFromQwords(
        _ qwords: [UInt64]
    ) throws -> [UInt32] {
        guard qwords.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalidProcess2P5PublicQwordCount("scalar words", qwords.count)
        }
        let tables = try cachedTables.get()
        var state: UInt64 = 0x8e047df005b7774b
        var out: [UInt32] = []
        out.reserveCapacity(builder633fa8ScalarWordCount)
        for (index, qword) in qwords.enumerated() {
            state = state &* 0x4f9b1e335b5175b1
                &+ qword &* 0xddc0126ec4f0da8b
                &+ 0x807a205bcf09b957
            let foldedSeed = state &* 0x0cc6d1cb7a71ea27 &+ 0x75f17a53af690cbc
            let folded7 = try foldProcess2P5Public(
                foldedSeed,
                tableOffset: process2P5PublicScalarQwordFoldTable,
                rounds: 7,
                tables: tables
            )
            var word = UInt32(
                (
                    UInt64(UInt32(truncatingIfNeeded: state)) &* 0xb904cc8b
                    &+ UInt64(UInt32(truncatingIfNeeded: folded7)) &* 0x30000000
                    &+ 0x7733dbc5
                ) & 0xffff_ffff
            )
            let folded16 = try foldProcess2P5Public(
                folded7,
                tableOffset: process2P5PublicScalarQwordFoldTable,
                rounds: 9,
                tables: tables
            )
            let tableOffset = (index * 4) & 0x1c
            word = word
                &* (try u32TableWord63c278(process2P5PublicScalarQwordMulTable + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(process2P5PublicScalarQwordAddTable + tableOffset, tables: tables))
            out.append(word)

            state = folded7 &* 0xf5b69300c49039c7
                &+ folded16 &* 0xb6fc639000000000
                &+ 0x5c589cf77e794af2
        }
        return out
    }

    private static func builderProcess2P5PublicScalarWindowFromWords(
        _ words: [UInt32]
    ) throws -> Data {
        guard words.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalidProcess2P5PublicWordCount("scalar pack", words.count)
        }
        let tables = try cachedTables.get()
        var out = [UInt8](repeating: 0, count: builder633fa8ScalarWindowBytes)
        var acc: UInt64 = 0
        var bits = 0
        var outIndex = 0
        for (index, word) in words.enumerated() {
            let tableOffset = (index * 4) & 0x1c
            var value = word
                &* (try u32TableWord63c278(process2P5PublicScalarPackMulTable + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(process2P5PublicScalarPackAddTable + tableOffset, tables: tables))
            value = value &* 0x0b6afc2f &+ 0x4608a396

            acc ^= UInt64(value) << UInt64(bits)
            bits += 28
            while bits > 16 && outIndex < 69 {
                out[outIndex] = UInt8(acc & 0xff)
                acc >>= 8
                outIndex += 1
                bits -= 8
            }
        }
        if bits >= 1 && outIndex < 69 {
            out[outIndex] = UInt8(acc & 0xff)
        }
        return Data(out)
    }

    private static func builderProcess2P5PublicPrefixQword(
        _ word: UInt32,
        foldTable: Int,
        qwordMul: UInt64,
        qwordAdd: UInt64,
        foldMul: UInt64,
        finalMul: UInt64,
        finalAdd: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        let folded = try foldProcess2P5Public(
            UInt64(word) &* qwordMul &+ qwordAdd,
            tableOffset: foldTable,
            rounds: 8,
            tables: tables
        )
        return folded &* foldMul
            &+ UInt64(word) &* finalMul
            &+ finalAdd
    }

    private static func diffCumulativeQwords(_ prefixes: [UInt64]) -> [UInt64] {
        guard !prefixes.isEmpty else { return [] }
        var out = [prefixes[0]]
        out.reserveCapacity(prefixes.count)
        for index in 1..<prefixes.count {
            out.append(prefixes[index] &- prefixes[index - 1])
        }
        return out
    }

    private static func cumulativeQwords(_ values: [UInt64]) -> [UInt64] {
        var total: UInt64 = 0
        var out: [UInt64] = []
        out.reserveCapacity(values.count)
        for value in values {
            total = total &+ value
            out.append(total)
        }
        return out
    }

    private static func process2P5PublicTableBlock(
        libOffset: Int,
        byteCount: Int,
        tables: SourceTables
    ) throws -> [UInt8] {
        let relative = libOffset - process2P5PublicTableBase
        guard relative >= 0, relative + byteCount <= tables.process2PublicTables.count else {
            throw FirstPairSourceSliceError.tableReadOutOfBounds(
                RuntimeTable.firstPairProcess2PublicTables.rawValue,
                libOffset
            )
        }
        return Array(tables.process2PublicTables[relative..<(relative + byteCount)])
    }

    private static func process2P5PublicTableByte(
        libOffset: Int,
        tables: SourceTables
    ) throws -> UInt8 {
        try process2P5PublicTableBlock(libOffset: libOffset, byteCount: 1, tables: tables)[0]
    }

    private static func process2P5PublicTableUInt64(
        libOffset: Int,
        tables: SourceTables
    ) throws -> UInt64 {
        let bytes = try process2P5PublicTableBlock(libOffset: libOffset, byteCount: 8, tables: tables)
        return readUInt64LE(bytes, 0)
    }

    private static func foldProcess2P5Public(
        _ value: UInt64,
        tableOffset: Int,
        rounds: Int,
        tables: SourceTables
    ) throws -> UInt64 {
        var folded = value
        for _ in 0..<rounds {
            folded = try process2P5PublicTableUInt64(
                libOffset: tableOffset + Int(folded & 0x0f) * 8,
                tables: tables
            ) &+ (folded >> 4)
        }
        return folded
    }

    private static func builder633fa8TailStreamU64(
        _ word: UInt32,
        wordMul: UInt64,
        wordAdd: UInt64,
        foldTable: Int,
        foldMul: UInt64,
        mixMul: UInt64,
        mixAdd: UInt64,
        tables: SourceTables
    ) throws -> UInt64 {
        let folded = try fold633fa8Tail(
            UInt64(word) &* wordMul &+ wordAdd,
            tableOffset: foldTable,
            rounds: 8,
            tables: tables
        )
        return folded &* foldMul &+ UInt64(word) &* mixMul &+ mixAdd
    }

    private static func convolutionWorkspace633fa8Tail(
        stack: inout [UInt8],
        aVectorOffset: Int,
        aPrefixOffset: Int,
        bVectorOffset: Int,
        bPrefixOffset: Int,
        outOffset: Int,
        length: Int,
        outputCount: Int,
        countMul: UInt64,
        countAdd: UInt64,
        productMul: UInt64,
        bPrefixMul: UInt64,
        aPrefixMul: UInt64,
        finalMul: UInt64,
        finalAdd: UInt64
    ) {
        let aVector = (0..<length).map { readUInt64LE(stack, aVectorOffset + $0 * 8) }
        let aPrefix = (0..<length).map { readUInt64LE(stack, aPrefixOffset + $0 * 8) }
        let bVector = (0..<length).map { readUInt64LE(stack, bVectorOffset + $0 * 8) }
        let bPrefix = (0..<length).map { readUInt64LE(stack, bPrefixOffset + $0 * 8) }

        for index in 0..<outputCount {
            let low = max(0, index - (length - 1))
            let high = min(index, length - 1)
            let productSum: UInt64
            let aSum: UInt64
            let bSum: UInt64
            let count: Int
            if low <= high {
                var runningProductSum: UInt64 = 0
                for bIndex in low...high {
                    runningProductSum = runningProductSum &+ aVector[index - bIndex] &* bVector[bIndex]
                }
                productSum = runningProductSum

                var runningASum = aPrefix[index - low]
                if index - high - 1 >= 0 {
                    runningASum = runningASum &- aPrefix[index - high - 1]
                }
                aSum = runningASum

                var runningBSum = bPrefix[high]
                if low > 0 {
                    runningBSum = runningBSum &- bPrefix[low - 1]
                }
                bSum = runningBSum
                count = high - low + 1
            } else {
                productSum = 0
                aSum = 0
                bSum = 0
                count = 0
            }

            var out = UInt64(count) &* countMul &+ countAdd
            out = out &+ productSum &* productMul
            out = out &+ bSum &* bPrefixMul
            out = out &+ aSum &* aPrefixMul
            out = out &* finalMul &+ finalAdd
            writeUInt64LE(out, into: &stack, at: outOffset + index * 8)
        }
    }

    private static func unpack3BitStream5bdd14(
        source: [UInt8],
        offset: Int,
        count: Int
    ) throws -> ([UInt8], Int) {
        guard count >= 0 else {
            throw FirstPairSourceSliceError.sourceTooShort("3-bit unpack", count, 0)
        }
        guard offset >= 0 && offset < source.count else {
            throw FirstPairSourceSliceError.sourceTooShort("3-bit unpack source", source.count, offset + 1)
        }

        var pointer = offset
        var bitOffset = 0
        var out: [UInt8] = []
        out.reserveCapacity(count)
        var remaining = count
        while remaining > 0 {
            let currentBit = bitOffset & 0xff
            if currentBit == 8 {
                pointer += 1
                guard pointer < source.count else {
                    throw FirstPairSourceSliceError.sourceTooShort("3-bit unpack source", source.count, pointer + 1)
                }
                out.append(source[pointer] & 7)
                bitOffset = 3
            } else if currentBit == 0 {
                out.append(source[pointer] & 7)
                bitOffset = 3
            } else if currentBit <= 5 {
                out.append((source[pointer] >> UInt8(currentBit)) & 7)
                bitOffset = currentBit + 3
            } else {
                let spanBits = currentBit - 5
                guard pointer + 1 < source.count else {
                    throw FirstPairSourceSliceError.sourceTooShort("3-bit unpack source", source.count, pointer + 2)
                }
                let low = source[pointer] >> UInt8(currentBit)
                let high = source[pointer + 1] & UInt8((1 << spanBits) - 1)
                out.append((low | (high << UInt8(8 - currentBit))) & 7)
                pointer += 1
                bitOffset = spanBits
            }
            remaining -= 1
        }

        pointer += 1
        guard pointer <= source.count else {
            throw FirstPairSourceSliceError.sourceTooShort("3-bit unpack source", source.count, pointer)
        }
        return (out, pointer)
    }

    private static func fold63c278FirstNibbleBeforeAdd(
        _ product: UInt64,
        addend: UInt64,
        tableOffset: Int,
        tables: SourceTables
    ) throws -> UInt64 {
        let relative = tableOffset - table63c278FoldBase + Int(product & 0x0f) * 8
        guard relative >= 0, relative + 8 <= tables.foldTables63c278.count else {
            throw FirstPairSourceSliceError.tableReadOutOfBounds(
                RuntimeTable.firstPair63c278FoldTables.rawValue,
                tableOffset
            )
        }
        let folded = readUInt64LE(tables.foldTables63c278, relative) &+ ((product &+ addend) >> 4)
        return try fold63c278(folded, tableOffset: tableOffset, rounds: 7, tables: tables)
    }

    private static func fold32ByNibbles63c278(
        _ value: UInt32,
        tableOffset: Int,
        rounds: Int,
        tables: SourceTables
    ) throws -> UInt32 {
        var folded = value
        for _ in 0..<rounds {
            let word = try foldTableU32Word63c278(tableOffset + Int(folded & 0x0f) * 4, tables: tables)
            folded = word &+ (folded >> 4)
        }
        return folded
    }

    private static func laneTable6388f0Expand(
        tableOffset: Int,
        selectorByte: UInt8,
        tables: SourceTables
    ) throws -> [UInt8] {
        let rowOffset = tableOffset + Int(selectorByte) * builder6388f0LaneTablePackedRowSize
        let row = try checkedSlice(
            tables.laneTables6388f0,
            rowOffset,
            builder6388f0LaneTablePackedRowSize,
            RuntimeTable.firstPair6388f0LaneTables.rawValue
        )
        var out: [UInt8] = []
        out.reserveCapacity(builder6388f0LaneTableExpandedSize)
        for packed in row {
            out.append(packed & 7)
            out.append((packed >> 3) & 7)
        }
        return out
    }

    private static func lanePrefixed6388f0(prefixWord: UInt32, state18: [UInt8]) throws -> [UInt8] {
        try require(state18, count: 14, label: "6388f0 lane state")
        return u32LEBytes(prefixWord) + Array(state18[0..<14])
    }

    private static func selector6388f0(
        index: Int,
        scheduleWord: UInt32,
        tables: SourceTables
    ) throws -> UInt32 {
        let tableOffset = (index * 4) & 0x1c
        guard tableOffset + 4 <= tables.selectorMul6388f0.count,
              tableOffset + 4 <= tables.selectorAdd6388f0.count else {
            throw FirstPairSourceSliceError.tableReadOutOfBounds(
                RuntimeTable.firstPair6388f0SelectorMul.rawValue,
                tableOffset
            )
        }
        let multiplier = UInt64(readUInt32LE(tables.selectorMul6388f0, tableOffset))
        let addend = UInt64(readUInt32LE(tables.selectorAdd6388f0, tableOffset))
        return UInt32((UInt64(scheduleWord) * multiplier + addend) & 0xffff_ffff)
    }

    private struct LowSeedPhaseSpec {
        let phaseMagic: UInt64
        let auxMagics: [UInt64]
        let e10Magics: [UInt64]
        let e10Markers: [UInt8]
        let bd0Magic: UInt64
        let staticOffset: Int
        let unaryMagic: UInt64
        let f40Magics: [UInt64]
    }

    private struct LowSeedPhaseResult {
        let finalCF0: [UInt8]
    }

    private static func builder6388f0LowSeedPhaseFromCF0Seed(
        spec: LowSeedPhaseSpec,
        seedCF0: [UInt8],
        tables: SourceTables
    ) throws -> LowSeedPhaseResult {
        let count = spec.auxMagics.count
        for (label, valueCount) in [
            ("e10 magics", spec.e10Magics.count),
            ("e10 markers", spec.e10Markers.count),
            ("e10 shifts", builder6388f0LowSeedE10SourceShifts.count),
            ("f40 magics", spec.f40Magics.count),
        ] {
            if valueCount != count {
                throw FirstPairSourceSliceError.invalidLowSeedPhaseInputCount(label, valueCount, count)
            }
        }
        try require(seedCF0, count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed cf0 seed")

        let staticBlock = try builder6388f0LowSeedStaticBlock(libOffset: spec.staticOffset, tables: tables)
        var cf0 = seedCF0
        for index in 0..<count {
            let bd0 = try vm638840(magic: spec.bd0Magic, src1: cf0, src2: staticBlock, tables: tables)
            let ab0 = try vm641fcc(magic: spec.unaryMagic, src: bd0, tables: tables)
            let e10Source = try builder6388f0LowSeedE10SourceFromAB0(
                marker: spec.e10Markers[index],
                shift: builder6388f0LowSeedE10SourceShifts[index],
                ab0: ab0
            )
            let e10 = try vm638840(
                magic: spec.e10Magics[index],
                src1: e10Source,
                src2: e10Source,
                tables: tables
            )
            let f40 = try vm6420d8(
                magic: spec.f40Magics[index],
                src1: ab0,
                src2: ab0,
                tables: tables
            )
            let aux = try vm638840(
                magic: spec.auxMagics[index],
                src1: e10,
                src2: f40,
                tables: tables
            )
            cf0 = try vm638840(magic: spec.phaseMagic, src1: cf0, src2: aux, tables: tables)
        }
        return LowSeedPhaseResult(finalCF0: cf0)
    }

    private static func builder6388f0LowSeedE10SourceFromAB0(
        marker: UInt8,
        shift: Int,
        ab0: [UInt8]
    ) throws -> [UInt8] {
        guard marker <= 7 else {
            throw FirstPairSourceSliceError.invalidLowSeedMarker(Int(marker))
        }
        guard shift >= 1 && shift <= builder6388f0LowSeedBlockBytes else {
            throw FirstPairSourceSliceError.invalidLowSeedShift(shift)
        }
        try require(
            ab0,
            count: builder6388f0LowSeedBlockBytes - shift,
            label: "6388f0 low-seed ab0 source"
        )

        var out = [UInt8](repeating: 0, count: builder6388f0LowSeedBlockBytes)
        out[shift - 1] = marker
        let copyCount = builder6388f0LowSeedBlockBytes - shift
        if copyCount > 0 {
            out.replaceSubrange(shift..<builder6388f0LowSeedBlockBytes, with: ab0[0..<copyCount])
        }
        return out
    }

    private static func builder6388f0LowSeedStaticBlock(libOffset: Int, tables: SourceTables) throws -> [UInt8] {
        let offset = libOffset - builder6388f0LowSeedStaticBase
        return try checkedSlice(
            tables.lowSeedStatics6388f0,
            offset,
            builder6388f0LowSeedBlockBytes,
            RuntimeTable.firstPair6388f0LowSeedStatics.rawValue
        )
    }

    private static func builder6388f0LowLoopStaticBlock(
        libOffset: Int,
        byteCount: Int,
        tables: SourceTables
    ) throws -> [UInt8] {
        let offset = libOffset - builder6388f0LowLoopStaticBase
        return try checkedSlice(
            tables.lowLoopStatics6388f0,
            offset,
            byteCount,
            RuntimeTable.firstPair6388f0LowLoopStatics.rawValue
        )
    }

    private static func builder6388f0LowLoopStaticByte(libOffset: Int, tables: SourceTables) throws -> UInt8 {
        try builder6388f0LowLoopStaticBlock(libOffset: libOffset, byteCount: 1, tables: tables)[0]
    }

    private static func builder633fa8NullTableBlock(
        libOffset: Int,
        byteCount: Int,
        tables: SourceTables
    ) throws -> [UInt8] {
        let offset = libOffset - builder633fa8NullTableBase
        return try checkedSlice(
            tables.nullTables633fa8,
            offset,
            byteCount,
            RuntimeTable.firstPair633fa8NullTables.rawValue
        )
    }

    private static func builder633fa8NullNibbleByte(libOffset: Int, tables: SourceTables) throws -> UInt8 {
        let offset = libOffset - builder633fa8NullNibbleTableBase
        return try checkedSlice(
            tables.nullNibble633fa8,
            offset,
            1,
            RuntimeTable.firstPair633fa8NullNibble.rawValue
        )[0]
    }

    private static func u32TableWord633fa8Null(_ absoluteOffset: Int, tables: SourceTables) throws -> UInt32 {
        let relative = absoluteOffset - builder633fa8NullTableBase
        guard relative >= 0, relative + 4 <= tables.nullTables633fa8.count else {
            throw FirstPairSourceSliceError.tableReadOutOfBounds(
                RuntimeTable.firstPair633fa8NullTables.rawValue,
                absoluteOffset
            )
        }
        return readUInt32LE(tables.nullTables633fa8, relative)
    }

    private static func fold633fa8NullCheck32(
        _ value: UInt32,
        tableOffset: Int,
        rounds: Int,
        tables: SourceTables
    ) throws -> UInt32 {
        var folded = value
        for _ in 0..<rounds {
            folded = try u32TableWord633fa8Null(
                tableOffset + Int(folded & 0x0f) * 4,
                tables: tables
            ) &+ (folded >> 4)
        }
        return folded
    }

    private static func expand3BitPairTableRow633fa8Null(_ raw9: [UInt8]) throws -> [UInt8] {
        guard raw9.count == 9 else {
            throw FirstPairSourceSliceError.sourceTooShort("633fa8 null 3-bit pair row", raw9.count, 9)
        }
        var out: [UInt8] = []
        out.reserveCapacity(builder633fa8NullLoopLaneBytes)
        for value in raw9 {
            out.append(value & 7)
            out.append((value >> 3) & 7)
        }
        return out
    }

    private static func stitch633fa8NullPrelude11A(
        firstBlock: [UInt8],
        restBlocks: [UInt8]
    ) throws -> [UInt8] {
        guard firstBlock.count == builder633fa8NullSeedBlockBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "633fa8 null prelude first stitch block",
                firstBlock.count,
                builder633fa8NullSeedBlockBytes
            )
        }
        let restByteCount = (builder633fa8ScalarWordCount - 1) * builder633fa8NullSeedBlockBytes
        guard restBlocks.count == restByteCount else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "633fa8 null prelude rest stitch blocks",
                restBlocks.count,
                restByteCount
            )
        }

        var out = [UInt8](repeating: 0, count: builder633fa8NullEntropyBytes)
        out.replaceSubrange(0..<builder633fa8NullSeedBlockBytes, with: firstBlock)
        for index in 0..<(builder633fa8ScalarWordCount - 1) {
            let srcStart = index * builder633fa8NullSeedBlockBytes + 2
            let dstStart = builder633fa8NullSeedBlockBytes + index * builder633fa8NullSeedBlockStride
            out.replaceSubrange(
                dstStart..<(dstStart + builder633fa8NullSeedBlockStride),
                with: restBlocks[srcStart..<(srcStart + builder633fa8NullSeedBlockStride)]
            )
        }
        return out
    }

    private static func builder633fa8NullScheduleCheck(
        scheduleWords: [UInt32],
        sourceWords: [UInt32],
        scheduleMulTable: Int,
        sourceMulTable: Int,
        addTable: Int,
        foldTable: Int,
        target: UInt32,
        foldTarget: UInt32,
        tables: SourceTables
    ) throws -> Bool {
        guard scheduleWords.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalid633fa8WordCount(scheduleWords.count)
        }
        guard sourceWords.count == builder633fa8ScalarWordCount else {
            throw FirstPairSourceSliceError.invalid633fa8WordCount(sourceWords.count)
        }

        for index in stride(from: builder633fa8ScalarWordCount - 1, through: 0, by: -1) {
            let tableOffset = (index * 4) & 0x1c
            let word = scheduleWords[index]
                &* (try u32TableWord63c278(scheduleMulTable + tableOffset, tables: tables))
                &+ sourceWords[index]
                    &* (try u32TableWord63c278(sourceMulTable + tableOffset, tables: tables))
                &+ (try u32TableWord63c278(addTable + tableOffset, tables: tables))
            if word == target {
                continue
            }
            let folded = try fold633fa8NullCheck32(word, tableOffset: foldTable, rounds: 7, tables: tables)
            return (folded & 0x0f) == foldTarget
        }
        return true
    }

    private static func builder6388f0LowSeedTailPairFromEntryAndCF0(
        _ entrySource: Data,
        pre2CF0: [UInt8],
        preCF0: [UInt8],
        tailCF0: [UInt8],
        tables: SourceTables
    ) throws -> Builder6388f0LowSeedTailPair {
        guard entrySource.count >= builder6388f0LowSeedEntrySourceBytes else {
            throw FirstPairSourceSliceError.sourceTooShort(
                "6388f0 low-seed entry source",
                entrySource.count,
                builder6388f0LowSeedEntrySourceBytes
            )
        }
        try require(pre2CF0, count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed pre2 cf0")
        try require(preCF0, count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed pre cf0")
        try require(tailCF0, count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed tail cf0")

        let source = [UInt8](entrySource)
        let entryHead = Array(source[0..<builder6388f0LowSeedBlockBytes])
        let entryTail = Array(source[builder6388f0LowSeedBlockBytes..<builder6388f0LowSeedEntrySourceBytes])
        let pre2S898 = try vm638840(
            magic: builder6388f0LowSeedEntryS898Magic,
            src1: entryHead,
            src2: entryHead,
            tables: tables
        )
        let pre2S78E = try vm638840(
            magic: builder6388f0LowSeedEntryS78EMagic,
            src1: entryTail,
            src2: entryTail,
            tables: tables
        )

        let pre2Static = try builder6388f0LowSeedStaticBlock(
            libOffset: builder6388f0LowSeedPrev2Static,
            tables: tables
        )
        let preStatic = try builder6388f0LowSeedStaticBlock(
            libOffset: builder6388f0LowSeedPreStatic,
            tables: tables
        )
        let tailStatic = try builder6388f0LowSeedStaticBlock(
            libOffset: builder6388f0LowSeedTailStatic,
            tables: tables
        )
        let pre2BD0 = try vm638840(
            magic: builder6388f0LowSeedPrev2BD0Magic,
            src1: pre2CF0,
            src2: pre2Static,
            tables: tables
        )
        let pre2S684 = try vm638840(
            magic: builder6388f0LowSeedPrev2S684Magic,
            src1: pre2BD0,
            src2: pre2BD0,
            tables: tables
        )
        let pre2S57A = try vm638840(
            magic: builder6388f0LowSeedMiddleMagic,
            src1: pre2S898,
            src2: pre2S684,
            tables: tables
        )
        let preS898 = try vm638840(
            magic: builder6388f0LowSeedTailLeftMagic,
            src1: pre2S78E,
            src2: pre2S78E,
            tables: tables
        )
        let preS78E = try vm638840(
            magic: builder6388f0LowSeedTailRightMagic,
            src1: pre2S57A,
            src2: pre2S57A,
            tables: tables
        )
        let preBD0 = try vm638840(
            magic: builder6388f0LowSeedPreBD0Magic,
            src1: preCF0,
            src2: preStatic,
            tables: tables
        )
        let tailBD0 = try vm638840(
            magic: builder6388f0LowSeedTailBD0Magic,
            src1: tailCF0,
            src2: tailStatic,
            tables: tables
        )
        return try builder6388f0LowSeedTailPairFromSlotState(
            preS898: preS898,
            preS78E: preS78E,
            preBD0: preBD0,
            tailBD0: tailBD0,
            tables: tables
        )
    }

    private static func builder6388f0LowSeedTailPairFromSlotState(
        preS898: [UInt8],
        preS78E: [UInt8],
        preBD0: [UInt8],
        tailBD0: [UInt8],
        tables: SourceTables
    ) throws -> Builder6388f0LowSeedTailPair {
        try require(preS898, count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed pre s898")
        try require(preS78E, count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed pre s78e")
        try require(preBD0, count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed pre bd0")
        try require(tailBD0, count: builder6388f0LowSeedBlockBytes, label: "6388f0 low-seed tail bd0")

        let prevS684 = try vm638840(
            magic: builder6388f0LowSeedPrevS684Magic,
            src1: preBD0,
            src2: preBD0,
            tables: tables
        )
        let prevS57A = try vm638840(
            magic: builder6388f0LowSeedMiddleMagic,
            src1: preS898,
            src2: prevS684,
            tables: tables
        )
        let seedS898 = try vm638840(
            magic: builder6388f0LowSeedTailLeftMagic,
            src1: preS78E,
            src2: preS78E,
            tables: tables
        )
        let seedS78E = try vm638840(
            magic: builder6388f0LowSeedTailRightMagic,
            src1: prevS57A,
            src2: prevS57A,
            tables: tables
        )
        let tailS684 = try vm638840(
            magic: builder6388f0LowSeedTailS684Magic,
            src1: tailBD0,
            src2: tailBD0,
            tables: tables
        )
        let tailS57A = try vm638840(
            magic: builder6388f0LowSeedMiddleMagic,
            src1: seedS898,
            src2: tailS684,
            tables: tables
        )
        let left = try vm638840(
            magic: builder6388f0LowSeedTailLeftMagic,
            src1: seedS78E,
            src2: seedS78E,
            tables: tables
        )
        let right = try vm638840(
            magic: builder6388f0LowSeedTailRightMagic,
            src1: tailS57A,
            src2: tailS57A,
            tables: tables
        )
        return Builder6388f0LowSeedTailPair(left: Data(left), right: Data(right))
    }

    private struct SourceTables {
        let sbox19: [UInt8]
        let prog64e2b8: [UInt8]
        let prog638840: [UInt8]
        let lowSeedStatics6388f0: [UInt8]
        let lowLoopStatics6388f0: [UInt8]
        let laneTables6388f0: [UInt8]
        let selectorMul6388f0: [UInt8]
        let selectorAdd6388f0: [UInt8]
        let u32Tables63c278: [UInt8]
        let foldTables63c278: [UInt8]
        let tailFoldTables633fa8: [UInt8]
        let tailU32LowTables633fa8: [UInt8]
        let nullTables633fa8: [UInt8]
        let nullNibble633fa8: [UInt8]
        let process2PublicTables: [UInt8]
        let prog67cc18: [UInt8]
        let ttableBExt: [UInt8]
        let finalLenTables: [UInt8]
        let df80RoundTables: [UInt8]
        let finalizerTables: [UInt8]
        let seedTables679f48: [UInt8]
        let reducer67ea28Nibble: [UInt8]
        let prog67076c: [UInt8]
    }

    private static let cachedTables = SuccessCache<SourceTables> {
        let sbox = try Tables.load(.sbox19)
        let prog = try Tables.load(.firstPairProg64e2b8)
        let prog638840 = try Tables.load(.firstPairProg638840)
        let lowSeedStatics6388f0 = try Tables.load(.firstPair6388f0LowSeedStatics)
        let lowLoopStatics6388f0 = try Tables.load(.firstPair6388f0LowLoopStatics)
        let laneTables6388f0 = try Tables.load(.firstPair6388f0LaneTables)
        let selectorMul6388f0 = try Tables.load(.firstPair6388f0SelectorMul)
        let selectorAdd6388f0 = try Tables.load(.firstPair6388f0SelectorAdd)
        let u32Tables63c278 = try Tables.load(.firstPair63c278U32Tables)
        let foldTables63c278 = try Tables.load(.firstPair63c278FoldTables)
        let tailFoldTables633fa8 = try Tables.load(.firstPair633fa8TailFoldTables)
        let tailU32LowTables633fa8 = try Tables.load(.firstPair633fa8TailU32LowTables)
        let nullTables633fa8 = try Tables.load(.firstPair633fa8NullTables)
        let nullNibble633fa8 = try Tables.load(.firstPair633fa8NullNibble)
        let process2PublicTables = try Tables.load(.firstPairProcess2PublicTables)
        let prog67 = try Tables.load(.firstPairProg67cc18)
        let ttableBExt = try Tables.load(.child23TTableBExt)
        let finalLenTables = try Tables.load(.firstPairFinalLenTables)
        let df80RoundTables = try Tables.load(.firstPairDF80RoundTables)
        let finalizerTables = try Tables.load(.firstPairFinalizerTables)
        let seedTables679f48 = try Tables.load(.firstPair679f48SeedTables)
        let reducer67ea28Nibble = try Tables.load(.firstPairReducer67ea28Nibble)
        let prog67076c = try Tables.load(.firstPairProg67076c)
        guard sbox.count == 0x80000 else {
            throw FirstPairSourceSliceError.invalidTableSize(RuntimeTable.sbox19.rawValue, sbox.count)
        }
        guard prog.count >= prog64e2b8Length else {
            throw FirstPairSourceSliceError.invalidTableSize(RuntimeTable.firstPairProg64e2b8.rawValue, prog.count)
        }
        guard prog638840.count >= prog638840Length else {
            throw FirstPairSourceSliceError.invalidTableSize(RuntimeTable.firstPairProg638840.rawValue, prog638840.count)
        }
        guard lowSeedStatics6388f0.count == lowSeedStatics6388f0Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair6388f0LowSeedStatics.rawValue,
                lowSeedStatics6388f0.count
            )
        }
        guard lowLoopStatics6388f0.count == lowLoopStatics6388f0Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair6388f0LowLoopStatics.rawValue,
                lowLoopStatics6388f0.count
            )
        }
        guard laneTables6388f0.count == laneTables6388f0Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair6388f0LaneTables.rawValue,
                laneTables6388f0.count
            )
        }
        guard selectorMul6388f0.count == selectorTables6388f0Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair6388f0SelectorMul.rawValue,
                selectorMul6388f0.count
            )
        }
        guard selectorAdd6388f0.count == selectorTables6388f0Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair6388f0SelectorAdd.rawValue,
                selectorAdd6388f0.count
            )
        }
        guard u32Tables63c278.count == u32Tables63c278Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair63c278U32Tables.rawValue,
                u32Tables63c278.count
            )
        }
        guard foldTables63c278.count == foldTables63c278Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair63c278FoldTables.rawValue,
                foldTables63c278.count
            )
        }
        guard tailFoldTables633fa8.count == tailFoldTables633fa8Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair633fa8TailFoldTables.rawValue,
                tailFoldTables633fa8.count
            )
        }
        guard tailU32LowTables633fa8.count == tailU32LowTables633fa8Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair633fa8TailU32LowTables.rawValue,
                tailU32LowTables633fa8.count
            )
        }
        guard nullTables633fa8.count == nullTables633fa8Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair633fa8NullTables.rawValue,
                nullTables633fa8.count
            )
        }
        guard nullNibble633fa8.count == nullNibble633fa8Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair633fa8NullNibble.rawValue,
                nullNibble633fa8.count
            )
        }
        guard process2PublicTables.count == process2P5PublicTableLength else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPairProcess2PublicTables.rawValue,
                process2PublicTables.count
            )
        }
        guard prog67.count >= prog67cc18Length else {
            throw FirstPairSourceSliceError.invalidTableSize(RuntimeTable.firstPairProg67cc18.rawValue, prog67.count)
        }
        guard ttableBExt.count >= ttableBExtLength else {
            throw FirstPairSourceSliceError.invalidTableSize(RuntimeTable.child23TTableBExt.rawValue, ttableBExt.count)
        }
        guard finalLenTables.count == finalLenTablesLength else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPairFinalLenTables.rawValue,
                finalLenTables.count
            )
        }
        guard df80RoundTables.count == df80RoundTablesLength else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPairDF80RoundTables.rawValue,
                df80RoundTables.count
            )
        }
        guard finalizerTables.count == finalizerTablesLength else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPairFinalizerTables.rawValue,
                finalizerTables.count
            )
        }
        guard seedTables679f48.count == seedTables679f48Length else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPair679f48SeedTables.rawValue,
                seedTables679f48.count
            )
        }
        guard reducer67ea28Nibble.count == reducer67ea28NibbleLength else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPairReducer67ea28Nibble.rawValue,
                reducer67ea28Nibble.count
            )
        }
        guard prog67076c.count == prog67076cLength else {
            throw FirstPairSourceSliceError.invalidTableSize(
                RuntimeTable.firstPairProg67076c.rawValue,
                prog67076c.count
            )
        }
        return SourceTables(
            sbox19: sbox,
            prog64e2b8: prog,
            prog638840: prog638840,
            lowSeedStatics6388f0: lowSeedStatics6388f0,
            lowLoopStatics6388f0: lowLoopStatics6388f0,
            laneTables6388f0: laneTables6388f0,
            selectorMul6388f0: selectorMul6388f0,
            selectorAdd6388f0: selectorAdd6388f0,
            u32Tables63c278: u32Tables63c278,
            foldTables63c278: foldTables63c278,
            tailFoldTables633fa8: tailFoldTables633fa8,
            tailU32LowTables633fa8: tailU32LowTables633fa8,
            nullTables633fa8: nullTables633fa8,
            nullNibble633fa8: nullNibble633fa8,
            process2PublicTables: process2PublicTables,
            prog67cc18: prog67,
            ttableBExt: ttableBExt,
            finalLenTables: finalLenTables,
            df80RoundTables: df80RoundTables,
            finalizerTables: finalizerTables,
            seedTables679f48: seedTables679f48,
            reducer67ea28Nibble: reducer67ea28Nibble,
            prog67076c: prog67076c
        )
    }

    private static func vm64e2b8(
        magic: UInt64,
        src1: [UInt8],
        src2: [UInt8],
        tables: SourceTables
    ) throws -> [UInt8] {
        let progOff = Int(magic & 0x3f_ffff)
        let count = Int((magic >> 36) & 0x3fff)
        let tail = Int(magic >> 50)
        let total = count + tail
        let prog = try checkedSlice(
            tables.prog64e2b8,
            progOff,
            total,
            RuntimeTable.firstPairProg64e2b8.rawValue
        )
        try require(src1, count: count, label: "vm64e2b8 src1")
        try require(src2, count: total, label: "vm64e2b8 src2")

        var state = 0
        var out = [UInt8](repeating: 0, count: total)
        for i in 0..<count {
            state = try step(state: state, src1: src1[i], src2: src2[i], prog: prog[i], tables: tables)
            out[i] = UInt8(state & 7)
        }
        for i in 0..<tail {
            let pos = count + i
            state = try step(state: state, src1: nil, src2: src2[pos], prog: prog[pos], tables: tables)
            out[pos] = UInt8(state & 7)
        }
        return out
    }

    private static func vm638840(
        magic: UInt64,
        src1: [UInt8],
        src2: [UInt8],
        tables: SourceTables
    ) throws -> [UInt8] {
        let progOff = Int(magic & 0x3f_ffff)
        let count = Int((magic >> 36) & 0x3fff)
        let tail = Int(magic >> 50)
        let total = count + tail
        let prog = try checkedSlice(
            tables.prog638840,
            progOff,
            total,
            RuntimeTable.firstPairProg638840.rawValue
        )
        try require(src1, count: count, label: "vm638840 src1")
        try require(src2, count: total, label: "vm638840 src2")

        var state = 0
        var out = [UInt8](repeating: 0, count: total)
        for i in 0..<count {
            state = try step(state: state, src1: src1[i], src2: src2[i], prog: prog[i], tables: tables)
            out[i] = UInt8(state & 7)
        }
        for i in 0..<tail {
            let pos = count + i
            state = try step(state: state, src1: nil, src2: src2[pos], prog: prog[pos], tables: tables)
            out[pos] = UInt8(state & 7)
        }
        return out
    }

    private static func vm6420d8(
        magic: UInt64,
        src1: [UInt8],
        src2: [UInt8],
        tables: SourceTables
    ) throws -> [UInt8] {
        let progOff = Int(magic & 0x3f_ffff)
        let primer = Int((magic >> 22) & 0x3fff)
        let count = Int((magic >> 36) & 0x3fff)
        let tail = Int(magic >> 50)
        let totalProg = primer + count + tail
        let prog = try checkedSlice(
            tables.prog638840,
            progOff,
            totalProg,
            RuntimeTable.firstPairProg638840.rawValue
        )
        try require(src1, count: primer + count, label: "vm6420d8 src1")
        try require(src2, count: primer + count, label: "vm6420d8 src2")

        var state = 0
        for i in 0..<primer {
            state = try step(state: state, src1: src1[i], src2: src2[i], prog: prog[i], tables: tables)
        }

        var out = [UInt8](repeating: 0, count: count + tail)
        for i in 0..<count {
            let srcPos = primer + i
            state = try step(state: state, src1: src1[srcPos], src2: src2[srcPos], prog: prog[srcPos], tables: tables)
            out[i] = UInt8(state & 7)
        }
        for i in 0..<tail {
            let progPos = primer + count + i
            state = try step(state: state, src1: nil, src2: nil, prog: prog[progPos], tables: tables)
            out[count + i] = UInt8(state & 7)
        }
        return out
    }

    private static func vm641fcc(magic: UInt64, src: [UInt8], tables: SourceTables) throws -> [UInt8] {
        let progOff = Int(magic & 0x3f_ffff)
        let primer = Int((magic >> 22) & 0x3fff)
        let count = Int((magic >> 36) & 0x3fff)
        guard primer >= 2 else {
            throw FirstPairSourceSliceError.invalid641fccPrimer(primer)
        }
        let totalProg = primer + count + 3
        let prog = try checkedSlice(
            tables.prog638840,
            progOff,
            totalProg,
            RuntimeTable.firstPairProg638840.rawValue
        )
        try require(src, count: max(primer + count, 5), label: "vm641fcc src")

        var state = 0
        for i in 0..<primer {
            state = try step16Masked(state: state, src: src[i], prog: prog[i], tables: tables)
        }

        var out = [UInt8](repeating: 0, count: count + 3)
        for i in 0..<count {
            let srcPos = primer + i
            state = try step16Masked(state: state, src: src[srcPos], prog: prog[srcPos], tables: tables)
            out[i] = UInt8(state & 7)
        }

        let tailProg = primer + count
        for i in 0..<3 {
            state = try step16Full(state: state, src: src[2 + i], prog: prog[tailProg + i], tables: tables)
            out[count + i] = UInt8(state & 7)
        }
        return out
    }

    private static func vm67cecc(
        magic: UInt64,
        src1: [UInt8],
        src2: [UInt8],
        tables: SourceTables
    ) throws -> [UInt8] {
        let progOff = Int(magic & 0x3f_ffff)
        let primer = Int((magic >> 22) & 0x3fff)
        let count = Int((magic >> 36) & 0x3fff)
        let tail = Int(magic >> 50)
        let totalProg = primer + count + tail
        let prog = try checkedSlice(
            tables.prog67cc18,
            progOff,
            totalProg,
            RuntimeTable.firstPairProg67cc18.rawValue
        )
        try require(src1, count: primer + count, label: "vm67cecc src1")
        try require(src2, count: primer + count, label: "vm67cecc src2")

        var state = 0
        for i in 0..<primer {
            state = try step(state: state, src1: src1[i], src2: src2[i], prog: prog[i], tables: tables)
        }

        var out = [UInt8](repeating: 0, count: count + tail)
        for i in 0..<count {
            let srcPos = primer + i
            state = try step(state: state, src1: src1[srcPos], src2: src2[srcPos], prog: prog[srcPos], tables: tables)
            out[i] = UInt8(state & 7)
        }
        for i in 0..<tail {
            let progPos = primer + count + i
            state = try step(state: state, src1: nil, src2: nil, prog: prog[progPos], tables: tables)
            out[count + i] = UInt8(state & 7)
        }
        return out
    }

    private static func vm67d524(magic: UInt64, src: [UInt8], tables: SourceTables) throws -> [UInt8] {
        let progOff = Int(magic & 0x3f_ffff)
        let primer = Int((magic >> 22) & 0x3fff)
        let count = Int((magic >> 36) & 0x3fff)
        let totalProg = primer + count + 3
        let prog = try checkedSlice(
            tables.prog67cc18,
            progOff,
            totalProg,
            RuntimeTable.firstPairProg67cc18.rawValue
        )
        try require(src, count: max(primer + count, 5), label: "vm67d524 src")

        var state = 0
        for i in 0..<primer {
            state = try step16Masked(state: state, src: src[i], prog: prog[i], tables: tables)
        }

        var out = [UInt8](repeating: 0, count: count + 3)
        for i in 0..<count {
            let srcPos = primer + i
            state = try step16Masked(state: state, src: src[srcPos], prog: prog[srcPos], tables: tables)
            out[i] = UInt8(state & 7)
        }

        let tailProg = primer + count
        for i in 0..<3 {
            state = try step16Full(state: state, src: src[2 + i], prog: prog[tailProg + i], tables: tables)
            out[count + i] = UInt8(state & 7)
        }
        return out
    }

    private static func vm67cc18(
        magic: UInt64,
        src1: [UInt8],
        src2: [UInt8],
        tables: SourceTables
    ) throws -> [UInt8] {
        let progOff = Int(magic & 0x3f_ffff)
        let count = Int((magic >> 36) & 0x3fff)
        let tail = Int(magic >> 50)
        let total = count + tail
        let prog = try checkedSlice(
            tables.prog67cc18,
            progOff,
            total,
            RuntimeTable.firstPairProg67cc18.rawValue
        )
        try require(src1, count: count, label: "vm67cc18 src1")
        try require(src2, count: total, label: "vm67cc18 src2")

        var state = 0
        var out = [UInt8](repeating: 0, count: total)
        for i in 0..<count {
            state = try step(state: state, src1: src1[i], src2: src2[i], prog: prog[i], tables: tables)
            out[i] = UInt8(state & 7)
        }
        for i in 0..<tail {
            let pos = count + i
            state = try step(state: state, src1: nil, src2: src2[pos], prog: prog[pos], tables: tables)
            out[pos] = UInt8(state & 7)
        }
        return out
    }

    private static func vm67076c(
        magic: UInt64,
        src1: [UInt8],
        src2: [UInt8],
        tables: SourceTables
    ) throws -> [UInt8] {
        let progOff = Int(magic & 0x3f_ffff)
        let prog = try checkedSlice(
            tables.prog67076c,
            progOff,
            block66Size,
            RuntimeTable.firstPairProg67076c.rawValue
        )
        try require(src1, count: block66Size, label: "vm67076c src1")
        try require(src2, count: block66Size, label: "vm67076c src2")

        var state = 0
        var out = [UInt8](repeating: 0, count: block66Size)
        for i in 0..<block66Size {
            state = try step(state: state, src1: src1[i], src2: src2[i], prog: prog[i], tables: tables)
            out[i] = UInt8(state & 7)
        }
        return out
    }

    private static func vm64e17c(
        src0: [UInt8],
        src1: [UInt8],
        tables: SourceTables
    ) throws -> [UInt8] {
        try require(src0, count: scratch130Size, label: "vm64e17c src0")
        try require(src1, count: scratch130Size, label: "vm64e17c src1")

        var state = try step(state: 0, src1: src0[0], src2: src1[0], prog: 14, tables: tables)
        for (index, progByte) in [UInt8(22), 9, 33].enumerated() {
            let pos = index + 1
            state = try step(state: state, src1: src0[pos], src2: src1[pos], prog: progByte, tables: tables)
        }

        let prog = try checkedSlice(
            tables.prog64e2b8,
            vm64e17cProgOffset,
            vm64e17cProgLength,
            RuntimeTable.firstPairProg64e2b8.rawValue
        )
        var out = [UInt8](repeating: 0, count: scratch130Size)
        for i in 0..<vm64e17cProgLength {
            state = try step(state: state, src1: src0[4 + i], src2: src1[4 + i], prog: prog[i], tables: tables)
            out[i] = UInt8(state & 7)
        }
        for (i, progByte) in [UInt8(12), 17, 18, 27].enumerated() {
            let pos = vm64e17cProgLength + i
            state = try step(state: state, src1: nil, src2: nil, prog: progByte, tables: tables)
            out[pos] = UInt8(state & 7)
        }
        return out
    }

    private static func shiftedScratch(_ block66: [UInt8]) -> [UInt8] {
        var scratch = [UInt8](repeating: 0, count: scratch130Size)
        scratch[0x3f] = 3
        for i in 0..<block66Size {
            scratch[0x40 + i] = block66[i]
        }
        return scratch
    }

    private static func step(
        state: Int,
        src1: UInt8?,
        src2: UInt8?,
        prog: UInt8,
        tables: SourceTables
    ) throws -> Int {
        var idx = state & 0xf8
        if let src1 {
            idx ^= Int(src1)
        }
        if let src2 {
            idx |= Int(src2) << 8
        }
        idx ^= Int(prog) << 11
        guard idx >= 0 && idx < tables.sbox19.count else {
            throw FirstPairSourceSliceError.tableReadOutOfBounds(RuntimeTable.sbox19.rawValue, idx)
        }
        return Int(tables.sbox19[idx])
    }

    private static func step16Masked(state: Int, src: UInt8, prog: UInt8, tables: SourceTables) throws -> Int {
        let byteOffset = (((state & 0xff8) ^ Int(src)) << 1) | (Int(prog) << 13)
        return try ttableBHalfword(byteOffset, tables: tables)
    }

    private static func step16Full(state: Int, src: UInt8, prog: UInt8, tables: SourceTables) throws -> Int {
        let byteOffset = (Int(prog) << 13) ^ ((state ^ Int(src)) << 1)
        return try ttableBHalfword(byteOffset, tables: tables)
    }

    private static func ttableBHalfword(_ byteOffset: Int, tables: SourceTables) throws -> Int {
        guard byteOffset >= 0 && byteOffset + 1 < tables.ttableBExt.count else {
            throw FirstPairSourceSliceError.tableReadOutOfBounds(RuntimeTable.child23TTableBExt.rawValue, byteOffset)
        }
        return Int(tables.ttableBExt[byteOffset]) | (Int(tables.ttableBExt[byteOffset + 1]) << 8)
    }

    private static func expandU64Trits(_ value: UInt64, tableOffset: Int, tables: SourceTables) throws -> [UInt8] {
        var out: [UInt8] = []
        out.reserveCapacity(48)
        for shift in stride(from: 0, to: 64, by: 8) {
            let index = tableOffset + Int((value >> UInt64(shift)) & 0xff) * 3
            let packed = try checkedSlice(
                tables.finalLenTables,
                index,
                3,
                RuntimeTable.firstPairFinalLenTables.rawValue
            )
            for byte in packed {
                out.append(byte & 7)
                out.append(byte >> 3)
            }
        }
        return out
    }

    private static func fold48To34(
        firstMagic: UInt64,
        tailMagic: UInt64,
        src48: [UInt8],
        tables: SourceTables
    ) throws -> [UInt8] {
        try require(src48, count: 0x30, label: "679f48 length fold source")
        var out = try vm67cc18(magic: firstMagic, src1: src48, src2: src48, tables: tables)
        for offset in stride(from: 6, to: 0x30, by: 6) {
            let src = Array(src48[offset..<src48.count])
            let chunk = try vm67cc18(magic: tailMagic, src1: src, src2: src, tables: tables)
            out.append(contentsOf: chunk[2..<6])
        }
        return out
    }

    private static func checkedSlice(_ bytes: [UInt8], _ offset: Int, _ count: Int, _ name: String) throws -> [UInt8] {
        guard offset >= 0, count >= 0, offset + count <= bytes.count else {
            throw FirstPairSourceSliceError.tableReadOutOfBounds(name, offset)
        }
        return Array(bytes[offset..<(offset + count)])
    }

    private static func require(_ bytes: [UInt8], count: Int, label: String) throws {
        guard bytes.count >= count else {
            throw FirstPairSourceSliceError.sourceTooShort(label, bytes.count, count)
        }
    }

    private static func readUInt32LE(_ bytes: [UInt8], _ offset: Int) -> UInt32 {
        UInt32(bytes[offset]) |
        (UInt32(bytes[offset + 1]) << 8) |
        (UInt32(bytes[offset + 2]) << 16) |
        (UInt32(bytes[offset + 3]) << 24)
    }

    private static func readUInt64LE(_ bytes: [UInt8], _ offset: Int) -> UInt64 {
        var value: UInt64 = 0
        for index in 0..<8 {
            value |= UInt64(bytes[offset + index]) << UInt64(index * 8)
        }
        return value
    }

    private static func writeUInt32LE(_ value: UInt32, into bytes: inout [UInt8], at offset: Int) {
        for index in 0..<4 {
            bytes[offset + index] = UInt8((value >> UInt32(index * 8)) & 0xff)
        }
    }

    private static func writeUInt64LE(_ value: UInt64, into bytes: inout [UInt8], at offset: Int) {
        for index in 0..<8 {
            bytes[offset + index] = UInt8((value >> UInt64(index * 8)) & 0xff)
        }
    }

    private static func hexBytes(_ hex: String) -> [UInt8] {
        precondition(hex.count % 2 == 0)
        var bytes: [UInt8] = []
        bytes.reserveCapacity(hex.count / 2)
        var index = hex.startIndex
        while index < hex.endIndex {
            let next = hex.index(index, offsetBy: 2)
            guard let byte = UInt8(hex[index..<next], radix: 16) else {
                preconditionFailure("invalid hex byte")
            }
            bytes.append(byte)
            index = next
        }
        return bytes
    }

    private static func u32LEBytes(_ value: UInt32) -> [UInt8] {
        [
            UInt8(value & 0xff),
            UInt8((value >> 8) & 0xff),
            UInt8((value >> 16) & 0xff),
            UInt8((value >> 24) & 0xff),
        ]
    }

    private static func u64LEBytes(_ value: UInt64) -> [UInt8] {
        (0..<8).map { UInt8((value >> UInt64($0 * 8)) & 0xff) }
    }

    private static let block66Size = 0x42
    private static let df80InputBlockCount = 4
    private static let df80WordSize = 0x12
    private static let df80DerivedScheduleSize = 0x360
    private static let df80InitialWorkspaceStride = 0x48
    private static let df80InitialWorkspaceSize = 0x120
    private static let df80ScheduleSize = 0x480
    private static let df80StateSize = 8 * df80WordSize
    private static let finalizerDD7CPadOffset = 0x0000
    private static let finalizerZeroLowBlockOffset = 0x0e70
    private static let finalizerPad2Offset = 0x0eb2
    private static let finalizerStaticBlockOffset = 0x1290
    private static let expand67ed24AOffset = 0x0870
    private static let expand67ed24BOffset = 0x0b70
    private static let init679f48Block66SrcOffset = 0
    private static let raw67d630TableAOffset = 0x0d2
    private static let raw67d630TableBOffset = 0x3d2
    private static let init679f48Block66DstOffsets = [0x08, 0x4a, 0x8c, 0xce]
    private static let init679f48Block18Specs: [(magic: UInt64, srcOffset: Int, dstOffset: Int)] = [
        (0x120000058e3, 0x42, 0x114),
        (0x12000004b6b, 0x54, 0x126),
        (0x1200000388e, 0x66, 0x138),
        (0x12000000662, 0x78, 0x14a),
        (0x12000000c90, 0x8a, 0x15c),
        (0x120000045f6, 0x9c, 0x16e),
        (0x12000000139, 0xae, 0x180),
        (0x12000002cb1, 0xc0, 0x192),
    ]
    private static let aa8cInitialReducerSpecs: [(magic: UInt64, srcOffset: Int, dstOffset: Int)] = [
        (0x400120000030e8, 0x114, 0x1ec),
        (0x40012000000006, 0x126, 0x1f0),
        (0x400120000022d5, 0x138, 0x1f4),
        (0x40012000001859, 0x14a, 0x1f8),
        (0x40012000005e7a, 0x15c, 0x1fc),
        (0x40012000004661, 0x16e, 0x200),
        (0x4001200000178f, 0x180, 0x204),
        (0x40012000002c8f, 0x192, 0x208),
    ]
    private static let eb94UpdateMagics: [UInt64] = [
        0x12000004154,
        0x1200000392c,
        0x120000036db,
        0x12000000f83,
        0x120000000f9,
        0x12000000a72,
        0x120000018d7,
        0x1200000191d,
    ]
    private static let scratch130Size = 130
    private static let context679f48Size = 0x20c
    private static let builder6388f0WorkspaceSize = 0x10a
    private static let builder6388f0StageSize = 0x11a
    private static let builder6388f0LaneBlockCount = 20
    private static let builder6388f0LaneBlockSize = 0x10
    private static let builder6388f0LaneBlocksSize = builder6388f0LaneBlockCount * builder6388f0LaneBlockSize
    private static let builder6388f0LaneTablePackedRowSize = 9
    private static let builder6388f0LaneTableExpandedSize = 18
    private static let builder6388f0LaneATableOffset = 0x0000
    private static let builder6388f0LaneBTableOffset = 0x0900
    private static let builder6388f0LaneAInitOffset = 0x1200
    private static let builder6388f0LaneBInitOffset = 0x1212
    private static let builder6388f0LanePrimaryStaticOffset = 0x1224
    private static let builder6388f0LaneSecondaryStaticOffset = 0x1236
    private static let builder63c278VectorWords = 22
    private static let builder63c278VectorBytes = builder63c278VectorWords * 4
    private static let builder6388f0CallerStackBytes = 0x5000
    private static let builder6473d0CallerStackPreimageBytes = 0xc00
    private static let builder64cd40WorkspaceWords = 44
    private static let builder64cd40WorkspaceBytes = builder64cd40WorkspaceWords * 8
    private static let builder6421c0X0MulTable = 0x113f08
    private static let builder6421c0X0AddTable = 0x113628
    private static let builder6421c0X0FoldTable = 0x2feb18
    private static let builder6421c0X1MulTable = 0x11b288
    private static let builder6421c0X1AddTable = 0x118388
    private static let builder6421c0X1FoldTable = 0x2feb98
    private static let builder6421c0X2MulTable = 0x1183a8
    private static let builder6421c0X2AddTable = 0x11b2a8
    private static let builder6421c0X2FoldTable = 0x2fec18
    private static let builder6421c0WorkspaceFoldTable = 0x2fec98
    private static let builder6421c0RewriteFold1Table = 0x2fed18
    private static let builder6421c0RewriteFold2Table = 0x2fed98
    private static let builder6421c0FinalFoldTable = 0x2fee18
    private static let builder6421c0FinalOutMulTable = 0x115e48
    private static let builder6421c0FinalOutAddTable = 0x115308
    private static let builder6388f0HighSeedX0SourceMulTable = 0x11fd48
    private static let builder6388f0HighSeedX0SourceAddTable = 0x1152e8
    private static let builder6388f0Pre63Arg1MulTable = 0x11a988
    private static let builder6388f0Pre63Arg1AddTable = 0x1184c8
    private static let builder6388f0Pre63Arg2MulTable = 0x112608
    private static let builder6388f0Pre63Arg2AddTable = 0x11a008
    private static let builder6388f0Next642X1MulTable = 0x114948
    private static let builder6388f0Next642X1AddTable = 0x1184e8
    private static let builder6388f0StreamStartOut0To642f60X0MulTable = 0x11fd68
    private static let builder6388f0StreamStartOut0To642f60X0AddTable = 0x1233a8
    private static let builder6388f0StreamStartOut1To642f60X1MulTable = 0x115328
    private static let builder6388f0StreamStartOut1To642f60X1AddTable = 0x11b2c8
    private static let builder6388f0SharedContextLength = 0x520
    private static let builder6388f0CallerLoopTableRows = 59
    private static let builder6388f0CallerLoopRowBytes = 0x58
    private static let builder6388f0CallerLoopTableBytes = builder6388f0CallerLoopTableRows * builder6388f0CallerLoopRowBytes
    private static let builder6388f0CallerLoopInterleavedRowBytes = builder6388f0CallerLoopRowBytes * 2
    private static let builder6388f0CallerLoopInterleavedLength = builder6388f0CallerLoopTableRows * builder6388f0CallerLoopInterleavedRowBytes
    private static let builder6388f0CallerLoopTable1ContextOffset = 0x4c8
    private static let builder6388f0CallerLoopTable2ContextOffset = 0x1910
    private static let builder6388f0CallerContextLength = builder6388f0CallerLoopTable2ContextOffset + builder6388f0CallerLoopTableBytes
    private static let builder6388f0FirstPairStreamRows = builder6388f0CallerLoopTableRows * 2
    private static let builder642f60SP2A8X1MulTable = 0x116808
    private static let builder642f60SP2A8X1AddTable = 0x113f48
    private static let builder642f60SP2A8OutMulTable = 0x11b2e8
    private static let builder642f60SP2A8OutAddTable = 0x11e468
    private static let builder642f60SP2A8FoldTable = 0x2feef0
    private static let builder642f60SP300MulTable = 0x114808
    private static let builder642f60SP300AddTable = 0x112d48
    private static let builder642f60SP1F8X0MulTable = 0x122168
    private static let builder642f60SP1F8X0AddTable = 0x1171c8
    private static let builder642f60SP1F8OutMulTable = 0x112d68
    private static let builder642f60SP1F8OutAddTable = 0x115368
    private static let builder642f60SP1F8FoldTable = 0x2ff2b0
    private static let builder642f60SP250MulTable = 0x118e28
    private static let builder642f60SP250AddTable = 0x11b368
    private static let builder642f60SP148MulTable = 0x113668
    private static let builder642f60SP148AddTable = 0x113f68
    private static let builder642f60SPF0MulTable = 0x116828
    private static let builder642f60SPF0AddTable = 0x1233c8
    private static let builder642f60SP1A0MulTable = 0x117ac8
    private static let builder642f60SP1A0AddTable = 0x120568
    private static let builder642f60FirstAMulTable = 0x11b308
    private static let builder642f60FirstAAddTable = 0x120e68
    private static let builder642f60FirstAFoldTable = 0x2fef30
    private static let builder642f60FirstBMulTable = 0x117a88
    private static let builder642f60FirstBAddTable = 0x11c308
    private static let builder642f60FirstBFoldTable = 0x2fefb0
    private static let builder642f60SecondAMulTable = 0x115388
    private static let builder642f60SecondAAddTable = 0x1153a8
    private static let builder642f60SecondAFoldTable = 0x2ff2f0
    private static let builder642f60SecondBMulTable = 0x11dc48
    private static let builder642f60SecondBAddTable = 0x11b348
    private static let builder642f60SecondBFoldTable = 0x2ff370
    private static let builder642f60ThirdAMulTable = 0x117aa8
    private static let builder642f60ThirdAAddTable = 0x11a8c8
    private static let builder642f60ThirdAFoldTable = 0x2ff3f0
    private static let builder642f60ThirdBMulTable = 0x11e488
    private static let builder642f60ThirdBAddTable = 0x11e4a8
    private static let builder642f60ThirdBFoldTable = 0x2ff470
    private static let builder642f60FourthAMulTable = 0x112588
    private static let builder642f60FourthAAddTable = 0x123cc8
    private static let builder642f60FourthAFoldTable = 0x2ff4f0
    private static let builder642f60FourthBMulTable = 0x115e68
    private static let builder642f60FourthBAddTable = 0x1125a8
    private static let builder642f60FourthBFoldTable = 0x2ff570
    private static let builder642f60MidAX0MulTable = 0x114828
    private static let builder642f60MidAX0AddTable = 0x118e48
    private static let builder642f60MidAFoldTable = 0x2ff5f0
    private static let builder642f60MidSP40FoldTable = 0x2ff670
    private static let builder642f60MidSP40OutMulTable = 0x116848
    private static let builder642f60MidSP40OutAddTable = 0x123ce8
    private static let builder642f60MidContextMulTable = 0x1183c8
    private static let builder642f60MidContextAddTable = 0x1171e8
    private static let builder642f60MidContextFoldTable = 0x2ff6f0
    private static let builder642f60MidSPF0MulTable = 0x121828
    private static let builder642f60MidSPF0AddTable = 0x114848
    private static let builder642f60MidSPF0FoldTable = 0x2ff770
    private static let builder642f60MidSP40BMulTable = 0x121848
    private static let builder642f60MidSP40BAddTable = 0x113688
    private static let builder642f60MidSP40BFoldTable = 0x2ff7f0
    private static let builder642f60MidStaticSrcTable = 0x2fee98
    private static let builder642f60MidStaticMulTable = 0x11b388
    private static let builder642f60MidStaticAddTable = 0x1233e8
    private static let builder642f60MidStaticFoldTable = 0x2ff870
    private static let builder642f60SixthAMulTable = 0x115e88
    private static let builder642f60SixthAAddTable = 0x11cd48
    private static let builder642f60SixthAFoldTable = 0x2ff8f0
    private static let builder642f60SixthBMulTable = 0x123d08
    private static let builder642f60SixthBAddTable = 0x122188
    private static let builder642f60SixthBFoldTable = 0x2ff970
    private static let builder642f60Out0StaticQ0 = 0x125450
    private static let builder642f60Out0StaticQ1 = 0x126540
    private static let builder642f60Out0StaticD1 = 0x126900
    private static let builder642f60Out0SixthMulTable = 0x1229e8
    private static let builder642f60Out0ContextMulTable = 0x123d28
    private static let builder642f60Out0SP250MulTable = 0x1183e8
    private static let builder642f60Out0FoldTable = 0x2ff9f0
    private static let builder642f60Out0OutMulTable = 0x11d428
    private static let builder642f60Out0OutAddTable = 0x120e88
    private static let builder642f60SeventhStaticQ0 = 0x125380
    private static let builder642f60SeventhStaticQ1 = 0x1256c0
    private static let builder642f60SeventhStaticD1 = 0x126c70
    private static let builder642f60SeventhSP250MulTable = 0x11d448
    private static let builder642f60SeventhContextMulTable = 0x117ae8
    private static let builder642f60SeventhOut0MulTable = 0x11cd68
    private static let builder642f60SeventhSP148FoldTable = 0x2ffa30
    private static let builder642f60SeventhSP148OutMulTable = 0x1153c8
    private static let builder642f60SeventhSP148OutAddTable = 0x11dc68
    private static let builder642f60SeventhAMulTable = 0x112d88
    private static let builder642f60SeventhAAddTable = 0x1153e8
    private static let builder642f60SeventhAFoldTable = 0x2ffa70
    private static let builder642f60SeventhBMulTable = 0x11a8e8
    private static let builder642f60SeventhBAddTable = 0x1136a8
    private static let builder642f60SeventhBFoldTable = 0x2ffaf0
    private static let builder642f60SeventhSP9E0FoldTable = 0x2ffb70
    private static let builder642f60SeventhSP9E0OutMulTable = 0x123d48
    private static let builder642f60SeventhSP9E0OutAddTable = 0x123d68
    private static let builder642f60SeventhSP300MulTable = 0x11eba8
    private static let builder642f60SeventhSP300AddTable = 0x11e4c8
    private static let builder642f60SeventhSP300FoldTable = 0x2ffbf0
    private static let builder642f60SeventhSP7D0FoldTable = 0x2ffc70
    private static let builder642f60SeventhSP7D0OutMulTable = 0x114868
    private static let builder642f60SeventhSP7D0OutAddTable = 0x122a08
    private static let builder642f60SeventhSourceStaticTable = 0x118408
    private static let builder642f60SeventhSourceSP9E0MulTable = 0x11f528
    private static let builder642f60SeventhSourceContext368MulTable = 0x120ea8
    private static let builder642f60SeventhSourceSP7D0MulTable = 0x123408
    private static let builder642f60SeventhSP40FoldTable = 0x2ffcf0
    private static let builder642f60SeventhSP40OutMulTable = 0x11bb68
    private static let builder642f60SeventhSP40OutAddTable = 0x1196a8
    private static let builder642f60SeventhWorkspaceMulTable = 0x123d88
    private static let builder642f60SeventhWorkspaceAddTable = 0x113f88
    private static let builder642f60SeventhWorkspaceFoldTable = 0x2ffd30
    private static let builder642f60Out1MulTable = 0x11ebc8
    private static let builder642f60Out1AddTable = 0x11e4e8
    private static let builder642f60EighthAMulTable = 0x11a908
    private static let builder642f60EighthAAddTable = 0x116868
    private static let builder642f60EighthAFoldTable = 0x2ffdb0
    private static let builder642f60EighthBMulTable = 0x115ea8
    private static let builder642f60EighthBAddTable = 0x118e68
    private static let builder642f60EighthBFoldTable = 0x2ffe30
    private static let builder642f60Out2MulTable = 0x119f48
    private static let builder642f60Out2AddTable = 0x119f68
    private static let builder64bd0cWorkspaceWords = 44
    private static let builder64bd0cWorkspaceBytes = builder64bd0cWorkspaceWords * 8
    private static let builder64c524WorkspaceWords = 44
    private static let builder64c524WorkspaceBytes = builder64c524WorkspaceWords * 8
    private static let builder64bd0cArg0MulTable = 0x11c328
    private static let builder64bd0cArg0AddTable = 0x113648
    private static let builder64bd0cArg0FoldTable = 0x2ff030
    private static let builder64bd0cWorkspaceFold1Table = 0x2ff0b0
    private static let builder64bd0cRewriteFold1Table = 0x2ff130
    private static let builder64bd0cRewriteFold2Table = 0x2ff1b0
    private static let builder64bd0cFinalFoldTable = 0x2ff230
    private static let builder64bd0cFinalOutMulTable = 0x11b328
    private static let builder64bd0cFinalOutAddTable = 0x115348
    private static let builder64c524Arg0MulTable = 0x118e88
    private static let builder64c524Arg0AddTable = 0x118428
    private static let builder64c524Arg0FoldTable = 0x2fffb0
    private static let builder64c524WorkspaceFold1Table = 0x300030
    private static let builder64c524RewriteFold1Table = 0x3000b0
    private static let builder64c524RewriteFold2Table = 0x300130
    private static let builder64c524FinalFoldTable = 0x3001b0
    private static let builder64c524FinalOutMulTable = 0x120ec8
    private static let builder64c524FinalOutAddTable = 0x11b3a8
    private static let builder6473d0FirstA0U32Mul: UInt32 = 0x77de3399
    private static let builder6473d0FirstA0U32Add: UInt32 = 0x58e2f220
    private static let builder6473d0FirstAMulTable = 0x121868
    private static let builder6473d0FirstAAddTable = 0x1221a8
    private static let builder6473d0FirstAU32Mul: UInt32 = 0x4455c2a7
    private static let builder6473d0FirstAU32Add: UInt32 = 0x5fb4bcba
    private static let builder6473d0FirstAFoldMul: UInt64 = 0x1a5dd9d49d616e49
    private static let builder6473d0FirstAFoldAdd: UInt64 = 0x35ca2ed01cc6fc5e
    private static let builder6473d0FirstAFoldTable = 0x2ffeb0
    private static let builder6473d0FirstAFoldedMul: UInt64 = 0xc0342d0500000000
    private static let builder6473d0FirstALinearMul: UInt64 = 0x52a77526a5e20393
    private static let builder6473d0FirstALinearAdd: UInt64 = 0xe18c4214f69259e3
    private static let builder6473d0FirstB0U32Mul: UInt32 = 0x87742383
    private static let builder6473d0FirstB0U32Add: UInt32 = 0xc9c817bb
    private static let builder6473d0FirstBMulTable = 0x120588
    private static let builder6473d0FirstBAddTable = 0x121888
    private static let builder6473d0FirstBU32Mul: UInt32 = 0x10aa86fb
    private static let builder6473d0FirstBU32Add: UInt32 = 0xc396dd66
    private static let builder6473d0FirstBFoldMul: UInt64 = 0xb113a5da27ca9531
    private static let builder6473d0FirstBFoldAdd: UInt64 = 0x9ebadbc5621b3655
    private static let builder6473d0FirstBFoldTable = 0x2fff30
    private static let builder6473d0FirstBFoldedMul: UInt64 = 0x05cb504100000000
    private static let builder6473d0FirstBLinearMul: UInt64 = 0xc109dc395415ce8f
    private static let builder6473d0FirstBLinearAdd: UInt64 = 0xf36dd79d8bc15312
    private static let builder6473d0FirstConvBaseAdd: UInt64 = 0xea076efa672179ab
    private static let builder6473d0FirstConvCountMul: UInt64 = 0x901a2a1a1970b75f
    private static let builder6473d0FirstConvProductMul: UInt64 = 0x4300ab4afadcbbf7
    private static let builder6473d0FirstConvSumAMul: UInt64 = 0x7de2bd685f4f4709
    private static let builder6473d0FirstConvSumBMul: UInt64 = 0xa38b46b3853abda1
    private static let builder6473d0FirstConvFinalMul: UInt64 = 0xd77dcf630e2637db
    private static let builder6473d0FirstConvFinalAdd: UInt64 = 0x5c2daa5720071908
    private static let builder6473d0SP488MulTable = 0x11f548
    private static let builder6473d0SP488AddTable = 0x120ee8
    private static let builder6473d0SecondA0U32Mul: UInt32 = 0x39489dd3
    private static let builder6473d0SecondA0U32Add: UInt32 = 0x84fea303
    private static let builder6473d0SecondAMulTable = 0x1196c8
    private static let builder6473d0SecondAAddTable = 0x114888
    private static let builder6473d0SecondAU32Mul: UInt32 = 0x55b224db
    private static let builder6473d0SecondAU32Add: UInt32 = 0x42db73c8
    private static let builder6473d0SecondAFoldMul: UInt64 = 0x9ab586ead7a10a23
    private static let builder6473d0SecondAFoldAdd: UInt64 = 0x745539fbd1dd9f3d
    private static let builder6473d0SecondAFoldTable = 0x300230
    private static let builder6473d0SecondAFoldedMul: UInt64 = 0xcf9ca88500000000
    private static let builder6473d0SecondALinearMul: UInt64 = 0x8522c616d05ac3d1
    private static let builder6473d0SecondALinearAdd: UInt64 = 0xf16d077d4bce4ca7
    private static let builder6473d0SecondB0U32Mul: UInt32 = 0xce63ced3
    private static let builder6473d0SecondB0U32Add: UInt32 = 0x34652b7a
    private static let builder6473d0SecondBMulTable = 0x11b3c8
    private static let builder6473d0SecondBAddTable = 0x118ea8
    private static let builder6473d0SecondBU32Mul: UInt32 = 0xed7fd02d
    private static let builder6473d0SecondBU32Add: UInt32 = 0xcaf62b51
    private static let builder6473d0SecondBFoldMul: UInt64 = 0x9345f0e11be71ab7
    private static let builder6473d0SecondBFoldAdd: UInt64 = 0xc397557b35344783
    private static let builder6473d0SecondBFoldTable = 0x3002b0
    private static let builder6473d0SecondBFoldedMul: UInt64 = 0x4e61310500000000
    private static let builder6473d0SecondBLinearMul: UInt64 = 0xfa2624af5708736d
    private static let builder6473d0SecondBLinearAdd: UInt64 = 0x8ace523ec06aa294
    private static let builder6473d0SecondConvBaseAdd: UInt64 = 0x3a938197b6fc0c6d
    private static let builder6473d0SecondConvCountMul: UInt64 = 0x6b6072f5b68541ed
    private static let builder6473d0SecondConvProductMul: UInt64 = 0x17273c8d47cdf1cd
    private static let builder6473d0SecondConvSumAMul: UInt64 = 0xbe760fcc7bdf8909
    private static let builder6473d0SecondConvSumBMul: UInt64 = 0x0a87db0f0661d8c1
    private static let builder6473d0SecondConvFinalMul: UInt64 = 0x4de8dcb2e8bedd8d
    private static let builder6473d0SecondConvFinalAdd: UInt64 = 0x24bff8d093bcfa48
    private static let builder6473d0ThirdStaticQ0 = 0x126340
    private static let builder6473d0ThirdStaticQ1 = 0x125500
    private static let builder6473d0ThirdStaticD1 = 0x126af8
    private static let builder6473d0ThirdSecondMulTable = 0x115ec8
    private static let builder6473d0ThirdContext208MulTable = 0x11ebe8
    private static let builder6473d0ThirdIn0MulTable = 0x1196e8
    private static let builder6473d0ThirdSP430StateInit: UInt32 = 0xcf789378
    private static let builder6473d0ThirdSP430StateMul: UInt32 = 0x807fabb9
    private static let builder6473d0ThirdSP430FoldPreMul: UInt32 = 0xa5cb8299
    private static let builder6473d0ThirdSP430FoldPreAdd: UInt32 = 0x35afa3e6
    private static let builder6473d0ThirdSP430SideMul: UInt32 = 0x87693409
    private static let builder6473d0ThirdSP430SideAdd: UInt32 = 0xd6091d59
    private static let builder6473d0ThirdSP430NextFolded7Mul: UInt32 = 0x67448d71
    private static let builder6473d0ThirdSP430NextFolded8Mul: UInt32 = 0x8bb728f0
    private static let builder6473d0ThirdSP430NextAdd: UInt32 = 0x4b56addb
    private static let builder6473d0ThirdSP430FoldTable = 0x300330
    private static let builder6473d0ThirdSP430OutMulTable = 0x112da8
    private static let builder6473d0ThirdSP430OutAddTable = 0x123da8
    private static let builder6473d0ThirdA0U32Mul: UInt32 = 0xa0c3f4e7
    private static let builder6473d0ThirdA0U32Add: UInt32 = 0xca140f35
    private static let builder6473d0ThirdAMulTable = 0x11d468
    private static let builder6473d0ThirdAAddTable = 0x1218a8
    private static let builder6473d0ThirdAU32Mul: UInt32 = 0xd85895b7
    private static let builder6473d0ThirdAU32Add: UInt32 = 0xfe4ad573
    private static let builder6473d0ThirdAFoldMul: UInt64 = 0x2d873af1d6d51fab
    private static let builder6473d0ThirdAFoldAdd: UInt64 = 0xfa32d6ea7762f713
    private static let builder6473d0ThirdAFoldTable = 0x300370
    private static let builder6473d0ThirdAFoldedMul: UInt64 = 0xd60956a700000000
    private static let builder6473d0ThirdALinearMul: UInt64 = 0x7c054da63351e573
    private static let builder6473d0ThirdALinearAdd: UInt64 = 0x8b3f83af9a986f82
    private static let builder6473d0ThirdB0U32Mul: UInt32 = 0x2f4895c9
    private static let builder6473d0ThirdB0U32Add: UInt32 = 0x548370bf
    private static let builder6473d0ThirdBMulTable = 0x117b08
    private static let builder6473d0ThirdBAddTable = 0x112dc8
    private static let builder6473d0ThirdBU32Mul: UInt32 = 0x5f18e243
    private static let builder6473d0ThirdBU32Add: UInt32 = 0x601ea383
    private static let builder6473d0ThirdBFoldMul: UInt64 = 0xccb971c8df4a10cb
    private static let builder6473d0ThirdBFoldAdd: UInt64 = 0xbdc12d7c86b96bc9
    private static let builder6473d0ThirdBFoldTable = 0x3003f0
    private static let builder6473d0ThirdBFoldedMul: UInt64 = 0x8970cf0900000000
    private static let builder6473d0ThirdBLinearMul: UInt64 = 0x8ae83bc3470143dd
    private static let builder6473d0ThirdBLinearAdd: UInt64 = 0x888ef8790921d76b
    private static let builder6473d0ThirdConvBaseAdd: UInt64 = 0x917278c29688d77b
    private static let builder6473d0ThirdConvCountMul: UInt64 = 0xc7906210d3d1e095
    private static let builder6473d0ThirdConvProductMul: UInt64 = 0x4701e4eecdc47ad3
    private static let builder6473d0ThirdConvSumAMul: UInt64 = 0xaa41cc7914d43151
    private static let builder6473d0ThirdConvSumBMul: UInt64 = 0x4ed4ffc26ea9e41f
    private static let builder6473d0ThirdConvFinalMul: UInt64 = 0xddb691aa5df690b3
    private static let builder6473d0ThirdConvFinalAdd: UInt64 = 0xa100d744fa1a1050
    private static let builder6473d0FourthA0U32Mul: UInt32 = 0x984ca5a3
    private static let builder6473d0FourthA0U32Add: UInt32 = 0x3bb4166d
    private static let builder6473d0FourthAMulTable = 0x11e508
    private static let builder6473d0FourthAAddTable = 0x11dc88
    private static let builder6473d0FourthAU32Mul: UInt32 = 0xb2d6e3f9
    private static let builder6473d0FourthAU32Add: UInt32 = 0xfb7f4287
    private static let builder6473d0FourthAFoldMul: UInt64 = 0xd1ffa13328840637
    private static let builder6473d0FourthAFoldAdd: UInt64 = 0x2262d6944a6e7f87
    private static let builder6473d0FourthAFoldTable = 0x300470
    private static let builder6473d0FourthAFoldedMul: UInt64 = 0xac42268700000000
    private static let builder6473d0FourthALinearMul: UInt64 = 0x814152cd7b468eff
    private static let builder6473d0FourthALinearAdd: UInt64 = 0xef9b4475a4d654da
    private static let builder6473d0FourthB0U32Mul: UInt32 = 0xe701693f
    private static let builder6473d0FourthB0U32Add: UInt32 = 0xf6342272
    private static let builder6473d0FourthBMulTable = 0x11bb88
    private static let builder6473d0FourthBAddTable = 0x11bba8
    private static let builder6473d0FourthBU32Mul: UInt32 = 0xc6f77079
    private static let builder6473d0FourthBU32Add: UInt32 = 0xe9127329
    private static let builder6473d0FourthBFoldMul: UInt64 = 0xd34530d23ec1313b
    private static let builder6473d0FourthBFoldAdd: UInt64 = 0xb004febcdc86f0ed
    private static let builder6473d0FourthBFoldTable = 0x3004f0
    private static let builder6473d0FourthBFoldedMul: UInt64 = 0xdc92270100000000
    private static let builder6473d0FourthBLinearMul: UInt64 = 0xceecbc048b18d1c5
    private static let builder6473d0FourthBLinearAdd: UInt64 = 0xc37fd29022b6d9f5
    private static let builder6473d0FourthConvBaseAdd: UInt64 = 0xae9114e278083c51
    private static let builder6473d0FourthConvCountMul: UInt64 = 0x4fe0792a5595a26c
    private static let builder6473d0FourthConvProductMul: UInt64 = 0x803778f9280a64a7
    private static let builder6473d0FourthConvSumAMul: UInt64 = 0xe524e08d7cfc960f
    private static let builder6473d0FourthConvSumBMul: UInt64 = 0x21c7bf84b2e3e84c
    private static let builder6473d0FourthConvFinalMul: UInt64 = 0x46c1c6f2d742d5b5
    private static let builder6473d0FourthConvFinalAdd: UInt64 = 0x1f5c231ea84be10c
    private static let builder6473d0FifthStaticQ0 = 0x124e40
    private static let builder6473d0FifthStaticQ1 = 0x125c20
    private static let builder6473d0FifthStaticD1 = 0x126778
    private static let builder6473d0FifthFourthMulTable = 0x1148a8
    private static let builder6473d0FifthContext158MulTable = 0x11e528
    private static let builder6473d0FifthIn1MulTable = 0x1148c8
    private static let builder6473d0FifthSP3D8StateInit: UInt32 = 0x68c6dea6
    private static let builder6473d0FifthSP3D8StateMul: UInt32 = 0x3e3c7069
    private static let builder6473d0FifthSP3D8FoldPreMul: UInt32 = 0xe2d8f8a1
    private static let builder6473d0FifthSP3D8FoldPreAdd: UInt32 = 0xcb837279
    private static let builder6473d0FifthSP3D8SideMul: UInt32 = 0x3f4a34bb
    private static let builder6473d0FifthSP3D8SideFoldedMul: UInt32 = 0x50000000
    private static let builder6473d0FifthSP3D8SideAdd: UInt32 = 0xd3af772c
    private static let builder6473d0FifthSP3D8NextFolded7Mul: UInt32 = 0x09ce4439
    private static let builder6473d0FifthSP3D8NextFolded8Mul: UInt32 = 0x631bbc70
    private static let builder6473d0FifthSP3D8NextAdd: UInt32 = 0x4949bbb6
    private static let builder6473d0FifthSP3D8FoldTable = 0x300570
    private static let builder6473d0FifthSP3D8OutMulTable = 0x123dc8
    private static let builder6473d0FifthSP3D8OutAddTable = 0x115408
    private static let builder6473d0FifthA0U32Mul: UInt32 = 0x72f7749f
    private static let builder6473d0FifthA0U32Add: UInt32 = 0xf4acd75f
    private static let builder6473d0FifthAMulTable = 0x11f568
    private static let builder6473d0FifthAAddTable = 0x11fd88
    private static let builder6473d0FifthAU32Mul: UInt32 = 0x496b3517
    private static let builder6473d0FifthAU32Add: UInt32 = 0xcb6c6440
    private static let builder6473d0FifthAFoldMul: UInt64 = 0xed35bde10b7f0a6d
    private static let builder6473d0FifthAFoldAdd: UInt64 = 0x6dc10d7393e30fd4
    private static let builder6473d0FifthAFoldTable = 0x3005b0
    private static let builder6473d0FifthAFoldedMul: UInt64 = 0x2ff00d6100000000
    private static let builder6473d0FifthALinearMul: UInt64 = 0x35078add682583b3
    private static let builder6473d0FifthALinearAdd: UInt64 = 0x98856e9773f37314
    private static let builder6473d0FifthB0U32Mul: UInt32 = 0x37d64dab
    private static let builder6473d0FifthB0U32Add: UInt32 = 0xc5e5e2fb
    private static let builder6473d0FifthBMulTable = 0x1148e8
    private static let builder6473d0FifthBAddTable = 0x118ec8
    private static let builder6473d0FifthBU32Mul: UInt32 = 0xbfc55b8f
    private static let builder6473d0FifthBU32Add: UInt32 = 0x1239d41d
    private static let builder6473d0FifthBFoldMul: UInt64 = 0xb32c7a78268d803f
    private static let builder6473d0FifthBFoldAdd: UInt64 = 0x3751011be1daba47
    private static let builder6473d0FifthBFoldTable = 0x300630
    private static let builder6473d0FifthBFoldedMul: UInt64 = 0x5c54cc7d00000000
    private static let builder6473d0FifthBLinearMul: UInt64 = 0x769635acb20a2d3d
    private static let builder6473d0FifthBLinearAdd: UInt64 = 0xd7e17822568f72b6
    private static let builder6473d0FifthConvBaseAdd: UInt64 = 0x6bb3ed620e4062d1
    private static let builder6473d0FifthConvCountMul: UInt64 = 0x5a7ef60c532941a8
    private static let builder6473d0FifthConvProductMul: UInt64 = 0x6d7ef3b93c27bb1b
    private static let builder6473d0FifthConvSumAMul: UInt64 = 0x4899963aacd79ade
    private static let builder6473d0FifthConvSumBMul: UInt64 = 0xb234bdac100e1d64
    private static let builder6473d0FifthConvFinalMul: UInt64 = 0x7c7297a28fd61e6b
    private static let builder6473d0FifthConvFinalAdd: UInt64 = 0xc0f5768719fc1ff6
    private static let builder6473d0SixthSP380MulTable = 0x1205a8
    private static let builder6473d0SixthSP380AddTable = 0x119f88
    private static let builder6473d0SixthA0U32Mul: UInt32 = 0xaab2b12b
    private static let builder6473d0SixthA0U32Add: UInt32 = 0x7657d9e0
    private static let builder6473d0SixthAMulTable = 0x112de8
    private static let builder6473d0SixthAAddTable = 0x120f08
    private static let builder6473d0SixthAU32Mul: UInt32 = 0xe1c1f541
    private static let builder6473d0SixthAU32Add: UInt32 = 0xa44e1c99
    private static let builder6473d0SixthAFoldMul: UInt64 = 0x14ba61e7dca94a8b
    private static let builder6473d0SixthAFoldAdd: UInt64 = 0x50b1b5306d47040b
    private static let builder6473d0SixthAFoldTable = 0x300730
    private static let builder6473d0SixthAFoldedMul: UInt64 = 0xb5f6b68f00000000
    private static let builder6473d0SixthALinearMul: UInt64 = 0xd41818fe79de8a5b
    private static let builder6473d0SixthALinearAdd: UInt64 = 0xd151dec0329e6e93
    private static let builder6473d0SixthB0U32Mul: UInt32 = 0x84509d71
    private static let builder6473d0SixthB0U32Add: UInt32 = 0x1c1eb057
    private static let builder6473d0SixthBMulTable = 0x113fa8
    private static let builder6473d0SixthBAddTable = 0x122a28
    private static let builder6473d0SixthBU32Mul: UInt32 = 0xeaf35335
    private static let builder6473d0SixthBU32Add: UInt32 = 0x0aa66a43
    private static let builder6473d0SixthBFoldMul: UInt64 = 0x601f255bbc8594af
    private static let builder6473d0SixthBFoldAdd: UInt64 = 0x3abe7da8622c20aa
    private static let builder6473d0SixthBFoldTable = 0x3006b0
    private static let builder6473d0SixthBFoldedMul: UInt64 = 0xa22de34100000000
    private static let builder6473d0SixthBLinearMul: UInt64 = 0x1a4af047ce7b1291
    private static let builder6473d0SixthBLinearAdd: UInt64 = 0xfc749709a3c0a2f0
    private static let builder6473d0SixthConvBaseAdd: UInt64 = 0x48627c9e905863c1
    private static let builder6473d0SixthConvCountMul: UInt64 = 0x870c05f8b8020220
    private static let builder6473d0SixthConvProductMul: UInt64 = 0x171538f14356cf37
    private static let builder6473d0SixthConvSumAMul: UInt64 = 0x077d4a1b0a412afa
    private static let builder6473d0SixthConvSumBMul: UInt64 = 0xe17b173ed4c11f30
    private static let builder6473d0SixthConvFinalMul: UInt64 = 0xcfb213eb0fd9778f
    private static let builder6473d0SixthConvFinalAdd: UInt64 = 0xad771cda5ed87b82
    private static let builder6473d0SeventhSP328MulTable = 0x116888
    private static let builder6473d0SeventhSP328AddTable = 0x115ee8
    private static let builder6473d0SeventhSP750A0U32Mul: UInt32 = 0xcbc32467
    private static let builder6473d0SeventhSP750A0U32Add: UInt32 = 0x1cbc099b
    private static let builder6473d0SeventhSP750MulTable = 0x11a928
    private static let builder6473d0SeventhSP750AddTable = 0x1205c8
    private static let builder6473d0SeventhSP750U32Mul: UInt32 = 0xd5de3091
    private static let builder6473d0SeventhSP750U32Add: UInt32 = 0xc850f622
    private static let builder6473d0SeventhSP750FoldMul: UInt64 = 0x29ccd0b4b66bf69b
    private static let builder6473d0SeventhSP750FoldAdd: UInt64 = 0x92b5c9aad779cd01
    private static let builder6473d0SeventhSP750FoldTable = 0x3007b0
    private static let builder6473d0SeventhSP750FoldedMul: UInt64 = 0x69bd621900000000
    private static let builder6473d0SeventhSP750LinearMul: UInt64 = 0xf8eecd0e379e94dd
    private static let builder6473d0SeventhSP750LinearAdd: UInt64 = 0x42ed620b1951ea95
    private static let builder6473d0SeventhSP698A0U32Mul: UInt32 = 0xa331630f
    private static let builder6473d0SeventhSP698A0U32Add: UInt32 = 0x9bfc072b
    private static let builder6473d0SeventhSP698MulTable = 0x1221c8
    private static let builder6473d0SeventhSP698AddTable = 0x1136c8
    private static let builder6473d0SeventhSP698U32Mul: UInt32 = 0x5c6a96ef
    private static let builder6473d0SeventhSP698U32Add: UInt32 = 0x7bbe0d20
    private static let builder6473d0SeventhSP698FoldMul: UInt64 = 0x0f9465160d0a8253
    private static let builder6473d0SeventhSP698FoldAdd: UInt64 = 0xf56e8b822124be55
    private static let builder6473d0SeventhSP698FoldTable = 0x300830
    private static let builder6473d0SeventhSP698FoldedMul: UInt64 = 0x5f21e5dd00000000
    private static let builder6473d0SeventhSP698LinearMul: UInt64 = 0x0889f295bda63f59
    private static let builder6473d0SeventhSP698LinearAdd: UInt64 = 0x827f2e3ed1537188
    private static let builder6473d0SeventhConvBaseAdd: UInt64 = 0x4f71889106fdcf1a
    private static let builder6473d0SeventhConvCountMul: UInt64 = 0xc645bd197ffec780
    private static let builder6473d0SeventhConvProductMul: UInt64 = 0x902bc054731b0e19
    private static let builder6473d0SeventhConvSumAMul: UInt64 = 0x6ee76be95cd58d16
    private static let builder6473d0SeventhConvSumBMul: UInt64 = 0x2975699057393140
    private static let builder6473d0SeventhConvFinalMul: UInt64 = 0xfabebc0148fce955
    private static let builder6473d0SeventhConvFinalAdd: UInt64 = 0xd9e959c072d37daf
    private static let builder6473d0EighthSP2D0MulTable = 0x122a48
    private static let builder6473d0EighthSP2D0AddTable = 0x117208
    private static let builder6473d0EighthA0U32Mul: UInt32 = 0x06cb3af9
    private static let builder6473d0EighthA0U32Add: UInt32 = 0x35bb0129
    private static let builder6473d0EighthAMulTable = 0x118448
    private static let builder6473d0EighthAAddTable = 0x114908
    private static let builder6473d0EighthAU32Mul: UInt32 = 0xac8612f9
    private static let builder6473d0EighthAU32Add: UInt32 = 0x93df82d0
    private static let builder6473d0EighthAFoldMul: UInt64 = 0xea864d2bbd71e693
    private static let builder6473d0EighthAFoldAdd: UInt64 = 0xbd72f04e9eb16893
    private static let builder6473d0EighthAFoldTable = 0x3008b0
    private static let builder6473d0EighthAFoldedMul: UInt64 = 0x89c4bba700000000
    private static let builder6473d0EighthALinearMul: UInt64 = 0xfc50406703b9351b
    private static let builder6473d0EighthALinearAdd: UInt64 = 0xdc2e9343b6f35309
    private static let builder6473d0EighthB0U32Mul: UInt32 = 0x744d2f57
    private static let builder6473d0EighthB0U32Add: UInt32 = 0x54be6d45
    private static let builder6473d0EighthBMulTable = 0x1136e8
    private static let builder6473d0EighthBAddTable = 0x123de8
    private static let builder6473d0EighthBU32Mul: UInt32 = 0xed2a4af5
    private static let builder6473d0EighthBU32Add: UInt32 = 0x7159ddd6
    private static let builder6473d0EighthBFoldMul: UInt64 = 0xf5a291e49092493d
    private static let builder6473d0EighthBFoldAdd: UInt64 = 0x317bb3a8544de11f
    private static let builder6473d0EighthBFoldTable = 0x300930
    private static let builder6473d0EighthBFoldedMul: UInt64 = 0x33652f4500000000
    private static let builder6473d0EighthBLinearMul: UInt64 = 0x4de23df1210f0f8f
    private static let builder6473d0EighthBLinearAdd: UInt64 = 0xc716615aa5d2b4a0
    private static let builder6473d0EighthConvBaseAdd: UInt64 = 0x6b3d1044d1e0bae4
    private static let builder6473d0EighthConvCountMul: UInt64 = 0x1cfde242e61ced64
    private static let builder6473d0EighthConvProductMul: UInt64 = 0x9c4b2fa9d6a82bcb
    private static let builder6473d0EighthConvSumAMul: UInt64 = 0x397a076065abdda4
    private static let builder6473d0EighthConvSumBMul: UInt64 = 0xd82dc30e2ff5c69b
    private static let builder6473d0EighthConvFinalMul: UInt64 = 0xfc34a2ab410fb0ab
    private static let builder6473d0EighthConvFinalAdd: UInt64 = 0x750634486b3a5505
    private static let builder6473d0Ninth1StaticQ0 = 0x126550
    private static let builder6473d0Ninth1StaticQ1 = 0x124f30
    private static let builder6473d0Ninth1StaticD1 = 0x126c30
    private static let builder6473d0Ninth1EighthMulTable = 0x11d488
    private static let builder6473d0Ninth1Context208MulTable = 0x113fc8
    private static let builder6473d0Ninth1SP328MulTable = 0x112e08
    private static let builder6473d0Ninth1SP2D0MulTable = 0x117b28
    private static let builder6473d0Ninth1Out3StateInit: UInt32 = 0x6c423344
    private static let builder6473d0Ninth1Out3StateMul: UInt32 = 0x5f7e4217
    private static let builder6473d0Ninth1Out3FoldPreMul: UInt32 = 0x7b015015
    private static let builder6473d0Ninth1Out3FoldPreAdd: UInt32 = 0x5f6e7ace
    private static let builder6473d0Ninth1Out3SideMul: UInt32 = 0xb4d76dfb
    private static let builder6473d0Ninth1Out3SideFoldedMul: UInt32 = 0x10000000
    private static let builder6473d0Ninth1Out3SideAdd: UInt32 = 0x9eeaec8f
    private static let builder6473d0Ninth1Out3NextFolded7Mul: UInt32 = 0x9b8c81cb
    private static let builder6473d0Ninth1Out3NextFolded8Mul: UInt32 = 0x4737e350
    private static let builder6473d0Ninth1Out3NextAdd: UInt32 = 0xd38a5bb7
    private static let builder6473d0Ninth1Out3FoldTable = 0x3009b0
    private static let builder6473d0Ninth1Out3OutMulTable = 0x119fa8
    private static let builder6473d0Ninth1Out3OutAddTable = 0x11ec08
    private static let builder6473d0Ninth2StaticQ0 = 0x124f40
    private static let builder6473d0Ninth2StaticQ1 = 0x126610
    private static let builder6473d0Ninth2StaticD1 = 0x126d10
    private static let builder6473d0Ninth2SP2D0MulTable = 0x113fe8
    private static let builder6473d0Ninth2Context260MulTable = 0x117228
    private static let builder6473d0Ninth2Out2MulTable = 0x11b3e8
    private static let builder6473d0Ninth2SP278StateInit: UInt32 = 0x8d141c95
    private static let builder6473d0Ninth2SP278StateMul: UInt32 = 0xb65c329f
    private static let builder6473d0Ninth2SP278FoldPreMul: UInt32 = 0x76178341
    private static let builder6473d0Ninth2SP278FoldPreAdd: UInt32 = 0xda083f12
    private static let builder6473d0Ninth2SP278SideMul: UInt32 = 0x7da69527
    private static let builder6473d0Ninth2SP278SideFoldedMul: UInt32 = 0x90000000
    private static let builder6473d0Ninth2SP278SideAdd: UInt32 = 0x01f661ed
    private static let builder6473d0Ninth2SP278NextFolded7Mul: UInt32 = 0x4f3ae49f
    private static let builder6473d0Ninth2SP278NextFolded8Mul: UInt32 = 0x0c51b610
    private static let builder6473d0Ninth2SP278NextAdd: UInt32 = 0xc23b392a
    private static let builder6473d0Ninth2SP278FoldTable = 0x3009f0
    private static let builder6473d0Ninth2SP278OutMulTable = 0x1125c8
    private static let builder6473d0Ninth2SP278OutAddTable = 0x118468
    private static let builder6473d0NinthSP3D8AMulTable = 0x119fc8
    private static let builder6473d0NinthSP3D8AAddTable = 0x11a948
    private static let builder6473d0NinthSP3D8AU32Mul: UInt32 = 0x3f3b07b5
    private static let builder6473d0NinthSP3D8AU32Add: UInt32 = 0xa76f4d34
    private static let builder6473d0NinthSP3D8AFoldMul: UInt64 = 0x42a5684e40c837e5
    private static let builder6473d0NinthSP3D8AFoldAdd: UInt64 = 0x8187dd38d660ab02
    private static let builder6473d0NinthSP3D8AFoldTable = 0x300a30
    private static let builder6473d0NinthSP3D8AFoldedMul: UInt64 = 0xc387f23b00000000
    private static let builder6473d0NinthSP3D8ALinearMul: UInt64 = 0x41edfb94e441a439
    private static let builder6473d0NinthSP3D8ALinearAdd: UInt64 = 0x8630a437323b9a06
    private static let builder6473d0NinthSP278BMulTable = 0x114008
    private static let builder6473d0NinthSP278BAddTable = 0x115428
    private static let builder6473d0NinthSP278BU32Mul: UInt32 = 0x3bc03ba1
    private static let builder6473d0NinthSP278BU32Add: UInt32 = 0x551e0b18
    private static let builder6473d0NinthSP278BFoldMul: UInt64 = 0x4a4ebd73a2ac7ecf
    private static let builder6473d0NinthSP278BFoldAdd: UInt64 = 0xc26c352e790eb9d2
    private static let builder6473d0NinthSP278BFoldTable = 0x300ab0
    private static let builder6473d0NinthSP278BFoldedMul: UInt64 = 0x325b382b00000000
    private static let builder6473d0NinthSP278BLinearMul: UInt64 = 0x3b1bfc266fb46b3b
    private static let builder6473d0NinthSP278BLinearAdd: UInt64 = 0xc26ae547d56e3752
    private static let builder6473d0NinthConv1StateInit: UInt64 = 0x44890e57fee2b127
    private static let builder6473d0NinthConv1CountMul: UInt64 = 0x22e7e2dd39986f0c
    private static let builder6473d0NinthConv1SumAMul: UInt64 = 0xefcd57be2939dd8e
    private static let builder6473d0NinthConv1ProductMul: UInt64 = 0x3579615d7809d6f9
    private static let builder6473d0NinthConv1SumBMul: UInt64 = 0xfb335b5dda0d71fa
    private static let builder6473d0NinthConv1FoldPreMul: UInt64 = 0xa56af869b8f14f9f
    private static let builder6473d0NinthConv1FoldPreAdd: UInt64 = 0x4dce076dc16d62a6
    private static let builder6473d0NinthConv1FoldTable = 0x300b30
    private static let builder6473d0NinthConv1SideMul: UInt32 = 0x5c05a20f
    private static let builder6473d0NinthConv1SideFoldedMul: UInt32 = 0xf0000000
    private static let builder6473d0NinthConv1SideAdd: UInt32 = 0x42d490fb
    private static let builder6473d0NinthConv1NextFolded8Mul: UInt64 = 0x3422cdbd16480c5f
    private static let builder6473d0NinthConv1NextFolded16Mul: UInt64 = 0x9b7f3a1000000000
    private static let builder6473d0NinthConv1NextAdd: UInt64 = 0x5788d57815189c66
    private static let builder6473d0NinthConv1OutMulTable = 0x11e548
    private static let builder6473d0NinthConv1OutAddTable = 0x119fe8
    private static let builder6473d0NinthIn1AMulTable = 0x115f08
    private static let builder6473d0NinthIn1AAddTable = 0x118488
    private static let builder6473d0NinthIn1AU32Mul: UInt32 = 0xa23b4591
    private static let builder6473d0NinthIn1AU32Add: UInt32 = 0x27b4f995
    private static let builder6473d0NinthIn1AFoldMul: UInt64 = 0xe3d571fe10b7dd6f
    private static let builder6473d0NinthIn1AFoldAdd: UInt64 = 0x0ead98380f165a1b
    private static let builder6473d0NinthIn1AFoldTable = 0x300bb0
    private static let builder6473d0NinthIn1AFoldedMul: UInt64 = 0x24883b3100000000
    private static let builder6473d0NinthIn1ALinearMul: UInt64 = 0xb919418f2dce08c1
    private static let builder6473d0NinthIn1ALinearAdd: UInt64 = 0xc178a260ab561c2d
    private static let builder6473d0NinthSP328BMulTable = 0x11c348
    private static let builder6473d0NinthSP328BAddTable = 0x11e568
    private static let builder6473d0NinthSP328BU32Mul: UInt32 = 0xc7e7ff39
    private static let builder6473d0NinthSP328BU32Add: UInt32 = 0x6ede9d60
    private static let builder6473d0NinthSP328BFoldMul: UInt64 = 0xb7f69af6de331b05
    private static let builder6473d0NinthSP328BFoldAdd: UInt64 = 0xfb07ecba9e561d89
    private static let builder6473d0NinthSP328BFoldTable = 0x300c30
    private static let builder6473d0NinthSP328BFoldedMul: UInt64 = 0x9c0181bb00000000
    private static let builder6473d0NinthSP328BLinearMul: UInt64 = 0xc2cb60ecc908be59
    private static let builder6473d0NinthSP328BLinearAdd: UInt64 = 0xf63168d72b49d4d5
    private static let builder6473d0NinthConv2StateInit: UInt64 = 0xc46e4bf2bc94905f
    private static let builder6473d0NinthConv2CountMul: UInt64 = 0xb43becaf979eccdb
    private static let builder6473d0NinthConv2SumAMul: UInt64 = 0xea769816201b6855
    private static let builder6473d0NinthConv2ProductMul: UInt64 = 0x0286e00ddaf23867
    private static let builder6473d0NinthConv2SumBMul: UInt64 = 0xa5fd2d47569ca4a9
    private static let builder6473d0NinthConv2FoldPreMul: UInt64 = 0x131a43f6b293c469
    private static let builder6473d0NinthConv2FoldPreAdd: UInt64 = 0xae11e8f737712446
    private static let builder6473d0NinthConv2FoldTable = 0x300cb0
    private static let builder6473d0NinthConv2SideMul: UInt32 = 0xe9b78f65
    private static let builder6473d0NinthConv2SideFoldedMul: UInt32 = 0x30000000
    private static let builder6473d0NinthConv2SideAdd: UInt32 = 0x3d19005d
    private static let builder6473d0NinthConv2NextFolded8Mul: UInt64 = 0xd206f236cb1e0bd9
    private static let builder6473d0NinthConv2NextFolded16Mul: UInt64 = 0x4e1f427000000000
    private static let builder6473d0NinthConv2NextAdd: UInt64 = 0x1008f89662553eaa
    private static let builder6473d0NinthConv2OutMulTable = 0x11d4a8
    private static let builder6473d0NinthConv2OutAddTable = 0x114028
    private static let builder6473d0Ninth3StaticTable = 0x114048
    private static let builder6473d0Ninth3SP1C8MulTable = 0x117b48
    private static let builder6473d0Ninth3Context2B8MulTable = 0x1184a8
    private static let builder6473d0Ninth3SP118MulTable = 0x1168a8
    private static let builder6473d0Ninth3SP68StateInit: UInt32 = 0xa2d2a851
    private static let builder6473d0Ninth3SP68StateMul: UInt32 = 0x9b30705f
    private static let builder6473d0Ninth3SP68FoldPreMul: UInt32 = 0x6cbeb92d
    private static let builder6473d0Ninth3SP68FoldPreAdd: UInt32 = 0x82af87fc
    private static let builder6473d0Ninth3SP68SideMul: UInt32 = 0x72482a2f
    private static let builder6473d0Ninth3SP68SideFoldedMul: UInt32 = 0x50000000
    private static let builder6473d0Ninth3SP68SideAdd: UInt32 = 0xc925d16a
    private static let builder6473d0Ninth3SP68NextFolded7Mul: UInt32 = 0x1d589f7b
    private static let builder6473d0Ninth3SP68NextFolded8Mul: UInt32 = 0x2a760850
    private static let builder6473d0Ninth3SP68NextAdd: UInt32 = 0xa10a4f8b
    private static let builder6473d0Ninth3SP68FoldTable = 0x300d30
    private static let builder6473d0Ninth3SP68OutMulTable = 0x118ee8
    private static let builder6473d0Ninth3SP68OutAddTable = 0x11c368
    private static let builder6473d0NinthWorkspaceMulTable = 0x117248
    private static let builder6473d0NinthWorkspaceAddTable = 0x1168c8
    private static let builder6473d0NinthWorkspaceU32Mul: UInt32 = 0xddfc952f
    private static let builder6473d0NinthWorkspaceU32Add: UInt32 = 0xfa88584b
    private static let builder6473d0NinthWorkspaceFoldMul: UInt64 = 0x4e5c7da178b9e563
    private static let builder6473d0NinthWorkspaceFoldAdd: UInt64 = 0xd8a71f348e783f37
    private static let builder6473d0NinthWorkspaceFoldTable = 0x300d70
    private static let builder6473d0NinthWorkspaceFoldedMul: UInt64 = 0x27c0cb3900000000
    private static let builder6473d0NinthWorkspaceLinearMul: UInt64 = 0x81df0a6c96766bf5
    private static let builder6473d0NinthWorkspaceLinearAdd: UInt64 = 0xc97918a2a3eb7f6b
    private static let builder6473d0TenthOut3MulTable = 0x11bbc8
    private static let builder6473d0TenthOut3AddTable = 0x115448
    private static let builder6473d0TenthAMulTable = 0x11a968
    private static let builder6473d0TenthAAddTable = 0x11c388
    private static let builder6473d0TenthA0U32Mul: UInt32 = 0x4c82531f
    private static let builder6473d0TenthA0U32Add: UInt32 = 0x9d6c5712
    private static let builder6473d0TenthAU32Mul: UInt32 = 0x7d67d167
    private static let builder6473d0TenthAU32Add: UInt32 = 0x9fe36605
    private static let builder6473d0TenthAFoldMul: UInt64 = 0xdaea1b52b6016691
    private static let builder6473d0TenthAFoldAdd: UInt64 = 0x3b80308f53669e2e
    private static let builder6473d0TenthAFoldTable = 0x300df0
    private static let builder6473d0TenthAFoldedMul: UInt64 = 0x418bbf9900000000
    private static let builder6473d0TenthALinearMul: UInt64 = 0x4b523055abe88457
    private static let builder6473d0TenthALinearAdd: UInt64 = 0x70cd301dacb08338
    private static let builder6473d0TenthBMulTable = 0x11dca8
    private static let builder6473d0TenthBAddTable = 0x114928
    private static let builder6473d0TenthB0U32Mul: UInt32 = 0xfcd41a2b
    private static let builder6473d0TenthB0U32Add: UInt32 = 0xf953e1f8
    private static let builder6473d0TenthBU32Mul: UInt32 = 0xee73b901
    private static let builder6473d0TenthBU32Add: UInt32 = 0xce0a7777
    private static let builder6473d0TenthBFoldMul: UInt64 = 0xa7fa1537bf414305
    private static let builder6473d0TenthBFoldAdd: UInt64 = 0x07a282e2032d7105
    private static let builder6473d0TenthBFoldTable = 0x300e70
    private static let builder6473d0TenthBFoldedMul: UInt64 = 0xa8b5cc4500000000
    private static let builder6473d0TenthBLinearMul: UInt64 = 0x4ebe8304c777f3a7
    private static let builder6473d0TenthBLinearAdd: UInt64 = 0xe1237f2df16faf59
    private static let builder6473d0TenthConvBaseAdd: UInt64 = 0x4f04381a3a25c55f
    private static let builder6473d0TenthConvCountMul: UInt64 = 0xeda7ceed201a4f20
    private static let builder6473d0TenthConvProductMul: UInt64 = 0x5f94dd0a9ca697b5
    private static let builder6473d0TenthConvSumAMul: UInt64 = 0xacff7aae673c319c
    private static let builder6473d0TenthConvSumBMul: UInt64 = 0x11489ebd7e12a758
    private static let builder6473d0TenthConvFinalMul: UInt64 = 0xf234ac9ea555f56f
    private static let builder6473d0TenthConvFinalAdd: UInt64 = 0x4f16240dd4606c20
    private static let builder6473d0FinalOut4MulTable = 0x11b408
    private static let builder6473d0FinalOut4AddTable = 0x11dcc8
    private static let table63c278U32Base = 0x112588
    private static let table63c278FoldBase = 0x2feb18
    private static let table633fa8TailFoldBase = 0x2fe798
    private static let table633fa8TailU32LowBase = 0x112528
    private static let builder633fa8NullTableBase = 0x2fd1f1
    private static let builder633fa8NullNibbleTableBase = 0x303a14
    private static let prog64e2b8Length = 0x250
    private static let prog638840Length = 0x8200
    private static let lowSeedStatics6388f0Length = 0x31e
    private static let lowLoopStatics6388f0Length = 0x194
    private static let laneTables6388f0Length = 0x1248
    private static let selectorTables6388f0Length = 0x20
    private static let u32Tables63c278Length = 0x14790
    private static let foldTables63c278Length = 0x3b60
    private static let tailFoldTables633fa8Length = 0x380
    private static let tailU32LowTables633fa8Length = 0x40
    private static let nullTables633fa8Length = 0x140f
    private static let nullNibble633fa8Length = 0x40
    private static let process2P5PublicTableBase = 0x3038c0
    private static let process2P5PublicTableLength = 0x518
    private static let prog67cc18Length = 0x6100
    private static let ttableBExtLength = 0x100000
    private static let finalLenTablesLength = 0x600
    private static let df80RoundTablesLength = 0x492
    private static let finalizerTablesLength = 0x12d2
    private static let seedTables679f48Length = 0x6d2
    private static let reducer67ea28NibbleLength = 0x40
    private static let prog67076cLength = 0x84
    private static let vm64e17cProgOffset = 0x1ce
    private static let vm64e17cProgLength = 0x7e

    private static let builder6388f0LowSeedBlockBytes = 0x10a
    private static let builder6388f0LowSeedEntrySourceBytes = 0x214
    private static let builder6388f0LowSeedEntryS898Magic: UInt64 = 0x10a000001764
    private static let builder6388f0LowSeedEntryS78EMagic: UInt64 = 0x10a000000fe9
    private static let builder6388f0LowSeedPrev2BD0Magic: UInt64 = 0x10a000006abd
    private static let builder6388f0LowSeedPrev2S684Magic: UInt64 = 0x10a000005fdb
    private static let builder6388f0LowSeedPrevS684Magic: UInt64 = 0x10a0000004c6
    private static let builder6388f0LowSeedMiddleMagic: UInt64 = 0x10a00000141c
    private static let builder6388f0LowSeedPreBD0Magic: UInt64 = 0x10a000003360
    private static let builder6388f0LowSeedTailBD0Magic: UInt64 = 0x10a00000505e
    private static let builder6388f0LowSeedTailLeftMagic: UInt64 = 0x10a0000003bc
    private static let builder6388f0LowSeedTailRightMagic: UInt64 = 0x10a000006bc7
    private static let builder6388f0LowSeedTailS684Magic: UInt64 = 0x10a000004a08
    private static let builder6388f0LowSeedTailStageMagic: UInt64 = 0x10a000007d1f
    private static let builder6388f0LowSeedPreludeStageMagic: UInt64 = 0x10a0000018b4
    private static let builder6388f0LowSeedPreludeSourceMagic: UInt64 = 0x10a000000c72
    private static let builder6388f0LowSeedPreludeMagic: UInt64 = 0x810a000003acb
    private static let builder6388f0LowSeedCF0Phase1SeedMagic: UInt64 = 0x000c107000c03d57
    private static let builder6388f0LowSeedCF0Phase2SeedMagic: UInt64 = 0x000c107000c05886
    private static let builder6388f0LowSeedCF0Phase3SeedMagic: UInt64 = 0x000c107000c036a0
    private static let builder6388f0LowSeedStaticBase = 0x2f4d28
    private static let builder6388f0LowSeedPrev2Static = 0x2f4d28
    private static let builder6388f0LowSeedPreStatic = 0x2f4e32
    private static let builder6388f0LowSeedTailStatic = 0x2f4f3c
    private static let builder6388f0LowSeedE10SourceShifts = [4, 8, 16, 32, 64, 128, 256]
    private static let builder6388f0LowSeedExpandedPreludeBytes = 0x10c
    private static let builder6388f0LowSeedSeedBlocksBytes = 20 * 0x10
    private static let builder6388f0Row0SeedBlockMagic: UInt64 = 0x10000005fcb
    private static let builder6388f0LowLoopStaticBase = 0x2fe600
    private static let builder6388f0LowLoopStaticETable = 0x2fe600
    private static let builder6388f0LowLoopStaticDTable = 0x2fe690
    private static let builder6388f0LowSeedStaticBlockOffset = 0x2fe720
    private static let builder6388f0LowLoopStaticCTable = 0x2fe730
    private static let builder6388f0LowLoopStaticATable = 0x2fe742
    private static let builder6388f0LowLoopNibbleTable = 0x2fe754
    private static let builder6388f0LowLoopLaneBytes = 18
    private static let builder6388f0LowLoopEInitMagic: UInt64 = 0x12000006ef9
    private static let builder6388f0LowLoopDInitMagic: UInt64 = 0x801000000654d
    private static let builder6388f0LowLoopBInitMagic: UInt64 = 0x12000007d0d
    private static let builder6388f0LowLoopFMagic: UInt64 = 0x12000000398
    private static let builder6388f0LowLoopAMagic: UInt64 = 0x12000006ddb
    private static let builder6388f0LowLoopTMagic: UInt64 = 0x12000001752
    private static let builder6388f0LowLoopBMixMagic: UInt64 = 0x12000002dd3
    private static let builder6388f0LowLoopEAdvanceMagic: UInt64 = 0x12000007ae7
    private static let builder6388f0LowLoopCAdvanceMagic: UInt64 = 0x12000006897
    private static let builder6388f0LowLoopPostFMagic: UInt64 = 0x12000003241
    private static let builder6388f0LowLoopPostDMagic: UInt64 = 0x120000045a8
    private static let builder6388f0LowLoopPostEMagic: UInt64 = 0xc000f000c01bfa
    private static let builder6388f0LowLoopPackCMagic: UInt64 = 0x4000004a04
    private static let builder6388f0LowLoopPackEMagic: UInt64 = 0x8010000800350
    private static let builder6388f0LowLoopPackBMagic: UInt64 = 0x4000002271
    private static let builder633fa8ScalarWordCount = 20
    private static let builder633fa8ScalarWindowBytes = 70
    private static let builder633fa8ScalarPackMulTable = 0x121808
    private static let builder633fa8ScalarPackAddTable = 0x11f508
    private static let builder633fa8ScalarPackMul: UInt32 = 0x37c0c559
    private static let builder633fa8ScalarPackAdd: UInt32 = 0xfa73673b
    private static let builder633fa8E10TailFoldTable = 0x2fea98
    private static let builder633fa8E10TailMulTable = 0x118e08
    private static let builder633fa8E10TailAddTable = 0x1229c8
    private static let builder633fa8E10InitialCarry: UInt64 = 0x7f9e71176c43f336
    private static let builder633fa8E10QwordMul: UInt64 = 0xa44fd620a45fddc7
    private static let builder633fa8E10CarryMul: UInt64 = 0x8b3babe0304f96f9
    private static let builder633fa8E10CarryAdd: UInt64 = 0x12e00771bb9547af
    private static let builder633fa8E10FoldSeedMul: UInt64 = 0x039ae28b51354965
    private static let builder633fa8E10FoldSeedAdd: UInt64 = 0x248e5dc60fc0f4fb
    private static let builder633fa8E10WordMul: UInt32 = 0x4a018c3b
    private static let builder633fa8E10WordAdd: UInt32 = 0x79d84f1b
    private static let builder633fa8E10NextCarryFolded7Mul: UInt64 = 0xd310088be2b9ce15
    private static let builder633fa8E10NextCarryFolded16Mul: UInt64 = 0xd4631eb000000000
    private static let builder633fa8E10NextCarryAdd: UInt64 = 0x02f149c1c6520051
    private static let builder633fa8TailStackBytes = 0x4300
    private static let builder633fa8TailAFoldTable = 0x2fe798
    private static let builder633fa8TailBFoldTable = 0x2fe818
    private static let builder633fa8TailCFoldTable = 0x2fe898
    private static let builder633fa8TailDFoldTable = 0x2fe918
    private static let builder633fa8TailEFoldTable = 0x2fe998
    private static let builder633fa8TailFFoldTable = 0x2fea18
    private static let builder633fa8InvariantWords2dfc: [UInt32] = [
        0x9bed19fd, 0xc70a4d0f, 0x8257d22b, 0xe2fafcb3, 0x02c77d20,
        0xb5ed0efa, 0x878c1b06, 0x4bd92d7d, 0x21c6944f, 0xd3ec5d2f,
        0x876fda86, 0x37f3e22a, 0x3cfcd7ce, 0xabdc16eb, 0x84ad2f7d,
        0x4bd92d7d, 0xf647adce, 0xaa7b701e, 0x876fda86, 0x37f3e22a,
    ]
    private static let builder633fa8InvariantSeed3110: UInt64 = 0xb6ccf02833a9825e
    private static let builder633fa8InvariantWords3120: [UInt32] = [
        0xb33842d7, 0x7b6ba784, 0xa2f90f36, 0xde5e2ad7, 0x3c3537a9,
        0x81d564f6, 0x339ab4a2, 0x999de03b, 0x56c13b42, 0xff14a487,
        0x5a31640c, 0xc3f85236, 0x3c1dc79e, 0x58a8d4a6, 0x541cb00e,
        0x63323fcd, 0x1aa54a16, 0x01f1b661, 0x5a31640c, 0xc3f85236,
    ]
    private static let builder633fa8NullEntropyBytes = 0x11a
    private static let builder633fa8NullInitialAMagic: UInt64 = 0x11a000000236
    private static let builder633fa8NullInitialBMagic: UInt64 = 0x11a0000047e0
    private static let builder633fa8NullSeedBlockMagic: UInt64 = 0x1000000725d
    private static let builder633fa8NullSeedBlockBytes = 0x10
    private static let builder633fa8NullSeedBlockStride = 0x0e
    private static let builder633fa8NullSeedBlocksBytes = 20 * builder633fa8NullSeedBlockBytes
    private static let builder633fa8NullLoopStaticETable = 0x2fd1f1
    private static let builder633fa8NullLoopStaticDTable = 0x2fd281
    private static let builder633fa8NullLoopStaticCTable = 0x2fd311
    private static let builder633fa8NullLoopStaticATable = 0x2fd323
    private static let builder633fa8NullLoopNibbleTable = 0x303a14
    private static let builder633fa8NullLoopLaneBytes = 18
    private static let builder633fa8NullLoopEInitMagic: UInt64 = 0x12000000376
    private static let builder633fa8NullLoopDInitMagic: UInt64 = 0x8010000002447
    private static let builder633fa8NullLoopBInitMagic: UInt64 = 0x120000010f3
    private static let builder633fa8NullLoopFMagic: UInt64 = 0x12000004596
    private static let builder633fa8NullLoopAMagic: UInt64 = 0x12000007141
    private static let builder633fa8NullLoopTMagic: UInt64 = 0x12000008199
    private static let builder633fa8NullLoopBMixMagic: UInt64 = 0x1200000726d
    private static let builder633fa8NullLoopEAdvanceMagic: UInt64 = 0x12000000eab
    private static let builder633fa8NullLoopCAdvanceMagic: UInt64 = 0x12000005026
    private static let builder633fa8NullLoopPostFMagic: UInt64 = 0x12000003e64
    private static let builder633fa8NullLoopPostDMagic: UInt64 = 0x12000001be8
    private static let builder633fa8NullLoopPostEMagic: UInt64 = 0x0c00f000c079c5
    private static let builder633fa8NullLoopPackCMagic: UInt64 = 0x4000000a28
    private static let builder633fa8NullLoopPackEMagic: UInt64 = 0x8010000806883
    private static let builder633fa8NullLoopPackBMagic: UInt64 = 0x400000186e
    private static let builder633fa8NullCheck1ScheduleMulTable = 0x11b228
    private static let builder633fa8NullCheck1SourceMulTable = 0x1152c8
    private static let builder633fa8NullCheck1AddTable = 0x119688
    private static let builder633fa8NullCheck1FoldTable = 0x2fd338
    private static let builder633fa8NullCheck1Target: UInt32 = 0xc5e51deb
    private static let builder633fa8NullCheck1FoldTarget: UInt32 = 0x0b
    private static let builder633fa8NullCheck2ScheduleMulTable = 0x120e28
    private static let builder633fa8NullCheck2SourceMulTable = 0x11b248
    private static let builder633fa8NullCheck2AddTable = 0x11f4e8
    private static let builder633fa8NullCheck2FoldTable = 0x2fd378
    private static let builder633fa8NullCheck2Target: UInt32 = 0xfbc7d17c
    private static let builder633fa8NullCheck2FoldTarget: UInt32 = 0x0c
    private static let builder633fa8NullPostKeyMulTable = 0x118de8
    private static let builder633fa8NullPostKeyAddTable = 0x113ee8
    private static let builder633fa8NullPostInitCF0Static = 0x2fe5b8
    private static let builder633fa8NullPostInitBD0Static = 0x2fe5ca
    private static let builder633fa8NullPostTableCF0 = 0x2fd3b8
    private static let builder633fa8NullPostTableBD0 = 0x2fdcb8
    private static let builder633fa8NullPostFinalCF0Static = 0x2fe5dc
    private static let builder633fa8NullPostFinalBD0Static = 0x2fe5ee
    private static let builder633fa8NullPostInitCF0Magic: UInt64 = 0x12000005508
    private static let builder633fa8NullPostInitBD0Magic: UInt64 = 0x12000005874
    private static let builder633fa8NullPostMixCF0Magic: UInt64 = 0x12000002dc1
    private static let builder633fa8NullPostMixBD0Magic: UInt64 = 0x1200000653b
    private static let builder633fa8NullPostFinalCF0Magic: UInt64 = 0x120000019c2
    private static let builder633fa8NullPostFinalBD0Magic: UInt64 = 0x1200000552c
    private static let builder633fa8NullPostBlock4080Magic: UInt64 = 0x10000005864
    private static let builder633fa8NullPostBlock3f40Magic: UInt64 = 0x10000006f0b
    private static let builder633fa8NullPreludeFirst4080Magic: UInt64 = 0x10000001638
    private static let builder633fa8NullPreludeRest4080Magic: UInt64 = 0x10000000d7c
    private static let builder633fa8NullPreludeBD0Magic: UInt64 = 0x11a000002ffd
    private static let builder633fa8NullPreludeFirst3f40Magic: UInt64 = 0x10000003690
    private static let builder633fa8NullPreludeRest3f40Magic: UInt64 = 0x10000008167
    private static let builder633fa8NullPreludeAB0Magic: UInt64 = 0x11a000003117
    private static let builder633fa8NullPreludeStage4080Magic: UInt64 = 0x11a00000267f
    private static let builder633fa8NullPreludeF40Magic: UInt64 = 0x11a000000ecf
    private static let builder633fa8NullPreludeSourceMagic: UInt64 = 0x10a000004e02
    private static let builder633fa8NullEntryBitsChecksSource: [UInt8] = hexBytes(
        "3674f8f8a81c394e2bca21f938be42b1adbc94923891e2d38ee57c2d131dcebb" +
        "6eed185b2fe5d82f9543c721bdf818eb782dd2545d9b6429daaa6d5b725db614" +
        "4b8b6d5dca64a99a7565cb64a9baa66599b5688b34dd9aaadc9a354d53a2cd8a" +
        "756bca955b56b42bca12e1343551a11412fbcb2ecd59982c841bdca6eeda33bd" +
        "5e2cf8e2f1b468845576104cfaf7f8ceecfa7a15262ed5f6fa9bd9d442e12e97" +
        "ec15c1cb4c3ec1ec2881104cfaf7f8ceecfa7a15262ed5f6fa9b8bb0d0b3c47a" +
        "1c6cf95016b01676804ff8491d5e0e08e8c3b0504bc066ef57b66fbe719164d2" +
        "19086a9310bf190e20a7c27976c5579249c17bedcf2166ef57b6453b9c865799" +
        "a2246a9310bf190e20a7"
    )

    private static let process2P5PublicScalarQwordFoldTable = 0x303d58
    private static let process2P5PublicScalarQwordMulTable = 0x1219a8
    private static let process2P5PublicScalarQwordAddTable = 0x1149e8
    private static let process2P5PublicScalarPackMulTable = 0x118608
    private static let process2P5PublicScalarPackAddTable = 0x118f68
    private static let process2P5PublicQwordFoldTableA = 0x303bd8
    private static let process2P5PublicQwordFoldTableB = 0x303c58
    private static let process2P5PublicQwordFoldTableC = 0x303cd8
    private static let process2P5PublicInitWorkspaceConstants = (
        countMul: UInt64(0x94dfbb91a5378e68),
        countAdd: UInt64(0x4218665245881823),
        productMul: UInt64(0x501edede429b621f),
        bPrefixMul: UInt64(0x6658ca76ca6e396a),
        aPrefixMul: UInt64(0x918160dbec5e059c),
        finalMul: UInt64(0xbcb96bc3c168e865),
        finalAdd: UInt64(0x242a710f34e73cea)
    )
    private static let process2P5PublicTableU32MulTable = 0x116988
    private static let process2P5PublicTableU32AddTable = 0x11d528
    private static let process2P5PublicTableFoldTable = 0x303b58
    private static let process2P5PublicTableWordMul: UInt32 = 0x347334f7
    private static let process2P5PublicTableWordAdd: UInt32 = 0x7713d14d
    private static let process2P5PublicTableQwordMul: UInt64 = 0x7378135b2404ba5f
    private static let process2P5PublicTableQwordAdd: UInt64 = 0x2bb7cb5d40ee4303
    private static let process2P5PublicTableFinalMul: UInt64 = 0x714b9632f149a92d
    private static let process2P5PublicTableFoldMul: UInt64 = 0x25f3200d00000000
    private static let process2P5PublicTableFinalAdd: UInt64 = 0x77db08099d019a2f
    private static let process2P5PublicPrefixAInitWordMul: UInt32 = 0x68309fdf
    private static let process2P5PublicPrefixAInitWordAdd: UInt32 = 0x9a8acd31
    private static let process2P5PublicPrefixAWordMulTable = 0x121988
    private static let process2P5PublicPrefixAWordAddTable = 0x117328
    private static let process2P5PublicPrefixAWordMul: UInt32 = 0xa14d75f7
    private static let process2P5PublicPrefixAWordAdd: UInt32 = 0x23fe38ed
    private static let process2P5PublicPrefixAFoldTable = 0x303a58
    private static let process2P5PublicPrefixAQwordMul: UInt64 = 0xdea88f4cd7aa9967
    private static let process2P5PublicPrefixAQwordAdd: UInt64 = 0x2498e0a8ace26d05
    private static let process2P5PublicPrefixAFoldMul: UInt64 = 0x2403505500000000
    private static let process2P5PublicPrefixAFinalMul: UInt64 = 0x77260d39cc35e0cd
    private static let process2P5PublicPrefixAFinalAdd: UInt64 = 0xf68d6a799b022952
    private static let process2P5PublicPrefixBInitWordMul: UInt32 = 0xb417ac45
    private static let process2P5PublicPrefixBInitWordAdd: UInt32 = 0xb9d0b931
    private static let process2P5PublicPrefixBWordMulTable = 0x1185e8
    private static let process2P5PublicPrefixBWordAddTable = 0x112688
    private static let process2P5PublicPrefixBWordMul: UInt32 = 0x569e8293
    private static let process2P5PublicPrefixBWordAdd: UInt32 = 0xa7b25d96
    private static let process2P5PublicPrefixBFoldTable = 0x303ad8
    private static let process2P5PublicPrefixBQwordMul: UInt64 = 0xac344b5a12897c6d
    private static let process2P5PublicPrefixBQwordAdd: UInt64 = 0x7f6923d8cce61732
    private static let process2P5PublicPrefixBFoldMul: UInt64 = 0xcf8f92cb00000000
    private static let process2P5PublicPrefixBFinalMul: UInt64 = 0x671bb0c140212b91
    private static let process2P5PublicPrefixBFinalAdd: UInt64 = 0x2ecd4bceff393710
    private static let process2P5PublicASourceInitialMagic: UInt64 = 0x810a000006ded
    private static let process2P5PublicASourceBlockMagic: UInt64 = 0x10000000b46
    private static let process2P5PublicASourceStaticTailBlock = 0x3039e0
    private static let process2P5PublicASourceStaticETable = 0x3038c0
    private static let process2P5PublicASourceStaticDTable = 0x303950
    private static let process2P5PublicASourceStaticCTable = 0x3039f0
    private static let process2P5PublicASourceStaticATable = 0x303a02
    private static let process2P5PublicASourceNibbleTable = 0x303a14
    private static let process2P5PublicASourceBInitMagic: UInt64 = 0x12000004162
    private static let process2P5PublicASourceDInitMagic: UInt64 = 0x8010000000364
    private static let process2P5PublicASourcePrebridgeMagic: UInt64 = 0x120000047ce
    private static let process2P5PublicASourceFMagic: UInt64 = 0x12000005eaf
    private static let process2P5PublicASourceAMagic: UInt64 = 0x12000003574
    private static let process2P5PublicASourceTMagic: UInt64 = 0x12000008187
    private static let process2P5PublicASourceBMixMagic: UInt64 = 0x1200000266d
    private static let process2P5PublicASourceEAdvanceMagic: UInt64 = 0x12000000ebd
    private static let process2P5PublicASourceCAdvanceMagic: UInt64 = 0x1200000504c
    private static let process2P5PublicASourcePostFMagic: UInt64 = 0x12000003be7
    private static let process2P5PublicASourcePostDMagic: UInt64 = 0x12000000224
    private static let process2P5PublicASourcePostEMagic: UInt64 = 0x0c00f000c00e96
    private static let process2P5PublicASourcePackCMagic: UInt64 = 0x4000004b12
    private static let process2P5PublicASourcePackEMagic: UInt64 = 0x8010000805038
    private static let process2P5PublicASourcePackBMagic: UInt64 = 0x40000019be
    private static let process2P5PublicLowA8Mul: UInt64 = 0x93b6e33be4ad3c3f
    private static let process2P5PublicLowA8Add: UInt64 = 0x698d7878bd852e23
    private static let process2P5PublicLow80Mul: UInt64 = 0x4a0e602e6ec97079
    private static let process2P5PublicLow80Add: UInt64 = 0xad7d39c097694af0
    private static let process2P5PublicLowCopyOffsets: [(offset: Int, tableIndex: Int)] = [
        (0x88, 1), (0x90, 0), (0x78, 2), (0x68, 4), (0x70, 3),
        (0x58, 6), (0x60, 5), (0x48, 8), (0x50, 7), (0x38, 10),
        (0x40, 9), (0x28, 12), (0x30, 11),
    ]
    private static let process2P5PublicBSourceStaticWords: [UInt32] = [
        0xa99f067d, 0xb7043f80, 0x2b6ee291, 0xa4732ba2, 0x6d3a9d91,
        0x4fd9d579, 0x319597e5, 0xfce96d28, 0x48b26f75, 0x05c01679,
        0x5080bac6, 0x2e25e6a6, 0xbfbafcdf, 0x8e127707, 0x000d0fb3,
        0x4ac77820, 0x7923dadf, 0xe4ae8f3a, 0x5080bac6, 0x2e25e6a6,
    ]
    private static let process2P5PublicFixedPointBE: [UInt8] = hexBytes(
        "04" +
        "a9bf2be2fd3d90f6467b8ca074710db3804eb0cfcc952a86d23289695d435ee0" +
        "9523a7d0e8aa2c53c6f7a49e9b6bd0db7a2d1035cd61876f37e43a74a1b65237"
    )

    private static let builder6388f0LowSeedPhase1Spec = LowSeedPhaseSpec(
        phaseMagic: 0x10a000002563,
        auxMagics: [
            0x10a0000076a7, 0x10a000002de5, 0x10a000007af9, 0x10a000007e6b,
            0x10a0000068a9, 0x10a0000062e7, 0x10a000007025,
        ],
        e10Magics: [
            0x10a0000008dc, 0x10a00000448c, 0x10a000000000, 0x10a000007493,
            0x10a0000039c1, 0x10a000000b56, 0x10a000005648,
        ],
        e10Markers: [3, 2, 3, 3, 7, 6, 3],
        bd0Magic: builder6388f0LowSeedPrev2BD0Magic,
        staticOffset: builder6388f0LowSeedPrev2Static,
        unaryMagic: 0x000c107000c03253,
        f40Magics: [
            0x0410006041004174, 0x040000a040002bb7, 0x03e001203e001e19,
            0x03a002203a005ba1, 0x0320042032003f90, 0x02200820220066f1,
            0x0020102002001526,
        ]
    )

    private static let builder6388f0LowSeedPhase2Spec = LowSeedPhaseSpec(
        phaseMagic: 0x10a0000046c4,
        auxMagics: [
            0x10a0000077b1, 0x10a0000038b7, 0x10a000001ade, 0x10a00000727f,
            0x10a0000069b3, 0x10a000007c03, 0x10a00000201b,
        ],
        e10Magics: [
            0x10a000006f1b, 0x10a00000553e, 0x10a000005d93, 0x10a000001648,
            0x10a000002459, 0x10a000002aad, 0x10a0000005d0,
        ],
        e10Markers: [3, 1, 5, 7, 6, 0, 7],
        bd0Magic: builder6388f0LowSeedPreBD0Magic,
        staticOffset: builder6388f0LowSeedPreStatic,
        unaryMagic: 0x000c107000c01105,
        f40Magics: [
            0x04100060410052fa, 0x040000a040001c0f, 0x03e001203e0028ab,
            0x03a002203a007f75, 0x0320042032002275, 0x0220082022005168,
            0x0020102002002799,
        ]
    )

    private static let builder6388f0LowSeedPhase3Spec = LowSeedPhaseSpec(
        phaseMagic: 0x10a0000048fa,
        auxMagics: [
            0x10a0000045ba, 0x10a000000d8c, 0x10a0000019d4, 0x10a000003586,
            0x10a0000037ad, 0x10a00000759d, 0x10a000007389,
        ],
        e10Magics: [
            0x10a000004382, 0x10a00000010a, 0x10a000005ec1, 0x10a000003c3b,
            0x10a000007153, 0x10a000002125, 0x10a00000346a,
        ],
        e10Markers: [3, 3, 0, 3, 1, 0, 5],
        bd0Magic: builder6388f0LowSeedTailBD0Magic,
        staticOffset: builder6388f0LowSeedTailStatic,
        unaryMagic: 0x000c107000c079da,
        f40Magics: [
            0x0410006041005993, 0x040000a040001212, 0x03e001203e0006da,
            0x03a002203a0060e5, 0x0320042032004c30, 0x022008202200655f,
            0x0020102002005752,
        ]
    )
}
