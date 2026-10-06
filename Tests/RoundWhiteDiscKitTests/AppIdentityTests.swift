import CryptoKit
import XCTest
@testable import RoundWhiteDiscKit

/// Cross-implementation check against the Python reference, using an arbitrary
/// test scalar (0x4444) — not any real credential, so no key material lives in
/// the repo. Fixed scalars: phone ephemeral 0x1111, sensor ephemeral 0x2222,
/// sensor static 0x3333, phone static 0x4444.
final class AppIdentityTests: XCTestCase {
    private let scalarHex = "0000000000000000000000000000000000000000000000000000000000004444"
    private let certHex = "03000102030405060708090a0b0c0d0e0f1000005f92a79201000000000000000004a85b3aad6f3a346d85523141cb434e1caf4c642b2b3cc952cb07a635cb6a1df1bcbdadb66bae8eb25eca92f8b08b67be02cc736150dd7ffcd3f019c875f9ffde" + String(repeating: "0", count: 128)
    private let sensorEphemeral = Data(vectorHex: "04a62f048f367359809c2d46c2049d7d7bf268c3c073c472753cb18a24a8ad20b1caccf8104b666795c7f35dac9dc444b3c2c61978198c49859955b99956da5edb")
    private let sensorStatic = Data(vectorHex: "048570e95d85825286db92c78317679bdd8ffe3c90d0af84291bf64132b66fcc99c926f087212d75b1f4dbc5d4999b4c5605adf66db801a4de371cdad39ebc55e5")
    private let expectedAuthKey = Data(vectorHex: "d321308aaf9d1d68132ff5192ecb67f4")
    private let expectedAnswer = Data(vectorHex: "a4016be402aef5485155238b8dee3f36f564dd18819889ff25b35221a7f6f207b3512232816ce2c5a1a2a3a4a5a6a7")
    private let sensorReply = Data(vectorHex: "5e10ddf6634fcf8fce8e81bf67d47dd5a66995159a53f7cbc3939a75d34a565844e1be3b5ca66092a5127f362ae7c7278feb1184058ce9aed6a77f43b1b2b3b4b5b6b7")

    private func testIdentity() throws -> AppIdentity {
        let json = #"{"format":1,"curve":"P-256","identities":[{"label":"test","privateKeyHex":"\#(scalarHex)","certificateHex":"\#(certHex)"}]}"#
        let identities = try AppIdentities.parse(json: Data(json.utf8))
        return try XCTUnwrap(identities.first)
    }

    private func scalar(_ value: UInt16) throws -> P256.KeyAgreement.PrivateKey {
        var raw = Data(count: 32)
        raw[30] = UInt8(value >> 8)
        raw[31] = UInt8(value & 0xff)
        return try P256.KeyAgreement.PrivateKey(rawRepresentation: raw)
    }

    func testInstallRoundTrip() throws {
        AppIdentities.install(try AppIdentities.parse(json: Data(
            #"{"format":1,"curve":"P-256","identities":[{"label":"test","privateKeyHex":"\#(scalarHex)","certificateHex":"\#(certHex)"}]}"#.utf8)))
        XCTAssertEqual(try AppIdentities.installed().map(\.label), ["test"])
    }

    func testKeyCertificateMismatchRejected() {
        let wrongScalarHex = "0000000000000000000000000000000000000000000000000000000000005555"
        let json = #"{"format":1,"curve":"P-256","identities":[{"label":"bad","privateKeyHex":"\#(wrongScalarHex)","certificateHex":"\#(certHex)"}]}"#
        XCTAssertThrowsError(try AppIdentities.parse(json: Data(json.utf8))) { error in
            XCTAssertEqual(error as? AppIdentityError, .keyCertificateMismatch("bad"))
        }
    }

    func testAuthKeyMatchesReference() throws {
        let key = try testIdentity().authKey(
            phoneEphemeral: scalar(0x1111),
            sensorEphemeral: EphemeralExchange.parsePeerPubkey(sensorEphemeral),
            sensorStatic: EphemeralExchange.parsePeerPubkey(sensorStatic)
        )
        XCTAssertEqual(key, expectedAuthKey)
    }

    func testChallengeAnswerAndSessionMatchReference() throws {
        let aes = try AppIdentity.phase5Cipher(expectedAuthKey)
        let challenge = Data(0..<16)
        let appNonce = Data(0x40..<0x50)
        let phase5 = try Phase5Challenge.encrypt(
            plaintext: challenge + appNonce + Data(vectorHex: "deadbeef"),
            aes: aes,
            nonce: Data(vectorHex: "a1a2a3a4a5a6a7")
        )
        // Reference returns ct||tag||nonce; the wire form pads ct||tag instead.
        XCTAssertEqual(phase5.logicalBytes, expectedAnswer.prefix(Phase5Challenge.logicalSize))

        let session = try Phase6Response.decode(sensorReply).decrypt(aes: aes)
        XCTAssertEqual(session.phoneR2, appNonce)
        XCTAssertEqual(session.sensorR1, challenge)
        XCTAssertEqual(session.kEnc, Data(0x80..<0x90))
        XCTAssertEqual(session.ivEnc, Data(0x90..<0x98))
    }
}

private extension Data {
    init(vectorHex hex: String) {
        self.init(stride(from: 0, to: hex.count, by: 2).map { offset in
            let start = hex.index(hex.startIndex, offsetBy: offset)
            return UInt8(hex[start..<hex.index(start, offsetBy: 2)], radix: 16)!
        })
    }
}
