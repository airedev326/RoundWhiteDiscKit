import XCTest
import CryptoKit
@testable import RoundWhiteDiscKit

final class FirstPairSourceSliceTests: XCTestCase {
    override func setUpWithError() throws {
        try installRuntimeTablesForTests()
    }

    func testInit679f48AndInitialAA8CMatchPythonReferenceVectors() throws {
        let initial = try FirstPairSourceSlice.init679f48Context()
        XCTAssertEqual(
            Data(SHA256.hash(data: initial)).hex,
            "2df6726428a8e0ab82f3a9807e742ee08fae532a00f8da456b2978ef4a93e6c8"
        )
        XCTAssertEqual(
            Data(initial.prefix(72)).hex,
            "000000000000000005000402050203010503050404010603020105040504050703" +
            "010604050703050006020605050606020704070503040303030704070602010704" +
            "010206030501"
        )

        let updated = try FirstPairSourceSlice.update67aa8cLen4Initial(
            context: initial,
            src4: Data([0, 0, 0, 1])
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: updated)).hex,
            "bcfc48c06814b940af45b26c60b35161014f3131cbfa9bcb7a3bdd178b7cc179"
        )
        XCTAssertEqual(
            Data(updated.suffix(72)).hex,
            "0000000000000000000000000000000000000000000000000000000000000000" +
            "000000000400000067e6096a85ae67bb72f36e3c3af54fa57f520e518c68059b" +
            "abd9831f19cde05b"
        )
    }

    func testInitialAA8CRejectsInvalidInputs() throws {
        let initial = try FirstPairSourceSlice.init679f48Context()
        XCTAssertThrowsError(
            try FirstPairSourceSlice.update67aa8cLen4Initial(context: initial, src4: Data([1, 2, 3]))
        ) { error in
            XCTAssertEqual(error as? FirstPairSourceSliceError, .invalid67aa8cInitialSourceLength(3))
        }

        var flagged = initial
        flagged[0x1a4] = 2
        XCTAssertThrowsError(
            try FirstPairSourceSlice.update67aa8cLen4Initial(context: flagged, src4: Data([0, 0, 0, 1]))
        ) { error in
            XCTAssertEqual(error as? FirstPairSourceSliceError, .invalid67aa8cInitialFlag(2))
        }
    }

    func testApply67eb94PendingBlocksMatchesPythonReferenceVector() throws {
        let initial = try FirstPairSourceSlice.init679f48Context()
        let updated = try FirstPairSourceSlice.update67aa8cLen4Initial(
            context: initial,
            src4: Data([0, 0, 0, 1])
        )
        let applied = try FirstPairSourceSlice.apply67eb94PendingBlocks(context: updated)

        XCTAssertEqual(
            Data(SHA256.hash(data: applied)).hex,
            "144260d5df72c48af66d02ee64b7ab3e901b4f5b6c1a69cf41020bc8028c8425"
        )
        XCTAssertEqual(
            Data(applied[0x114..<0x1a4]).hex,
            "060604030004050007010507070303070200050206010400020205020203070503" +
            "070602040500000701040300070303030700070400020207020705010103050006" +
            "010606070202060204020100030507040600000004070002060404050203060702" +
            "050704030600020402060404060006060301040705020701070701050206030707" +
            "000306050504000700040403"
        )
    }

    func testEncode67d630BlockMatchesPythonReferenceVectors() throws {
        let vectors: [(src: Data, expectedHex: String)] = [
            (
                Data([0, 0, 0, 1]),
                "050604040404020504060402060202020206050502020604020605040202050605" +
                "020506060402050506020202050606040506020206060202060604020606060402"
            ),
            (
                Data((0..<16).map { UInt8($0) }),
                "040600060104000207000305060202050606000500030307000302040003050305" +
                "060004000100000502070400070301050500000302030206060104020606060502"
            ),
        ]

        for vector in vectors {
            let encoded = try FirstPairSourceSlice.encode67d630Block(vector.src)
            XCTAssertEqual(encoded.hex, vector.expectedHex)
        }
    }

    func testEncode67d630BlockRejectsInvalidLengths() {
        XCTAssertThrowsError(try FirstPairSourceSlice.encode67d630Block(Data())) { error in
            XCTAssertEqual(error as? FirstPairSourceSliceError, .invalid67d630BlockLength(0))
        }
        XCTAssertThrowsError(try FirstPairSourceSlice.encode67d630Block(Data(count: 17))) { error in
            XCTAssertEqual(error as? FirstPairSourceSliceError, .invalid67d630BlockLength(17))
        }
    }

    func testApply67eb94WithPendingRawAdapterMatchesPythonReferenceVector() throws {
        let initial = try FirstPairSourceSlice.init679f48Context()
        let updated = try FirstPairSourceSlice.update67aa8cLen4Initial(
            context: initial,
            src4: Data([0, 0, 0, 1])
        )
        let applied = try FirstPairSourceSlice.apply67eb94WithPendingRawAdapter(context: updated)

        XCTAssertEqual(
            Data(SHA256.hash(data: applied)).hex,
            "7311b8040cd2b3c972246f43f27662024b9b64d2c9b117a0571a3eef59e759c1"
        )
        XCTAssertEqual(
            Data(applied[0x08..<0x4a]).hex,
            "050202020202040604020404020506050502050506040404060206040506060406" +
            "060505040406050504040406060204020507000102050605050504050502040404"
        )
    }

    func testApply67dd7cUpdateCrossesDF80Boundary() throws {
        let context = make679f48Context(contextLength: 0, blockIndex: 3)
        let encoded = try FirstPairSourceSlice.encode67d630Block(Data((0..<16).map { UInt8($0) }))
        let applied = try FirstPairSourceSlice.apply67dd7cUpdateUntilDF80(
            context: context,
            encoded66: encoded,
            rawLength: 16
        )

        XCTAssertEqual(
            Data(SHA256.hash(data: applied)).hex,
            "dff592f458a6f495de02a3c60bf4c0f2c46692df8d67020a65bcdf1277ce2030"
        )
        XCTAssertEqual(
            Data(applied[0x114..<0x1a4]).hex,
            "050700050504040205060504010701000006060302070207060503050701060406" +
            "040104030206070100070704010400040006050500000202030200040700060003" +
            "050502070702050503060203010406050606000007070103000306010705030507" +
            "040500000301070101020600010401070102000205050204060007030003060703" +
            "050403060205070004010000"
        )
    }

    func testDeriveFrom679f48InputsMatchesPythonReferenceVector() throws {
        let previousBytes: [UInt8] = (0..<(2 * 66)).map { index in
            UInt8((index * 5 + 2) & 7)
        }
        let previous = Data(previousBytes)
        let updates = try FirstPairSourceSlice.previousDescriptorBlocksToDD7CInputs(previousBlocks: previous)
        XCTAssertEqual(updates.count, 132)
        XCTAssertEqual(
            Data(SHA256.hash(data: updates)).hex,
            "44e2abbbeb7fa7615a64007196fcdbbfb396ed9fe8e48e6b048404e8f96a2730"
        )

        let context = try FirstPairSourceSlice.finalized679f48ContextFromInputs(previousBlocks: previous)
        XCTAssertEqual(
            Data(SHA256.hash(data: context)).hex,
            "8a57624059dee8d2679edd1b2e6de78f8d1856a871eb268d59f309943d10aa11"
        )
        let source = try FirstPairSourceSlice.deriveFrom679f48Inputs(
            previousBlocks: previous,
            offset: 0,
            length: 16
        )
        XCTAssertEqual(
            source.hex,
            "040400020506020406010204030101020502070705070404000302040501050505" +
            "010004030304070206030607070000000005000102030205000107030202050000"
        )
    }

    func testConstructor67076cAndRawDescriptorDerivationMatchPythonReferenceVectors() throws {
        let rawBytes: [UInt8] = (0..<(2 * 66)).map { index in
            UInt8((index * 3 + 1) & 7)
        }
        let raw = Data(rawBytes)
        let ptr28 = try FirstPairSourceSlice.constructor670978Ptr28Blocks(rawDescriptorBlocks: raw)
        XCTAssertEqual(
            Data(SHA256.hash(data: ptr28)).hex,
            "706be35f728909a58b2924e4ddb1a8aad7a725fa7f614445cd92feefb611de1c"
        )
        let ptr10 = try FirstPairSourceSlice.constructor670a54Ptr10Blocks(rawDescriptorBlocks: raw)
        XCTAssertEqual(
            Data(SHA256.hash(data: ptr10)).hex,
            "914e5cf5c7677d9c570a74351fffbd879f75aca534c08426f3042eb2c6212d2b"
        )

        let source660448 = try FirstPairSourceSlice.deriveFrom660448RawDescriptor(
            rawDescriptorBlocks: raw,
            offset: 0,
            length: 16
        )
        XCTAssertEqual(
            source660448.hex,
            "040401010705040302070407030002030400040004030507070305050106050402" +
            "070401040604040707070702010000030500040203000304030103030004060301"
        )

        let firstBytes: [UInt8] = (0..<66).map { index in UInt8((index * 5 + 2) & 7) }
        let secondBytes: [UInt8] = (0..<66).map { index in UInt8((index * 7 + 4) & 7) }
        let first = Data(firstBytes)
        let second = Data(secondBytes)
        let source64d774 = try FirstPairSourceSlice.deriveFrom64d774RawStreams(
            firstRawBlocks: first,
            secondRawBlocks: second,
            offset: 0,
            length: 16
        )
        XCTAssertEqual(
            source64d774.hex,
            "040406010201060506000205040004000004010001010207060607060607050502" +
            "000107040306040106020704040002000600030200070603040004010004010207"
        )
    }

    func testBuilder6388f0TailLayersMatchPythonReferenceVectors() throws {
        let internalBytes: [UInt8] = (0..<(2 * 66)).map { index in UInt8((index * 5 + 1) & 7) }
        let prefinalBytes: [UInt8] = (0..<(2 * 66)).map { index in UInt8((index * 3 + 2) & 7) }
        let workspaceBytes: [UInt8] = (0..<266).map { index in UInt8((index * 7 + 4) & 7) }
        let stageABytes: [UInt8] = (0..<282).map { index in UInt8((index * 5 + 2) & 7) }
        let stageBBytes: [UInt8] = (0..<282).map { index in UInt8((index * 3 + 6) & 7) }

        let internalData = Data(internalBytes)
        let prefinal = Data(prefinalBytes)
        let workspace = Data(workspaceBytes)
        let stageA = Data(stageABytes)
        let stageB = Data(stageBBytes)

        let finalRaw = try FirstPairSourceSlice.builder6388f0FinalRawBlocks(internalBlocks: internalData)
        XCTAssertEqual(finalRaw.count, 132)
        XCTAssertEqual(
            Data(SHA256.hash(data: finalRaw)).hex,
            "56ddfdbf0fcc1b60f339a70d9cba7e8262d02c9e7bed64970126f795fb635576"
        )

        let prefinalInternal = try FirstPairSourceSlice.builder6388f0PrefinalLen32InternalBlocks(
            prefinalSourceBlocks: prefinal
        )
        XCTAssertEqual(prefinalInternal.count, 132)
        XCTAssertEqual(
            Data(SHA256.hash(data: prefinalInternal)).hex,
            "b6af68238f927cb2f27d318fa8fb6e0c77494d16555c4dd64a06d1376544995a"
        )

        let workspacePrefinal = try FirstPairSourceSlice.builder6388f0Len32PrefinalSourcesFromWorkspace(
            workspaceSource: workspace
        )
        XCTAssertEqual(workspacePrefinal.count, 132)
        XCTAssertEqual(
            Data(SHA256.hash(data: workspacePrefinal)).hex,
            "b7fed8b0449eb2368269402165ea6bf581f68580bdb3a1719b0ecf14ac2f9172"
        )

        let stagePrefinal = try FirstPairSourceSlice.builder6388f0Len32PrefinalSourcesFromStageInputs(
            stageASource: stageA,
            stageBSource: stageB
        )
        XCTAssertEqual(stagePrefinal.count, 132)
        XCTAssertEqual(
            Data(SHA256.hash(data: stagePrefinal)).hex,
            "cc33aa4c896081feb2a44b378afd6b9830ca655c174f6d507c9716e8a68a7830"
        )
    }

    func testDeriveFrom6388f0LayersMatchPythonReferenceVectors() throws {
        let internalBytes: [UInt8] = (0..<(2 * 66)).map { index in UInt8((index * 5 + 1) & 7) }
        let prefinalBytes: [UInt8] = (0..<(2 * 66)).map { index in UInt8((index * 3 + 2) & 7) }
        let workspaceABytes: [UInt8] = (0..<266).map { index in UInt8((index * 7 + 4) & 7) }
        let workspaceBBytes: [UInt8] = (0..<266).map { index in UInt8((index * 7 + 5) & 7) }
        let stageA0Bytes: [UInt8] = (0..<282).map { index in UInt8((index * 5 + 2) & 7) }
        let stageB0Bytes: [UInt8] = (0..<282).map { index in UInt8((index * 3 + 6) & 7) }
        let stageA1Bytes: [UInt8] = (0..<282).map { index in UInt8((index * 3 + 1) & 7) }
        let stageB1Bytes: [UInt8] = (0..<282).map { index in UInt8((index * 5 + 4) & 7) }

        let internalData = Data(internalBytes)
        let prefinal = Data(prefinalBytes)

        XCTAssertEqual(
            try FirstPairSourceSlice.deriveFrom6388f0InternalStreams(
                firstInternalBlocks: internalData,
                secondInternalBlocks: prefinal,
                offset: 0,
                length: 16
            ).hex,
            "040400040702000206000504060306040706020100040303030205020506030603" +
            "020207050704040602060006000600020002020305050000020401070006030103"
        )

        XCTAssertEqual(
            try FirstPairSourceSlice.deriveFrom6388f0PrefinalLen32Streams(
                firstPrefinalBlocks: prefinal,
                secondPrefinalBlocks: internalData,
                offset: 0,
                length: 16
            ).hex,
            "040400000703050704050203030503020706030400060402020001060302050104" +
            "070104060000030706020104020007060300040207050502050502000405050700"
        )

        XCTAssertEqual(
            try FirstPairSourceSlice.deriveFrom6388f0WorkspaceLen32Streams(
                firstWorkspaceSource: Data(workspaceABytes),
                secondWorkspaceSource: Data(workspaceBBytes),
                offset: 0,
                length: 16
            ).hex,
            "040407040606030500050503030005050606010206050607040407000306050202" +
            "070100040200040407070303020600010302040007020501000306000406020107"
        )

        XCTAssertEqual(
            try FirstPairSourceSlice.deriveFrom6388f0StageLen32Streams(
                firstStageASource: Data(stageA0Bytes),
                firstStageBSource: Data(stageB0Bytes),
                secondStageASource: Data(stageA1Bytes),
                secondStageBSource: Data(stageB1Bytes),
                offset: 0,
                length: 16
            ).hex,
            "040400030102000103000703030201010707070106000506020306040203060202" +
            "070203000305040200010504020501070103070706000700040501060003060005"
        )
    }

    func testBuilder6388f0PackAndLaneLayersMatchPythonReferenceVectors() throws {
        let primary0Bytes: [UInt8] = (0..<(20 * 16)).map { index in UInt8((index * 3 + 1) & 7) }
        let secondary0Bytes: [UInt8] = (0..<(20 * 16)).map { index in UInt8((index * 5 + 2) & 7) }
        let primary1Bytes: [UInt8] = (0..<(20 * 16)).map { index in UInt8((index * 7 + 4) & 7) }
        let secondary1Bytes: [UInt8] = (0..<(20 * 16)).map { index in UInt8((index * 3 + 6) & 7) }

        let primary0 = Data(primary0Bytes)
        let secondary0 = Data(secondary0Bytes)
        let primary1 = Data(primary1Bytes)
        let secondary1 = Data(secondary1Bytes)

        let pack0 = try FirstPairSourceSlice.builder6388f0PackOutputsFromLaneBlocks(
            primaryLaneBlocks: primary0,
            secondaryLaneBlocks: secondary0
        )
        XCTAssertEqual(Data(SHA256.hash(data: pack0.stageBPackHead16)).hex, "cbb73fff67fc8d84576195e087bdadabd862476bea09fd3603ec19f75f703f28")
        XCTAssertEqual(Data(SHA256.hash(data: pack0.stageBPackBody16)).hex, "1ed65e8008b64c579a8dc5ef91bbb8026a7bd10180c16fd9022395cc6f21e583")
        XCTAssertEqual(Data(SHA256.hash(data: pack0.stageAPackHead16)).hex, "0419abe716a28762aae3d3abdfcbd20069e74db5f4cc62060cbf32f11ed3c2ea")
        XCTAssertEqual(Data(SHA256.hash(data: pack0.stageAPackBody16)).hex, "ec559fc571319e7d69e31ba7761b9035072bcddc75324c3de9f78b7eca830560")

        let stage0 = try FirstPairSourceSlice.builder6388f0Len32StageInputsFromPackOutputs(
            stageBPackHead16: pack0.stageBPackHead16,
            stageBPackBody16: pack0.stageBPackBody16,
            stageAPackHead16: pack0.stageAPackHead16,
            stageAPackBody16: pack0.stageAPackBody16
        )
        XCTAssertEqual(Data(SHA256.hash(data: stage0.stageASource)).hex, "fbece039249b3700c3908af39c16cfdffda2a8e94765ce1243280ede14a0db22")
        XCTAssertEqual(Data(SHA256.hash(data: stage0.stageBSource)).hex, "55622eae1f29c6264a33d62e2b41fb3875832683281b456831037d8a4e01d4f6")

        let pack1 = try FirstPairSourceSlice.builder6388f0PackOutputsFromLaneBlocks(
            primaryLaneBlocks: primary1,
            secondaryLaneBlocks: secondary1
        )
        let sourceFromPack = try FirstPairSourceSlice.deriveFrom6388f0PackLen32Streams(
            firstStageBPackHead16: pack0.stageBPackHead16,
            firstStageBPackBody16: pack0.stageBPackBody16,
            firstStageAPackHead16: pack0.stageAPackHead16,
            firstStageAPackBody16: pack0.stageAPackBody16,
            secondStageBPackHead16: pack1.stageBPackHead16,
            secondStageBPackBody16: pack1.stageBPackBody16,
            secondStageAPackHead16: pack1.stageAPackHead16,
            secondStageAPackBody16: pack1.stageAPackBody16,
            offset: 0,
            length: 16
        )
        XCTAssertEqual(
            sourceFromPack.hex,
            "040400060501060401060002050500050600010504000007060300050100000407" +
            "060406030405050001050500010002050100020501010304040405040706050200"
        )

        let sourceFromLanes = try FirstPairSourceSlice.deriveFrom6388f0LaneLen32Streams(
            firstPrimaryLaneBlocks: primary0,
            firstSecondaryLaneBlocks: secondary0,
            secondPrimaryLaneBlocks: primary1,
            secondSecondaryLaneBlocks: secondary1,
            offset: 0,
            length: 16
        )
        XCTAssertEqual(sourceFromLanes, sourceFromPack)
    }

    func testBuilder6388f0ScheduleLayerMatchesPythonReferenceVectors() throws {
        let schedule0: [UInt32] = [
            0x11223344, 0x12243648, 0x1326394c, 0x14283c50, 0x152a3f54,
            0x162c4258, 0x172e455c, 0x18304860, 0x19324b64, 0x1a344e68,
            0x1b36516c, 0x1c385470, 0x1d3a5774, 0x1e3c5a78, 0x1f3e5d7c,
            0x20406080, 0x21426384, 0x22446688, 0x2346698c, 0x24486c90,
        ]
        let schedule1: [UInt32] = [
            0x89abcdef, 0x8aaccef0, 0x8badcff1, 0x8caed0f2, 0x8dafd1f3,
            0x8eb0d2f4, 0x8fb1d3f5, 0x90b2d4f6, 0x91b3d5f7, 0x92b4d6f8,
            0x93b5d7f9, 0x94b6d8fa, 0x95b7d9fb, 0x96b8dafc, 0x97b9dbfd,
            0x98badcfe, 0x99bbddff, 0x9abcdf00, 0x9bbde001, 0x9cbee102,
        ]

        let lanes0 = try FirstPairSourceSlice.builder6388f0LaneBlocksFromScheduleWords(schedule0)
        XCTAssertEqual(Data(SHA256.hash(data: lanes0.primaryLaneBlocks)).hex, "1b70254a30185288de09f9a35ec6b1293474b349a720f89794631dd5cd43c2f8")
        XCTAssertEqual(Data(SHA256.hash(data: lanes0.secondaryLaneBlocks)).hex, "d718360163754dcd6fc33adfe4d184ce65e7f9f6e9bd32b4fcb677b425845bc1")

        let lanes1 = try FirstPairSourceSlice.builder6388f0LaneBlocksFromScheduleWords(schedule1)
        XCTAssertEqual(Data(SHA256.hash(data: lanes1.primaryLaneBlocks)).hex, "2ebd449c1b18906b11e48c56f3bdef9cb98072e5be686a4b89cb02b2dab45d04")
        XCTAssertEqual(Data(SHA256.hash(data: lanes1.secondaryLaneBlocks)).hex, "cbc6175ef451f45406d268a601058f257271e2ddcd12d6a773c0b51f48c8f2f0")

        let source = try FirstPairSourceSlice.deriveFrom6388f0ScheduleLen32Streams(
            firstScheduleWords: schedule0,
            secondScheduleWords: schedule1,
            offset: 0,
            length: 16
        )
        XCTAssertEqual(
            source.hex,
            "040401070203010704050106010001020204070005060100030704020306000701" +
            "070104060605050201000402010102050201000404040305070103060002030602"
        )

        let key = try FirstPairSourceSlice.phase5RawKeyFrom6388f0ScheduleLen32Streams(
            firstScheduleWords: schedule0,
            secondScheduleWords: schedule1
        )
        XCTAssertEqual(key.hex, "e407917d692fd119fbf18baf60644ded")
    }

    func testBuilder63c278InitialMixAndTailReducersMatchPythonReferenceVectors() throws {
        let arg0Bytes: [UInt8] = (0..<88).map { index in UInt8((index * 7 + 3) & 0xff) }
        let arg1Bytes: [UInt8] = (0..<88).map { index in UInt8((index * 5 + 11) & 0xff) }
        let arg2Bytes: [UInt8] = (0..<88).map { index in UInt8((index * 3 + 17) & 0xff) }
        let scalar: UInt64 = 0x0123456789abcdef

        let initial = try FirstPairSourceSlice.builder63c278InitialVectors(
            arg0: Data(arg0Bytes),
            arg1: Data(arg1Bytes)
        )
        XCTAssertEqual(initial.x1Vec44.count, 44)
        XCTAssertEqual(initial.x0Vec22.count, 22)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(initial.x1Vec44))).hex,
            "7510279962382f9fbfd7acbc437c419e0efe3aa928c3b86a09fa3235880799d1"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(initial.x0Vec22))).hex,
            "cd3066baa97e86c4cd0882325622da57d6283f598225b6c7b19f3e066e18a9d3"
        )

        let second = try FirstPairSourceSlice.builder63c278SecondInitialVectors(
            arg0: Data(arg0Bytes),
            arg2: Data(arg2Bytes)
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(second.x2Vec44))).hex,
            "571998e49bf13bc6a2e9d7df592371186beacebb27c8fd7d498924f41591f53e"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(second.x0Vec22))).hex,
            "dbbd9840317de13798bd1cf50ef6fec8ad0e26638b894a62b1cfd14aee785fda"
        )

        let mixed1 = try FirstPairSourceSlice.builder63c278ScalarMixVector(
            x1Vec44: initial.x1Vec44,
            x0Vec22: initial.x0Vec22,
            scalar: scalar
        )
        let mixed2 = try FirstPairSourceSlice.builder63c278ScalarMix2Vector(
            x2Vec44: second.x2Vec44,
            x0Vec22: second.x0Vec22,
            scalar: scalar
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(mixed1))).hex,
            "4692583a47aa6989ac7d4fab5d20c97ee27970af79f4590824a8268dbf1b27dd"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(mixed2))).hex,
            "5b7a4c6be8ac3f3c33331e866588d75f17b62dcdf9b1bfab22846801cd262dca"
        )

        let tail1 = try FirstPairSourceSlice.builder63c278Tail1U32Words(mixed1)
        let tail2 = try FirstPairSourceSlice.builder63c278Tail2U32Words(mixed2)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(tail1))).hex,
            "27e1f0bcd8f8555166c80cb3ee788ce5c03a1ee08dde0f2aa8e9c3282a72b472"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(tail2))).hex,
            "9b840d5956cdaae86b1835984c6bdcfa4b44577c1cfeae66455c2c04739d1e4f"
        )
        XCTAssertEqual(tail1.prefix(4), [0xc21a61c6, 0x74c4feaf, 0x58177aec, 0x7a88bfb1])
        XCTAssertEqual(tail2.prefix(4), [0xc822edf3, 0x3210de15, 0x669f83ce, 0x9d56a88e])

        let accum = try FirstPairSourceSlice.builder63c278AccumulatorStreams(
            arg2: Data(arg2Bytes),
            tail2Words: tail2
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(accum.sp440Cumulative))).hex,
            "b5ba8730b4f348f2bead511a543354ac3cba1388e04d737af3487124cbc79598"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(accum.sp4f0Words))).hex,
            "2f26f4d41701f9596582f852831caeede87aa078ff624ab70e59dad3eb170b5d"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(accum.sp5a0Words))).hex,
            "84932501eaef1bcf7c0b58a51b1bf8653c46ae9527a759b0469ff2653e43db03"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(accum.sp390Cumulative))).hex,
            "22518465559d66c1e916c293fe4bc2e9380a5018f23d213d7bedfaef9f3f746b"
        )

        let bridgeConv = try FirstPairSourceSlice.builder63c278BridgeConvolutionVector(
            sp440Cumulative: accum.sp440Cumulative,
            sp4f0Words: accum.sp4f0Words,
            sp5a0Words: accum.sp5a0Words,
            sp390Cumulative: accum.sp390Cumulative
        )
        let bridgeX0 = try FirstPairSourceSlice.builder63c278BridgeX0Vector(arg0: Data(arg0Bytes))
        let bridgeMix = try FirstPairSourceSlice.builder63c278BridgeMixVector(
            sp230Vec44: bridgeConv,
            x0Vec22: bridgeX0,
            scalar: scalar
        )
        let sp128 = try FirstPairSourceSlice.builder63c278BridgeSP128Words(bridgeMix)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(bridgeConv))).hex,
            "9d307ee87af9694b08e35935470c931390def241ff8cf03071b0c97e9288a7e6"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(bridgeX0))).hex,
            "ba1a0930d3edc74b7b1cbc65257d0d5e0b84935ba8baf2a8d1bffb131618f370"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(bridgeMix))).hex,
            "51c7581842c0ac902cde4145e6edec72344c6b174e1637b7804a54cf8c639e1c"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp128))).hex,
            "eacc144f8735791a4d91c9c60617e7203b18f9338142c63fd549bc9e19957670"
        )

        let prebranch = try FirstPairSourceSlice.builder63c278PrebranchInitialStreams(
            arg0: Data(arg0Bytes),
            tail1Words: tail1,
            sp128Words: sp128
        )
        let pre4f0 = try FirstPairSourceSlice.builder63c278PrebranchSP4F0Words(arg0: Data(arg0Bytes))
        let pre230 = try FirstPairSourceSlice.builder63c278PrebranchSP230Words(sp4f0Words: pre4f0)
        let pre5a0 = try FirstPairSourceSlice.builder63c278PrebranchSP5A0Words(sp230Words: pre230)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(prebranch.sp390Static))).hex,
            "bb76f8765891dfcb76e25a5b078bf9a703142137ab005f646526f4654e693626"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(prebranch.sp440Words))).hex,
            "7eb39fcc20f253b51776dd9ea7a697b92813d2db917ca91ed5c8378b1e7fd37c"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(prebranch.sp6b0Words))).hex,
            "a1594bb70ed406c9e25a8cd067e68d56e23292b717ec02cd551456e5ed89f6a4"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(prebranch.sp658Words))).hex,
            "8ac4e5d77a1070b2926a06ef3c8fbb01a0c4618c8237d5073f4198044ce1c02d"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(pre4f0))).hex,
            "d9523b2165986722e70834869ba3bc017dfe1c0ae5bc42ca299bb7dabd2450c6"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(pre230))).hex,
            "651bc9459d7ca269bd73de0e77a883f06126649d59e0ed448912291dd626832f"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(pre5a0))).hex,
            "fe3dad8c38db4b9a4ebf05fa507d885080f4119e6751a0c30a92ef115b676746"
        )
    }

    func testBuilder63c278ScheduleWordsMatchCapturedPythonReferenceVectors() throws {
        let arg0 = FirstPairSourceSlice.pre63c278Arg0Source
        let vectors: [(arg1: Data, arg2: Data, expected: [UInt32], hash: String)] = [
            (
                dataFromHex(
                    "870f4045410102fa6ae48ed935d4528112946ec5085053dcda8e537f1f02ea84" +
                    "ddb295ec23ff6a8c58b97fed9a2736abd68482c3517b7ad27fbe711c7fb9f" +
                    "32a00c1356f38b3025e143d56dd9017a173d68482c3517b7ad2"
                ),
                dataFromHex(
                    "d9f6a9980cacf13569f2843968ae9cdc112262a50b5bdb6a435931a1d02896c3" +
                    "ab70c95476b7ea17fb1fadf32aeabc0881ab695ce36c62eca5621fafcf684" +
                    "616c5198a7948a03ad3e82ae3783b32b01681ab695ce36c62ec"
                ),
                [
                    0x8c15c5da, 0x34dd429d, 0x955af9fe, 0x6897e537, 0x1bad4a31,
                    0xb3206998, 0x3bda123d, 0x3fdb46c5, 0xd42db9fd, 0x29dc0f3a,
                    0x3b95a64c, 0xcce6d138, 0x70227a65, 0x87ca2121, 0xefb07a8f,
                    0xc4749659, 0x1cd92603, 0xe0ab3767, 0x3b95a64c, 0xcce6d138,
                ],
                "bca47c5f0b63efce696822be0e0b00455d7f4d592cf55332429588fcba3e285b"
            ),
            (
                dataFromHex(
                    "2576fe36ecd8e7be514212a7129bcb32c361f0d230d0612528124ca25fd446a2" +
                    "5979de6adb6a70c2b534e301985718a0d68482c3517b7ad27fbe711c7fb9f" +
                    "32a00c1356f38b3025e143d56dd9017a173d68482c3517b7ad2"
                ),
                dataFromHex(
                    "37b2af34160b02ddf8e45aef8f22c626ed2984e27b754dc75c89f9a58cb0b0a8" +
                    "eea62a650526362ea30760fa9319f39781ab695ce36c62eca5621fafcf684" +
                    "616c5198a7948a03ad3e82ae3783b32b01681ab695ce36c62ec"
                ),
                [
                    0x04961c3d, 0x1f110752, 0x271f9e47, 0x551739bc, 0x828a0f59,
                    0xd01fa5be, 0x6703b5b7, 0x22e03d75, 0x9cbed758, 0x7f4e06d1,
                    0x3b95a64c, 0xcce6d138, 0x70227a65, 0x87ca2121, 0xefb07a8f,
                    0xc4749659, 0x1cd92603, 0xe0ab3767, 0x3b95a64c, 0xcce6d138,
                ],
                "8b6ad5e9244eb599dbfdaabee633b41bd6230643ed86ec7c90e9d3335c621a3c"
            ),
        ]

        for vector in vectors {
            let schedule = try FirstPairSourceSlice.builder63c278ScheduleWords(
                arg0: arg0,
                arg1: vector.arg1,
                arg2: vector.arg2,
                scalar: FirstPairSourceSlice.pre63c278Scalar
            )
            XCTAssertEqual(schedule, vector.expected)
            XCTAssertEqual(Data(SHA256.hash(data: packUInt32LE(schedule))).hex, vector.hash)
        }

        let source = try FirstPairSourceSlice.deriveFrom63c278ScheduleInputs(
            arg0: arg0,
            firstArg1: vectors[0].arg1,
            firstArg2: vectors[0].arg2,
            secondArg1: vectors[1].arg1,
            secondArg2: vectors[1].arg2,
            scalar: FirstPairSourceSlice.pre63c278Scalar,
            offset: 0,
            length: 16
        )
        let defaultSource = try FirstPairSourceSlice.deriveFromPre63c278ScheduleInputs(
            firstArg1: vectors[0].arg1,
            firstArg2: vectors[0].arg2,
            secondArg1: vectors[1].arg1,
            secondArg2: vectors[1].arg2,
            offset: 0,
            length: 16
        )
        XCTAssertEqual(defaultSource, source)
        XCTAssertEqual(
            source.hex,
            "040402020404000202060205040102060705010600010704020506070300050007" +
            "070004010407010502000304070207010604030305070405040204060700000702"
        )
        let rawKey = try FirstPairSourceSlice.phase5RawKeyFrom63c278ScheduleInputs(
            arg0: arg0,
            firstArg1: vectors[0].arg1,
            firstArg2: vectors[0].arg2,
            secondArg1: vectors[1].arg1,
            secondArg2: vectors[1].arg2,
            scalar: FirstPairSourceSlice.pre63c278Scalar
        )
        XCTAssertEqual(rawKey.hex, "8df19b56ae4a0d4044a5c0d5fc86a34e")
        let defaultRawKey = try FirstPairSourceSlice.phase5RawKeyFromPre63c278ScheduleInputs(
            firstArg1: vectors[0].arg1,
            firstArg2: vectors[0].arg2,
            secondArg1: vectors[1].arg1,
            secondArg2: vectors[1].arg2
        )
        XCTAssertEqual(defaultRawKey, rawKey)
    }

    func testBuilder6388f0Next642f60InputsFrom64cd40OutputsMatchPythonReferenceVector() throws {
        let first = Data((0..<88).map { index in UInt8((index * 3 + 1) & 0xff) })
        let second = Data((0..<88).map { index in UInt8((index * 5 + 2) & 0xff) })
        let third = Data((0..<88).map { index in UInt8((index * 7 + 4) & 0xff) })

        let next = try FirstPairSourceSlice.builder6388f0Next642f60InputsFrom64cd40Outputs(
            first64cd40Output: first,
            second64cd40Output: second,
            third64cd40Output: third
        )
        XCTAssertEqual(
            next.x0.hex,
            "727ff3b03b7f9b9445dc32088470dba2e6560584f7811dda9c792f21b509e1d2" +
            "92391698dbe3f37f255093af64049e2b463bc0751707c7423cc615e155ef3aa8" +
            "b2f3387f7b484c6b05c4f356449860b4a61f7b67378c0d92"
        )
        XCTAssertEqual(
            next.x1.hex,
            "82da21c2812f75174d7cb165a116dbf009e53aea970434b39f33459e272f861b" +
            "e27b90bce1deb6322d5fcb2a41d541dfa991d42677480a7cbfe36d5d8767d5e1" +
            "424e8159410f29ef0dd7bbe7e1623750495d780257d74f2d"
        )
        XCTAssertEqual(
            next.x2.hex,
            "24966d1c50f77db7f8f3f44c7c6f1c9008083749fa291b844bf1adcccc9903b8" +
            "445a06e7b06968ce9823d9b09c5ab1b3687801c69a9ee22fab48de1eac457f9" +
            "56487f0801049ff2d38d61817bc4546d7c8e8cb423a13aadb"
        )
    }

    func testBuilder6388f0StreamStart642f60InputsMatchPythonReferenceVector() throws {
        let out0Seed = Data((0..<88).map { index in UInt8((index * 9 + 5) & 0xff) })
        let out1Seed = Data((0..<88).map { index in UInt8((index * 11 + 7) & 0xff) })

        let start = try FirstPairSourceSlice.builder6388f0StreamStart642f60Inputs(
            out0Seed: out0Seed,
            out1Seed: out1Seed
        )
        XCTAssertEqual(
            start.x0.hex,
            "6a98ace04c88d51d6ab1d75da53dff508ffdea49d14182592c7500a439baad09" +
            "8a47a5a0ecaafcc40aeef4178563c64f2f9e8ba1f142af1f8c2af649193b49f6" +
            "aaf69d608ccd236caa2a12d265898d4ecf3e2cf91144d37d"
        )
        XCTAssertEqual(
            start.x1.hex,
            "b5912a7855f4aa29d3882cbc13838a3ddb7e261648807def1c24491cda8c00ef" +
            "959d913335cd3f2ef30e15433318e7babb6b628ea8c7820d7ca628d67a01846" +
            "c75a9f8ee15a6d44513dae60c53ca4cfd9bdda4ac08d0b22e"
        )
        XCTAssertEqual(start.x2, FirstPairSourceSlice.streamStart642f60X2Source)
        XCTAssertEqual(
            Data(SHA256.hash(data: start.x2)).hex,
            "64eec98b6cf193a8c6f413af4eb1ed6bb4d4f06cb6c343284c46c9ce85ebde6f"
        )

        XCTAssertEqual(
            try FirstPairSourceSlice.builder6388f0RecoverStreamStartOut0SeedFrom642f60X0(start.x0),
            out0Seed
        )
        XCTAssertEqual(
            try FirstPairSourceSlice.builder6388f0RecoverStreamStartOut1SeedFrom642f60X1(start.x1),
            out1Seed
        )
    }

    func testBuilder6421c0HighSeedHelpersMatchPythonReferenceVectors() throws {
        let x0 = Data((0..<80).map { index in UInt8((index * 11 + 7) & 0xff) })
        let x1 = Data((0..<88).map { index in UInt8((index * 13 + 3) & 0xff) })
        let x2 = Data((0..<88).map { index in UInt8((index * 17 + 5) & 0xff) })
        let output = try FirstPairSourceSlice.builder6421c0OutputWords(
            x0Source: x0,
            x1Source: x1,
            x2Source: x2,
            scalar: 0x0123456789abcdef
        )
        XCTAssertEqual(
            output,
            [
                0xdbc1c7c6, 0x2033fae4, 0xdbba46f4, 0x51d8e106, 0x06acf332,
                0x8bad4314, 0xb5c9adb4, 0x54da2609, 0x4ea01830, 0x00da7af7,
                0x207da04a, 0xbaa6764d, 0x0e8a02aa, 0x41fc4b04, 0x299ed743,
                0xa8d7eaf6, 0x088c1fe0, 0x83d47285, 0x9d6a5499, 0x640e0bb3,
                0x799af52d, 0xa7308434,
            ]
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output))).hex,
            "613beae0326a26de5b07c1bca00a356d6d497e222d8cfe34e4cb84ae26be14a8"
        )

        let source70 = Data((0..<70).map { index in UInt8((index * 19 + 9) & 0xff) })
        let highX0 = try FirstPairSourceSlice.builder6388f0HighSeedX0SourceFrom5bcf98Output(source70)
        XCTAssertEqual(
            highX0.hex,
            "3a2dfcb318b7344cf51e5b96b0815468383cdb6a10f727cbc3e953daf6513562" +
            "261b8e3aeda4df7071901e85677af85bdc709a418e53b9f15fe323f7937078" +
            "c9120920c1c2928a95ed01e2731e03cdea"
        )
        let highOutput = try FirstPairSourceSlice.builder6421c0OutputWords(
            x0Source: highX0,
            x1Source: FirstPairSourceSlice.highSeed6421c0X1Source,
            x2Source: FirstPairSourceSlice.highSeed6421c0X2Source,
            scalar: FirstPairSourceSlice.highSeed6421c0Scalar
        )
        XCTAssertEqual(
            highOutput,
            [
                0x808a1855, 0x783ef112, 0x27aa1861, 0x18f09114, 0x3d286c05,
                0x83db42f3, 0x57a5bb1e, 0x208b0c9e, 0x64223ac2, 0x97cc4564,
                0x0ef21945, 0xe627151f, 0xd8178670, 0xdba71039, 0xdcae32d6,
                0x26e1b50b, 0x8fb269cb, 0x6bcc9065, 0x9d1492af, 0x94fe8376,
                0xd8178670, 0xdba71039,
            ]
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(highOutput))).hex,
            "cbe9227ccdfa92d4e23f2bd4f11e67cc0ef66de6b945f812bd0c2d213b7afd93"
        )

        let secondSource70 = Data((0..<70).map { index in UInt8((index * 23 + 4) & 0xff) })
        let highSeeds = try FirstPairSourceSlice.builder6388f0HighSeedStreamStartSeedsFrom5bcf98Outputs(
            firstOutput70: source70,
            secondOutput70: secondSource70
        )
        XCTAssertEqual(highSeeds.out0, packUInt32LE(highOutput))
        XCTAssertEqual(
            highSeeds.out1.hex,
            "8d85f2399a367b70a58ac991bc36c7604a45a128e91d968a99cb7b3dd020a2b5" +
            "f7b82949a78159b9b962810cbd3e57fd708617d83910a7dbd632aedc0bb5e126" +
            "cb69b28f6590cc6baf92149d7683fe94708617d83910a7db"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: highSeeds.out0 + highSeeds.out1)).hex,
            "bd9129fe22f4ab7d395e31c3e369cfc6cc62b3109df0b4ec7d82cffa5117d0e2"
        )

        let scalarWindow = dataFromHex(
            "3b588dd68f20da5f883993332cabcda6576645712cdd039d0a8195f4b1c0b52e" +
            "0000000000000000000000000000000000000000000000000000000000000000000000000000"
        )
        let generatorPoint = dataFromHex(
            "6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296" +
            "4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5"
        )
        let p256Outputs = try FirstPairSourceSlice.builder5bcf98P256Outputs(
            scalarWindowLE: scalarWindow,
            sensorPointXYBE: generatorPoint
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: p256Outputs.xOutput70)).hex,
            "fb123cffe9d4e8e9e27f9c5251cdcd24a9f513c43d130a07925b8ceee0fe75d0"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: p256Outputs.yOutput70)).hex,
            "5f6979616cb8bbeb57dac5b362653508b597e8292b6bc0a3defc0787cc4737ca"
        )
        XCTAssertEqual(
            p256Outputs.xOutput70.hex,
            "a1e69a746868223565f55b036dcb352ac7ad64457d8304d2a015b5ee90942023" +
            "0000000000000000000000000000000000000000000000000000000000000000000000000000"
        )
        XCTAssertEqual(
            p256Outputs.yOutput70.hex,
            "3ac85ab9f4754fade9fb79588ec4d48ef3af4d916151ad0477d595de947261ea" +
            "0000000000000000000000000000000000000000000000000000000000000000000000000000"
        )

        let p256HighSeeds = try FirstPairSourceSlice.builder6388f0HighSeedStreamStartSeedsFromScalarP256(
            scalarWindowLE: scalarWindow,
            sensorPointXYBE: generatorPoint
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: p256HighSeeds.out0)).hex,
            "fbc744031431d9fda2ceed80266ee2dfefb9a55e585ea5bbc2666a144379f042"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: p256HighSeeds.out1)).hex,
            "f9b223b45fe8ec5687cdcbd18218714f4b261938a4befb37e0ced7b42d012289"
        )
    }

    func testBuilder6388f0FirstPairStreamSeedsFrom5bcf98OutputsMatchPythonReferenceVectors() throws {
        let row0FirstOutput70 = Data((0..<70).map { index in UInt8((index * 19 + 9) & 0xff) })
        let row0SecondOutput70 = Data((0..<70).map { index in UInt8((index * 23 + 4) & 0xff) })
        let row59FirstOutput70 = Data((0..<70).map { index in UInt8((index * 41 + 6) & 0xff) })
        let row59SecondOutput70 = Data((0..<70).map { index in UInt8((index * 43 + 7) & 0xff) })

        let highSeeds = try FirstPairSourceSlice.builder6388f0FirstPairHighSeedStreamStartSeedsFrom5bcf98Outputs(
            row0FirstOutput70: row0FirstOutput70,
            row0SecondOutput70: row0SecondOutput70,
            row59FirstOutput70: row59FirstOutput70,
            row59SecondOutput70: row59SecondOutput70
        )
        XCTAssertEqual(
            highSeeds.row0.out0.hex,
            "55188a8012f13e786118aa271491f018056c283df342db831ebba5579e0c8b20" +
            "c23a22646445cc974519f20e1f1527e6708617d83910a7dbd632aedc0bb5e126" +
            "cb69b28f6590cc6baf92149d7683fe94708617d83910a7db"
        )
        XCTAssertEqual(
            highSeeds.row59.out1.hex,
            "59a1e91687277937b599fe911da5ba4ac96f50c6c5cebb77a0a54a7387248dad" +
            "a8360f4c149e5731729ffa13bd3e57fd708617d83910a7dbd632aedc0bb5e126" +
            "cb69b28f6590cc6baf92149d7683fe94708617d83910a7db"
        )

        let seeds = try FirstPairSourceSlice.builder6388f0FirstPairStreamSeedsFrom5bcf98Outputs(
            row0Out4: Data((0..<88).map { index in UInt8((index * 3 + 1) & 0xff) }),
            row0Out3: Data((0..<88).map { index in UInt8((index * 5 + 2) & 0xff) }),
            row0Out2: Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) }),
            row0FirstOutput70: row0FirstOutput70,
            row0SecondOutput70: row0SecondOutput70,
            row59FirstOutput70: row59FirstOutput70,
            row59SecondOutput70: row59SecondOutput70,
            nullScalarWindow: Data((0..<70).map { index in UInt8((index * 29 + 1) & 0xff) }),
            staticScalarWindow: Data((0..<70).map { index in UInt8((index * 31 + 2) & 0xff) }),
            nullEntropy11A: Data((0..<0x11a).map { index in UInt8((index * 37 + 3) & 0xff) }),
            nullAttempts: 2
        )
        XCTAssertEqual(seeds.row0Out0, highSeeds.row0.out0)
        XCTAssertEqual(seeds.row0Out1, highSeeds.row0.out1)
        XCTAssertEqual(seeds.row59Out0, highSeeds.row59.out0)
        XCTAssertEqual(seeds.row59Out1, highSeeds.row59.out1)
        XCTAssertEqual(seeds.nullAttempts, 2)

        let starts = try FirstPairSourceSlice.builder6388f0FirstPair642f60StreamStarts(seeds: seeds)
        XCTAssertEqual(
            Data(SHA256.hash(data: starts.row0.x0)).hex,
            "6cf7247e7ccce409f16a110e66e29d319ef41e9dc20b12951b97f9d3a996166a"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: starts.row59.x1)).hex,
            "3e9f58eae41463a5ddc7b08db2cd537e8bff419108e5d5b9c1e6fd6e6bbfcc9d"
        )

        let source = try FirstPairSourceSlice.deriveFrom6388f0FirstPairStreamSeeds(seeds: seeds)
        XCTAssertEqual(
            source.hex,
            "0404040101050405010306060207010704000002020100020106040104030400" +
            "07050303000306070304070503010202020402050106030505050207070104020100"
        )

        let entrySource = Data((0..<0x214).map { index in UInt8((index * 5 + 1) & 7) })
        let entrySeeds = try FirstPairSourceSlice.builder6388f0FirstPairStreamSeedsFromEntrySourceAnd5bcf98Outputs(
            entrySource: entrySource,
            row0FirstOutput70: row0FirstOutput70,
            row0SecondOutput70: row0SecondOutput70,
            row59FirstOutput70: row59FirstOutput70,
            row59SecondOutput70: row59SecondOutput70,
            nullScalarWindow: seeds.nullScalarWindow,
            staticScalarWindow: seeds.staticScalarWindow,
            nullEntropy11A: seeds.nullEntropy11A,
            nullAttempts: seeds.nullAttempts
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: entrySeeds.row0Out4)).hex,
            "e70d3f912b290b5bd31c6dd27e8816448c16863247354286fc66957bdf2a8e27"
        )
        XCTAssertEqual(entrySeeds.row0Out0, highSeeds.row0.out0)
        XCTAssertEqual(entrySeeds.row0Out1, highSeeds.row0.out1)
        XCTAssertEqual(entrySeeds.row59Out0, highSeeds.row59.out0)
        XCTAssertEqual(entrySeeds.row59Out1, highSeeds.row59.out1)

        let entrySeedsWithDerivedStatic = try FirstPairSourceSlice.builder6388f0FirstPairStreamSeedsFromEntrySourceAnd5bcf98Outputs(
            entrySource: entrySource,
            row0FirstOutput70: row0FirstOutput70,
            row0SecondOutput70: row0SecondOutput70,
            row59FirstOutput70: row59FirstOutput70,
            row59SecondOutput70: row59SecondOutput70,
            nullScalarWindow: seeds.nullScalarWindow,
            nullEntropy11A: seeds.nullEntropy11A,
            nullAttempts: seeds.nullAttempts
        )
        XCTAssertEqual(entrySeedsWithDerivedStatic.row0Out4, entrySeeds.row0Out4)
        XCTAssertEqual(
            entrySeedsWithDerivedStatic.staticScalarWindow.hex,
            "f38d95844ac5834265c854266814ed9e67ce508eea912fc81a9b2d28db0ddd5e" +
            "0000000000000000000000000000000000000000000000000000000000000000000000000000"
        )

        let nullEntropy = Data((0..<0x11a).map { index in UInt8((index * 11 + 3) & 0xff) })
        let entropySeeds = try FirstPairSourceSlice.builder6388f0FirstPairStreamSeedsFromEntropyAnd5bcf98Outputs(
            entrySource: entrySource,
            row0FirstOutput70: row0FirstOutput70,
            row0SecondOutput70: row0SecondOutput70,
            row59FirstOutput70: row59FirstOutput70,
            row59SecondOutput70: row59SecondOutput70,
            nullEntropy11A: nullEntropy
        )
        XCTAssertEqual(entropySeeds.nullEntropy11A, nullEntropy)
        XCTAssertEqual(entropySeeds.nullAttempts, 1)
        XCTAssertEqual(
            Data(SHA256.hash(data: entropySeeds.nullScalarWindow)).hex,
            "c4f2357511bf2071de2a5478a5d3d8a17c2b4da7b46c6cb46f4834ecb3a2f2ba"
        )

        let retrySeeds = try FirstPairSourceSlice.builder6388f0FirstPairStreamSeedsFromEntropySourceAnd5bcf98Outputs(
            entrySource: entrySource,
            row0FirstOutput70: row0FirstOutput70,
            row0SecondOutput70: row0SecondOutput70,
            row59FirstOutput70: row59FirstOutput70,
            row59SecondOutput70: row59SecondOutput70,
            maxAttempts: 4
        ) { requestedCount in
            XCTAssertEqual(requestedCount, 0x11a)
            return nullEntropy
        }
        XCTAssertEqual(retrySeeds, entropySeeds)

        let generatorPoint = dataFromHex(
            "6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296" +
            "4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5"
        )
        let sensorPointSeeds = try FirstPairSourceSlice.builder6388f0FirstPairStreamSeedsFromEntropyAndSensorPoints(
            entrySource: entrySource,
            nullEntropy11A: nullEntropy,
            row0SensorPointXYBE: generatorPoint,
            row59SensorPointXYBE: generatorPoint
        )
        XCTAssertEqual(sensorPointSeeds.nullAttempts, 1)
        XCTAssertEqual(sensorPointSeeds.nullEntropy11A, nullEntropy)
        XCTAssertEqual(
            Data(SHA256.hash(data: sensorPointSeeds.staticScalarWindow)).hex,
            "581f613027f3b91683819a69b62ac6b691103abc55a62825f0f6a889322c1269"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: sensorPointSeeds.row0Out0)).hex,
            "fbc744031431d9fda2ceed80266ee2dfefb9a55e585ea5bbc2666a144379f042"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: sensorPointSeeds.row0Out1)).hex,
            "f9b223b45fe8ec5687cdcbd18218714f4b261938a4befb37e0ced7b42d012289"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: sensorPointSeeds.row59Out0)).hex,
            "4e9c7fbc86f08bf6293e64ffc1c7aad72df8289410f1928576d42e0062bbf929"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: sensorPointSeeds.row59Out1)).hex,
            "58f151f44d8166ab108b348e911e479fe881bb31598ae34e709a8f4bff586c80"
        )

        let retryPointSeeds = try FirstPairSourceSlice.builder6388f0FirstPairStreamSeedsFromEntropySourceAndSensorPoints(
            entrySource: entrySource,
            row0SensorPointXYBE: generatorPoint,
            row59SensorPointXYBE: generatorPoint,
            maxAttempts: 4
        ) { requestedCount in
            XCTAssertEqual(requestedCount, 0x11a)
            return nullEntropy
        }
        XCTAssertEqual(retryPointSeeds, sensorPointSeeds)

        let sensorPointSource = try FirstPairSourceSlice.deriveFrom6388f0FirstPairEntropyAndSensorPoints(
            entrySource: entrySource,
            nullEntropy11A: nullEntropy,
            row0SensorPointXYBE: generatorPoint,
            row59SensorPointXYBE: generatorPoint
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: sensorPointSource)).hex,
            "ef4495c4b868489d0b4a30546bbf3d3b3ef51498e314a792214092d50ea09f2f"
        )
        XCTAssertEqual(
            sensorPointSource.hex,
            "04040706000606020005070707050402050701070106000602000707060002050402" +
            "0407050605040400060004020400000106060102060205030303040600040606"
        )

        let retryPointSource = try FirstPairSourceSlice.deriveFrom6388f0FirstPairEntropySourceAndSensorPoints(
            entrySource: entrySource,
            row0SensorPointXYBE: generatorPoint,
            row59SensorPointXYBE: generatorPoint,
            maxAttempts: 4
        ) { requestedCount in
            XCTAssertEqual(requestedCount, 0x11a)
            return nullEntropy
        }
        XCTAssertEqual(retryPointSource, sensorPointSource)

        let sensorPointRawKey = try FirstPairSourceSlice.phase5RawKeyFrom6388f0FirstPairEntropyAndSensorPoints(
            entrySource: entrySource,
            nullEntropy11A: nullEntropy,
            row0SensorPointXYBE: generatorPoint,
            row59SensorPointXYBE: generatorPoint
        )
        XCTAssertEqual(sensorPointRawKey, try Phase5KeySchedule.deriveRawKey(input66: sensorPointSource))
    }

    func testBuilder6388f0LowSeedCF0SeedsFromEntrySourceMatchesPythonReferenceVectors() throws {
        let entrySource = Data((0..<0x214).map { index in UInt8((index * 5 + 1) & 7) })
        let seeds = try FirstPairSourceSlice.builder6388f0LowSeedCF0SeedsFromEntrySource(entrySource)
        XCTAssertEqual(seeds.phase1.count, 0x10a)
        XCTAssertEqual(seeds.phase2.count, 0x10a)
        XCTAssertEqual(seeds.phase3.count, 0x10a)
        XCTAssertEqual(
            Data(SHA256.hash(data: seeds.phase1)).hex,
            "9b2d39eb30062613f7ccf5520345c80937d149f06c42c3816f9547388745df3b"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: seeds.phase2)).hex,
            "a34a6cc968db094daaecfd303bbecdda322cd0e01c606c1705422f800dbf02fd"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: seeds.phase3)).hex,
            "c60ed79f4e6da3aa3768e10d95a2c5837708652bb7e2c06c1b91b09adcb2d451"
        )
        XCTAssertEqual(
            Data(seeds.phase3.suffix(16)).hex,
            "04020200010104050701060202000004"
        )

        let pair = try FirstPairSourceSlice.builder6388f0LowSeedTailPairFromEntrySource(entrySource)
        XCTAssertEqual(
            Data(SHA256.hash(data: pair.left)).hex,
            "2c31a9b72d1587155839611a00ebb6756ae34b459dbcbb10b7977ec6f2f85fa8"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: pair.right)).hex,
            "2da6677e738231f8eeeec117db576aaffd4c1c495efd72bf847bf15813ed1d4c"
        )
        let tailStage = try FirstPairSourceSlice.builder6388f0LowSeedTailStageFromPair(pair)
        XCTAssertEqual(
            Data(SHA256.hash(data: tailStage)).hex,
            "05755c6dd9bc68d980beeef36392143524e6bbfcb20b270893509d57ebbc83a3"
        )
        let prelude = try FirstPairSourceSlice.builder6388f0LowSeedPreludeSourceFromTailStage(tailStage)
        XCTAssertEqual(
            Data(SHA256.hash(data: prelude)).hex,
            "e07c11f4368e33eb9812c3d31c186b76741a5b63eb7e77c1fd79a80dd680aaf2"
        )
        let seedBlocks = try FirstPairSourceSlice.builder6388f0LowSeedBlocksFromPreludeSource(prelude)
        XCTAssertEqual(seedBlocks.count, 20 * 16)
        XCTAssertEqual(
            Data(SHA256.hash(data: seedBlocks)).hex,
            "77da5cce8122c3f8309100320249ddfc7d87e8a407e1699eb0d96032a3eb1283"
        )

        let loop = try FirstPairSourceSlice.builder6388f0LowSeedLoopFromBlocks(seedBlocks)
        XCTAssertEqual(loop.final6377f0.hex, "010103020202020202040402040402030502")
        XCTAssertEqual(Array(loop.scheduleWords.prefix(4)), [0x27985d74, 0x602c800b, 0xb5823fb5, 0x3b970a6f])
        XCTAssertEqual(Array(loop.scheduleWords.suffix(4)), [0x1185db13, 0x397e64c3, 0xec257cd4, 0x995e53cc])

        let preimages = try FirstPairSourceSlice.builder6388f0Row0LowSeedPreimagesFromEntrySource(entrySource)
        XCTAssertEqual(
            Data(SHA256.hash(data: preimages.out4)).hex,
            "e70d3f912b290b5bd31c6dd27e8816448c16863247354286fc66957bdf2a8e27"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: preimages.out3)).hex,
            "feb5a841e9f99f5c149350296ffb74725c839af719015cfebfc2e1c01714acbc"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: preimages.out2)).hex,
            "236c8c5040f999f86bfa6bdfd7f9e8e3ee79ce19a6568cf75fd6ef58880bced2"
        )
    }

    func testBuilder633fa8StaticScalarWindowFromEntrySourceMatchesPythonReferenceVector() throws {
        let entrySource = Data((0..<0x214).map { index in UInt8((index * 5 + 1) & 7) })
        let boundary = try FirstPairSourceSlice.builder633fa8StaticTailBoundaryFromEntrySource(entrySource)
        XCTAssertEqual(
            Data(SHA256.hash(data: boundary.preludeSource)).hex,
            "e07c11f4368e33eb9812c3d31c186b76741a5b63eb7e77c1fd79a80dd680aaf2"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(boundary.words3ab0))).hex,
            "9bb588ed741963c1ed0b32efab701fbd87819dfe65f9e0192e8830e8a7a7574d"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(boundary.words3120))).hex,
            "fe4e9fc8207e0cc3276f2cb073a8050bbaa842cd2b114165630eb8214fb30b01"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(boundary.words2dfc))).hex,
            "2acd8bebf1f8746c4d0c264f28cd42010725f116a4587b702b29b75b8fbb2052"
        )
        XCTAssertEqual(boundary.seed3110, 0xb6ccf02833a9825e)

        let scalar = try FirstPairSourceSlice.builder633fa8StaticScalarWindowFromEntrySource(entrySource)
        XCTAssertEqual(
            scalar.hex,
            "f38d95844ac5834265c854266814ed9e67ce508eea912fc81a9b2d28db0ddd5e" +
            "0000000000000000000000000000000000000000000000000000000000000000000000000000"
        )
    }

    func testBuilder633fa8NullEntrySourcesAndInitialMatchPythonReferenceVector() throws {
        let sources = try FirstPairSourceSlice.builder633fa8NullEntrySourcesFromInvariantEntry()
        XCTAssertEqual(sources.prologueSource.count, 0x11a)
        XCTAssertEqual(
            Data(SHA256.hash(data: sources.prologueSource)).hex,
            "b2b08a579ebd69e28c8bbb33b19317c3d4c22cce9ec2a6d60eb81e49c7729115"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sources.check1SourceWords))).hex,
            "4b29cac325304080f0e7b82a92ffe3ef9c3e252aac748ab6e776673fe7e73db6"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sources.check2SourceWords))).hex,
            "8905c6b8cd1d1fec875c168212d3555909e4554ee63432a54744a404db243e4d"
        )

        let entropy = Data((0..<0x11a).map { index in UInt8((index * 11 + 3) & 0xff) })
        let initial = try FirstPairSourceSlice.builder633fa8NullInitialFromEntropy(
            entropy11A: entropy,
            prologueSource: sources.prologueSource
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: initial.maskedEntropy)).hex,
            "23db0a42e5599a320a6384094203a1ecf34a1f7517c94c7fd47267708c760834"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: initial.cf0)).hex,
            "9f50c4c539508ffd0d5a87b37d60997bb1622db044b55662c4d1d6d8bad6f532"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: initial.e10)).hex,
            "0d0d59d1394d720b3d30d2a5f0ae4af4e811d2c9c690767b95d603883164cba5"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: initial.seedInputs)).hex,
            "296b545eb6c3114d4b731abf59bbcb43e1e34b321e787683228ceb02c11d9cc2"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: initial.seedBlocks)).hex,
            "30f124b2c0d6cd19c0bbf4e4f8cf1974e5766ed3171e9556e69979108e74626f"
        )

        let loop = try FirstPairSourceSlice.builder633fa8NullFirstLoopFromBlocks(initial.seedBlocks)
        XCTAssertEqual(loop.finalTLane.hex, "060504020202040404020204040404010504")
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(loop.scheduleWords))).hex,
            "652ce3a7810e6b09bf6ce92f7029f7a79599a95db235538aea7e84bec65e21f0"
        )
        XCTAssertEqual(
            Array(loop.scheduleWords.prefix(4)),
            [0x77de69c8, 0xc857bd48, 0x65000b63, 0xa6ddb53b]
        )
        XCTAssertEqual(
            Array(loop.scheduleWords.suffix(4)),
            [0x7c13a2ce, 0xe082b5ba, 0xbfaf4d29, 0xc67887e7]
        )

        let acceptance = try FirstPairSourceSlice.builder633fa8NullScheduleAcceptance(
            scheduleWords: loop.scheduleWords,
            check1SourceWords: sources.check1SourceWords,
            check2SourceWords: sources.check2SourceWords
        )
        XCTAssertTrue(acceptance.firstOK)
        XCTAssertTrue(acceptance.secondOK)

        var rejectedWords = loop.scheduleWords
        rejectedWords[19] ^= 1
        let rejected = try FirstPairSourceSlice.builder633fa8NullScheduleAcceptance(
            scheduleWords: rejectedWords,
            check1SourceWords: sources.check1SourceWords,
            check2SourceWords: sources.check2SourceWords
        )
        XCTAssertFalse(rejected.firstOK)
        XCTAssertFalse(rejected.secondOK)

        let postAccept = try FirstPairSourceSlice.builder633fa8NullPostAcceptBlocks(
            scheduleWords: loop.scheduleWords
        )
        XCTAssertEqual(postAccept.blocks4080.count, 20 * 16)
        XCTAssertEqual(postAccept.blocks3f40.count, 20 * 16)
        XCTAssertEqual(
            Data(SHA256.hash(data: postAccept.blocks4080)).hex,
            "a8732537d6be3b54f8d00663ae3d0461ed7974b6861b1095b0d16730c08f9c86"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: postAccept.blocks3f40)).hex,
            "8975ea6381dc1f9149d202522d21abf7105e2faf2888a306b5122d3c8f6f0b7c"
        )
        XCTAssertEqual(Data(postAccept.blocks4080.prefix(16)).hex, "01070705070306040206010301020603")
        XCTAssertEqual(Data(postAccept.blocks3f40.prefix(16)).hex, "02030203010200000706020600030203")

        let prelude = try FirstPairSourceSlice.builder633fa8NullPreludeSourceFromPostAccept(
            blocks4080: postAccept.blocks4080,
            blocks3f40: postAccept.blocks3f40
        )
        XCTAssertEqual(prelude.count, 0x10a)
        XCTAssertEqual(
            Data(SHA256.hash(data: prelude)).hex,
            "ed4e5c29dff15da45590bf9bc4ea8b7124af32f51f3add5e786cf77fd36c747d"
        )
        XCTAssertEqual(Data(prelude.prefix(16)).hex, "05000204070405070006020301060606")
        XCTAssertEqual(Data(prelude.suffix(16)).hex, "06040206050602040404020605060204")

        let entropyPrelude = try FirstPairSourceSlice.builder633fa8NullPreludeSourceFromEntropy(
            entropy11A: entropy
        )
        XCTAssertEqual(entropyPrelude, prelude)

        let scalar = try FirstPairSourceSlice.builder633fa8NullScalarWindowFromEntropy(
            entropy11A: entropy
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: scalar)).hex,
            "c4f2357511bf2071de2a5478a5d3d8a17c2b4da7b46c6cb46f4834ecb3a2f2ba"
        )
        XCTAssertEqual(
            scalar.hex,
            "3b588dd68f20da5f883993332cabcda6576645712cdd039d0a8195f4b1c0b52e" +
            "0000000000000000000000000000000000000000000000000000000000000000000000000000"
        )
        XCTAssertEqual(try FirstPairSourceSlice.builder633fa8ScalarWindowFromPreludeSource(prelude), scalar)

        var entropyCalls = 0
        let retryResult = try FirstPairSourceSlice.builder633fa8NullScalarWindowFromEntropySource(
            maxAttempts: 3
        ) { requestedCount in
            entropyCalls += 1
            XCTAssertEqual(requestedCount, 0x11a)
            return entropy
        }
        XCTAssertEqual(entropyCalls, 1)
        XCTAssertEqual(retryResult.scalarWindow, scalar)
        XCTAssertEqual(retryResult.entropy11A, entropy)
        XCTAssertEqual(retryResult.attempts, 1)
        XCTAssertThrowsError(
            try FirstPairSourceSlice.builder633fa8NullScalarWindowFromEntropySource(maxAttempts: 0) { _ in entropy }
        ) { error in
            XCTAssertEqual(error as? FirstPairSourceSliceError, .invalid633fa8NullMaxAttempts(0))
        }
    }

    func testBuilder633fa8TailQwordsFromSourcesMatchesPythonReferenceVector() throws {
        let words3ab0: [UInt32] = [
            0x561f0a13, 0x2703b81f, 0xc60ebb71, 0x13ae9923, 0x6151794d,
            0xcbd488b3, 0x105a57ba, 0xbe270b51, 0x35178421, 0x9c1e6b02,
            0x8131d744, 0x995e53cc, 0xe98d93e2, 0xbcf84415, 0xbfccce8e,
            0x6c32338c, 0xd608b5a1, 0xe7c2db10, 0x8131d744, 0x995e53cc,
        ]
        let words3120: [UInt32] = [
            0xb33842d7, 0x7b6ba784, 0xa2f90f36, 0xde5e2ad7, 0x3c3537a9,
            0x81d564f6, 0x339ab4a2, 0x999de03b, 0x56c13b42, 0xff14a487,
            0x5a31640c, 0xc3f85236, 0x3c1dc79e, 0x58a8d4a6, 0x541cb00e,
            0x63323fcd, 0x1aa54a16, 0x01f1b661, 0x5a31640c, 0xc3f85236,
        ]
        let words2dfc: [UInt32] = [
            0x9bed19fd, 0xc70a4d0f, 0x8257d22b, 0xe2fafcb3, 0x02c77d20,
            0xb5ed0efa, 0x878c1b06, 0x4bd92d7d, 0x21c6944f, 0xd3ec5d2f,
            0x876fda86, 0x37f3e22a, 0x3cfcd7ce, 0xabdc16eb, 0x84ad2f7d,
            0x4bd92d7d, 0xf647adce, 0xaa7b701e, 0x876fda86, 0x37f3e22a,
        ]
        let qwords = try FirstPairSourceSlice.builder633fa8TailQwordsFromSources(
            words3ab0: words3ab0,
            words3120: words3120,
            words2dfc: words2dfc,
            seed3110: 0xb6ccf02833a9825e
        )
        XCTAssertEqual(
            qwords,
            [
                0x278653e978fb8d86, 0x01531105e76d5345, 0x6ca239d879644a5c, 0xa06b5f9758fb4bd5,
                0xd4aba6030256919a, 0x701b8d245771a9c8, 0x25f9e61e7612a2cb, 0x42af4c71aeed4949,
                0xf69e5c8932e52f6c, 0x7785655189e16a0f, 0x7785655189e16a0f, 0x7785655189e16a0f,
                0x7785655189e16a0f, 0x7785655189e16a0f, 0x7785655189e16a0f, 0x7785655189e16a0f,
                0x7785655189e16a0f, 0x7785655189e16a0f, 0x7785655189e16a0f, 0x7785655189e16a0f,
            ]
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(qwords))).hex,
            "8718a3b565f0e38d8631d894877d72c491cfaa21abccc8958829a7b0ca97b15d"
        )
        let e10Words = try FirstPairSourceSlice.builder633fa8E10WordsFromTailQwords(qwords)
        XCTAssertEqual(
            try FirstPairSourceSlice.builder633fa8ScalarWindowFromE10Words(e10Words).hex,
            "4532bea83bfdabcf74fdaeeb0319a83c051a31e40a620e3bd0db1cd993ed8522" +
            "0000000000000000000000000000000000000000000000000000000000000000000000000000"
        )
    }

    func testBuilder633fa8E10WordsFromTailQwordsMatchesPythonReferenceVector() throws {
        let tailQwords: [UInt64] = [
            0x278653e978fb8d86, 0x01531105e76d5345, 0x6ca239d879644a5c, 0xa06b5f9758fb4bd5,
            0xd4aba6030256919a, 0x701b8d245771a9c8, 0x25f9e61e7612a2cb, 0x42af4c71aeed4949,
            0xf69e5c8932e52f6c, 0x7785655189e16a0f, 0x7785655189e16a0f, 0x7785655189e16a0f,
            0x7785655189e16a0f, 0x7785655189e16a0f, 0x7785655189e16a0f, 0x7785655189e16a0f,
            0x7785655189e16a0f, 0x7785655189e16a0f, 0x7785655189e16a0f, 0x7785655189e16a0f,
        ]
        let words = try FirstPairSourceSlice.builder633fa8E10WordsFromTailQwords(tailQwords)
        XCTAssertEqual(
            words,
            [
                0x5a1e4b39, 0x5e9483af, 0xcf48138f, 0x9e28b8cd, 0x55b48903,
                0xdefd3261, 0x2c462f90, 0x5d22446d, 0x5170b893, 0xdcd2fa37,
                0xfaacce40, 0x997a6bab, 0x7781207b, 0x182c4538, 0x5475ee9a,
                0xf1fd3b9c, 0x8281f8c2, 0x0ba21025, 0xfaacce40, 0x997a6bab,
            ]
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(words))).hex,
            "4f7646b6cb17189560193adc7b951d47443edf292ea8213d2481cd8c89ba79a9"
        )
        XCTAssertEqual(
            try FirstPairSourceSlice.builder633fa8ScalarWindowFromE10Words(words).hex,
            "4532bea83bfdabcf74fdaeeb0319a83c051a31e40a620e3bd0db1cd993ed8522" +
            "0000000000000000000000000000000000000000000000000000000000000000000000000000"
        )
    }

    func testBuilder633fa8ScalarWindowFromE10WordsMatchesPythonReferenceVector() throws {
        let e10Words: [UInt32] = [
            0xf15eecb3, 0x6c31d20d, 0x7a812282, 0x88c66764, 0xc7daeb98,
            0xcb55b447, 0x7dc4c98a, 0xe8533b12, 0x3976a2b8, 0x39a2c9bd,
            0xa7ca28ea, 0x6e74c495, 0x06708db4, 0x5a2caf42, 0xedb8643d,
            0xd19d3544, 0x8281f8c2, 0x0ba21025, 0xfaacce40, 0x997a6bab,
        ]
        let scalar = try FirstPairSourceSlice.builder633fa8ScalarWindowFromE10Words(e10Words)
        XCTAssertEqual(scalar.count, 70)
        XCTAssertEqual(
            scalar.hex,
            "f38d95844ac5834265c854266814d19822125ef87edcfcab64db2fd1a3b4b0e7a" +
            "d6a1fa15f51ce7eea7853023be2e9ecb5a99876f7a8a0e00000000000000000000000000000"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: scalar)).hex,
            "af6aea9e701fb090af64b2446d8ccdef01327837f264bbe65b20db784345fa16"
        )
    }

    func testBuilder6388f0CallerContextResourcesMatchPythonReferenceVectors() throws {
        let shared = try FirstPairSourceSlice.builder6388f0SharedContextFromBundle()
        XCTAssertEqual(shared.count, 0x520)
        XCTAssertEqual(
            Data(SHA256.hash(data: shared)).hex,
            "ef3f9995fade12005f0f4410bc1ffa23a03412851e31503042e149da302f2dac"
        )
        XCTAssertEqual(
            Data(shared.prefix(32)).hex,
            "21ed7e8fc9862976ac50b4cb1e31a91f30fa05c70682ac26bc7db76219fd1d35"
        )
        XCTAssertEqual(
            Data(shared.suffix(32)).hex,
            "4a411f4b3cf073011ded82b57188f50f977c1b57e3fbc2051c7577ffbb255fc9"
        )

        let tables = try FirstPairSourceSlice.builder6388f0CallerLoopTablesFromBundle()
        XCTAssertEqual(tables.first.count, 59 * 0x58)
        XCTAssertEqual(tables.second.count, 59 * 0x58)
        XCTAssertEqual(
            Data(SHA256.hash(data: tables.first)).hex,
            "08e40f696924cbde7e31db9c9102d071f1d17a0a60a17f58768b01f5ec067d35"
        )
        XCTAssertEqual(
            Data(tables.first.prefix(32)).hex,
            "db7c3afca9d52301c0064bb894889a5e8c592cf871412afd4a411f5dad1b1a64"
        )
        XCTAssertEqual(
            Data(tables.first.suffix(32)).hex,
            "4a411f4b3cf073011ded82b57188f50f977c1b57e3fbc2051c7577ffbb255fc9"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: tables.second)).hex,
            "6471d5ae1bc99ec976683bc2e568af44b58f900cf0242439b9626d69cb54ec65"
        )
        XCTAssertEqual(
            Data(tables.second.prefix(32)).hex,
            "bfcf00c8b7ecf353653481454ad35d2054aae79357422e128e2024529ca00ce0"
        )
        XCTAssertEqual(
            Data(tables.second.suffix(32)).hex,
            "fccee0a880f009f9e121349c190bb74368363d144a33c2dd9112d90aeb6e5f5d"
        )

        let context = try FirstPairSourceSlice.builder6388f0CallerContextFromLoopTables(tables)
        XCTAssertEqual(context.count, 0x2d58)
        XCTAssertEqual(
            Data(SHA256.hash(data: context)).hex,
            "f5059c7c440707b8bdc08c309540e629e109e78941406442a7d189f5c23fbe5f"
        )
        XCTAssertEqual(
            Data(context.prefix(32)).hex,
            "21ed7e8fc9862976ac50b4cb1e31a91f30fa05c70682ac26bc7db76219fd1d35"
        )
        XCTAssertEqual(
            Data(context.suffix(32)).hex,
            "fccee0a880f009f9e121349c190bb74368363d144a33c2dd9112d90aeb6e5f5d"
        )
        XCTAssertEqual(Data(context[0x4c8..<(0x4c8 + tables.first.count)]), tables.first)
        XCTAssertEqual(Data(context[0x1910..<(0x1910 + tables.second.count)]), tables.second)
        XCTAssertEqual(try FirstPairSourceSlice.builder6388f0CallerContextFromBundle(), context)
    }

    func testBuilder642f60InitialStagesMatchPythonReferenceVectors() throws {
        let x1 = Data((0..<88).map { index in UInt8((index * 13 + 9) & 0xff) })
        let x0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let x2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let output = Data((0..<88).map { index in UInt8((index * 17 + 4) & 0xff) })
        let arg0 = Data((0..<88).map { index in UInt8((index * 19 + 3) & 0xff) })
        let scalar: UInt64 = 0x0fedcba987654321

        let sp2a8 = try FirstPairSourceSlice.builder642f60StageSP2A8WordsFromX1(x1)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp2a8))).hex,
            "8f828a7da4493c59a03f2e57e5040ba00114d22495ebc08a9bb71d06bdc115d5"
        )
        XCTAssertEqual(
            Array(sp2a8.prefix(4)),
            [0x4a545152, 0xeb8ceacd, 0x6ee8542c, 0x8f614dc2]
        )
        XCTAssertEqual(
            Array(sp2a8.suffix(4)),
            [0x9da005cb, 0x375c139a, 0xc085fb32, 0x8542933b]
        )
        let firstWorkspace = try FirstPairSourceSlice.builder642f60First64bd0cWorkspaceFromX1(
            x1Source: x1,
            sp2a8Words: sp2a8
        )
        XCTAssertEqual(firstWorkspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: firstWorkspace)).hex,
            "71999b7359489904962a33e87d4f7d7b045b1d59b6056d2031c3039df85b9003"
        )
        XCTAssertEqual(
            Data(firstWorkspace.prefix(32)).hex,
            "086cb880065cb85808ad97f53a270ada48ff6b096bd1aa3ea0268718ad4e3ddf"
        )
        XCTAssertEqual(
            Data(firstWorkspace.suffix(32)).hex,
            "0c413ff42dbed2247aaebca271a82607684e5068580db306084c720cc23e1703"
        )
        let arg0Words = try FirstPairSourceSlice.builder64bd0cArg0U64Words(arg0: arg0)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(arg0Words))).hex,
            "959177503b2023288b94d3167c99cd47f8e7fc6f3449aa7f20f3a461d18251f9"
        )
        let updated64bd0c = try FirstPairSourceSlice.builder64bd0cWorkspaceAfterUpdate(
            arg0U64Words: arg0Words,
            scalar: scalar,
            x2Workspace: firstWorkspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: updated64bd0c)).hex,
            "bb1551ac44a49ebd22583cb1eb07bc918a8b522172e049092b8596fc7ab2bf29"
        )
        let output64bd0c = try FirstPairSourceSlice.builder64bd0cFinalU32Words(x2Workspace: updated64bd0c)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output64bd0c))).hex,
            "5d3ef1f04a3b810f276531edc05b4901e6ec17dca864503d7ee38c1dae9c5a6e"
        )
        XCTAssertEqual(
            try FirstPairSourceSlice.builder64bd0cOutputWords(
                arg0: arg0,
                scalar: scalar,
                x2Workspace: firstWorkspace
            ),
            output64bd0c
        )

        let sp1f8 = try FirstPairSourceSlice.builder642f60StageSP1F8WordsFromX0(x0)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp1f8))).hex,
            "3fd4edb09dc91b6ddc9ad925775420a371151828eac3ee32b1e0e92932651e57"
        )
        XCTAssertEqual(
            Array(sp1f8.prefix(4)),
            [0x69e6983e, 0x52adf2b0, 0x9c3e0b1c, 0xce05e1cd]
        )
        XCTAssertEqual(
            Array(sp1f8.suffix(4)),
            [0xf8aada36, 0x50d2d9ef, 0x8d23cbd4, 0x222c26ac]
        )
        let sp300FromFirstOutput = try FirstPairSourceSlice.builder642f60StageSP300WordsFrom64bd0cOutput(
            packUInt32LE(output64bd0c)
        )
        let secondWorkspace = try FirstPairSourceSlice.builder642f60Second64bd0cWorkspace(
            sp1f8Words: sp1f8,
            sp300Words: sp300FromFirstOutput
        )
        XCTAssertEqual(secondWorkspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: secondWorkspace)).hex,
            "ca10191ddcf021d37fe567b3840c74edd67cb2d8eb6f93e062ede78437ac75cd"
        )
        XCTAssertEqual(
            Data(secondWorkspace.prefix(32)).hex,
            "b471e2fe79a9a301ac050344d103e81f5a31686d8112adeef233681d13dc7244"
        )
        XCTAssertEqual(
            Data(secondWorkspace.suffix(32)).hex,
            "89dee183dabe10816ffdfd9fdd8fb8a0eac33fd506ace277084c720cc23e1703"
        )
        let secondOutput = try FirstPairSourceSlice.builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: secondWorkspace
        )
        let sp250FromSecondOutput = try FirstPairSourceSlice.builder642f60StageSP250WordsFrom64bd0cOutput(
            packUInt32LE(secondOutput)
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp250FromSecondOutput))).hex,
            "589183582eca59a369e4539a9af3447aa94a9254685aa95ec7b6425ae70cb98b"
        )

        let thirdWorkspace = try FirstPairSourceSlice.builder642f60Third64bd0cWorkspaceFromX2(x2)
        XCTAssertEqual(thirdWorkspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: thirdWorkspace)).hex,
            "eb364923c9af8081354fdb867b420b25a7671cd6ad29be6a59d6f42575c64b78"
        )
        XCTAssertEqual(
            Data(thirdWorkspace.prefix(32)).hex,
            "0c104df2b29622434c82979a125bceab958df21121cfd218fe9b83f1886f08e8"
        )
        XCTAssertEqual(
            Data(thirdWorkspace.suffix(32)).hex,
            "8c4da37cf84d2509e8b7b9e083eec7ba482c27a7e28df965084c720cc23e1703"
        )
        let thirdOutput = try FirstPairSourceSlice.builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: thirdWorkspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(thirdOutput))).hex,
            "eb48d72aa8e50042313ee7997d44bac8913c326beaf560c1526172eb65aab723"
        )
        let sp148FromThirdOutput = try FirstPairSourceSlice.builder642f60StageSP148WordsFrom64bd0cOutput(
            packUInt32LE(thirdOutput)
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp148FromThirdOutput))).hex,
            "dc2f907533997ec0281f478799f738cedb091dd4823583aca78fb29b735ab721"
        )
        let fourthWorkspace = try FirstPairSourceSlice.builder642f60Fourth64bd0cWorkspace(
            sp148Words: sp148FromThirdOutput
        )
        XCTAssertEqual(fourthWorkspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: fourthWorkspace)).hex,
            "4e05b824f913c717b12674a3aab7228c7da82df22939cf9d5aaa17067e2fff63"
        )
        XCTAssertEqual(
            Data(fourthWorkspace.prefix(32)).hex,
            "0cffa70f53d9c80d14057382fc257a18b1b8a01412c2938bd8d3ffdcc1cb8d6a"
        )
        XCTAssertEqual(
            Data(fourthWorkspace.suffix(32)).hex,
            "a04db05d65de38a4488b463bf601890618d225871af87a14084c720cc23e1703"
        )
        let fourthOutput = try FirstPairSourceSlice.builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: fourthWorkspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(fourthOutput))).hex,
            "eb1a69a95b8180f875b7ed6f2e5445b5144eac396c6d2f736dfd52472971aab7"
        )
        let spf0FromFourthOutput = try FirstPairSourceSlice.builder642f60StageSPF0WordsFrom64bd0cOutput(
            packUInt32LE(fourthOutput)
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(spf0FromFourthOutput))).hex,
            "5e40c800bafaf359c2f85016931771aab6bed679314cd57d6b93825ff824b9e1"
        )
        let midSPA90 = try FirstPairSourceSlice.builder642f60MidStageSPA90WordsFromX0(x0)
        XCTAssertEqual(midSPA90.count, 22)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(midSPA90))).hex,
            "aac4238d8bbb4b8919022d2808a5f78b6b8dfe8b2e65f74bf02e8e4e9c8e8589"
        )
        let midSP40 = try FirstPairSourceSlice.builder642f60MidStageSP40WordsFromSPA90(midSPA90)
        XCTAssertEqual(midSP40.count, 44)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(midSP40))).hex,
            "1504c65189554c49926041804dd19ae228fba4c1e385c12314f75bbec25bc375"
        )
        XCTAssertEqual(
            Array(midSP40.prefix(4)),
            [0x35529dd1, 0x72007bb1, 0xb3df1669, 0x5db9b4dc]
        )
        XCTAssertEqual(
            Array(midSP40.suffix(4)),
            [0x6c8a982f, 0x5f4c42a3, 0x4f51060d, 0x99fb2d87]
        )

        let midStreams = try FirstPairSourceSlice.builder642f60MidStageStreamsFromContextSPF0(
            contextSource: FirstPairSourceSlice.builder6388f0SharedContextFromBundle(),
            spf0Words: spf0FromFourthOutput
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(midStreams.spa90Words))).hex,
            "4612a77fcc1862e03e8f9071ed96021fd8278d9e4b759902f9d708d93f015518"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(midStreams.sp510Prefix))).hex,
            "bd332ed27e750a48e1253148b35979fd033779dd54687278031cdf38487ec1b4"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(midStreams.sp880Words))).hex,
            "1060d4058c115741df2d3c32ecc5b72d07f4d51a0feab492c54d3c05cd9cac3b"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(midStreams.sp9e0Prefix))).hex,
            "dc97df1d2bb966138bd3636c12fd741949ed0b64be4ad80d03846a375a5fc19c"
        )
        let midSP670 = try FirstPairSourceSlice.builder642f60MidStageSP670Words(
            spa90Words: midStreams.spa90Words,
            sp510Prefix: midStreams.sp510Prefix,
            sp880Words: midStreams.sp880Words,
            sp9e0Prefix: midStreams.sp9e0Prefix
        )
        XCTAssertEqual(midSP670.count, 44)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(midSP670))).hex,
            "7022e51b4a7f4e8cf3efaf9a22df2490fe16cd52af14345dda8bdfba274913c7"
        )
        let midSP40B = try FirstPairSourceSlice.builder642f60MidStageSPA90SP880FromSP40(
            sp40Words: midSP40
        )
        XCTAssertEqual(midSP40B.sideInit, 0x9b3fe2a5f2a431c6)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(midSP40B.spa90Words))).hex,
            "704129f7d2f099279c16bdc46558950398e440a5696c0d3ce486af146f571c16"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(midSP40B.sp880Prefix))).hex,
            "0c2f3db5097284b92a2c9e9c657723251e88d0404d5557a2082a954bb479b6c2"
        )
        let midStatic = try FirstPairSourceSlice.builder642f60MidStageStaticSP9E0SP7D0(
            sideInit: midSP40B.sideInit
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(midStatic.sp9e0Words))).hex,
            "940228bc7962e67ba2baac5819a3e5fd6f97d4040f6a36f4a962e9d7e71165b8"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(midStatic.sp7d0Prefix))).hex,
            "2f9bd217712c0037a4bb0dc7f6428debe9f47d104e394b4aee09c39bf4e3b13f"
        )
        let midSP510 = try FirstPairSourceSlice.builder642f60MidStageSP510Words(
            spa90Words: midSP40B.spa90Words,
            sp880Prefix: midSP40B.sp880Prefix,
            sp9e0Words: midStatic.sp9e0Words,
            sp7d0Prefix: midStatic.sp7d0Prefix
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(midSP510))).hex,
            "0ec28196c798b8373f978ff6f23daca738c2743fcb3bd6a815fa80e41517e0a1"
        )
        let fifthWorkspace = try FirstPairSourceSlice.builder642f60MidFifth64bd0cWorkspace(
            sp670Words: midSP670,
            sp510Words: midSP510
        )
        XCTAssertEqual(fifthWorkspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: fifthWorkspace)).hex,
            "b82a12c1bc5b397f1408b510140ebaf5fc4ceedaedf8b39ae1b83cb406ae246d"
        )
        let fifthOutput = try FirstPairSourceSlice.builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: fifthWorkspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(fifthOutput))).hex,
            "ca6c0bf7532688d60636480d3ff0baed7a7bbb9c14b6f5c102716808baf8551f"
        )
        let sp1a0FromFifthOutput = try FirstPairSourceSlice.builder642f60StageSP1A0WordsFrom64bd0cOutput(
            packUInt32LE(fifthOutput)
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp1a0FromFifthOutput))).hex,
            "faf7f3a4cb372cf5e9c5428cdd2cac3737321290d618c099447201017a2065bd"
        )
        let sixthStreams = try FirstPairSourceSlice.builder642f60SixthStreamsFromSP1A0(
            sp1a0Words: sp1a0FromFifthOutput
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(sixthStreams.spa90Words))).hex,
            "e9c19157950aad3351142adeb2f1fed3804280bf27f8d8b3001f65f5448d1780"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(sixthStreams.sp670Prefix))).hex,
            "d59a1bea1b4b21a4b33acfc7e6d1ebc349e357a447a4c82fe30c4116ce76075f"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(sixthStreams.sp880Words))).hex,
            "c908be53c01f80bf8c7e4f487a4fecf5fc989aeb62a5a49de086021d946025de"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(sixthStreams.sp510Prefix))).hex,
            "f2ed82df4b86e6610cddb46a12ca466b28cb7fb8b51e8d48b398729af7b77b81"
        )
        let sixthWorkspace = try FirstPairSourceSlice.builder642f60Sixth64bd0cWorkspace(
            spa90Words: sixthStreams.spa90Words,
            sp670Prefix: sixthStreams.sp670Prefix,
            sp880Words: sixthStreams.sp880Words,
            sp510Prefix: sixthStreams.sp510Prefix
        )
        XCTAssertEqual(sixthWorkspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: sixthWorkspace)).hex,
            "f3f92c8a7b28e42606d05893406c61b98ba68869d51dd5886326b27137fdec19"
        )
        let sixthOutput = try FirstPairSourceSlice.builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: sixthWorkspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sixthOutput))).hex,
            "d5fb1d1b7a140d9fb9530ab11c3e748b7c2cb6a98caa11dcb29027b59aef43ef"
        )
        let out0Source = try FirstPairSourceSlice.builder642f60Out0SourceWords(
            sixthOutput: packUInt32LE(sixthOutput),
            contextSource: FirstPairSourceSlice.builder6388f0SharedContextFromBundle(),
            sp250Words: sp250FromSecondOutput
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(out0Source))).hex,
            "a786ef481ee4d3a137fb62b582fd2a0a25b067aa747b8e119e6dccb64f3d7931"
        )
        let out0 = try FirstPairSourceSlice.builder642f60Out0WordsFromSource(out0Source)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(out0))).hex,
            "ec26506de5e68c3fd206e6ec3d809c9425c8a48e2f7033bfab37f639b2d39ee6"
        )
        let seventhSource = try FirstPairSourceSlice.builder642f60SeventhSourceWords(
            sp250Words: sp250FromSecondOutput,
            contextSource: FirstPairSourceSlice.builder6388f0SharedContextFromBundle(),
            out0Words: out0
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(seventhSource))).hex,
            "a2e9303b9b5b9b3d6724efd2270260e25499279966cb839934468d34a4a7a3f2"
        )
        let seventhSP148 = try FirstPairSourceSlice.builder642f60SeventhStageSP148WordsFromSource(
            seventhSource
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(seventhSP148))).hex,
            "95259f0656efd4da682c6d44b3e75fbd5e0255b2cf4deb18fda24c314361f960"
        )
        let seventhStreams = try FirstPairSourceSlice.builder642f60SeventhStreams(
            sp1a0Words: sp1a0FromFifthOutput,
            sp148Words: seventhSP148
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(seventhStreams.sp670Words))).hex,
            "c994283392c158405962b94a3a3d1151c00a1697dda6078880de0549c0ba0ba4"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(seventhStreams.spa90Prefix))).hex,
            "ad186b4c6c314109cc76496bb2cfd20d4c9ce4b6cb46eabe2fa8bfedece4370d"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(seventhStreams.sp510Words))).hex,
            "9fb2e0f00e7464c47a64ffaa0e82e40b469579a7a95b8de1476b5e219788e21f"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(seventhStreams.sp880Prefix))).hex,
            "1f9b41793357ab8779a27573de0b8798a97fc3873a9936359e3fd218d7a3d410"
        )
        let seventhSP9E0 = try FirstPairSourceSlice.builder642f60SeventhSP9E0Words(
            sp670Words: seventhStreams.sp670Words,
            spa90Prefix: seventhStreams.spa90Prefix,
            sp510Words: seventhStreams.sp510Words,
            sp880Prefix: seventhStreams.sp880Prefix
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(seventhSP9E0))).hex,
            "e37413004fb514f85c75729da018412b5c415c9380bda9d0b719fea6db31f3a6"
        )
        XCTAssertEqual(
            Array(seventhSP9E0.prefix(4)),
            [0x5f6dd1e1, 0xabcb1928, 0xa1967cd8, 0xfeb29d92]
        )
        XCTAssertEqual(
            Array(seventhSP9E0.suffix(4)),
            [0xdcab123e, 0x4b8612e8, 0x02abe7d2, 0x7a2fefdd]
        )
        let seventhSPA90 = try FirstPairSourceSlice.builder642f60SeventhSPA90WordsFromSP300(
            sp300FromFirstOutput
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(seventhSPA90))).hex,
            "d6b753435f42d5c24fbb383ff1b3ee1b5fd1aad791a4ef8692902747f0e72997"
        )
        let seventhSP7D0 = try FirstPairSourceSlice.builder642f60SeventhSP7D0WordsFromSPA90(
            seventhSPA90
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(seventhSP7D0))).hex,
            "3e59a9f321203b7f35d979f45eebfea1886d4cfad5949626bc2664bcd875c748"
        )
        let seventhSource44 = try FirstPairSourceSlice.builder642f60SeventhSource44Words(
            sp9e0Words: seventhSP9E0,
            contextSource: FirstPairSourceSlice.builder6388f0SharedContextFromBundle(),
            sp7d0Words: seventhSP7D0
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(seventhSource44))).hex,
            "0dc439079188a120ee22095c559c1cc42fff70dd25c14986b09348d215f27b6f"
        )
        let seventhSP40 = try FirstPairSourceSlice.builder642f60SeventhSP40WordsFromSource44(
            seventhSource44
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(seventhSP40))).hex,
            "3b9636afe859f7dac63be47e1b5f8ba67ac0b08c025b311d0a155aba9ddd77aa"
        )
        let seventhWorkspace = try FirstPairSourceSlice.builder642f60Seventh64bd0cWorkspace(
            sp40Words: seventhSP40
        )
        XCTAssertEqual(seventhWorkspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: seventhWorkspace)).hex,
            "622ff09e3ef098d358adda7b57e061abd86c5a5cbc7d5c3f25452330f75ef9cb"
        )
        let seventhOutput = try FirstPairSourceSlice.builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: seventhWorkspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(seventhOutput))).hex,
            "3a822a7f1a90cf5cf5ae217a07640d66269e95f0be53dbbb607f486279ecbc9c"
        )
        let out1 = try FirstPairSourceSlice.builder642f60Out1WordsFrom64bd0cOutput(
            packUInt32LE(seventhOutput)
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(out1))).hex,
            "3e6436605d188c9ced00cd0accd72edf521d96eec87a3ef9527c911c19cb5b0f"
        )
        XCTAssertEqual(
            Array(out1.prefix(4)),
            [0xce8a9be4, 0xc663f93d, 0xf77e4c6a, 0x657aca3e]
        )
        XCTAssertEqual(
            Array(out1.suffix(4)),
            [0x38cb4c20, 0xd773b033, 0x6e86dad6, 0x6a737805]
        )
        let eighthStreams = try FirstPairSourceSlice.builder642f60EighthStreams(
            sp2a8Words: sp2a8,
            x2Source: x2
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(eighthStreams.spa90Words))).hex,
            "c327b7a453a17eb81062883abcbe55d935200cfe912ed92dbbee1734b5afc5d1"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(eighthStreams.sp670Prefix))).hex,
            "e66cf3bd22a351f438ef25f0489a7e6d7623002d4de4700fa8f665b0355ce8a9"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(eighthStreams.sp880Words))).hex,
            "bbc6d8b43127645cb932c82e7be91e4bae25b6daa6dafd89a42cfa8d60976f92"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(eighthStreams.sp510Prefix))).hex,
            "e9674687f3fa00f954d928d71797432cb57983150b2428f2dc6a04a020ac2980"
        )
        let eighthWorkspace = try FirstPairSourceSlice.builder642f60Eighth64bd0cWorkspace(
            spa90Words: eighthStreams.spa90Words,
            sp670Prefix: eighthStreams.sp670Prefix,
            sp880Words: eighthStreams.sp880Words,
            sp510Prefix: eighthStreams.sp510Prefix
        )
        XCTAssertEqual(eighthWorkspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: eighthWorkspace)).hex,
            "17b5fde88b8e761b44de016710946bbd52847db3f194fb548d424727daf94347"
        )
        let eighthOutput = try FirstPairSourceSlice.builder64bd0cOutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: eighthWorkspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(eighthOutput))).hex,
            "42e92eaf7ec2510b60090919242b7659adb855a220e3d208895a163f96e6775b"
        )
        let out2 = try FirstPairSourceSlice.builder642f60Out2WordsFrom64bd0cOutput(
            packUInt32LE(eighthOutput)
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(out2))).hex,
            "6742594d34d56c1f0c72ee89012f929548a832844b8b609775e9985fec3746b1"
        )
        XCTAssertEqual(
            Array(out2.prefix(4)),
            [0x317a551b, 0x1951c2c8, 0x696bf2c7, 0xfeedf1a6]
        )
        XCTAssertEqual(
            Array(out2.suffix(4)),
            [0xb927d2dd, 0xd529e3e0, 0x5dcdae1c, 0x0f6c6f5a]
        )

        let affineVectors: [(name: String, words: [UInt32], hash: String)] = [
            (
                "sp300",
                try FirstPairSourceSlice.builder642f60StageSP300WordsFrom64bd0cOutput(output),
                "230a5a9f7600e5c7f4edf9a41de45b802c0e86c9f0d34d6ec851fc9dfe7a3d01"
            ),
            (
                "sp250",
                try FirstPairSourceSlice.builder642f60StageSP250WordsFrom64bd0cOutput(output),
                "06a9ce49a16f0594114a591bf8f10adf630e65f39baab23042372d9b7f7b457a"
            ),
            (
                "sp148",
                try FirstPairSourceSlice.builder642f60StageSP148WordsFrom64bd0cOutput(output),
                "814f15ddb3e704703b4cdfbd670e848007b58858cce69cce3c03ab16c1b96465"
            ),
            (
                "spf0",
                try FirstPairSourceSlice.builder642f60StageSPF0WordsFrom64bd0cOutput(output),
                "89f74ab7564faa6ec3ce6ff27117df2948ca38e27362c58ba68ed05b53e30039"
            ),
            (
                "sp1a0",
                try FirstPairSourceSlice.builder642f60StageSP1A0WordsFrom64bd0cOutput(output),
                "b1364b48497efd7082324483daab477fc7dba684c5673c2b80f109fbbbe73e0a"
            ),
        ]
        for vector in affineVectors {
            XCTAssertEqual(vector.words.count, 22, vector.name)
            XCTAssertEqual(Data(SHA256.hash(data: packUInt32LE(vector.words))).hex, vector.hash, vector.name)
        }
    }

    func testBuilder642f60OutputsWithBundledContextMatchesPythonReferenceVector() throws {
        let x1 = Data((0..<88).map { index in UInt8((index * 13 + 9) & 0xff) })
        let x0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let x2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })

        let result = try FirstPairSourceSlice.builder642f60OutputsFromBundledContext(
            in0: x0,
            in1: x1,
            in2: x2
        )
        XCTAssertEqual(result.out0.count, 88)
        XCTAssertEqual(result.out1.count, 88)
        XCTAssertEqual(result.out2.count, 88)
        XCTAssertEqual(
            Data(SHA256.hash(data: result.out0)).hex,
            "e4e4bc44d23db2b617f3d9a3f84a9dc1a6767d4d242a4c52b8427c587148a813"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: result.out1)).hex,
            "f6e027253992cc3f10bc117332271b9c97a5e6570be183b0808309bcc759bfd2"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: result.out2)).hex,
            "9c0ec2ac6f581933c3e457e0c4267507a575e1280caf5cbe09b962f265307e92"
        )

        var combined = Data()
        combined.append(result.out0)
        combined.append(result.out1)
        combined.append(result.out2)
        XCTAssertEqual(
            Data(SHA256.hash(data: combined)).hex,
            "7b97c74090a4e4e2c720abf39d86a1343ba5e1961f206e227b3e06a531bc51ff"
        )

        let explicitContext = try FirstPairSourceSlice.builder642f60Outputs(
            in0: x0,
            in1: x1,
            in2: x2,
            contextSource: FirstPairSourceSlice.builder6388f0SharedContextFromBundle()
        )
        XCTAssertEqual(explicitContext, result)
    }

    func testBuilder6473d0OutputsWithBundledContextMatchesPythonReferenceVector() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let in0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let in1 = Data((0..<88).map { index in UInt8((index * 13 + 9) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let out1Seed = Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) })

        let result = try FirstPairSourceSlice.builder6473d0OutputsFromBundledContext(
            in0: in0,
            in1: in1,
            in2: in2,
            out0Preimage: out0Seed,
            out1Preimage: out1Seed
        )

        let vectors: [(String, Data, String)] = [
            ("in0_after", result.in0After, "9692c8145a24dcadc1fd23963c583512c8aebf55dc7c68ad677cb8f53f2117ea"),
            ("in1_after", result.in1After, "a4a1bb98f66e3d53a51c810379507e4a1f856bf51be0d007e10d5b3afc90252b"),
            ("in2_after", result.in2After, "8eb586c217d306dbde11f9301ab67d009e8dba5414bcebe90944e8542082edee"),
            ("out0", result.out0, "76cebb860262dd83aa186fc63ea614b3af5633e56600dda4d4da79ba840366bd"),
            ("out1", result.out1, "c49ad60aa507e639c71430a12067b0eb5d75737460bd9997b020b5760197ceb8"),
            ("out2", result.out2, "c5e3ec0675df26d11bd8390e34135652ad6b530fb8e003151b44cf1dfce6e169"),
            ("out3", result.out3, "d1486d791a35e129933d31bab4e814a0cdcd3db8c3b4895950882cba18791c90"),
            ("out4", result.out4, "3d1a32df33f5ce078ed6cfa67972c041d5aff9606ff86c381b5d257fa4bb3517"),
        ]
        for vector in vectors {
            XCTAssertEqual(vector.1.count, 88, vector.0)
            XCTAssertEqual(Data(SHA256.hash(data: vector.1)).hex, vector.2, vector.0)
        }

        var combined = Data()
        for vector in vectors {
            combined.append(vector.1)
        }
        XCTAssertEqual(
            Data(SHA256.hash(data: combined)).hex,
            "62d20b19dfc648c822a404a8672031efe193c1da60496b82a337458c1c1d2a5c"
        )

        let explicitContext = try FirstPairSourceSlice.builder6473d0Outputs(
            in0: in0,
            in1: in1,
            in2: in2,
            contextSource: FirstPairSourceSlice.builder6388f0SharedContextFromBundle(),
            out0Preimage: out0Seed,
            out1Preimage: out1Seed
        )
        XCTAssertEqual(explicitContext, result)
    }

    func testBuilder6473d0PreimageStackAndPostVectorsMatchPythonReferenceVector() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let in0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let in1 = Data((0..<88).map { index in UInt8((index * 13 + 9) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let out1Seed = Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) })

        let result = try FirstPairSourceSlice.builder6473d0OutputsFromBundledContext(
            in0: in0,
            in1: in1,
            in2: in2,
            out0Preimage: out0Seed,
            out1Preimage: out1Seed
        )
        let preimages = Builder6473d0OutputPreimages(
            out4: result.out4,
            out3: result.out3,
            out2: result.out2,
            out1: result.out1,
            out0: result.out0
        )

        let stack = try FirstPairSourceSlice.builder6473d0MinimalStack20FromPreimages(preimages)
        XCTAssertEqual(stack.count, 0xc00)
        XCTAssertEqual(
            Data(SHA256.hash(data: stack)).hex,
            "ee8cadccc44f822947d1cc8acc0b48081211016c8c8d20076751ac592d2a3640"
        )

        let stackChunks: [(String, Int, String, String, String)] = [
            (
                "out4",
                0x000,
                "3d1a32df33f5ce078ed6cfa67972c041d5aff9606ff86c381b5d257fa4bb3517",
                "ef7d09f934d4eb5e",
                "fc9ab4e34537c920"
            ),
            (
                "out3",
                0x058,
                "d1486d791a35e129933d31bab4e814a0cdcd3db8c3b4895950882cba18791c90",
                "22b8d195c99bd38f",
                "d7d6048d727efcdb"
            ),
            (
                "out2",
                0x0b0,
                "c5e3ec0675df26d11bd8390e34135652ad6b530fb8e003151b44cf1dfce6e169",
                "e9be8cecc1fb8a0d",
                "e0a9fd4dacfaa894"
            ),
            (
                "out1",
                0x210,
                "c49ad60aa507e639c71430a12067b0eb5d75737460bd9997b020b5760197ceb8",
                "0b1c2d3e4f607182",
                "5b6c7d8e9fb0c1d2"
            ),
            (
                "out0",
                0x268,
                "76cebb860262dd83aa186fc63ea614b3af5633e56600dda4d4da79ba840366bd",
                "05121f2c39465360",
                "15222f3c49566370"
            ),
        ]
        for chunk in stackChunks {
            let window = Data(stack[chunk.1..<(chunk.1 + 88)])
            XCTAssertEqual(Data(SHA256.hash(data: window)).hex, chunk.2, chunk.0)
            XCTAssertEqual(Data(window.prefix(8)).hex, chunk.3, chunk.0)
            XCTAssertEqual(Data(window.suffix(8)).hex, chunk.4, chunk.0)
        }

        let postVectors = FirstPairSourceSlice.builder6473d0PostVectors(result)
        XCTAssertEqual(postVectors.count, 8)
        let expectedPostVectors: [(Int, String)] = [
            (0x3708, "3d1a32df33f5ce078ed6cfa67972c041d5aff9606ff86c381b5d257fa4bb3517"),
            (0x3760, "d1486d791a35e129933d31bab4e814a0cdcd3db8c3b4895950882cba18791c90"),
            (0x37b8, "c5e3ec0675df26d11bd8390e34135652ad6b530fb8e003151b44cf1dfce6e169"),
            (0x3810, "8eb586c217d306dbde11f9301ab67d009e8dba5414bcebe90944e8542082edee"),
            (0x3868, "a4a1bb98f66e3d53a51c810379507e4a1f856bf51be0d007e10d5b3afc90252b"),
            (0x38c0, "9692c8145a24dcadc1fd23963c583512c8aebf55dc7c68ad677cb8f53f2117ea"),
            (0x3918, "c49ad60aa507e639c71430a12067b0eb5d75737460bd9997b020b5760197ceb8"),
            (0x3970, "76cebb860262dd83aa186fc63ea614b3af5633e56600dda4d4da79ba840366bd"),
        ]
        for (offset, expectedHash) in expectedPostVectors {
            let actual = try XCTUnwrap(postVectors[offset], "missing post vector at \(String(offset, radix: 16))")
            XCTAssertEqual(actual.count, 88)
            XCTAssertEqual(Data(SHA256.hash(data: actual)).hex, expectedHash, String(offset, radix: 16))
        }
    }

    func testBuilder6388f0First64cd40CallStateMatchesPythonReferenceVectors() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let in0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let in1 = Data((0..<88).map { index in UInt8((index * 13 + 9) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let out1Seed = Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) })
        let context = try FirstPairSourceSlice.builder6388f0CallerContextFromBundle()
        let result = try FirstPairSourceSlice.builder6473d0Outputs(
            in0: in0,
            in1: in1,
            in2: in2,
            contextSource: context,
            out0Preimage: out0Seed,
            out1Preimage: out1Seed
        )
        let preimages = Builder6473d0OutputPreimages(
            out4: result.out4,
            out3: result.out3,
            out2: result.out2,
            out1: result.out1,
            out0: result.out0
        )
        let stack20 = try FirstPairSourceSlice.builder6473d0MinimalStack20FromPreimages(preimages)
        let postVectors = FirstPairSourceSlice.builder6473d0PostVectors(result)

        let expectedRows: [(Int, String, String, String, String, String, String, String, String, String)] = [
            (
                0,
                "9b74a2232218a70449b125c5b25a1be077125ce8b113783a46454ed02d816021",
                "9b8cd70e7c008f70",
                "adfaa15b83fb7c0a",
                "e9a7694cd9ab4b0bae1d8434ff29d370977c0828549628487f9a1395e4469f8e",
                "22604f4f42c846ff",
                "0000000000000000",
                "a87ab02c52a3f0e4d24c373618e06f5ed46879e1cfd78bad86063abb421dbbc4",
                "a29c55c2cd095992",
                "21f8df859b8bfaae"
            ),
            (
                17,
                "80e40a3e574da19ee4e2698456b25369913b97fa6b5a8c5692dc57e96cef45cb",
                "15c9a7f3b301eb2e",
                "adfaa15b83fb7c0a",
                "4d9957cb000e2390f1f3351a15f22f85d4dde632936f68fc4e91ecafbdf3476e",
                "22604f4f42c846ff",
                "0000000000000000",
                "8970960806c647297af6a2c2e803fc62cb1a188b546b1234c35b507b3854788c",
                "f17f9f4f39b1673b",
                "21f8df859b8bfaae"
            ),
            (
                58,
                "433d81b9f713d296a31dbd232f7456b5545ca0f89640d5c98f257737207dad79",
                "c18fefc075d749c5",
                "adfaa15b83fb7c0a",
                "ec7eb53f85b5c2ae678ede450ae0d2ab16d1c8b6cdd35de4c6d8db90aefc3a70",
                "22604f4f42c846ff",
                "0000000000000000",
                "fe323876b4ec44df84474ba3d699aa824c9417b8363ab776f23c0c0def8e6359",
                "dfd4e82cac137e2b",
                "21f8df859b8bfaae"
            ),
        ]

        for row in expectedRows {
            let state = try FirstPairSourceSlice.builder6388f0First64cd40CallState(
                contextSource: context,
                callerStack20: stack20,
                postVectors: postVectors,
                entryIndex: row.0
            )
            let call = try FirstPairSourceSlice.builder6388f0Call64Call(state)

            XCTAssertEqual(call.scalar, 0x68404ef676a9b7d3, "entry \(row.0)")
            XCTAssertEqual(call.arg0.count, 88, "entry \(row.0)")
            XCTAssertEqual(
                Data(SHA256.hash(data: call.arg0)).hex,
                "496aa2bee379c421196b33f0e1ea8ff833a919340d09d4dd9c360e8322c9d362",
                "entry \(row.0)"
            )
            XCTAssertEqual(Data(call.arg0.prefix(8)).hex, "d6ce5d63de75b391", "entry \(row.0)")
            XCTAssertEqual(Data(call.arg0.suffix(8)).hex, "19ae4d0dc970204b", "entry \(row.0)")

            XCTAssertEqual(call.x2Workspace.count, 352, "entry \(row.0)")
            XCTAssertEqual(Data(SHA256.hash(data: call.x2Workspace)).hex, row.1, "entry \(row.0)")
            XCTAssertEqual(Data(call.x2Workspace.prefix(8)).hex, row.2, "entry \(row.0)")
            XCTAssertEqual(Data(call.x2Workspace.suffix(8)).hex, row.3, "entry \(row.0)")

            XCTAssertEqual(call.x3Preimage.count, 88, "entry \(row.0)")
            XCTAssertEqual(
                Data(SHA256.hash(data: call.x3Preimage)).hex,
                "10eef285deef7a4b7c82b22aa53589b7833df29de3814649c772bbd5c832f365",
                "entry \(row.0)"
            )

            XCTAssertEqual(call.stackWindow.count, 0xb50, "entry \(row.0)")
            XCTAssertEqual(Data(SHA256.hash(data: call.stackWindow)).hex, row.4, "entry \(row.0)")
            XCTAssertEqual(Data(call.stackWindow.prefix(8)).hex, row.5, "entry \(row.0)")
            XCTAssertEqual(Data(call.stackWindow.suffix(8)).hex, row.6, "entry \(row.0)")

            XCTAssertEqual(call.output.count, 88, "entry \(row.0)")
            XCTAssertEqual(Data(SHA256.hash(data: call.output)).hex, row.7, "entry \(row.0)")
            XCTAssertEqual(Data(call.output.prefix(8)).hex, row.8, "entry \(row.0)")
            XCTAssertEqual(Data(call.output.suffix(8)).hex, row.9, "entry \(row.0)")
        }
    }

    func testBuilder6388f0Second64cd40CallStateMatchesPythonReferenceVectors() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let in0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let in1 = Data((0..<88).map { index in UInt8((index * 13 + 9) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let out1Seed = Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) })
        let context = try FirstPairSourceSlice.builder6388f0CallerContextFromBundle()
        let result = try FirstPairSourceSlice.builder6473d0Outputs(
            in0: in0,
            in1: in1,
            in2: in2,
            contextSource: context,
            out0Preimage: out0Seed,
            out1Preimage: out1Seed
        )
        let preimages = Builder6473d0OutputPreimages(
            out4: result.out4,
            out3: result.out3,
            out2: result.out2,
            out1: result.out1,
            out0: result.out0
        )
        let stack20 = try FirstPairSourceSlice.builder6473d0MinimalStack20FromPreimages(preimages)
        let postVectors = FirstPairSourceSlice.builder6473d0PostVectors(result)

        let expectedRows: [(Int, String, String, String, String, String, String, String, String, String)] = [
            (
                0,
                "fdf23daa0954614bc792d8a4dfa7bdb95f110bb155ee30e63a3079c2c636d4db",
                "88d330fdf438d13f",
                "adfaa15b83fb7c0a",
                "3a3bd479b489dae29e94ac6fe23fb61edf0444b8489d330b0f86a30530cdc2de",
                "22604f4f42c846ff",
                "0000000000000000",
                "a88449fc45dda85642e0fb0945bdb49cc80f61fb70f2a2973239c4dc66234551",
                "543d01d17c9b3d9d",
                "21f8df859b8bfaae"
            ),
            (
                17,
                "674d446fa8d4488a5733b4abdea474ae081c4bd0066feff1870a3207d06e935e",
                "a95d0d81704cb873",
                "adfaa15b83fb7c0a",
                "889cd7b12cfc4a4dd772e404acdedc3bf64ea0b7f75e38c179381bfa60e47793",
                "22604f4f42c846ff",
                "0000000000000000",
                "25556b8bcbaede26866b77bd708a51231b62ba928254d3ebc71e8034c580337f",
                "47d5daecac25c281",
                "21f8df859b8bfaae"
            ),
            (
                58,
                "3bccb00b36a989df5282f89f0d9cad1874be43fc7ade4b7f14c64d16f80696e2",
                "77572d1aa71cdc21",
                "adfaa15b83fb7c0a",
                "fce4abbb0537b096ee71bcd98efb5f056fead875cf1fd53762d5608671e69580",
                "22604f4f42c846ff",
                "0000000000000000",
                "ccdf21b6f656f68f98024e8c8e049460de41630149212b23b38aeec2e6a30235",
                "02802ed57a5241ee",
                "21f8df859b8bfaae"
            ),
        ]

        for row in expectedRows {
            let firstState = try FirstPairSourceSlice.builder6388f0First64cd40CallState(
                contextSource: context,
                callerStack20: stack20,
                postVectors: postVectors,
                entryIndex: row.0
            )
            let firstCall = try FirstPairSourceSlice.builder6388f0Call64Call(firstState)
            let state = try FirstPairSourceSlice.builder6388f0Second64cd40CallState(
                contextSource: context,
                callerStack20: stack20,
                postVectors: postVectors,
                first64cd40Output: firstCall.output,
                entryIndex: row.0
            )
            let call = try FirstPairSourceSlice.builder6388f0Call64Call(state)

            XCTAssertEqual(call.scalar, 0x68404ef676a9b7d3, "entry \(row.0)")
            XCTAssertEqual(call.arg0.count, 88, "entry \(row.0)")
            XCTAssertEqual(
                Data(SHA256.hash(data: call.arg0)).hex,
                "496aa2bee379c421196b33f0e1ea8ff833a919340d09d4dd9c360e8322c9d362",
                "entry \(row.0)"
            )
            XCTAssertEqual(call.x2Workspace.count, 352, "entry \(row.0)")
            XCTAssertEqual(Data(SHA256.hash(data: call.x2Workspace)).hex, row.1, "entry \(row.0)")
            XCTAssertEqual(Data(call.x2Workspace.prefix(8)).hex, row.2, "entry \(row.0)")
            XCTAssertEqual(Data(call.x2Workspace.suffix(8)).hex, row.3, "entry \(row.0)")

            XCTAssertEqual(call.x3Preimage, firstCall.output, "entry \(row.0)")
            XCTAssertEqual(call.x3Preimage.count, 88, "entry \(row.0)")

            XCTAssertEqual(call.stackWindow.count, 0xb50, "entry \(row.0)")
            XCTAssertEqual(Data(SHA256.hash(data: call.stackWindow)).hex, row.4, "entry \(row.0)")
            XCTAssertEqual(Data(call.stackWindow.prefix(8)).hex, row.5, "entry \(row.0)")
            XCTAssertEqual(Data(call.stackWindow.suffix(8)).hex, row.6, "entry \(row.0)")

            XCTAssertEqual(call.output.count, 88, "entry \(row.0)")
            XCTAssertEqual(Data(SHA256.hash(data: call.output)).hex, row.7, "entry \(row.0)")
            XCTAssertEqual(Data(call.output.prefix(8)).hex, row.8, "entry \(row.0)")
            XCTAssertEqual(Data(call.output.suffix(8)).hex, row.9, "entry \(row.0)")
        }
    }

    func testBuilder6388f0Third64cd40CallStateMatchesPythonReferenceVectors() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let in0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let in1 = Data((0..<88).map { index in UInt8((index * 13 + 9) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let out1Seed = Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) })
        let context = try FirstPairSourceSlice.builder6388f0CallerContextFromBundle()
        let result = try FirstPairSourceSlice.builder6473d0Outputs(
            in0: in0,
            in1: in1,
            in2: in2,
            contextSource: context,
            out0Preimage: out0Seed,
            out1Preimage: out1Seed
        )
        let preimages = Builder6473d0OutputPreimages(
            out4: result.out4,
            out3: result.out3,
            out2: result.out2,
            out1: result.out1,
            out0: result.out0
        )
        let stack20 = try FirstPairSourceSlice.builder6473d0MinimalStack20FromPreimages(preimages)
        let postVectors = FirstPairSourceSlice.builder6473d0PostVectors(result)

        let expectedRows: [(Int, String, String, String, String, String, String, String, String, String)] = [
            (
                0,
                "27fe07cba0b4e7f62d5da4f07f91f5d1887d8f2038431d7f5d14e6d6c38683eb",
                "cc1a18d569c77ddd",
                "adfaa15b83fb7c0a",
                "a9194cbdf9a9f7e76911b05d2641ecddcb6a76e1721f0f1c37cac228a7b7995e",
                "22604f4f42c846ff",
                "0000000000000000",
                "a1c8d6d83a91ce22e8025eb97c641fa5396cdb629e7105d3b646767e1c2d6a29",
                "13e228e615652c1f",
                "21f8df859b8bfaae"
            ),
            (
                17,
                "611f5018d6ecd757ec6298405c6da354f4c757fa882244c1dc8e05cf0adadf75",
                "11af0e262ddece94",
                "adfaa15b83fb7c0a",
                "c3d48c9a66812e39a6cffe630fdabaea3a4f449953f3a14fdb30b9222bc34524",
                "22604f4f42c846ff",
                "0000000000000000",
                "4e61a8e846d745236315e1d28fc341466130e735de858695281b7bd40b10f2e2",
                "49821358928f5609",
                "21f8df859b8bfaae"
            ),
            (
                58,
                "c2ca68df25da9dab6dc07a22501cb037543119fee471ffcf4a139e28240a498b",
                "d7661ccde60dfbe2",
                "adfaa15b83fb7c0a",
                "1a99dbd410c58bc5b0fea71ec0a21804bf5151de2b77ee22ca393cd8355531c2",
                "22604f4f42c846ff",
                "0000000000000000",
                "6348e4b69ed966be0a14615776c7ad56f938543f74f0fea19539ebdd7b3a1449",
                "0bfcade05c9c24dd",
                "21f8df859b8bfaae"
            ),
        ]

        for row in expectedRows {
            let firstState = try FirstPairSourceSlice.builder6388f0First64cd40CallState(
                contextSource: context,
                callerStack20: stack20,
                postVectors: postVectors,
                entryIndex: row.0
            )
            let firstCall = try FirstPairSourceSlice.builder6388f0Call64Call(firstState)
            let secondState = try FirstPairSourceSlice.builder6388f0Second64cd40CallState(
                contextSource: context,
                callerStack20: stack20,
                postVectors: postVectors,
                first64cd40Output: firstCall.output,
                entryIndex: row.0
            )
            let secondCall = try FirstPairSourceSlice.builder6388f0Call64Call(secondState)
            let state = try FirstPairSourceSlice.builder6388f0Third64cd40CallState(
                contextSource: context,
                callerStack20: stack20,
                postVectors: postVectors,
                second64cd40Output: secondCall.output,
                entryIndex: row.0
            )
            let call = try FirstPairSourceSlice.builder6388f0Call64Call(state)

            XCTAssertEqual(call.scalar, 0x68404ef676a9b7d3, "entry \(row.0)")
            XCTAssertEqual(call.arg0.count, 88, "entry \(row.0)")
            XCTAssertEqual(
                Data(SHA256.hash(data: call.arg0)).hex,
                "496aa2bee379c421196b33f0e1ea8ff833a919340d09d4dd9c360e8322c9d362",
                "entry \(row.0)"
            )
            XCTAssertEqual(call.x2Workspace.count, 352, "entry \(row.0)")
            XCTAssertEqual(Data(SHA256.hash(data: call.x2Workspace)).hex, row.1, "entry \(row.0)")
            XCTAssertEqual(Data(call.x2Workspace.prefix(8)).hex, row.2, "entry \(row.0)")
            XCTAssertEqual(Data(call.x2Workspace.suffix(8)).hex, row.3, "entry \(row.0)")

            XCTAssertEqual(call.x3Preimage, secondCall.output, "entry \(row.0)")
            XCTAssertEqual(call.x3Preimage.count, 88, "entry \(row.0)")

            XCTAssertEqual(call.stackWindow.count, 0xb50, "entry \(row.0)")
            XCTAssertEqual(Data(SHA256.hash(data: call.stackWindow)).hex, row.4, "entry \(row.0)")
            XCTAssertEqual(Data(call.stackWindow.prefix(8)).hex, row.5, "entry \(row.0)")
            XCTAssertEqual(Data(call.stackWindow.suffix(8)).hex, row.6, "entry \(row.0)")

            XCTAssertEqual(call.output.count, 88, "entry \(row.0)")
            XCTAssertEqual(Data(SHA256.hash(data: call.output)).hex, row.7, "entry \(row.0)")
            XCTAssertEqual(Data(call.output.prefix(8)).hex, row.8, "entry \(row.0)")
            XCTAssertEqual(Data(call.output.suffix(8)).hex, row.9, "entry \(row.0)")
        }
    }

    func testBuilder6388f0SeededCaller64RowMatchesPythonReferenceVectors() throws {
        let current = Builder6388f0Next642f60Inputs(
            x0: Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) }),
            x1: Data((0..<88).map { index in UInt8((index * 13 + 9) & 0xff) }),
            x2: Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        )
        let preimages = Builder6473d0OutputPreimages(
            out4: Data((0..<88).map { index in UInt8((index * 3 + 1) & 0xff) }),
            out3: Data((0..<88).map { index in UInt8((index * 5 + 2) & 0xff) }),
            out2: Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) }),
            out1: Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) }),
            out0: Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        )
        let context = try FirstPairSourceSlice.builder6388f0CallerContextFromBundle()

        let expectedRows: [(Int, String, String, String, String, String, String)] = [
            (
                0,
                "5d2fd9d65710079e70120c4b41d30ef96b43de537f0812f9c55bcde5d13da6ff",
                "a1738cb1be833dfc46837e95defc6b05ce0d477432c31ce23185931226fd54c2",
                "4d643ba15818807886f8ce5a4b5b3dfdd1eaeb0c1fa1aa217372ef3c41daee36",
                "16c108e1f0d3e9f6056c72f55125d51ecebe8499991f335f23e7cbbbb925af77",
                "815963ee2b9a9870282a384b356ef0593e1dafb8b8db3721803374854b2a5a7e",
                "c92bd26c7e87a582242cd62421ca05a6fd2820dead0b9fa14002882b331c0e79"
            ),
            (
                17,
                "02afcb4bc9530532a885d949bd994c13c953de5ea643dbf476a98a35a7133bfa",
                "2a13bd55dca210d9687243e8871f8e71a130da7ca0d0bd19d3fdc446dd3ff7eb",
                "760c499e675bb4a49c79f3c4ce2ffda348cf28a8238e950121f82ca6b79e6e3e",
                "08d621986111b3b183965665743855d3e3babc160708137f5f38c9ffe236675c",
                "645a5a07228ceb9f3da9396abcdc1b052b50ffe7196e746dfbe9d4b3fc4cae61",
                "1a9300451e9d8f4398354952d1dddfabbbd5123f77649e1b59746df4921096a4"
            ),
            (
                58,
                "843342ef8bf55e0707d422f4b7df49fe1955f7c2fd9093169d3ce09045ee8c76",
                "81f4b91efc1d50c84ff8d861a4f1cd2fe1aa4e70f7a289bc16570faac0f55e92",
                "3b13937db283e3408050fbb9b07c6b1445ea6d0799c5bbecbbe0cf4edff68730",
                "4cd9881f383c036b27aa7956269a5e7e40863b7849f112c7abae3f459a7143d2",
                "e8e0c80abbcc900e14eaf167711b0aac4b705109f47b0311ea941e3fcc41d32c",
                "011ae4ecb8fdee4ed0158a4e198f43df9aed402ddbc981695e22ff8dfc113059"
            ),
        ]

        for expected in expectedRows {
            let row = try FirstPairSourceSlice.builder6388f0SeededCaller64Row(
                index: expected.0,
                current642f60: current,
                preimages: preimages,
                contextSource: context
            )

            XCTAssertEqual(row.index, expected.0)
            XCTAssertEqual(row.current642f60, current)
            XCTAssertEqual(row.preimages, preimages)
            XCTAssertEqual(Data(SHA256.hash(data: row.after642f60.out0)).hex, "e4e4bc44d23db2b617f3d9a3f84a9dc1a6767d4d242a4c52b8427c587148a813")
            XCTAssertEqual(Data(SHA256.hash(data: row.after642f60.out1)).hex, "f6e027253992cc3f10bc117332271b9c97a5e6570be183b0808309bcc759bfd2")
            XCTAssertEqual(Data(SHA256.hash(data: row.after642f60.out2)).hex, "9c0ec2ac6f581933c3e457e0c4267507a575e1280caf5cbe09b962f265307e92")
            XCTAssertEqual(Data(SHA256.hash(data: row.after6473d0.out2)).hex, "0d5c73fceaada7a6b59cc13b20292c84f7ed53adb1761938dcc102b24df3b333")
            XCTAssertEqual(Data(SHA256.hash(data: row.after6473d0.out3)).hex, "7d7898d5e1c1655ad924fba7ba2ecfd10669e8215583328da2e3b5e579c6d1a2")
            XCTAssertEqual(Data(SHA256.hash(data: row.after6473d0.out4)).hex, "4f8334dadc445d8e94bb4478cc915f6b7ed5097d904b916608a7f96b291c8c1d")
            XCTAssertEqual(Data(SHA256.hash(data: row.minimalStack20)).hex, "2a768e7ee55607748ec665cd8f02d2afa8e7585fac8796918438dc443bde1df4")
            XCTAssertEqual(Data(SHA256.hash(data: row.first64cd40.output)).hex, expected.1, "entry \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.second64cd40.output)).hex, expected.2, "entry \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.third64cd40.output)).hex, expected.3, "entry \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.next642f60.x0)).hex, expected.4, "entry \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.next642f60.x1)).hex, expected.5, "entry \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.next642f60.x2)).hex, expected.6, "entry \(expected.0)")
        }
    }

    func testBuilder6388f0SeededCaller64RowsThroughRow59MatchPythonReferenceVectors() throws {
        let row0Out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let row0Out1Seed = Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) })
        let row59Out0Seed = Data((0..<88).map { index in UInt8((index * 19 + 7) & 0xff) })
        let row59Out1Seed = Data((0..<88).map { index in UInt8((index * 23 + 3) & 0xff) })
        let starts = try FirstPairSourceSlice.builder6388f0FirstPair642f60StreamStarts(
            row0Out0Seed: row0Out0Seed,
            row0Out1Seed: row0Out1Seed,
            row59Out0Seed: row59Out0Seed,
            row59Out1Seed: row59Out1Seed
        )
        let row0LowPreimages = Builder6473d0OutputPreimages(
            out4: Data((0..<88).map { index in UInt8((index * 3 + 1) & 0xff) }),
            out3: Data((0..<88).map { index in UInt8((index * 5 + 2) & 0xff) }),
            out2: Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) }),
            out1: row0Out1Seed,
            out0: row0Out0Seed
        )

        let rows = try FirstPairSourceSlice.builder6388f0SeededCaller64Rows(
            starts: starts,
            row0LowPreimages: row0LowPreimages,
            contextSource: FirstPairSourceSlice.builder6388f0CallerContextFromBundle(),
            limit: 60
        )
        XCTAssertEqual(rows.count, 60)

        let expectedRows: [(Int, String, String, String, String, String, String, String, String, String, String, String)] = [
            (
                0,
                "ff807599b1ce0b18fbafc1f5ef3b1af310536e6a355f84b6fe6e5e7e70cb5d07",
                "32c5c3611fb9ddd8920ced6bd80e2f7823679cbeee2de9f315a1f98e47ade845",
                "c49ad60aa507e639c71430a12067b0eb5d75737460bd9997b020b5760197ceb8",
                "76cebb860262dd83aa186fc63ea614b3af5633e56600dda4d4da79ba840366bd",
                "aa133ccd20f64550f79e24d95edb4bd3840ea41170fb073ccfa7ed2f0a5ec2a6",
                "0c4e075f7394388253e849f3d6640211b122a3b80d4ec2f0fd6215ed2e2fa2d9",
                "50f98bbf26612a10b73c619cc69c6762dc158314f8f92eb9d5d6361129d1fae6",
                "82c27ffaaccebe24cfc57998d8c2db525d9fe19c49bca454cf60e9b09be83457",
                "735de0e678900db387d508151c8fecb730ea63cfd0c032c074d1259e6e312982",
                "c7fee1e743d7292d4cbaf16608f95bfdbe17aaac23696d2a79dff247ef44f833",
                "6b3c31cad24792ed5bef2eed597201dcf6ec3f3a0914bdf5a6db1b3fae3b994a"
            ),
            (
                1,
                "735de0e678900db387d508151c8fecb730ea63cfd0c032c074d1259e6e312982",
                "aa133ccd20f64550f79e24d95edb4bd3840ea41170fb073ccfa7ed2f0a5ec2a6",
                "c49ad60aa507e639c71430a12067b0eb5d75737460bd9997b020b5760197ceb8",
                "76cebb860262dd83aa186fc63ea614b3af5633e56600dda4d4da79ba840366bd",
                "387aa890d590abea241e416b8445b86cfcc0a167dfc7b108d746e462070d677e",
                "b8336b40eeb0d42767f8ff51ef6a32045fa0c08edb97c957f251290b9620bfcf",
                "c558bc603fed9ec13aa0b2479ca91d9eb5e57f14aabf113cfc8771dbc6525324",
                "2d6815f226308263a2648eea425e228698171b3a5947f7e10a615cb472d694ff",
                "66e37479739d0ec8db1f675bbf6e89320057bb0dae89f52fdf0f0f72aa4d3f84",
                "bf69b44f03b7832f07b7ca5e3be463f2884c3a52756834101008fdc9e76d5e7c",
                "95334b88f87b86184812a0451dbbf2138087eaa12cc3748af820ab8645959c5e"
            ),
            (
                58,
                "0f8cf013564d57471ee687ff1259e4a475284ac082bda3c145d1b39ba10735ff",
                "f8397a23467f7b742df4ac4ad0ef5039a53da85e2c59ecfb9201bf33284bedb3",
                "c49ad60aa507e639c71430a12067b0eb5d75737460bd9997b020b5760197ceb8",
                "76cebb860262dd83aa186fc63ea614b3af5633e56600dda4d4da79ba840366bd",
                "c0a36f54bde4a40820313a1f342aafece509cf5688f1cc6db298966d2c3d0fca",
                "1ea5c372b85c3d5a6d7653ed5e4eb6d3675633ed78224c5b61995994cfc8860e",
                "3ecc46b9fe2761cebc879dd2449b713f0bfadfd62091540e71412c246ef094c5",
                "89751b3b26a68d55cfd1b35764b4f26cf8f708bc04303cabc54228e8b20aaab6",
                "4ea5999b0919caf0302f7a36d44c30f88f5f0ea65ad455d7c8ad87c4d5e3af1a",
                "17c85652013c611c936ffda604594177fdc765a9b180be98c5a0edcff665903b",
                "88a7fe81fc5d1f1b6d5b24290c54f843de57fb3339e423afdb8a0e2da0dfe934"
            ),
            (
                59,
                "a2105eb9e12ffa599c55ff1714223addc7fb0fcfa9fb7b6ed4bec1acbcf1c31c",
                "c0a36f54bde4a40820313a1f342aafece509cf5688f1cc6db298966d2c3d0fca",
                "378ca711504b9c45e43c6abb6bbcfc018c3f1eb73af7be15195da5c2498d985d",
                "297391c138bee4a4837718a9e29bc9f007a0fd05321b8a84c0d2281d0111f905",
                "d6f95c8bd7aa8b4bdadcd02c4564a79ffa05c47fbc9c9f742a568e898e62dacc",
                "fde9684c6e046abd640e0d23a7df62c944606b55dae31bf0abb273861c7cb8b5",
                "93f147f5441ccbe38cdb51420c5c9a581a3cc59437ab74f6c829ed38276c898e",
                "0243976e2069612ff32ef284e79dfc3b11383403d465954c6b7d5e30aa5988ac",
                "2df364928960728a222d1a524f62a1affac4a974f17d06728aba4d1f0ec9772e",
                "5bbcc6cfaa034ffcc8f11766af29399c0717143569892f2cd0283ca21fb64338",
                "8f8f1879368b68c69b226763814a7c4cff7ed661c93283b3bc1f3c13b66f0ee4"
            ),
        ]

        for expected in expectedRows {
            let row = rows[expected.0]
            XCTAssertEqual(row.index, expected.0)
            XCTAssertEqual(Data(SHA256.hash(data: row.current642f60.x0)).hex, expected.1, "row \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.preimages.out4)).hex, expected.2, "row \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.preimages.out1)).hex, expected.3, "row \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.preimages.out0)).hex, expected.4, "row \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.after6473d0.out4)).hex, expected.5, "row \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.first64cd40.output)).hex, expected.6, "row \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.second64cd40.output)).hex, expected.7, "row \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.third64cd40.output)).hex, expected.8, "row \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.next642f60.x0)).hex, expected.9, "row \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.next642f60.x1)).hex, expected.10, "row \(expected.0)")
            XCTAssertEqual(Data(SHA256.hash(data: row.next642f60.x2)).hex, expected.11, "row \(expected.0)")
        }
    }

    func testBuilder6388f0Seeded63c278SchedulesFromRowsMatchPythonReferenceVectors() throws {
        let row0Out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let row0Out1Seed = Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) })
        let row59Out0Seed = Data((0..<88).map { index in UInt8((index * 19 + 7) & 0xff) })
        let row59Out1Seed = Data((0..<88).map { index in UInt8((index * 23 + 3) & 0xff) })
        let starts = try FirstPairSourceSlice.builder6388f0FirstPair642f60StreamStarts(
            row0Out0Seed: row0Out0Seed,
            row0Out1Seed: row0Out1Seed,
            row59Out0Seed: row59Out0Seed,
            row59Out1Seed: row59Out1Seed
        )
        let row0LowPreimages = Builder6473d0OutputPreimages(
            out4: Data((0..<88).map { index in UInt8((index * 3 + 1) & 0xff) }),
            out3: Data((0..<88).map { index in UInt8((index * 5 + 2) & 0xff) }),
            out2: Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) }),
            out1: row0Out1Seed,
            out0: row0Out0Seed
        )
        let rows = try FirstPairSourceSlice.builder6388f0SeededCaller64Rows(
            starts: starts,
            row0LowPreimages: row0LowPreimages,
            contextSource: FirstPairSourceSlice.builder6388f0CallerContextFromBundle()
        )

        let schedules = try FirstPairSourceSlice.builder6388f0Seeded63c278SchedulesFromRows(rows: rows)
        XCTAssertEqual(rows.count, 118)
        XCTAssertEqual(schedules.first.rowIndex, 58)
        XCTAssertEqual(schedules.second.rowIndex, 117)
        XCTAssertEqual(schedules.first.scalar, FirstPairSourceSlice.pre63c278Scalar)
        XCTAssertEqual(schedules.second.scalar, FirstPairSourceSlice.pre63c278Scalar)
        XCTAssertEqual(
            Data(SHA256.hash(data: schedules.first.arg0)).hex,
            "1b0499442309d372cc3cd1fa5ea6d8640f3e14661456c368f50123bebc51b647"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: schedules.first.arg1)).hex,
            "4ea5999b0919caf0302f7a36d44c30f88f5f0ea65ad455d7c8ad87c4d5e3af1a"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: schedules.first.arg2)).hex,
            "88a7fe81fc5d1f1b6d5b24290c54f843de57fb3339e423afdb8a0e2da0dfe934"
        )
        XCTAssertEqual(
            schedules.first.scheduleWords,
            [
                0x42fa386c, 0xc627b657, 0xc8638fd3, 0xc97a2ab7, 0xd23eb4ac,
                0x3dc33146, 0xee7d479c, 0xb1f34d23, 0xee536419, 0xaffc9f1c,
                0x3b95a64c, 0xcce6d138, 0x70227a65, 0x87ca2121, 0xefb07a8f,
                0xc4749659, 0x1cd92603, 0xe0ab3767, 0x3b95a64c, 0xcce6d138,
            ]
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(schedules.first.scheduleWords))).hex,
            "b31620465a69c66dee3504561f60addaf2c74055d82ad778a1f13e52da4750d0"
        )

        XCTAssertEqual(
            Data(SHA256.hash(data: schedules.second.arg0)).hex,
            "1b0499442309d372cc3cd1fa5ea6d8640f3e14661456c368f50123bebc51b647"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: schedules.second.arg1)).hex,
            "88e31fd2bc2b9bfc0d710473797991beb5dcd9df6b2489550f2a0d33f6a65b17"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: schedules.second.arg2)).hex,
            "8c49a1d43b53e3d6c0f09bbb75dafb847c67f33e4031e2db45e7eadc9145840d"
        )
        XCTAssertEqual(
            schedules.second.scheduleWords,
            [
                0x91390f77, 0x6f5270d3, 0x6412ea8c, 0x4e288c3b, 0x352b86cf,
                0x693acdea, 0x28d9d7d2, 0x08306255, 0x8f45b76a, 0x056e96b3,
                0x3b95a64c, 0xcce6d138, 0x70227a65, 0x87ca2121, 0xefb07a8f,
                0xc4749659, 0x1cd92603, 0xe0ab3767, 0x3b95a64c, 0xcce6d138,
            ]
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(schedules.second.scheduleWords))).hex,
            "f5187d8a9042e39cbc2758abd244f0a7bc91bc63a624c743ee8b10bb7af64cf1"
        )

        let source = try FirstPairSourceSlice.deriveFrom6388f0SeededCaller64Rows(rows: rows)
        XCTAssertEqual(
            source.hex,
            "040400010402030107000002030007050505030706070204050000060303020307" +
            "020600070302040604000305030603020102020003010306050605060207060303"
        )
        let rawKey = try FirstPairSourceSlice.phase5RawKeyFrom6388f0SeededCaller64Rows(rows: rows)
        XCTAssertEqual(rawKey.hex, "515ca99cb8c0deaf1208df352078064d")
    }

    func testDeriveFrom6388f0FirstPairStreamSeedsMatchesPythonReferenceVectors() throws {
        let seeds = Builder6388f0FirstPairStreamSeeds(
            nullScalarWindow: Data((0..<70).map { index in UInt8((index * 29 + 1) & 0xff) }),
            staticScalarWindow: Data((0..<70).map { index in UInt8((index * 31 + 2) & 0xff) }),
            nullEntropy11A: Data((0..<0x11a).map { index in UInt8((index * 37 + 3) & 0xff) }),
            nullAttempts: 2,
            row0Out4: Data((0..<88).map { index in UInt8((index * 3 + 1) & 0xff) }),
            row0Out3: Data((0..<88).map { index in UInt8((index * 5 + 2) & 0xff) }),
            row0Out2: Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) }),
            row0Out1: Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) }),
            row0Out0: Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) }),
            row59Out1: Data((0..<88).map { index in UInt8((index * 23 + 3) & 0xff) }),
            row59Out0: Data((0..<88).map { index in UInt8((index * 19 + 7) & 0xff) })
        )

        let starts = try FirstPairSourceSlice.builder6388f0FirstPair642f60StreamStarts(seeds: seeds)
        XCTAssertEqual(
            Data(SHA256.hash(data: starts.row0.x0)).hex,
            "ff807599b1ce0b18fbafc1f5ef3b1af310536e6a355f84b6fe6e5e7e70cb5d07"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: starts.row59.x0)).hex,
            "a2105eb9e12ffa599c55ff1714223addc7fb0fcfa9fb7b6ed4bec1acbcf1c31c"
        )

        let source = try FirstPairSourceSlice.deriveFrom6388f0FirstPairStreamSeeds(seeds: seeds)
        XCTAssertEqual(
            source.hex,
            "040400010402030107000002030007050505030706070204050000060303020307" +
            "020600070302040604000305030603020102020003010306050605060207060303"
        )
        let rawKey = try FirstPairSourceSlice.phase5RawKeyFrom6388f0FirstPairStreamSeeds(seeds: seeds)
        XCTAssertEqual(rawKey.hex, "515ca99cb8c0deaf1208df352078064d")
    }

    func testBuilder64c524OutputWordsMatchPythonReferenceVector() throws {
        let arg0 = Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) })
        let scalar: UInt64 = 0x0123456789abcdef
        let workspaceBytes: [UInt8] = (0..<352).map { index in
            UInt8((index * 5 + 11) & 0xff)
        }
        let x2Workspace = Data(workspaceBytes)

        let arg0Words = try FirstPairSourceSlice.builder64c524Arg0U64Words(arg0: arg0)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(arg0Words))).hex,
            "b4c289307b76fd400a7ebb93cfd81f6df15931c9553af9a9c8bc1a9f047ca741"
        )
        XCTAssertEqual(
            Array(arg0Words.prefix(4)),
            [0x3ff86d27c281a51b, 0x82c9235432f698da, 0xf846c40785c0883c, 0x9f193ff19acdd538]
        )

        let updated = try FirstPairSourceSlice.builder64c524WorkspaceAfterUpdate(
            arg0U64Words: arg0Words,
            scalar: scalar,
            x2Workspace: x2Workspace
        )
        XCTAssertEqual(updated.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: updated)).hex,
            "0dce7bc80d9fd277b44333a61aa8e14a608c6205b63cee6b9ea498a4407533ee"
        )
        XCTAssertEqual(
            Data(updated.prefix(32)).hex,
            "af4609c269497b9cc32a915a34c3bbd1c87d116319769c5fab21064d51fe471b"
        )
        XCTAssertEqual(
            Data(updated.suffix(32)).hex,
            "88227680af94c55adff3deccb1f86d6c81b410c13274fcc1c3c8cdd2d7dce1e6"
        )

        let output = try FirstPairSourceSlice.builder64c524FinalU32Words(x2Workspace: updated)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output))).hex,
            "59eebec8dcac326baa8e1be4844f38155835ea1734a2985fd12249e77de2d6b3"
        )
        XCTAssertEqual(
            Array(output.prefix(4)),
            [0x2c9a5e95, 0x39ffcae7, 0xdb27a8fe, 0x35947d74]
        )
        XCTAssertEqual(
            Array(output.suffix(4)),
            [0x35c32db9, 0x322abd54, 0x38781571, 0xeb184e5f]
        )
        XCTAssertEqual(
            try FirstPairSourceSlice.builder64c524OutputWords(
                arg0: arg0,
                scalar: scalar,
                x2Workspace: x2Workspace
            ),
            output
        )
    }

    func testBuilder6473d0First64c524SliceMatchesPythonReferenceVector() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let arg0 = Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) })
        let scalar: UInt64 = 0x0123456789abcdef

        let streams = try FirstPairSourceSlice.builder6473d0FirstStreamsFromIn2(in2)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aWords))).hex,
            "b1f4dcc49a972799f58fb3a398591ad74882914c02ccbe7e3457bb85d15f9e2a"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bWords))).hex,
            "546485573a7fa23d64c96fb217f9196d379f766f199e80e02609e286e0c0d2ee"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aPrefix))).hex,
            "07ca498940d4fdd6ecaf9d82d38c47e974e51b0c1afad1db014de69f9bd0b560"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bPrefix))).hex,
            "6b2c5100098474366f5642502dabe909b52b3ea6217c32b4d5ab4d0e206a805c"
        )
        XCTAssertEqual(
            Array(streams.aWords.prefix(4)),
            [0x266614493d8fa940, 0x6007c6dd9fbb3cce, 0x4a0463a7929bbbdb, 0xe71ae9adfa4dffb7]
        )
        XCTAssertEqual(
            Array(streams.bWords.prefix(4)),
            [0x21609531c6f7bbc2, 0x3a01cb0167bc1884, 0x6d10d5fd47b5d72f, 0xb3988c7c118905f3]
        )

        let workspace = try FirstPairSourceSlice.builder6473d0First64c524Workspace(in2: in2)
        XCTAssertEqual(workspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: workspace)).hex,
            "5acfd8607b33aa61a6f38cc24ecc4555d321cd500d9e6b9ff684d36884a827ed"
        )
        XCTAssertEqual(
            Data(workspace.prefix(32)).hex,
            "8c8f9e0050dc253a33746dd5535a791918564522a208dfbd7939d24e6a8f7413"
        )
        XCTAssertEqual(
            Data(workspace.suffix(32)).hex,
            "9537b90ea920365d794473ef8e6ecc24fceb758e6044aa2151eb2ff475dc024d"
        )

        let output = try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: workspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output))).hex,
            "107a44c71f1c2072c3659db4f8df499dcd81173019370d11fa3e5bf73ca829cd"
        )
        XCTAssertEqual(Array(output.prefix(4)), [0x4b27dc37, 0xbdbbe5dc, 0xe19df049, 0xa7b9b740])
        XCTAssertEqual(Array(output.suffix(4)), [0xff7a3bdb, 0x56fb02ef, 0xf5984e81, 0x9ea400e1])

        let sp488 = try FirstPairSourceSlice.builder6473d0SP488WordsFrom64c524Output(packUInt32LE(output))
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp488))).hex,
            "04041ca272f4abc0c853f762e581febd27c7eb6aac3d480aa0d94d5efe605160"
        )
        XCTAssertEqual(Array(sp488.prefix(4)), [0xa51e755a, 0x4ce7e2cb, 0xb6a6acfa, 0xd6d1cdb6])
        XCTAssertEqual(Array(sp488.suffix(4)), [0xfa4d4fcc, 0xf93c4e87, 0xa7b82e47, 0x8a95e647])
    }

    func testBuilder6473d0Second64c524SliceMatchesPythonReferenceVector() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let arg0 = Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) })
        let scalar: UInt64 = 0x0123456789abcdef

        let firstWorkspace = try FirstPairSourceSlice.builder6473d0First64c524Workspace(in2: in2)
        let firstOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: firstWorkspace
        ))
        let sp488 = try FirstPairSourceSlice.builder6473d0SP488WordsFrom64c524Output(firstOutput)

        let streams = try FirstPairSourceSlice.builder6473d0SecondStreams(
            out0Seed: out0Seed,
            sp488Words: sp488
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aWords))).hex,
            "df9ea4f10d2698fde031d956c2143316bb63595e4db592193408cbec3997a792"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bWords))).hex,
            "35e95635019b19c3fc100148b2a078890400453759c7e0e8a45fa91855518d64"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aPrefix))).hex,
            "b9099f56f72378936c3e52698f85809aede89bf5ca0cdab1248cc9864b954403"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bPrefix))).hex,
            "c0acb1f9c3464f26c4eb07d3ec1f88aed7a3203c5220256ea342fa643f86907a"
        )
        XCTAssertEqual(
            Array(streams.aWords.prefix(4)),
            [0xf0e978b818b93c69, 0x75a018a3672cb577, 0xa4c98421009de949, 0x0684e334238a06ce]
        )
        XCTAssertEqual(
            Array(streams.bWords.prefix(4)),
            [0x9fca7b25b214721c, 0x9f76e8d6d38da8e4, 0x8f10bab198854e7f, 0x1b1e7339e8891893]
        )

        let workspace = try FirstPairSourceSlice.builder6473d0Second64c524Workspace(
            out0Seed: out0Seed,
            sp488Words: sp488
        )
        XCTAssertEqual(workspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: workspace)).hex,
            "cd1f9403619681b0c5d076306a3a56bff7ae16312a1aca44cc6e81aa7b685fed"
        )
        XCTAssertEqual(
            Data(workspace.prefix(32)).hex,
            "9fc6f0b5a5b45c108bae7302f9b19bd803d70a934a2fc7e122894534255008c3"
        )
        XCTAssertEqual(
            Data(workspace.suffix(32)).hex,
            "daf46992df1ed21b8b56ac397d611828f1716ca712847b7551eb2ff475dc024d"
        )

        let output = try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: workspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output))).hex,
            "33532e554e19a5b35f3d621d486f9b7716d29c0605198e4a6ac1d320038bc28d"
        )
        XCTAssertEqual(Array(output.prefix(4)), [0x2b7825c8, 0xc4c63905, 0x0211b018, 0x9c1118f8])
        XCTAssertEqual(Array(output.suffix(4)), [0x474ddcc0, 0xa689879c, 0xf11dde81, 0xac1cba94])
    }

    func testBuilder6473d0Third64c524SliceMatchesPythonReferenceVector() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let in0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let arg0 = Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) })
        let scalar: UInt64 = 0x0123456789abcdef

        let firstWorkspace = try FirstPairSourceSlice.builder6473d0First64c524Workspace(in2: in2)
        let firstOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: firstWorkspace
        ))
        let sp488 = try FirstPairSourceSlice.builder6473d0SP488WordsFrom64c524Output(firstOutput)
        let secondWorkspace = try FirstPairSourceSlice.builder6473d0Second64c524Workspace(
            out0Seed: out0Seed,
            sp488Words: sp488
        )
        let secondOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: secondWorkspace
        ))

        let source = try FirstPairSourceSlice.builder6473d0ThirdSourceWords(
            secondOutput: secondOutput,
            contextSource: FirstPairSourceSlice.builder6388f0SharedContextFromBundle(),
            in0: in0
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(source))).hex,
            "6e34220606e6f5401122a935081884080412601262e305b059fddbe077803051"
        )
        XCTAssertEqual(Array(source.prefix(4)), [0xf5b579d3, 0x9d2de314, 0x2241a5f4, 0x79d5b76f])
        XCTAssertEqual(Array(source.suffix(4)), [0xab6e381a, 0xe56c72d8, 0x2e241889, 0xf358dc37])

        let sp430 = try FirstPairSourceSlice.builder6473d0ThirdSP430Words(sourceWords: source)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp430))).hex,
            "08a18f8160f3efca8c1f5834fa918d904b749724799d71b3d4420491df15318d"
        )
        XCTAssertEqual(Array(sp430.prefix(4)), [0x113e3183, 0x7ec235c3, 0x55dcb210, 0xf48aa162])
        XCTAssertEqual(Array(sp430.suffix(4)), [0x7b0eec9c, 0xcdf26752, 0xca504858, 0x06f09076])

        let streams = try FirstPairSourceSlice.builder6473d0ThirdStreams(in2: in2, sp488Words: sp488)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aWords))).hex,
            "cdcd8b9cba1a6f86509bbcc4a95e3d88787cfef390803bad4bb1f50cbd55eddf"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bWords))).hex,
            "20e806f4dec45407ae529955b5ae41af7c5228c240dbed1fb916a74a85417c6e"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aPrefix))).hex,
            "a7ebd396d071b5f6457ce58bbd5111e98dd19a87bf847c7de7d7b4c61cfc3ad3"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bPrefix))).hex,
            "6626fad83edd6d479df4bdf0c5fbc728c94c4e83fcc3a32eddb68581955954f3"
        )
        XCTAssertEqual(
            Array(streams.aWords.prefix(4)),
            [0x9ec32fb9eb41c8b4, 0xeadea57a0d5f4f66, 0xf47a4e4eba3970b9, 0xc5338a3849d5495d]
        )
        XCTAssertEqual(
            Array(streams.bWords.prefix(4)),
            [0x12ff4184f57f0b10, 0x2bba1c1466693768, 0x31d61d1b90c42b39, 0xe7a4053ead3bfd75]
        )

        let workspace = try FirstPairSourceSlice.builder6473d0Third64c524Workspace(
            in2: in2,
            sp488Words: sp488
        )
        XCTAssertEqual(workspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: workspace)).hex,
            "fb42796391ab808c901953f0f4c3be19bbd4d49553f4df5c111d566766a1ceb6"
        )
        XCTAssertEqual(
            Data(workspace.prefix(32)).hex,
            "2c35faea21f269ffd52ef8ec5e1ea3b888891ca17d146b93cddedd013d7ad84c"
        )
        XCTAssertEqual(
            Data(workspace.suffix(32)).hex,
            "fe379f241197fec60883cc17e6f9b2c9133658a70c24c1a951eb2ff475dc024d"
        )

        let output = try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: workspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output))).hex,
            "bddbfeeece5007421a61931dd17aa25f9e70ac7141aa394880fabbec7357b655"
        )
        XCTAssertEqual(Array(output.prefix(4)), [0xbaf05b61, 0xbcfafe93, 0xfdfbf603, 0x32bd3651])
        XCTAssertEqual(Array(output.suffix(4)), [0xdd26ba56, 0x344e60a5, 0xe12df139, 0x64f97835])
    }

    func testBuilder6473d0Fourth64c524SliceMatchesPythonReferenceVector() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let out1Seed = Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) })
        let arg0 = Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) })
        let scalar: UInt64 = 0x0123456789abcdef

        let firstWorkspace = try FirstPairSourceSlice.builder6473d0First64c524Workspace(in2: in2)
        let firstOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: firstWorkspace
        ))
        let sp488 = try FirstPairSourceSlice.builder6473d0SP488WordsFrom64c524Output(firstOutput)
        _ = try FirstPairSourceSlice.builder6473d0Second64c524Workspace(
            out0Seed: out0Seed,
            sp488Words: sp488
        )
        let thirdWorkspace = try FirstPairSourceSlice.builder6473d0Third64c524Workspace(
            in2: in2,
            sp488Words: sp488
        )
        let thirdOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: thirdWorkspace
        ))

        let streams = try FirstPairSourceSlice.builder6473d0FourthStreams(
            out1Seed: out1Seed,
            thirdOutput: thirdOutput
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aWords))).hex,
            "7d6cc7ceb43b20b5f628756c842c5ac7be1fde886d9309ed4518ac9ae4bb287c"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bWords))).hex,
            "f5bc9070ebae188fb4864386433ac3eeda3e68ed9a9e471aa5c21ebb45ca573b"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aPrefix))).hex,
            "c7d8186bbd46e981d96b8bf8ebce2bae4735a83eaf70726093750c54a7a1d025"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bPrefix))).hex,
            "3d7ab324afb3cbbf6fe7dd05ffc55e81d344fb246f24231d4f33db46209452c8"
        )
        XCTAssertEqual(
            Array(streams.aWords.prefix(4)),
            [0xc718cd948cdbbe6c, 0x19ab42c3d336544e, 0x40aeaaac042cd268, 0xf3351ed19d2a2273]
        )
        XCTAssertEqual(
            Array(streams.bWords.prefix(4)),
            [0x0848a5b0e557414a, 0x8327a66a50524d8f, 0xcf6aaf3c6af10b71, 0xa598b68e0c681612]
        )

        let workspace = try FirstPairSourceSlice.builder6473d0Fourth64c524Workspace(
            out1Seed: out1Seed,
            thirdOutput: thirdOutput
        )
        XCTAssertEqual(workspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: workspace)).hex,
            "2805724203e148d53582172f661f1c76fac1cceb16baa58a2d36f584fde6ebd0"
        )
        XCTAssertEqual(
            Data(workspace.prefix(32)).hex,
            "910a780dd0d36d7aa3cf54cfb62cd2bd1d63e86f26c61fe15c2948c36ef5f2c4"
        )
        XCTAssertEqual(
            Data(workspace.suffix(32)).hex,
            "ee066461203fc21a55f5ee8cc35f022825c98846d169126651eb2ff475dc024d"
        )

        let output = try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: workspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output))).hex,
            "1be5186490600873daaffdaf8dc02f9b053d163a70b498b6dabee5c10b7dbf88"
        )
        XCTAssertEqual(Array(output.prefix(4)), [0x9163deaa, 0x817053d2, 0xad6f4dd2, 0x74570c4c])
        XCTAssertEqual(Array(output.suffix(4)), [0x60ba61fc, 0xca5e579f, 0xea186ea5, 0x758cad4a])
    }

    func testBuilder6473d0Fifth64c524SliceMatchesPythonReferenceVector() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let in0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let in1 = Data((0..<88).map { index in UInt8((index * 13 + 9) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let out1Seed = Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) })
        let arg0 = Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) })
        let scalar: UInt64 = 0x0123456789abcdef
        let context = try FirstPairSourceSlice.builder6388f0SharedContextFromBundle()

        let firstWorkspace = try FirstPairSourceSlice.builder6473d0First64c524Workspace(in2: in2)
        let firstOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: firstWorkspace
        ))
        let sp488 = try FirstPairSourceSlice.builder6473d0SP488WordsFrom64c524Output(firstOutput)
        let secondWorkspace = try FirstPairSourceSlice.builder6473d0Second64c524Workspace(
            out0Seed: out0Seed,
            sp488Words: sp488
        )
        let secondOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: secondWorkspace
        ))
        let thirdWorkspace = try FirstPairSourceSlice.builder6473d0Third64c524Workspace(
            in2: in2,
            sp488Words: sp488
        )
        let thirdOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: thirdWorkspace
        ))
        let thirdSource = try FirstPairSourceSlice.builder6473d0ThirdSourceWords(
            secondOutput: secondOutput,
            contextSource: context,
            in0: in0
        )
        let sp430 = try FirstPairSourceSlice.builder6473d0ThirdSP430Words(sourceWords: thirdSource)
        let fourthWorkspace = try FirstPairSourceSlice.builder6473d0Fourth64c524Workspace(
            out1Seed: out1Seed,
            thirdOutput: thirdOutput
        )
        let fourthOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: fourthWorkspace
        ))

        let source = try FirstPairSourceSlice.builder6473d0FifthSourceWords(
            fourthOutput: fourthOutput,
            contextSource: context,
            in1: in1
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(source))).hex,
            "45c409753e24cb9cf75d8d77f758eaed100f898588b6ed1159f790a3754ee721"
        )
        XCTAssertEqual(Array(source.prefix(4)), [0x038ec1c7, 0x7d124e33, 0x9326dce9, 0x7d8762df])
        XCTAssertEqual(Array(source.suffix(4)), [0x85cf25f9, 0x09b28e3d, 0xef2023e0, 0x3b53428d])

        let sp3d8 = try FirstPairSourceSlice.builder6473d0FifthSP3D8Words(sourceWords: source)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp3d8))).hex,
            "d655cd5c70f502d4fa869630aad63fa3640a51cae610093237b5d9a2e5c3fb52"
        )
        XCTAssertEqual(Array(sp3d8.prefix(4)), [0x2e3356bb, 0x050404a6, 0x85d8c536, 0xef821eaf])
        XCTAssertEqual(Array(sp3d8.suffix(4)), [0xd8ade60a, 0x603b94bb, 0xe4df7216, 0x39d4082c])

        let streams = try FirstPairSourceSlice.builder6473d0FifthStreams(sp430Words: sp430)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aWords))).hex,
            "df784feb1db29901a7c95bd7093566adc6e0bd687800292035222c6c8266f735"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bWords))).hex,
            "520a4f15468ed4cd614ee48c53dd7cc5c37f65f43d8d7eb1b43fdfe50674f3b3"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aPrefix))).hex,
            "ecfb510b8864783d07f75918ac018b14c18cacefdf787b4f4aa980545635256f"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bPrefix))).hex,
            "6df97c23d326cb47adfb8243934446f76499ad1ee3eb4efeedd9b0587ee1f232"
        )
        XCTAssertEqual(
            Array(streams.aWords.prefix(4)),
            [0xd8656d2421961388, 0xda62e987118e1762, 0x8c90d0b55f2257ac, 0xdad118e6d0f8f21e]
        )
        XCTAssertEqual(
            Array(streams.bWords.prefix(4)),
            [0x9c6325c164fa4842, 0x3273ec272266d840, 0xc4822fb10931880e, 0x8af8e29135df5a14]
        )

        let workspace = try FirstPairSourceSlice.builder6473d0Fifth64c524Workspace(sp430Words: sp430)
        XCTAssertEqual(workspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: workspace)).hex,
            "08b5f2127f4f9d38a87ed43cc9df67aa41ee69d2f8f59b28bb09cdb00ed7d475"
        )
        XCTAssertEqual(
            Data(workspace.prefix(32)).hex,
            "01b043c35a882aca61ea3fa3b362448c9df8b98203ec08e86131a8ae94572ae8"
        )
        XCTAssertEqual(
            Data(workspace.suffix(32)).hex,
            "416cbbf2fcd52b7c510c434a347cbb7081571771f3e92ebd51eb2ff475dc024d"
        )

        let output = try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: workspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output))).hex,
            "7b8aeba91679cc87e0038e22256590e68819f8ae38935c5428e89b1783d3f4cc"
        )
        XCTAssertEqual(Array(output.prefix(4)), [0x7b4d3ac1, 0x5f7925de, 0x2d36a812, 0x4b7e2c6b])
        XCTAssertEqual(Array(output.suffix(4)), [0x1c1eacbf, 0xce0b74f3, 0x40694fb5, 0xeee0898f])
    }

    func testBuilder6473d0Sixth64c524SliceMatchesPythonReferenceVector() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let in0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let arg0 = Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) })
        let scalar: UInt64 = 0x0123456789abcdef
        let context = try FirstPairSourceSlice.builder6388f0SharedContextFromBundle()

        let firstWorkspace = try FirstPairSourceSlice.builder6473d0First64c524Workspace(in2: in2)
        let firstOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: firstWorkspace
        ))
        let sp488 = try FirstPairSourceSlice.builder6473d0SP488WordsFrom64c524Output(firstOutput)
        let secondWorkspace = try FirstPairSourceSlice.builder6473d0Second64c524Workspace(
            out0Seed: out0Seed,
            sp488Words: sp488
        )
        let secondOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: secondWorkspace
        ))
        let thirdSource = try FirstPairSourceSlice.builder6473d0ThirdSourceWords(
            secondOutput: secondOutput,
            contextSource: context,
            in0: in0
        )
        let sp430 = try FirstPairSourceSlice.builder6473d0ThirdSP430Words(sourceWords: thirdSource)
        let fifthWorkspace = try FirstPairSourceSlice.builder6473d0Fifth64c524Workspace(sp430Words: sp430)
        let fifthOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: fifthWorkspace
        ))

        let sp380 = try FirstPairSourceSlice.builder6473d0SixthSP380Words(fifthOutput: fifthOutput)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp380))).hex,
            "9504a74f2e28965005e5404ec5efe753f7422bcb693e58f4a5a6a7c18c0ad9b0"
        )
        XCTAssertEqual(Array(sp380.prefix(4)), [0x90f87c6e, 0x3895b89c, 0x930c4ee5, 0x982ce414])
        XCTAssertEqual(Array(sp380.suffix(4)), [0x212cdf90, 0xf3a5675c, 0xa476bcfc, 0xb2c330ba])

        let streams = try FirstPairSourceSlice.builder6473d0SixthStreams(
            sp430Words: sp430,
            sp380Words: sp380
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aWords))).hex,
            "2887bd4468fadc7e22e31f0fb9217bed4d97fe0244489fdf7f68d8bb9be25cbe"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bWords))).hex,
            "0935766dcd7efadb89b9ee300f6515d6919f7ca13efbef3d94b4c4338f44c0a9"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aPrefix))).hex,
            "a4c2f18f60e79acd4a34eeea084ed1f01cf4e3fc323f3805ee2deaf919331b3d"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bPrefix))).hex,
            "31ffa478e2e0ebbf1099622b29d76f4a1b9a8c3d9b91f87311818169d3bfb0c2"
        )
        XCTAssertEqual(
            Array(streams.aWords.prefix(4)),
            [0xe1348b33a7f370a5, 0x72acdb6c47b5dbd1, 0xcd420f20def32441, 0x1f16b89f702955ef]
        )
        XCTAssertEqual(
            Array(streams.bWords.prefix(4)),
            [0xc8956057eff4378e, 0xd3717a55b09625a0, 0x13542bc82050c562, 0x918fcdcd225d692c]
        )

        let workspace = try FirstPairSourceSlice.builder6473d0Sixth64c524Workspace(
            sp430Words: sp430,
            sp380Words: sp380
        )
        XCTAssertEqual(workspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: workspace)).hex,
            "4c4b1b102a9fa301c2ba8541851a2c324d6064c6ca38d695888dd660bd77ef6a"
        )
        XCTAssertEqual(
            Data(workspace.prefix(32)).hex,
            "65953c135dd69e4313e0ec23d690d764b3156da680db69c345161f884e4177e3"
        )
        XCTAssertEqual(
            Data(workspace.suffix(32)).hex,
            "5dd6d783f1600ea4f55d88064599a48d519049d01c5bcd8751eb2ff475dc024d"
        )

        let output = try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: workspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output))).hex,
            "2f5a21c7c184f09bdb00f9f11eb2d4292e2814306b2cf01cd97806dbb1f9c91b"
        )
        XCTAssertEqual(Array(output.prefix(4)), [0x7c89cb83, 0x90e88426, 0x4d2b1ea6, 0x017fc88c])
        XCTAssertEqual(Array(output.suffix(4)), [0x39f78b96, 0xae98d6c3, 0x9d47f134, 0xae88538b])
    }

    func testBuilder6473d0Seventh64c524SliceMatchesPythonReferenceVector() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let in0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let arg0 = Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) })
        let scalar: UInt64 = 0x0123456789abcdef
        let context = try FirstPairSourceSlice.builder6388f0SharedContextFromBundle()

        let firstWorkspace = try FirstPairSourceSlice.builder6473d0First64c524Workspace(in2: in2)
        let firstOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: firstWorkspace
        ))
        let sp488 = try FirstPairSourceSlice.builder6473d0SP488WordsFrom64c524Output(firstOutput)
        let secondWorkspace = try FirstPairSourceSlice.builder6473d0Second64c524Workspace(
            out0Seed: out0Seed,
            sp488Words: sp488
        )
        let secondOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: secondWorkspace
        ))
        let thirdSource = try FirstPairSourceSlice.builder6473d0ThirdSourceWords(
            secondOutput: secondOutput,
            contextSource: context,
            in0: in0
        )
        let sp430 = try FirstPairSourceSlice.builder6473d0ThirdSP430Words(sourceWords: thirdSource)
        let fifthWorkspace = try FirstPairSourceSlice.builder6473d0Fifth64c524Workspace(sp430Words: sp430)
        let fifthOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: fifthWorkspace
        ))
        let sp380 = try FirstPairSourceSlice.builder6473d0SixthSP380Words(fifthOutput: fifthOutput)
        let sixthWorkspace = try FirstPairSourceSlice.builder6473d0Sixth64c524Workspace(
            sp430Words: sp430,
            sp380Words: sp380
        )
        let sixthOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: sixthWorkspace
        ))

        let sp328 = try FirstPairSourceSlice.builder6473d0SeventhSP328Words(sixthOutput: sixthOutput)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp328))).hex,
            "82f7fa5ba1bfc8e84f566c3807ad6f87b5d574c792446ed797577ebb74eaf27a"
        )
        XCTAssertEqual(Array(sp328.prefix(4)), [0xc92f75a4, 0x843b24fe, 0xea821e69, 0x1fa6924f])
        XCTAssertEqual(Array(sp328.suffix(4)), [0x1a86ab99, 0x4a980308, 0x2dda072f, 0x84fba1df])

        let streams = try FirstPairSourceSlice.builder6473d0SeventhStreams(
            in0: in0,
            sp380Words: sp380
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aWords))).hex,
            "591cba75b0159e431614c436e10997c886d68a6d759a8d31be910eca22cf85e8"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bWords))).hex,
            "6b23d88bd5e0da2f00dfb68fdfba69ec6d94b5230348df4cb69d7adde0687c10"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aPrefix))).hex,
            "3c1a6ff0cfdf896e5edb0f455bb62ac7c504900176871e382f2e7c4f14d8a0bc"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bPrefix))).hex,
            "79ffe314f5ca539b42ab1ffa0e1247adf4ae14f09d5898478b3f3b931010b3d6"
        )
        XCTAssertEqual(
            Array(streams.aWords.prefix(4)),
            [0x124a61b90fed5e3a, 0x7c9ab6bc7f99fe0e, 0xc78f559a52db131e, 0x13b5c433fb943ac1]
        )
        XCTAssertEqual(
            Array(streams.bWords.prefix(4)),
            [0x586fe37826186e1d, 0x26c4451dd0d61491, 0x5ae38b9970a524a1, 0xe4a19cfee3a96103]
        )

        let workspace = try FirstPairSourceSlice.builder6473d0Seventh64c524Workspace(
            in0: in0,
            sp380Words: sp380
        )
        XCTAssertEqual(workspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: workspace)).hex,
            "2700fbf891008ce8edc1f11ba1557fd080d684b965dd65136260fbf2b0964878"
        )
        XCTAssertEqual(
            Data(workspace.prefix(32)).hex,
            "a7d5fa4acffa4b5b71873b9227d3fbb39bf0519294c52829de97e9cd730e84c2"
        )
        XCTAssertEqual(
            Data(workspace.suffix(32)).hex,
            "3da77073b43b4e286e33ecb22052330e918d36ca6f2384cf51eb2ff475dc024d"
        )

        let output = try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: workspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output))).hex,
            "0eccbe5cdbf85dff7a37c87d7e555481d1fd8bdae3b39088b6b6273af860a786"
        )
        XCTAssertEqual(Array(output.prefix(4)), [0x0083c378, 0x3b2d8fff, 0x1ae9f799, 0xf338f6eb])
        XCTAssertEqual(Array(output.suffix(4)), [0x808945ec, 0x1da59779, 0x2d0c9f18, 0x9b286f04])
    }

    func testBuilder6473d0Eighth64c524SliceMatchesPythonReferenceVector() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let in0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let in1 = Data((0..<88).map { index in UInt8((index * 13 + 9) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let out1Seed = Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) })
        let arg0 = Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) })
        let scalar: UInt64 = 0x0123456789abcdef
        let context = try FirstPairSourceSlice.builder6388f0SharedContextFromBundle()

        let firstWorkspace = try FirstPairSourceSlice.builder6473d0First64c524Workspace(in2: in2)
        let firstOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: firstWorkspace
        ))
        let sp488 = try FirstPairSourceSlice.builder6473d0SP488WordsFrom64c524Output(firstOutput)
        let secondWorkspace = try FirstPairSourceSlice.builder6473d0Second64c524Workspace(
            out0Seed: out0Seed,
            sp488Words: sp488
        )
        let secondOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: secondWorkspace
        ))
        let thirdWorkspace = try FirstPairSourceSlice.builder6473d0Third64c524Workspace(
            in2: in2,
            sp488Words: sp488
        )
        let thirdOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: thirdWorkspace
        ))
        let thirdSource = try FirstPairSourceSlice.builder6473d0ThirdSourceWords(
            secondOutput: secondOutput,
            contextSource: context,
            in0: in0
        )
        let sp430 = try FirstPairSourceSlice.builder6473d0ThirdSP430Words(sourceWords: thirdSource)
        let fourthWorkspace = try FirstPairSourceSlice.builder6473d0Fourth64c524Workspace(
            out1Seed: out1Seed,
            thirdOutput: thirdOutput
        )
        let fourthOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: fourthWorkspace
        ))
        let fifthSource = try FirstPairSourceSlice.builder6473d0FifthSourceWords(
            fourthOutput: fourthOutput,
            contextSource: context,
            in1: in1
        )
        let sp3d8 = try FirstPairSourceSlice.builder6473d0FifthSP3D8Words(sourceWords: fifthSource)
        let fifthWorkspace = try FirstPairSourceSlice.builder6473d0Fifth64c524Workspace(sp430Words: sp430)
        let fifthOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: fifthWorkspace
        ))
        let sp380 = try FirstPairSourceSlice.builder6473d0SixthSP380Words(fifthOutput: fifthOutput)
        let seventhWorkspace = try FirstPairSourceSlice.builder6473d0Seventh64c524Workspace(
            in0: in0,
            sp380Words: sp380
        )
        let seventhOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: seventhWorkspace
        ))

        let sp2d0 = try FirstPairSourceSlice.builder6473d0EighthSP2D0Words(seventhOutput: seventhOutput)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp2d0))).hex,
            "56cbeb55b6aa494a61207e0fca41d0265e917f6002b1ba2b8ece63458b76b085"
        )
        XCTAssertEqual(Array(sp2d0.prefix(4)), [0xc96913d6, 0x99773534, 0x7817f9b9, 0x56bb5785])
        XCTAssertEqual(Array(sp2d0.suffix(4)), [0x912f288c, 0x8432d14f, 0x4a8c6c61, 0x7c00265d])

        let streams = try FirstPairSourceSlice.builder6473d0EighthStreams(sp3d8Words: sp3d8)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aWords))).hex,
            "183f2be6b622dc2eb373fa393d1683d6dad201749fa3e60f45f6d027a267bdd9"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bWords))).hex,
            "8b884e80ad5ed6bd11860fe89f504e27b2a92ec8007bda2a1a51bf08fd9bb9f3"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.aPrefix))).hex,
            "dcceda41820f364bf5f77e6c726942b5c6c4f60c558994e809659c233e17ce29"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(streams.bPrefix))).hex,
            "c7cf326fc28abf2692e8e36c18851db85b28e83b92d51c6c27fa8fd1820a8a99"
        )
        XCTAssertEqual(
            Array(streams.aWords.prefix(4)),
            [0xaec355f61f8f894d, 0xaf57fb0fb715ffaf, 0x6753b2a275722cad, 0x6947fb771dfc5b54]
        )
        XCTAssertEqual(
            Array(streams.bWords.prefix(4)),
            [0x6a6ed2db7d276cee, 0x7fddfe69097ed3f4, 0x7fc2a48944be010e, 0x241e62d2712f2593]
        )

        let workspace = try FirstPairSourceSlice.builder6473d0Eighth64c524Workspace(sp3d8Words: sp3d8)
        XCTAssertEqual(workspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: workspace)).hex,
            "be9f91423ea1b893b3e58a877eb02980b4b44bc8906e2cd19a8a6df6b3d941b3"
        )
        XCTAssertEqual(
            Data(workspace.prefix(32)).hex,
            "3deb21d360b851b9d15548db2281aed4a9aafb92a4b162f9b5e42cb228336459"
        )
        XCTAssertEqual(
            Data(workspace.suffix(32)).hex,
            "d0dc135d19aa1ea3557c6030ac3bef953d026a8e0d3a913f51eb2ff475dc024d"
        )

        let output = try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: workspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output))).hex,
            "cc933de7d8905c4cac18b91c959fea8e7c302bd9fa3573677fe59f251908255a"
        )
        XCTAssertEqual(Array(output.prefix(4)), [0xa8338b67, 0x48585485, 0xa7d8b3f7, 0x9b238737])
        XCTAssertEqual(Array(output.suffix(4)), [0x57541043, 0x528d8294, 0xb0149d05, 0xc47caee4])
    }

    func testBuilder6473d0NinthSourceReducersMatchPythonReferenceVector() throws {
        let in2 = Data((0..<88).map { index in UInt8((index * 21 + 7) & 0xff) })
        let in0 = Data((0..<88).map { index in UInt8((index * 15 + 2) & 0xff) })
        let in1 = Data((0..<88).map { index in UInt8((index * 13 + 9) & 0xff) })
        let out0Seed = Data((0..<88).map { index in UInt8((index * 13 + 5) & 0xff) })
        let out1Seed = Data((0..<88).map { index in UInt8((index * 17 + 11) & 0xff) })
        let arg0 = Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) })
        let scalar: UInt64 = 0x0123456789abcdef
        let context = try FirstPairSourceSlice.builder6388f0SharedContextFromBundle()

        let firstWorkspace = try FirstPairSourceSlice.builder6473d0First64c524Workspace(in2: in2)
        let firstOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: firstWorkspace
        ))
        let sp488 = try FirstPairSourceSlice.builder6473d0SP488WordsFrom64c524Output(firstOutput)
        let secondWorkspace = try FirstPairSourceSlice.builder6473d0Second64c524Workspace(
            out0Seed: out0Seed,
            sp488Words: sp488
        )
        let secondOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: secondWorkspace
        ))
        let thirdWorkspace = try FirstPairSourceSlice.builder6473d0Third64c524Workspace(
            in2: in2,
            sp488Words: sp488
        )
        let thirdOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: thirdWorkspace
        ))
        let thirdSource = try FirstPairSourceSlice.builder6473d0ThirdSourceWords(
            secondOutput: secondOutput,
            contextSource: context,
            in0: in0
        )
        let sp430 = try FirstPairSourceSlice.builder6473d0ThirdSP430Words(sourceWords: thirdSource)
        let fourthWorkspace = try FirstPairSourceSlice.builder6473d0Fourth64c524Workspace(
            out1Seed: out1Seed,
            thirdOutput: thirdOutput
        )
        let fourthOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: fourthWorkspace
        ))
        let fifthSource = try FirstPairSourceSlice.builder6473d0FifthSourceWords(
            fourthOutput: fourthOutput,
            contextSource: context,
            in1: in1
        )
        let sp3d8 = try FirstPairSourceSlice.builder6473d0FifthSP3D8Words(sourceWords: fifthSource)
        let fifthWorkspace = try FirstPairSourceSlice.builder6473d0Fifth64c524Workspace(sp430Words: sp430)
        let fifthOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: fifthWorkspace
        ))
        let sp380 = try FirstPairSourceSlice.builder6473d0SixthSP380Words(fifthOutput: fifthOutput)
        let sixthWorkspace = try FirstPairSourceSlice.builder6473d0Sixth64c524Workspace(
            sp430Words: sp430,
            sp380Words: sp380
        )
        let sixthOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: sixthWorkspace
        ))
        let sp328 = try FirstPairSourceSlice.builder6473d0SeventhSP328Words(sixthOutput: sixthOutput)
        let seventhWorkspace = try FirstPairSourceSlice.builder6473d0Seventh64c524Workspace(
            in0: in0,
            sp380Words: sp380
        )
        let seventhOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: seventhWorkspace
        ))
        let sp2d0 = try FirstPairSourceSlice.builder6473d0EighthSP2D0Words(seventhOutput: seventhOutput)
        let eighthWorkspace = try FirstPairSourceSlice.builder6473d0Eighth64c524Workspace(sp3d8Words: sp3d8)
        let eighthOutput = packUInt32LE(try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: eighthWorkspace
        ))

        let source1 = try FirstPairSourceSlice.builder6473d0NinthFirstSourceWords(
            eighthOutput: eighthOutput,
            contextSource: context,
            sp328Words: sp328,
            sp2d0Words: sp2d0
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(source1))).hex,
            "e18c8416b17464c4bae6ff625375d164dfec55af019420d2ca0116c3cc0ebed6"
        )
        XCTAssertEqual(Array(source1.prefix(4)), [0x955b96bf, 0xa2b58afd, 0xd700ff5a, 0x06a83167])
        XCTAssertEqual(Array(source1.suffix(4)), [0xd2d4d332, 0x351e47aa, 0x93b71ffe, 0x2c7ac25c])

        let out2 = try FirstPairSourceSlice.builder6473d0NinthOut2Words(sourceWords: source1)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(out2))).hex,
            "8368856aed45b1d49270602d6edba23e92809b2346290be6bc6a392f0aaf988d"
        )
        XCTAssertEqual(Array(out2.prefix(4)), [0x0d39094b, 0x077ba0c5, 0x54ba9e1d, 0x94e0f0df])
        XCTAssertEqual(Array(out2.suffix(4)), [0xaf6062a0, 0x87026000, 0x552ef927, 0x67a5cc22])

        let source2 = try FirstPairSourceSlice.builder6473d0NinthSecondSourceWords(
            sp2d0Words: sp2d0,
            contextSource: context,
            out2Words: out2
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(source2))).hex,
            "f8eb019cf9c0f4154874174ce8abf240b8e14a3ec59e411d84a550998a7a9d5c"
        )
        XCTAssertEqual(Array(source2.prefix(4)), [0x0aa6b2ba, 0x62d4fe90, 0x681904f8, 0xdf2014ff])
        XCTAssertEqual(Array(source2.suffix(4)), [0x231bce32, 0x3be767fb, 0x21037d7f, 0x2c868663])

        let sp278 = try FirstPairSourceSlice.builder6473d0NinthSP278Words(sourceWords: source2)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp278))).hex,
            "d572b9c1bb74f6bfc893a8cf8991fee8f10520a516289e4ba9c18db8eccd7750"
        )
        XCTAssertEqual(Array(sp278.prefix(4)), [0x9413cee2, 0x0460a288, 0x22d03034, 0xbd433cdf])
        XCTAssertEqual(Array(sp278.suffix(4)), [0xb3476dc3, 0x694125fd, 0x80373a26, 0x76a974a1])

        let ninthFirstStreams = try FirstPairSourceSlice.builder6473d0NinthFirstStreams(
            sp3d8Words: sp3d8,
            sp278Words: sp278
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(ninthFirstStreams.aWords))).hex,
            "b71bdd49fef5edf17f87cbed6f144013ad6570fb619d7259eecee78563d4321e"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(ninthFirstStreams.bWords))).hex,
            "95ceb0b250e78470133394a723b433a5bf8e3f7669cfb77be6dcaefcccac094d"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(ninthFirstStreams.aPrefix))).hex,
            "43db401e21867455f70a7da5b3688986851ff1c50922e2b4a764382a75ec7bd7"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(ninthFirstStreams.bPrefix))).hex,
            "e327fc0348a9eb211eec7c47eb4ad39feeabd01ad929c43990736a69c6961b40"
        )
        XCTAssertEqual(
            Array(ninthFirstStreams.aWords.prefix(4)),
            [0x545b0c404f636e24, 0xb5392a3d7628dcd6, 0x7ff978526fe2c884, 0xb99d48d053f750c3]
        )
        XCTAssertEqual(
            Array(ninthFirstStreams.bWords.prefix(4)),
            [0x098d91ac4188cdd0, 0xd599083ddc2ffcb2, 0x8982a5c60026fe6a, 0xaf9785833d9b9f3e]
        )

        let sp1c8 = try FirstPairSourceSlice.builder6473d0NinthSP1C8Words(
            aWords: ninthFirstStreams.aWords,
            bWords: ninthFirstStreams.bWords
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp1c8))).hex,
            "86cae00a8644b96d2f81fdcc84e5a861e6086d2e57635918c1aa0a285f01a839"
        )
        XCTAssertEqual(Array(sp1c8.prefix(4)), [0x1ca7a428, 0x2c776676, 0x334f6402, 0xf76aaada])
        XCTAssertEqual(Array(sp1c8.suffix(4)), [0x6ffb40fd, 0xcfc772cc, 0x84b24ddf, 0x72f88ab3])

        let ninthSecondStreams = try FirstPairSourceSlice.builder6473d0NinthSecondStreams(
            in1: in1,
            sp328Words: sp328
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(ninthSecondStreams.aWords))).hex,
            "e2610e9a2bb7e7431a9d50e0c52d546c4dbf46dbf3d806253e11af0b66db64e0"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(ninthSecondStreams.bWords))).hex,
            "5cb107493620008b697a14577e98aca3b0b99ecbc0d5eb11824683df14589d8f"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(ninthSecondStreams.aPrefix))).hex,
            "89e8408978c20c1bdfb852e7f784ce2693f894aa065649d7a01aeacfd55e8594"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(ninthSecondStreams.bPrefix))).hex,
            "43af916e53a4d9773e251fd1a3401b53ef0acb92af42e8f008c539d39c6ed808"
        )
        XCTAssertEqual(
            Array(ninthSecondStreams.aWords.prefix(4)),
            [0xfb7a80d9192d1ec3, 0x6e6d75ae9199026b, 0xa2b5cbeef35ac70a, 0x5de39a957ccb60ee]
        )
        XCTAssertEqual(
            Array(ninthSecondStreams.bWords.prefix(4)),
            [0x6634d7f4c2cf2b36, 0x3cf9a20168417e5c, 0x73d6e1fd6db42ec0, 0x9fb8812a0485cfe1]
        )

        let sp118 = try FirstPairSourceSlice.builder6473d0NinthSP118Words(
            aWords: ninthSecondStreams.aWords,
            bWords: ninthSecondStreams.bWords
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp118))).hex,
            "ded780efbdff94c54fe57299d3fa3542f688bd86e0fc0b6890bd0a135e686c4c"
        )
        XCTAssertEqual(Array(sp118.prefix(4)), [0x4a28ffde, 0x782ea9be, 0x71a8268f, 0xf40984a7])
        XCTAssertEqual(Array(sp118.suffix(4)), [0xea23c4c1, 0x34cb8794, 0x8c5f0b7e, 0x6fbb76ae])

        let source3 = try FirstPairSourceSlice.builder6473d0NinthThirdSourceWords(
            sp1c8Words: sp1c8,
            contextSource: context,
            sp118Words: sp118
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(source3))).hex,
            "551881a522a53344a1f14689741406abc30267914aa02e8d36bd722182015f11"
        )
        XCTAssertEqual(Array(source3.prefix(4)), [0x61ce1299, 0x99472497, 0xc507ee19, 0xb11859f9])
        XCTAssertEqual(Array(source3.suffix(4)), [0xad72c809, 0x26e0941c, 0xa45e51b4, 0x0394a1b2])

        let sp68 = try FirstPairSourceSlice.builder6473d0NinthSP68Words(sourceWords: source3)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(sp68))).hex,
            "b5b7d07e747d5a677fb6cf9182a96755196408c6487d1e4e77bb37364cd12a07"
        )
        XCTAssertEqual(Array(sp68.prefix(4)), [0xf69fa821, 0x6d436f56, 0x7165aa1f, 0x0a29d5a2])
        XCTAssertEqual(Array(sp68.suffix(4)), [0xcebd599c, 0xfa56cc6b, 0x26f17702, 0x1d4c6065])

        let ninthWorkspace = try FirstPairSourceSlice.builder6473d0Ninth64c524Workspace(sp68Words: sp68)
        XCTAssertEqual(ninthWorkspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: ninthWorkspace)).hex,
            "01fab44ba58a157c53f8035e82a33ad31e7d5f3090040841bd4041841e9a2b22"
        )
        XCTAssertEqual(
            Data(ninthWorkspace.prefix(32)).hex,
            "6bc3af8c573468f34171d1b016dea4b2ebc4e3cff360f7404bdeb7283373accf"
        )
        XCTAssertEqual(
            Data(ninthWorkspace.suffix(32)).hex,
            "18cde1b75184abdb2a95c21dea4ed777a2b23d7400c863cc78769979df2c176d"
        )

        let ninthOutput = try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: ninthWorkspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(ninthOutput))).hex,
            "d81b8468a5a7d4b17bf44f39b479476a8568bfd82aadc937b563221ed16604c7"
        )
        XCTAssertEqual(Array(ninthOutput.prefix(4)), [0xa6afa142, 0xadd6d28a, 0x52b1d3b4, 0xa8a41d1b])
        XCTAssertEqual(Array(ninthOutput.suffix(4)), [0x546fe16d, 0xfcd5ce72, 0xba890604, 0x5ef00136])

        let out3 = try FirstPairSourceSlice.builder6473d0TenthOut3Words(ninthOutput: packUInt32LE(ninthOutput))
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(out3))).hex,
            "8b4cdea006adbc427fc62ed7e593a7368be01c5433e4792558564f7d944edcd1"
        )
        XCTAssertEqual(Array(out3.prefix(4)), [0x02cfb61b, 0x83a302bf, 0x7dce5814, 0xa99120b6])
        XCTAssertEqual(Array(out3.suffix(4)), [0x1733e4c3, 0x509ea371, 0x2e866201, 0xdcad41e9])

        let tenthStreams = try FirstPairSourceSlice.builder6473d0TenthStreams(
            in2: in2,
            sp430Words: sp430
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(tenthStreams.aWords))).hex,
            "bdb411ed05059270ed4e6b090a287fefb9565b45f1c041d2a752d359c48a73c4"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(tenthStreams.bWords))).hex,
            "b208110ec78dc587a68c8f8684542ec44e1629968c474e2a573ec958bba72774"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(tenthStreams.aPrefix))).hex,
            "115333e8d18efc2935219ffc80e2686f551d909b52fdaf22e135c5b67cd24f3a"
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(tenthStreams.bPrefix))).hex,
            "0effdc504ddc2b26b284681c862826d56a3b7ca3f59dda63f6a6196913b7904b"
        )

        let tenthWorkspace = try FirstPairSourceSlice.builder6473d0Tenth64c524Workspace(
            in2: in2,
            sp430Words: sp430
        )
        XCTAssertEqual(tenthWorkspace.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: tenthWorkspace)).hex,
            "29506e31bf43027e2b607a86a6b4dd22f33d88454f491b93e8872a9171e6a9e2"
        )
        XCTAssertEqual(
            Data(tenthWorkspace.prefix(32)).hex,
            "dd5e1b73483adb7c6779b22e8a27aabb3763e5ce240fc28b13c06819287ab5a1"
        )
        XCTAssertEqual(
            Data(tenthWorkspace.suffix(32)).hex,
            "9330f51ba1248fb1a1b5f5113f6fbaf9d58bd27f24e9617451eb2ff475dc024d"
        )

        let tenthOutput = try FirstPairSourceSlice.builder64c524OutputWords(
            arg0: arg0,
            scalar: scalar,
            x2Workspace: tenthWorkspace
        )
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(tenthOutput))).hex,
            "a36706388c5ac543203e0cd3eb2af42d02f3242aec9d4c183cb4fba7a3d7bb0c"
        )
        XCTAssertEqual(Array(tenthOutput.prefix(4)), [0x8783fae8, 0x0ddad1eb, 0x8749248c, 0x4fe49618])
        XCTAssertEqual(Array(tenthOutput.suffix(4)), [0xb2d83004, 0x1d858880, 0x3da98491, 0x53b73a9b])

        let out4 = try FirstPairSourceSlice.builder6473d0FinalOut4Words(tenthOutput: packUInt32LE(tenthOutput))
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(out4))).hex,
            "401fe726d4a75d7c7e6d399aa2e00fea0d56a3d6c5b3dc1b328178ea24d7a442"
        )
        XCTAssertEqual(Array(out4.prefix(4)), [0xb434cfbd, 0x433f90df, 0xc1b14cc0, 0xcff6365f])
        XCTAssertEqual(Array(out4.suffix(4)), [0x9b1fe3f8, 0x4823bd87, 0xb576ca82, 0xf3f2e79c])
    }

    func testBuilder64cd40OutputWordsMatchPythonReferenceVector() throws {
        let arg0 = Data((0..<88).map { index in UInt8((index * 7 + 3) & 0xff) })
        let scalar: UInt64 = 0x0123456789abcdef
        let workspaceBytes: [UInt8] = (0..<352).map { index in
            UInt8((index * 5 + 11) & 0xff)
        }
        let x2Workspace = Data(workspaceBytes)

        let arg0Words = try FirstPairSourceSlice.builder64cd40Arg0U64Words(arg0: arg0)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt64LE(arg0Words))).hex,
            "a44f4e91a177dc3a5cb312ef4f9719cdc71ddecceaddc3ec4e2edf789628e5d1"
        )
        XCTAssertEqual(
            Array(arg0Words.prefix(4)),
            [0x10ddde967190d344, 0xebd463e50c8fe285, 0x1a0e6a0158814d23, 0x0e751bdbe34a0c27]
        )

        let updated = try FirstPairSourceSlice.builder64cd40WorkspaceAfterUpdate(
            arg0U64Words: arg0Words,
            scalar: scalar,
            x2Workspace: x2Workspace
        )
        XCTAssertEqual(updated.count, 44 * 8)
        XCTAssertEqual(
            Data(SHA256.hash(data: updated)).hex,
            "4f72ca5ec1a21eaefb25bc5e1952d71e22482eff8776ab4d7d7b097dd898f698"
        )
        XCTAssertEqual(
            Data(updated.prefix(32)).hex,
            "d7b094c172d1d6f663803ebc41632b3a20173805dd60fba63f6cdf91fc96abe6"
        )
        XCTAssertEqual(
            Data(updated.suffix(32)).hex,
            "428e3ebc4f8e7959b5f33857d937a682a920452868aad593c3c8cdd2d7dce1e6"
        )

        let output = try FirstPairSourceSlice.builder64cd40FinalU32Words(x2Workspace: updated)
        XCTAssertEqual(
            Data(SHA256.hash(data: packUInt32LE(output))).hex,
            "d9242621c538e422518e9e87083886228bb6f88827716cf209de9e42fb4a336d"
        )
        XCTAssertEqual(
            output,
            [
                0x00cec4df, 0x26e4cde3, 0xcaeeb424, 0xe561e5c9, 0xe47fcf9f,
                0x0946526d, 0xed187991, 0xb16fcb0d, 0x3165ae59, 0xedbc680c,
                0x5d8e3672, 0x6f6ecb46, 0x73c1ecad, 0xdb28c019, 0x4d2396d0,
                0xb9045673, 0x6e108816, 0x491e7a22, 0x6ca69691, 0xa935ba59,
                0x67d4d8c8, 0x511b912c,
            ]
        )
        XCTAssertEqual(
            try FirstPairSourceSlice.builder64cd40OutputWords(
                arg0: arg0,
                scalar: scalar,
                x2Workspace: x2Workspace
            ),
            output
        )
    }

    func testFinalize679f48ToSecondDF80MatchesPythonReferenceVectors() throws {
        let vectors: [(name: String, contextLength: UInt64, blockIndex: UInt32, finalLen: String, contextHash: String, source: String)] = [
            (
                "low4_idx2",
                132,
                2,
                "010602060707010605040204060404050206040406050406020404040402020402" +
                "020204040506060504020604060604040502040504020602040505050604050502",
                "0a47106ad8b1d372b9f821d1ed1c421c9a33ac9c6f91e350c8bd89e4d1497143",
                "040407050303060105040303000500050302040700030303070502040102030405" +
                "000604000506020200030003060500040200000306060700070205070206030600"
            ),
            (
                "low0_idx3",
                128,
                3,
                "010606060505040605040204060404050206040406050406020404040402020402" +
                "020204040506060504020604060604040502040504020602040505050604050506",
                "17967df31a85c7937a2c2c0da54297a4f45387ede33b3c8aa10d8f584443c20f",
                "040402060207050701070101000501060401010007010403050107000401060205" +
                "070107070404010306000003050006020503030402070706000100010206040004"
            ),
        ]

        for vector in vectors {
            let context = make679f48Context(contextLength: vector.contextLength, blockIndex: vector.blockIndex)
            let finalized = try FirstPairSourceSlice.finalize679f48ToSecondDF80(context: context)
            XCTAssertEqual(
                try FirstPairSourceSlice.final679f48LengthBlock(contextLength: Int(vector.contextLength)).hex,
                vector.finalLen,
                vector.name
            )
            XCTAssertEqual(Data(SHA256.hash(data: finalized)).hex, vector.contextHash, vector.name)
            let source = try FirstPairSourceSlice.deriveFrom679f48Context(
                context,
                offset: 0,
                length: 16
            )
            XCTAssertEqual(source.hex, vector.source, vector.name)
        }
    }

    func testFinalize679f48RejectsInvalidBlockIndex() {
        let context = make679f48Context(contextLength: 132, blockIndex: 5)
        XCTAssertThrowsError(
            try FirstPairSourceSlice.finalize679f48ToSecondDF80(context: context)
        ) { error in
            XCTAssertEqual(error as? FirstPairSourceSliceError, .invalid679f48BlockIndex(5))
        }
    }

    func testDF80TransformMatchesPythonReferenceVector() throws {
        let blockBytes: [UInt8] = (0..<(4 * 66)).map { index in
            UInt8((index * 5 + 3) & 7)
        }
        let stateBytes: [UInt8] = (0..<(8 * 18)).map { index in
            UInt8((index * 7 + 2) & 7)
        }
        let blocks = Data(blockBytes)
        let state = Data(stateBytes)
        let transformed = try FirstPairSourceSlice.df80Transform(state: state, blocks: blocks)

        XCTAssertEqual(transformed.count, 144)
        XCTAssertEqual(
            Data(SHA256.hash(data: transformed)).hex,
            "83d6b1d8af5c9ae3696aa44b9f62680633b0a996598b934781aa571ba0bbe58d"
        )
        XCTAssertEqual(
            Data(transformed.prefix(72)).hex,
            "060505060603010607050500030303010703040102050702030300020103040406" +
            "060304030403060005010706050001060203000404030301030000040706010105" +
            "000102030607"
        )
        XCTAssertEqual(
            Data(transformed.suffix(72)).hex,
            "040707050405010406070505010204020502060200000307060605040407020503" +
            "070404070704010106060002050303040503010604070007070402050504070703" +
            "040704070607"
        )

        let workspace = try FirstPairSourceSlice.df80InitialWorkspace(blocks: blocks)
        let schedule = try FirstPairSourceSlice.df80ExpandedSchedule(initialWorkspace: workspace)
        let compressed = try FirstPairSourceSlice.df80CompressState(state: state, schedule: schedule)
        XCTAssertEqual(compressed, transformed)
    }

    func testRejectsInvalidDF80CompressionInputs() {
        XCTAssertThrowsError(
            try FirstPairSourceSlice.df80CompressState(state: Data(count: 143), schedule: Data(count: 0x480))
        ) { error in
            XCTAssertEqual(error as? FirstPairSourceSliceError, .invalidDF80StateLength(143))
        }
        XCTAssertThrowsError(
            try FirstPairSourceSlice.df80CompressState(state: Data(count: 144), schedule: Data(count: 0x47f))
        ) { error in
            XCTAssertEqual(error as? FirstPairSourceSliceError, .invalidDF80ScheduleLength(0x47f))
        }
    }

    func testDF80ExpandedScheduleMatchesPythonReferenceVector() throws {
        let blockBytes: [UInt8] = (0..<(4 * 66)).map { index in
            UInt8((index * 5 + 3) & 7)
        }
        let workspace = try FirstPairSourceSlice.df80InitialWorkspace(blocks: Data(blockBytes))
        let schedule = try FirstPairSourceSlice.df80ExpandedSchedule(initialWorkspace: workspace)

        XCTAssertEqual(schedule.count, 0x480)
        XCTAssertEqual(
            Data(SHA256.hash(data: schedule)).hex,
            "19a0a495eb712175fc15dda37e6a5719940376609560f2ca26e3586abde2db77"
        )
        XCTAssertEqual(
            Data(schedule[0x120..<(0x120 + 72)]).hex,
            "020607070005060306030005020607060101020000050407040500050007030003" +
            "000706030505050407040304000200040402050302010205040206000104010503" +
            "050402060306"
        )
        XCTAssertEqual(
            Data(schedule.suffix(72)).hex,
            "030505060104000601010201060203060004070203010405040204000207040103" +
            "060500020604000107000107030305000001000005010004010706020701070400" +
            "050103070204"
        )
    }

    func testRejectsInvalidDF80ScheduleWorkspaceLength() {
        XCTAssertThrowsError(
            try FirstPairSourceSlice.df80ExpandedSchedule(initialWorkspace: Data(count: 287))
        ) { error in
            XCTAssertEqual(error as? FirstPairSourceSliceError, .invalidDF80WorkspaceLength(287))
        }
    }

    func testDF80InitialWorkspaceMatchesPythonReferenceVector() throws {
        let blockBytes: [UInt8] = (0..<(4 * 66)).map { index in
            UInt8((index * 5 + 3) & 7)
        }
        let expectedHex = [
            "020606050700020404010501070401010504060201020704010204010501060601",
            "010305020601020201030306000307070005050200040200040203020404020407",
            "030401070102020600020104040506050500010603040207060207040106030303",
            "050500020506040501020605070606040204030206040403040502060206060301",
            "070106000103000603050002020606040301060100020107060205070303060204",
            "060300050606000107050405070702020604060702060001070305060105070704",
            "000402050404060100040705010205010207020605010505000002070601050207",
            "060001060203000502070503040305020107060504020603000302000407030707",
            "010507060106030301040304000002060007020004030006",
        ].joined()
        let blocks = Data(blockBytes)
        let got = try FirstPairSourceSlice.df80InitialWorkspace(blocks: blocks)
        XCTAssertEqual(got.hex, expectedHex)
    }

    func testRejectsInvalidDF80InitialWorkspaceBlockLength() {
        XCTAssertThrowsError(
            try FirstPairSourceSlice.df80InitialWorkspace(blocks: Data(count: 263))
        ) { error in
            XCTAssertEqual(error as? FirstPairSourceSliceError, .invalidDF80BlockLength(263))
        }
    }

    func testFinal679f48LengthBlockMatchesPythonReferenceVectors() throws {
        let vectors: [(contextLength: Int, expectedHex: String)] = [
            (
                0,
                "010606060404040505040204060404050206040406050406020404040402020402" +
                "020204040506060504020604060604040502040504020602040505050604050506"
            ),
            (
                4,
                "010602060101040505040204060404050206040406050406020404040402020402" +
                "020204040506060504020604060604040502040504020602040505050604050502"
            ),
            (
                68,
                "010602060701070707010204060404050206040406050406020404040402020402" +
                "020204040506060504020604060604040502040504020602040505050604050502"
            ),
            (
                132,
                "010602060707010605040204060404050206040406050406020404040402020402" +
                "020204040506060504020604060604040502040504020602040505050604050502"
            ),
        ]

        for vector in vectors {
            let got = try FirstPairSourceSlice.final679f48LengthBlock(contextLength: vector.contextLength)
            XCTAssertEqual(got.hex, vector.expectedHex)
        }
    }

    func testDerive64de54SliceMatchesPythonReferenceVectors() throws {
        let encodedBytes: [UInt8] = (0..<(66 * 2)).map { index in
            UInt8((index * 3 + 1) & 7)
        }
        let encoded = Data(encodedBytes)
        let vectors: [(offset: Int, expectedHex: String)] = [
            (
                0,
                "040404000403000004010706050306060105010204060302010504030702000005" +
                "040100010000060707050301030202050401000403030601050100040200020405"
            ),
            (
                16,
                "040407000000070705020503020004070506070000030105040307060003070705" +
                "030702030207040100070200030105070205030003010407060403000307040103"
            ),
        ]

        for vector in vectors {
            let got = try FirstPairSourceSlice.derive64de54Slice(
                encodedBlocks: encoded,
                offset: vector.offset,
                length: 16
            )
            XCTAssertEqual(got.hex, vector.expectedHex)
        }
    }

    func testRejectsInvalidEncodedBlockLength() {
        XCTAssertThrowsError(
            try FirstPairSourceSlice.derive64de54Slice(encodedBlocks: Data(count: 65))
        ) { error in
            XCTAssertEqual(error as? FirstPairSourceSliceError, .invalidEncodedBlockLength(65))
        }
    }

    func testDeriveFrom67cc18SourcesMatchesPythonReferenceVectors() throws {
        let sourceBytes: [UInt8] = (0..<(66 * 2)).map { index in
            UInt8((index * 5 + 2) & 7)
        }
        let source = Data(sourceBytes)
        let vectors: [(offset: Int, expectedHex: String)] = [
            (
                0,
                "040400010204020403070505010102040500070506070505040300070500020600" +
                "000406070603060706070607020602010602010202010400040206060406000602"
            ),
            (
                16,
                "040404030306020107070006010600010003020602000507000601000701020004" +
                "000004010506000003060407010603030005020605010101070405020206020702"
            ),
        ]

        for vector in vectors {
            let got = try FirstPairSourceSlice.deriveFrom67cc18Sources(
                sourceChunks: source,
                offset: vector.offset,
                length: 16
            )
            XCTAssertEqual(got.hex, vector.expectedHex)
        }
    }

    func testPhase5RawKeyFrom67cc18SourcesMatchesPythonReferenceVectors() throws {
        let sourceBytes: [UInt8] = (0..<(66 * 2)).map { index in
            UInt8((index * 5 + 2) & 7)
        }
        let source = Data(sourceBytes)
        let vectors: [(offset: Int, expectedRawKey: String)] = [
            (0, "1fc9367dbfe4d23015419023b8ff18b6"),
            (16, "4b92eac60192ed83e6666a2810a936a6"),
        ]

        for vector in vectors {
            let got = try FirstPairSourceSlice.phase5RawKeyFrom67cc18Sources(
                sourceChunks: source,
                offset: vector.offset
            )
            XCTAssertEqual(got.hex, vector.expectedRawKey)
        }
    }

    func testDeriveFrom67a960InputsMatchesPythonReferenceVectors() throws {
        let src1 = Data((0..<130).map { index in UInt8((index * 3 + 4) & 7) })
        let src2 = Data((0..<130).map { index in UInt8((index * 5 + 1) & 7) })
        let vectors: [(offset: Int, expectedHex: String, expectedRawKey: String)] = [
            (
                0,
                "040400040302000203010504050606010602060206010706040604020201000605" +
                "060300050706070506050406030505060205040406070504060105050706010702",
                "1a36bec545101e734f469c930b565b59"
            ),
            (
                16,
                "040400000700070601050100070301030104070402060100060100050502030707" +
                "030004040000020104020600040306040607040304000206050404040402060606",
                "61efbe0d4f32b0c424a29ff609c73a18"
            ),
        ]

        for vector in vectors {
            let source = try FirstPairSourceSlice.deriveFrom67a960Inputs(
                src1: src1,
                src2: src2,
                offset: vector.offset,
                length: 16
            )
            XCTAssertEqual(source.hex, vector.expectedHex)
            let key = try FirstPairSourceSlice.phase5RawKeyFrom67a960Inputs(
                src1: src1,
                src2: src2,
                offset: vector.offset
            )
            XCTAssertEqual(key.hex, vector.expectedRawKey)
        }
    }

    func testDeriveFromFinalized679f48ContextMatchesPythonReferenceVectors() throws {
        let context = Data((0..<0x20c).map { index in UInt8((index * 7 + 3) & 7) })
        let vectors: [(offset: Int, expectedHex: String, expectedRawKey: String)] = [
            (
                0,
                "040405070607060600000304050601020107020701070601000201030506040705" +
                "060707060203060200050700050006050303040107020404040607010306000605",
                "1e6348e3a52751cbac7cc95200f39d9e"
            ),
            (
                16,
                "040405010207070104030605020701010403030404070701070005030507010101" +
                "070705070202030500000005010301060606010703040400070207020302020707",
                "b2f4925e0545eb07acd86a4c00beee05"
            ),
        ]

        for vector in vectors {
            let source = try FirstPairSourceSlice.deriveFromFinalized679f48Context(
                context,
                offset: vector.offset,
                length: 16
            )
            XCTAssertEqual(source.hex, vector.expectedHex)
            let key = try FirstPairSourceSlice.phase5RawKeyFromFinalized679f48Context(
                context,
                offset: vector.offset
            )
            XCTAssertEqual(key.hex, vector.expectedRawKey)
        }
    }

    func testProcess2P5PublicKeyMatchesAndroidEntryTraces() throws {
        let vectors: [(entropy: String, publicKey65: String)] = [
            (
                "8987c91f1595e8a060e4cba652368ae8797e9113cfd412bebd0ea1a03783ae59" +
                "ee70d2c947578803b06b275c96632d148b81658bb87a3eabb5755273c40c397" +
                "f7255f3c1d742df608383fbbfff5a9b9fbc11a1ab525382024c85687cf79c2" +
                "a391ca7cc309ff82fe098c2d86e49f8b26364153f0bcb8945c887f5a2a7b5" +
                "4d568daa373a86c85c283fbb6285f35dca2d30263c34ce182c1fc63e6022a" +
                "3c7e6eaebe3a473d3c754bb8f3982172431af66388948aaf5c709f6699b76" +
                "08dcd161811dda99c61b302f46684433e61ef2afa4dd9f8b0f2472f612019" +
                "7cdfc0b940ad5f93ac01fc7497fb355c753df9c65fc68721690c35a09550fb" +
                "3c326e38bcbe37ebb309a680c383967627f58a108e1e94ecd16c5d2bc2f57" +
                "6dabdc7b",
                "04b60e0f455a1f2ebc3a1246d9311a66722f80fbc0cbdc23d18ae5e50693eed2" +
                "b1ea74d24eddcc8dd1957cf621a1f5514fcd7b40ec37f18f8c8060db6f8076b121"
            ),
            (
                "726d47655b9434b44cd08664665dfb86934638911b6ebcc26420fe124ab654fd" +
                "e722e77f43756603943a8ee8196c6d5f83fc9cfe637e309f6f4b3c8fd5f10" +
                "9596f60b9e4899422925b8a0368b143580541bcaac3b4017b82f38d00c14d" +
                "46fbe3197ccfa9af048f6b446973c664901b84d362e95086e235e58517883" +
                "f7b89aef742768adc355131885657b686bdb6bd82feb11591b63f3e9466f0" +
                "e21f20cc58757ac547f57a21ee59b4816779510bd7d911861a116c40332328" +
                "cd4ec68579831e76ede1a5c6776c9d114a2788e8aed94b8f50a051da8cd8b" +
                "dbdf7c77f53ce76ee259d5d568a7b71edd3564f80969a4550a920238d1739" +
                "b34eceeb275c29f8dfb94796005ff15989a177536119388ed70c8fb6fa721" +
                "09635da2741",
                "049cb2d2658568e6685fea83f5051ff703baec07cbca3b10e58600d538b85795db" +
                "5cd35248bd30f1918627a6d4f2f91ce31d21057279fa790b895b15192d040a99"
            ),
        ]

        for vector in vectors {
            let entropy = dataFromHex(vector.entropy)
            let publicKey = try FirstPairSourceSlice.builderProcess2P5PublicKey65FromEntropy(entropy11A: entropy)
            XCTAssertEqual(publicKey.hex, vector.publicKey65)
        }
    }

    private func make679f48Context(contextLength: UInt64, blockIndex: UInt32) -> Data {
        var bytes: [UInt8] = (0..<0x20c).map { index in
            UInt8((index * 7 + 3) & 7)
        }
        for index in 0..<8 {
            bytes[index] = UInt8((contextLength >> UInt64(index * 8)) & 0xff)
        }
        for index in 0..<4 {
            bytes[0x110 + index] = UInt8((blockIndex >> UInt32(index * 8)) & 0xff)
        }
        return Data(bytes)
    }

    private func packUInt64LE(_ words: [UInt64]) -> Data {
        var out = Data()
        out.reserveCapacity(words.count * 8)
        for word in words {
            for shift in stride(from: 0, to: 64, by: 8) {
                out.append(UInt8((word >> UInt64(shift)) & 0xff))
            }
        }
        return out
    }

    private func packUInt32LE(_ words: [UInt32]) -> Data {
        var out = Data()
        out.reserveCapacity(words.count * 4)
        for word in words {
            for shift in stride(from: 0, to: 32, by: 8) {
                out.append(UInt8((word >> UInt32(shift)) & 0xff))
            }
        }
        return out
    }

    private func dataFromHex(_ hex: String) -> Data {
        var data = Data()
        data.reserveCapacity(hex.count / 2)
        var index = hex.startIndex
        while index < hex.endIndex {
            let next = hex.index(index, offsetBy: 2)
            if let byte = UInt8(hex[index..<next], radix: 16) {
                data.append(byte)
            }
            index = next
        }
        return data
    }
}
