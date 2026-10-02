import XCTest
@testable import RoundWhiteDiscKit

final class Phase6ResponseTests: XCTestCase {
    override func setUpWithError() throws {
        try installRuntimeTablesForTests()
    }

    private let liveKey = Data(hexString: "f84d8c0f6251e81f46ff263343239fb9")
    private let liveR1 = Data(hexString: "544921efc2c2bcd4a9d0b119d3a923e0")
    private let liveR2 = Data(hexString: "9db1cc3f06e9d092d6602bdc5c7ad312")
    private let liveWire = Data(hexString:
        "85aa09d24bfcd0cddc7984d10e7451b34595c5" +
        "ab3947106858d729a947ee2f372a2403d9e728" +
        "34a82f870f16b415afa032654b1572c848361b" +
        "ef399535040000a4e148"
    )

    func testLivePhase6ResponseDecryptsToSessionMaterial() throws {
        let response = try Phase6Response.decode(liveWire)
        XCTAssertEqual(response.ciphertext.count, 56)
        XCTAssertEqual(response.tag.hex, "1bef3995")
        XCTAssertEqual(response.nonce.hex, "35040000a4e148")

        let material = try response.decrypt(rawKey: liveKey)
        XCTAssertEqual(material.phoneR2, liveR2)
        XCTAssertEqual(material.sensorR1, liveR1)
        XCTAssertEqual(material.kEnc.hex, "4bbce496a63cc9a435adeeb4f78e1617")
        XCTAssertEqual(material.ivEnc.hex, "0000000067c72c01")
    }

    func testFirstPair0RKHDKRA8Phase6ResponseDecryptsToSessionMaterial() throws {
        let rawKey = Data(hexString: "21b5cd0e7ab84d60f5d7453a6e2ddf40")
        let sensorR1 = Data(hexString: "d02d410e6ef40e76e36abf7455dcc432")
        let phoneR2 = Data(hexString: "6fdddbd344b7379a581a856e31c01d25")
        let wire = Data(hexString:
            "c7abf31874dc02e9f775b8ef83906a35632c99" +
            "8ca6c34ca81d4410c0a062d18ac0c8859e92a3" +
            "8c1c7521198de87394b2086b4e458cf7fe8161" +
            "9540f208000000f38356"
        )

        let response = try Phase6Response.decode(wire)
        XCTAssertEqual(response.tag.hex, "619540f2")
        XCTAssertEqual(response.nonce.hex, "08000000f38356")

        let material = try response.decrypt(rawKey: rawKey)
        XCTAssertEqual(material.phoneR2, phoneR2)
        XCTAssertEqual(material.sensorR1, sensorR1)
        XCTAssertEqual(material.kEnc.hex, "9f15acd6f2584a911429b45060276617")
        XCTAssertEqual(material.ivEnc.hex, "00000000faaa2dda")
    }

    func testTamperedPhase6ResponseFailsAuth() throws {
        var tampered = liveWire
        tampered[0] ^= 0x01
        let response = try Phase6Response.decode(tampered)

        XCTAssertThrowsError(try response.decrypt(rawKey: liveKey)) { error in
            guard case AESCCMError.macMismatch = error else {
                XCTFail("expected macMismatch, got \(error)")
                return
            }
        }
    }
}

private extension Data {
    init(hexString: String) {
        var data = Data(capacity: hexString.count / 2)
        var idx = hexString.startIndex
        while idx < hexString.endIndex {
            let next = hexString.index(idx, offsetBy: 2)
            if let b = UInt8(hexString[idx..<next], radix: 16) {
                data.append(b)
            }
            idx = next
        }
        self = data
    }
}
