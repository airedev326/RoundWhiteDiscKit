import CryptoKit
import Foundation

/// An app credential: a phone certificate plus the P-256 scalar behind its
/// public key. The host supplies these to RoundWhiteDiscKit before pairing;
/// the package never ships or fetches key material of its own.
///
/// kAuth is plain ECDH and SHA-256, and Phase 5/6 use standard AES-CCM.
public struct AppIdentity: Sendable {
    public let label: String
    public let privateKey: P256.KeyAgreement.PrivateKey
    public let certificate: PhoneCert

    /// Build from a 32-byte P-256 scalar and a 162-byte phone certificate. The
    /// scalar must be the private key behind the certificate's public point.
    public init(label: String, privateKey: P256.KeyAgreement.PrivateKey, certificate: PhoneCert) throws {
        guard privateKey.publicKey.x963Representation == certificate.staticPub else {
            throw AppIdentityError.keyCertificateMismatch(label)
        }
        self.label = label
        self.privateKey = privateKey
        self.certificate = certificate
    }

    /// NIST SP 800-56A concat KDF: `SHA-256(00000001 || Ze || Zs)[0..<16]`, where
    /// Ze is ephemeral × sensor ephemeral and Zs is our static × sensor static.
    public func authKey(
        phoneEphemeral: P256.KeyAgreement.PrivateKey,
        sensorEphemeral: P256.KeyAgreement.PublicKey,
        sensorStatic: P256.KeyAgreement.PublicKey
    ) throws -> Data {
        let ze = try EphemeralExchange.sharedSecret(privateKey: phoneEphemeral, peer: sensorEphemeral)
        let zs = try EphemeralExchange.sharedSecret(privateKey: privateKey, peer: sensorStatic)
        let digest = SHA256.hash(data: Data([0, 0, 0, 1]) + ze + zs)
        return Data(digest.prefix(16))
    }

    /// Standard AES for the Phase 5/6 exchange under a kAuth from `authKey`.
    public static let phase5Cipher: (Data) throws -> AESBlockEncrypt = { key in
        AESCCM.commonCryptoBlockEncrypt(key: key)
    }
}

/// The app credentials in use, supplied by the host at initialization. Pairing
/// tries them in order.
public enum AppIdentities {
    private static let lock = NSLock()
    private static var current: [AppIdentity]?

    /// Install host-supplied credentials. Replaces any previously installed set.
    public static func install(_ identities: [AppIdentity]) {
        lock.withLock { current = identities }
    }

    /// Install from host-supplied JSON: `{ "format": 1, "curve": "P-256",
    /// "identities": [ { "label", "privateKeyHex", "certificateHex" } ] }`.
    public static func install(json: Data) throws {
        install(try parse(json: json))
    }

    public static var isInstalled: Bool {
        lock.withLock { current != nil }
    }

    public static func installed() throws -> [AppIdentity] {
        guard let identities = lock.withLock({ current }) else {
            throw AppIdentityError.notInstalled
        }
        return identities
    }

    static func parse(json: Data) throws -> [AppIdentity] {
        let file = try JSONDecoder().decode(File.self, from: json)
        guard file.format == 1, file.curve == "P-256" else {
            throw AppIdentityError.unsupportedFormat(file.format, file.curve)
        }
        return try file.identities.map { entry in
            guard let scalar = Data(appIdentityHex: entry.privateKeyHex),
                  let certRaw = Data(appIdentityHex: entry.certificateHex) else {
                throw AppIdentityError.badHex(entry.label)
            }
            return try AppIdentity(
                label: entry.label,
                privateKey: P256.KeyAgreement.PrivateKey(rawRepresentation: scalar),
                certificate: PhoneCert(raw: certRaw)
            )
        }
    }

    private struct File: Decodable {
        let format: Int
        let curve: String
        let identities: [Entry]
    }

    private struct Entry: Decodable {
        let label: String
        let privateKeyHex: String
        let certificateHex: String
    }
}

public enum AppIdentityError: Error, Equatable {
    case notInstalled
    case unsupportedFormat(Int, String)
    case badHex(String)
    case keyCertificateMismatch(String)
}

private extension Data {
    init?(appIdentityHex hex: String) {
        guard hex.count % 2 == 0 else { return nil }
        var bytes = [UInt8]()
        var index = hex.startIndex
        while index < hex.endIndex {
            let next = hex.index(index, offsetBy: 2)
            guard let byte = UInt8(hex[index..<next], radix: 16) else { return nil }
            bytes.append(byte)
            index = next
        }
        self.init(bytes)
    }
}
