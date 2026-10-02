import Foundation

// Phase 6 sensor -> phone wire format on handle 0x002a.
//
// Ground truth from 2026-05-06 live iPhone and Android pristine runs:
//   [0..56)   ciphertext for plaintext56 = R2 || R1 || kEnc || ivEnc8
//   [56..60)  CCM tag, M=4
//   [60..67)  sensor nonce7
//
// The same `LibAES.phase5BlockEncrypt` (`lib+0x5defec`) block primitive and
// child[23]/ptr05-derived raw key used for Phase 5 decrypt this response.

public struct Phase6SessionMaterial: Equatable, Sendable {
    public let phoneR2: Data
    public let sensorR1: Data
    public let kEnc: Data
    public let ivEnc: Data

    public init(phoneR2: Data, sensorR1: Data, kEnc: Data, ivEnc: Data) throws {
        guard phoneR2.count == 16 else { throw Phase6ResponseError.wrongR2Size(phoneR2.count) }
        guard sensorR1.count == 16 else { throw Phase6ResponseError.wrongR1Size(sensorR1.count) }
        guard kEnc.count == 16 else { throw Phase6ResponseError.wrongKEncSize(kEnc.count) }
        guard ivEnc.count == 8 else { throw Phase6ResponseError.wrongIVEncSize(ivEnc.count) }
        self.phoneR2 = phoneR2
        self.sensorR1 = sensorR1
        self.kEnc = kEnc
        self.ivEnc = ivEnc
    }
}

public struct Phase6Response: Equatable, Sendable {
    public static let plaintextSize: Int = 56
    public static let ciphertextSize: Int = 56
    public static let tagSize: Int = 4
    public static let logicalSize: Int = 60
    public static let wireSize: Int = 67

    public let ciphertext: Data
    public let tag: Data
    public let nonce: Data

    public init(ciphertext: Data, tag: Data, nonce: Data) throws {
        guard ciphertext.count == Self.ciphertextSize else {
            throw Phase6ResponseError.wrongCiphertextSize(ciphertext.count)
        }
        guard tag.count == Self.tagSize else { throw Phase6ResponseError.wrongTagSize(tag.count) }
        guard nonce.count == 7 else { throw ChallengeError.wrongNonceSize(nonce.count) }
        self.ciphertext = ciphertext
        self.tag = tag
        self.nonce = nonce
    }

    public static func decode(_ raw: Data) throws -> Phase6Response {
        guard raw.count == Self.wireSize else { throw ChallengeError.wrongWireSize(raw.count) }
        return try Phase6Response(
            ciphertext: raw.subdata(in: 0..<Self.ciphertextSize),
            tag: raw.subdata(in: Self.ciphertextSize..<Self.logicalSize),
            nonce: raw.subdata(in: Self.logicalSize..<Self.wireSize)
        )
    }

    public func decrypt(aes: AESBlockEncrypt, aad: Data = Data()) throws -> Phase6SessionMaterial {
        let plaintext = try AESCCM.decrypt(
            nonce: nonce,
            ciphertext: ciphertext,
            tag: tag,
            aad: aad,
            aes: aes
        )
        guard plaintext.count == Self.plaintextSize else {
            throw Phase6ResponseError.wrongPlaintextSize(plaintext.count)
        }
        return try Phase6SessionMaterial(
            phoneR2: plaintext.subdata(in: 0..<16),
            sensorR1: plaintext.subdata(in: 16..<32),
            kEnc: plaintext.subdata(in: 32..<48),
            ivEnc: plaintext.subdata(in: 48..<56)
        )
    }

    public func decrypt(rawKey: Data, aad: Data = Data()) throws -> Phase6SessionMaterial {
        let aes = try LibAES.phase5BlockEncryptor(rawKey: rawKey)
        return try decrypt(aes: aes, aad: aad)
    }
}

public enum Phase6ResponseError: Error, Equatable {
    case wrongCiphertextSize(Int)
    case wrongTagSize(Int)
    case wrongPlaintextSize(Int)
    case wrongR2Size(Int)
    case wrongR1Size(Int)
    case wrongKEncSize(Int)
    case wrongIVEncSize(Int)
}
