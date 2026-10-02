import XCTest
@testable import RoundWhiteDiscKit

final class LibAESTests: XCTestCase {
    override func setUpWithError() throws {
        try installRuntimeTablesForTests()
    }

    private let rawKey = Data(libaesHex: "3bb02ee4fdefe1737312a4668e7f8604")!

    func testKeySetupAndBlockVectorsMatchPython() throws {
        let ctx = try LibAES.keySetup(rawKey: rawKey)
        XCTAssertEqual(ctx.count, LibAES.contextSize)

        let vectors: [(String, Data, String)] = [
            ("zero block",
             Data(count: 16),
             "bf7a0358dc26e61faeb3d310b30f0826"),
            ("counter block",
             Data((0..<16).map(UInt8.init)),
             "d388d17cc37abcfa3354656979c5ac77"),
            ("apr26 R1",
             Data(libaesHex: "db94448c6abde8bc183df11cf5cf197f")!,
             "ef66b86917499e796a66a9edf2b6f8d2"),
            ("ff block",
             Data(repeating: 0xff, count: 16),
             "a87e6d65ec16f3669541ccebbb585758"),
            ("10..1f block",
             Data((0x10..<0x20).map(UInt8.init)),
             "2c534187108ce4af212a12cfc4cf52fb"),
        ]

        for (name, plaintext, expectedHex) in vectors {
            let actual = try LibAES.blockEncrypt(plaintext, context: ctx)
            XCTAssertEqual(actual.hex, expectedHex, "\(name) diverged from Python lib_aes")
        }
    }

    func testCCMOverLibAESMatchesPython() throws {
        let aes = try LibAES.blockEncryptor(rawKey: rawKey)
        let nonce = Data(libaesHex: "010000007500dc")!
        let plaintext = Data((0..<36).map(UInt8.init))

        let (ct, tag) = try AESCCM.encrypt(
            nonce: nonce,
            plaintext: plaintext,
            tagLength: 8,
            aes: aes
        )
        XCTAssertEqual((ct + tag).hex, "2be74afb317295bdc5eb664a38780ea660e8660fdb743dd487591762ee7d115657918fc4294fa2abd83c575a")

        let recovered = try AESCCM.decrypt(nonce: nonce, ciphertext: ct, tag: tag, aes: aes)
        XCTAssertEqual(recovered, plaintext)
    }

    func testPhase5WireBlockMatchesPython5defecPort() throws {
        let vectors: [(String, Data, Data, String)] = [
            ("zero key zero block",
             Data(count: 16),
             Data(count: 16),
             "6b9bddb402786cba9adac3304b86028b"),
            ("range key range block",
             Data((0..<16).map(UInt8.init)),
             Data((0..<16).map(UInt8.init)),
             "aa4454e26d649350498357b4ce2596ed"),
            ("live 2026-05-06 A1",
             Data(libaesHex: "3b16168843c299ad7fa311ba2440d58a")!,
             Data(libaesHex: "07210400008f8c4b0000000000000001")!,
             "c4ccfb387363f51bf61df08fc6d39304"),
        ]

        for (name, key, plaintext, expectedHex) in vectors {
            let ctx = try LibAES.keySetup(rawKey: key)
            let actual = try LibAES.phase5BlockEncrypt(plaintext, context: ctx)
            XCTAssertEqual(actual.hex, expectedHex, "\(name) diverged from Python block_5defec")
        }
    }

    func testPhase5CCMOver5defecMatchesLiveWireTuple() throws {
        let key = Data(libaesHex: "3b16168843c299ad7fa311ba2440d58a")!
        let aes = try LibAES.phase5BlockEncryptor(rawKey: key)
        let nonce = Data(libaesHex: "210400008f8c4b")!
        let plaintext = Data(libaesHex: "8d2f296f882c1c0991d0e38c097892288c5b0b7441a7486d930806db08acdf1e3225ec72")!

        let (ct, tag) = try AESCCM.encrypt(
            nonce: nonce,
            plaintext: plaintext,
            tagLength: 4,
            aes: aes
        )

        XCTAssertEqual((ct + tag).hex, "49e3d257fb4fe91267cd1303cfab012ca215375f94040f8e9340a139de69720a88dc15dd50d3931a")
        let recovered = try AESCCM.decrypt(nonce: nonce, ciphertext: ct, tag: tag, aes: aes)
        XCTAssertEqual(recovered, plaintext)
    }
}

private extension Data {
    init?(libaesHex: String) {
        guard libaesHex.count % 2 == 0 else { return nil }
        var data = Data(capacity: libaesHex.count / 2)
        var idx = libaesHex.startIndex
        while idx < libaesHex.endIndex {
            let next = libaesHex.index(idx, offsetBy: 2)
            guard let byte = UInt8(libaesHex[idx..<next], radix: 16) else { return nil }
            data.append(byte)
            idx = next
        }
        self = data
    }
}
