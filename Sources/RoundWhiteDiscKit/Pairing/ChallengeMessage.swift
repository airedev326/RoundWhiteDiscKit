import Foundation

// Phase 5 phone -> sensor wire format on handle 0x002a.
//
// Ground truth as of 2026-05-06:
//   [0..36)   ciphertext for plaintext36 = R1 || R2 || tail4
//   [36..40)  CCM tag, M=4
//   [40..54)  zero pad so the fixed 3 x 18B BLE write shape lines up
//
// The CCM nonce is the 7-byte trailer from the sensor's 23B challenge notify:
//   sensor_A = R1(16) || nonce7(7)
//
// The block primitive is `LibAES.phase5BlockEncrypt` (`lib+0x5defec`), supplied
// by callers as an `AESBlockEncrypt` so tests can also use standard AES.

public struct Phase5Challenge: Equatable, Sendable {
    public static let plaintextSize: Int = 36
    public static let ciphertextSize: Int = 36
    public static let tagSize: Int = 4
    public static let logicalSize: Int = 40   // ct36 + tag4
    public static let wireSize: Int    = 54   // 3 × 18B fragmented writes

    public let ciphertext: Data   // 36B
    public let tag: Data          // 4B

    public init(ciphertext: Data, tag: Data) throws {
        guard ciphertext.count == Self.ciphertextSize else { throw ChallengeError.wrongCiphertextSize(ciphertext.count) }
        guard tag.count == Self.tagSize else { throw ChallengeError.wrongTagSize(tag.count) }
        self.ciphertext = ciphertext
        self.tag = tag
    }

    /// Build by AES-CCM encrypting the 36B `R1 || R2 || tail4` plaintext under
    /// a standard AES key. Most current callers should pass
    /// `LibAES.phase5BlockEncryptor(rawKey:)` to the lower-level overload.
    public static func encrypt(
        plaintext: Data,
        sessionKey: Data,
        nonce: Data,
        aad: Data = Data()
    ) throws -> Phase5Challenge {
        guard sessionKey.count == 16 else { throw ChallengeError.wrongKeySize(sessionKey.count) }
        let aes = AESCCM.commonCryptoBlockEncrypt(key: sessionKey)
        return try encrypt(plaintext: plaintext, aes: aes, nonce: nonce, aad: aad)
    }

    public static func encrypt(
        plaintext: Data,
        aes: AESBlockEncrypt,
        nonce: Data,
        aad: Data = Data()
    ) throws -> Phase5Challenge {
        guard plaintext.count == Self.plaintextSize else { throw ChallengeError.wrongPlaintextSize(plaintext.count) }
        guard nonce.count == 7 else { throw ChallengeError.wrongNonceSize(nonce.count) }
        let (ct, tag) = try AESCCM.encrypt(nonce: nonce, plaintext: plaintext, aad: aad, tagLength: Self.tagSize, aes: aes)
        return try Phase5Challenge(ciphertext: ct, tag: tag)
    }

    public func decrypt(sessionKey: Data, nonce: Data, aad: Data = Data()) throws -> Data {
        guard sessionKey.count == 16 else { throw ChallengeError.wrongKeySize(sessionKey.count) }
        let aes = AESCCM.commonCryptoBlockEncrypt(key: sessionKey)
        return try decrypt(aes: aes, nonce: nonce, aad: aad)
    }

    public func decrypt(aes: AESBlockEncrypt, nonce: Data, aad: Data = Data()) throws -> Data {
        guard nonce.count == 7 else { throw ChallengeError.wrongNonceSize(nonce.count) }
        return try AESCCM.decrypt(nonce: nonce, ciphertext: ciphertext, tag: tag, aad: aad, aes: aes)
    }

    /// Encode as the 40-byte logical message (ct36 || tag4).
    public var logicalBytes: Data { ciphertext + tag }

    /// Encode as the 54-byte wire payload (logical + 14B zero pad).
    public var wireBytes: Data {
        var out = Data(capacity: Self.wireSize)
        out.append(logicalBytes)
        out.append(Data(count: Self.wireSize - Self.logicalSize))
        return out
    }

    /// Parse the 54-byte wire payload (or accept the 40-byte logical form).
    public static func decode(_ raw: Data) throws -> Phase5Challenge {
        guard raw.count == wireSize || raw.count == logicalSize else {
            throw ChallengeError.wrongWireSize(raw.count)
        }
        return try Phase5Challenge(
            ciphertext: raw.subdata(in: 0..<36),
            tag: raw.subdata(in: 36..<40)
        )
    }
}

public enum ChallengeError: Error, Equatable {
    case wrongNonceSize(Int)
    case wrongCiphertextSize(Int)
    case wrongTagSize(Int)
    case wrongPlaintextSize(Int)
    case wrongKeySize(Int)
    case wrongWireSize(Int)
}
