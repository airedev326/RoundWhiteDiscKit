import XCTest
import CryptoKit
@testable import RoundWhiteDiscKit

final class SessionKeyTests: XCTestCase {
    override func setUpWithError() throws {
        try installRuntimeTablesForTests()
    }


    func testDeriveThrowsNotYetSpecified() {
        let inputs = SessionKeyInputs(
            sharedEphStatic: Data(repeating: 0xaa, count: 32),
            sharedEphEph:    Data(repeating: 0xbb, count: 32),
            k1:              Data(repeating: 0xcc, count: 16),
            k2:              Data(repeating: 0xdd, count: 16),
            extra:           Data()
        )
        XCTAssertThrowsError(try SessionKey.derive(inputs)) { err in
            guard case SessionKeyError.notYetSpecified = err else {
                XCTFail("expected notYetSpecified, got \(err)")
                return
            }
        }
    }

    func testInputsEquatable() {
        let i1 = SessionKeyInputs(
            sharedEphStatic: Data([0x01]), sharedEphEph: Data([0x02]),
            k1: Data([0x03]), k2: Data([0x04]), extra: Data([0x05])
        )
        let i2 = SessionKeyInputs(
            sharedEphStatic: Data([0x01]), sharedEphEph: Data([0x02]),
            k1: Data([0x03]), k2: Data([0x04]), extra: Data([0x05])
        )
        XCTAssertEqual(i1, i2)
    }

    func testBundledFirstPairEntrySourceMatchesPythonReference() {
        let source = FirstPairSourceSlice.bundled6388f0LowSeedEntrySource
        XCTAssertEqual(source.count, 0x214)
        XCTAssertEqual(
            Data(SHA256.hash(data: source)).hex,
            "263e4b14637a6779be45abeaf3b688cfe34df4614cb928cb3ee7d883acfa028a"
        )
    }

    func testFirstPairIndex1StaticScalarWindowMatchesHarnessTrace() {
        let scalar = FirstPairStaticScalarWindow.firstPairIndex1
        XCTAssertEqual(scalar.count, 70)
        XCTAssertEqual(
            Data(SHA256.hash(data: scalar)).hex,
            "32d3f057582e12b27701edf28f38b08018a252dacd19638f9c13b079d3952e7a"
        )
    }

    func testFirstPairPhase5SourceFromSensorPublicKeysMatchesPythonReferenceVector() throws {
        let entrySource = Data((0..<0x214).map { index in UInt8((index * 5 + 1) & 7) })
        let nullEntropy = Data((0..<0x11a).map { index in UInt8((index * 11 + 3) & 0xff) })
        let generatorPoint65 = dataFromHex(
            "04" +
            "6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296" +
            "4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5"
        )

        let inputs = FirstPairPhase5KeyInputs(
            entrySource: entrySource,
            nullEntropy11A: nullEntropy,
            sensorEphemeralPub65: generatorPoint65,
            sensorStaticPub65: generatorPoint65
        )
        let material = try SessionKey.deriveFirstPairPhase5Material(inputs)
        XCTAssertEqual(material.nullEntropy11A, nullEntropy)
        XCTAssertEqual(material.nullAttempts, 1)
        XCTAssertEqual(
            material.source66.hex,
            "04040706000606020005070707050402050701070106000602000707060002050402" +
            "0407050605040400060004020400000106060102060205030303040600040606"
        )

        let rawKey = try SessionKey.deriveFirstPairPhase5RawKey(inputs)
        XCTAssertEqual(rawKey, material.rawKey)
        XCTAssertEqual(material.rawKey, try Phase5KeySchedule.deriveRawKey(input66: material.source66))
    }

    func testFirstPairPhase5MaterialMatchesSingleRunEntropyTrace() throws {
        let entropy = dataFromHex(
            "0101050002040400000305000501050006020600020307070405030604020407" +
            "0507010501060703030103070701030606050003010703010404020603070501" +
            "0504020706020404060201000603070606050303070606010105070601030103" +
            "0502040401020201070503060100070002010406070306070105050404040300" +
            "0506060007070707060103060603000601010601000404000500010102000703" +
            "0306030705030107040406070401050003070700050104000001030106070002" +
            "0704020302020606000504060700070507040306070607020505040505010204" +
            "0702000606060507010400030101020500020400070201030400010502010604" +
            "0301060206020102000507020400000404050706010002050305"
        )
        let sensorEphemeral = dataFromHex(
            "04" +
            "e40ff95713629069c7be93644140a6d641435b84cb343adb3a208571b20b29a4" +
            "8322a60f864b12c1136cba8171ec68f0adce245a9f8be567d05c18bbe528b016"
        )
        let sensorStatic = dataFromHex(
            "04" +
            "3e1f46f25d44b3d72a8c37dcfebc7c339ed01fc5668a6387458084ac9cafebe" +
            "7438b649f76b81eeca9343287da162b07c5c07362997e40e13035df14cdf3d5d8"
        )

        let material = try SessionKey.deriveFirstPairPhase5Material(
            FirstPairPhase5KeyInputs(
                entrySource: FirstPairSourceSlice.bundled6388f0LowSeedEntrySource,
                nullEntropy11A: entropy,
                sensorEphemeralPub65: sensorEphemeral,
                sensorStaticPub65: sensorStatic
            )
        )

        XCTAssertEqual(material.nullAttempts, 1)
        XCTAssertEqual(material.nullEntropy11A, entropy)
        XCTAssertEqual(
            material.source66.hex,
            "040404070404070200010700040400070602030604040602030706060405020003" +
            "050701010602000206010207070005060307000202000300010003040004060203"
        )
        XCTAssertEqual(material.rawKey.hex, "3fad08acb65701a8552a31a003ab2556")
        XCTAssertEqual(
            Data(SHA256.hash(data: material.source66)).hex,
            "8ceeb7ddd894f8100cf50519140be9dc53f560014392aac96a808833b39339d9"
        )
    }

    func testFirstPairPhase5MaterialWithFirstPairIndex1ScalarMatchesFreshTraceCandidate() throws {
        // Fresh sensor 0RKHDKRA8, 2026-05-09. The live `03 03` run accepted
        // the phone cert but sent Phase 5 with the older index-0 static scalar.
        // Recomputing the same null entropy and sensor points with the native
        // index-1 static scalar gives this next candidate source/key.
        let entropy = dataFromHex(
            "31c165896d9172293ad6ced18e0b5de05678a01d4b4c2510f244559f504f681" +
            "cc125d81e63dca5eb04dadbce3b870002e58603e0b4eea14fef6325159f1907" +
            "d0cc92833be4b8ccaed896e907f9456c3a90fc3afc58740629de28e348308a4" +
            "6eafc861b93694fd23e83a82e3112bd55a383a563ee91909e6670174811dc7" +
            "9c360017e6e87b301a09c345f895ca2146d885b207a0e84e27e78cf65c3024" +
            "50c5eeca553343c0e99de1952b51fd7239f2213f10db9c621d980073f204d" +
            "9cc5c390757012153219e5d327b72a02e52c910b509cec0e4d8dd28ae443d" +
            "95f6eb0d7fb010b2c0fd96b3591e954def75a86705d920beb020cdd47cd7" +
            "f41b20084cbc5a1937a36bc0e81a7a6ca377b400f1f88c58e6725293fc305" +
            "4e74b988"
        )
        let sensorEphemeral = dataFromHex(
            "04" +
            "0794129c51c5785b620b21e8737f9a29bc59a9b4fc820284d7e870e6030cd7b" +
            "118c230b4eb8ff17fbf2f352fe85d6d9893a277737d549aea21b2f0d601967b18"
        )
        let sensorStatic = dataFromHex(
            "04" +
            "56d505b8de7ea821a2a43c2329bf613d7309595bacbfb5ac4bb49ecc1ddd88" +
            "fc331e314c23b739e10c8fa6e63f955603f9b9a2cfc12aa41f669490d2047893ef"
        )

        let material = try SessionKey.deriveFirstPairPhase5Material(
            FirstPairPhase5KeyInputs(
                entrySource: FirstPairSourceSlice.bundled6388f0LowSeedEntrySource,
                nullEntropy11A: entropy,
                sensorEphemeralPub65: sensorEphemeral,
                sensorStaticPub65: sensorStatic,
                staticScalarWindow: FirstPairStaticScalarWindow.firstPairIndex1
            )
        )

        XCTAssertEqual(material.nullAttempts, 1)
        XCTAssertEqual(material.nullEntropy11A, entropy)
        XCTAssertEqual(
            material.source66.hex,
            "040406040104010300050302040704000607030001050102030203050106040100" +
            "020203010205050601000503060405070404050103060003070002020501010102"
        )
        XCTAssertEqual(material.rawKey.hex, "a44aa812c72f0fb7c1321e62caef2312")
    }

    func testFirstPairPhase5MaterialMatchesPost08LiveAttempt16() throws {
        // Fresh sensor 0RKHDKRA8, 2026-05-09 post-Xcode rerun. This is the
        // first live attempt that sent the post-Phase-5 command 0x08 and then
        // disconnected before 0843, so keep the exact source/key fixture pinned.
        let entropy = dataFromHex(
            "8987c91f1595e8a060e4cba652368ae8797e9113cfd412bebd0ea1a03783ae" +
            "59ee70d2c947578803b06b275c96632d148b81658bb87a3eabb5755273c40" +
            "c397f7255f3c1d742df608383fbbfff5a9b9fbc11a1ab525382024c8568" +
            "7cf79c2a391ca7cc309ff82fe098c2d86e49f8b26364153f0bcb8945c8" +
            "87f5a2a7b54d568daa373a86c85c283fbb6285f35dca2d30263c34ce18" +
            "2c1fc63e6022a3c7e6eaebe3a473d3c754bb8f3982172431af6638894" +
            "8aaf5c709f6699b7608dcd161811dda99c61b302f46684433e61ef2af" +
            "a4dd9f8b0f2472f6120197cdfc0b940ad5f93ac01fc7497fb355c753" +
            "df9c65fc68721690c35a09550fb3c326e38bcbe37ebb309a680c38396" +
            "7627f58a108e1e94ecd16c5d2bc2f576dabdc7b"
        )
        let sensorEphemeral = dataFromHex(
            "04" +
            "057637b02770974bf685ccf017992cf586e94bf7a6cbe229bd813f68873a90e" +
            "1606b8b73d6d8873a31b3a556feae538c9a808fcd936cee8e73ad556922b98f87"
        )
        let sensorStatic = dataFromHex(
            "04" +
            "56d505b8de7ea821a2a43c2329bf613d7309595bacbfb5ac4bb49ecc1ddd88" +
            "fc331e314c23b739e10c8fa6e63f955603f9b9a2cfc12aa41f669490d2047893ef"
        )

        let material = try SessionKey.deriveFirstPairPhase5Material(
            FirstPairPhase5KeyInputs(
                entrySource: FirstPairSourceSlice.bundled6388f0LowSeedEntrySource,
                nullEntropy11A: entropy,
                sensorEphemeralPub65: sensorEphemeral,
                sensorStaticPub65: sensorStatic,
                staticScalarWindow: FirstPairStaticScalarWindow.firstPairIndex1
            )
        )

        XCTAssertEqual(material.nullAttempts, 1)
        XCTAssertEqual(
            material.nullScalarWindow.hex,
            "1b2c5bac8edb26c91d0d89d976e065040704fcd7858c792f82ae8e97829fd2f3" +
            "0000000000000000000000000000000000000000000000000000000000000000000000000000"
        )
        XCTAssertEqual(
            material.source66.hex,
            "040407030302040007070700030207010601000101020103050707010704070706" +
            "060404020305010105030005050006010300000202060300030002020504060404"
        )
        XCTAssertEqual(material.rawKey.hex, "4d4bdbc9e8881dc2918e5225ebfd56a2")
    }

    func testFirstPairPhase5SourceRejectsInvalidSensorPointEncoding() throws {
        let inputs = FirstPairPhase5KeyInputs(
            entrySource: Data((0..<0x214).map { index in UInt8((index * 5 + 1) & 7) }),
            nullEntropy11A: Data(repeating: 0, count: 0x11a),
            sensorEphemeralPub65: Data([0x05]),
            sensorStaticPub65: Data(repeating: 0x04, count: 65)
        )
        XCTAssertThrowsError(try SessionKey.deriveFirstPairPhase5Source(inputs)) { error in
            guard case SessionKeyError.invalidSensorPointEncoding(
                label: "sensor ephemeral",
                count: 1,
                prefix: 0x05
            ) = error else {
                XCTFail("expected invalidSensorPointEncoding, got \(error)")
                return
            }
        }
    }

    func testFirstPairPhase5MaterialEntropySourceRejectsInvalidAttemptLimit() throws {
        let generatorPoint65 = dataFromHex(
            "04" +
            "6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296" +
            "4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5"
        )
        XCTAssertThrowsError(
            try SessionKey.deriveFirstPairPhase5Material(
                entrySource: Data((0..<0x214).map { index in UInt8((index * 5 + 1) & 7) }),
                sensorEphemeralPub65: generatorPoint65,
                sensorStaticPub65: generatorPoint65,
                maxAttempts: 0
            ) { _ in
                XCTFail("entropy source should not be called")
                return Data()
            }
        ) { error in
            guard case FirstPairSourceSliceError.invalid633fa8NullMaxAttempts(0) = error else {
                XCTFail("expected invalid633fa8NullMaxAttempts, got \(error)")
                return
            }
        }
    }

    private func dataFromHex(_ hex: String) -> Data {
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
        return Data(bytes)
    }
}
