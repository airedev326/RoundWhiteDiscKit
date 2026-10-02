import Foundation
import CryptoKit

// Phase 3/4 ephemeral P-256 ECDH.
//
// The phone generates a fresh P-256 keypair, sends the uncompressed
// pubkey (65B) on handle 0x002d, and receives the sensor's ephemeral
// pubkey (65B notify on the same handle).
//
// The 3DH-style key agreement combines:
//   - phone_eph × sensor_static  (binds to the cert pubkey)
//   - phone_eph × sensor_eph     (binds to the per-session ephemeral)
//   - phone_static × sensor_eph  (proves phone identity to sensor)
//
// CryptoKit's `P256.KeyAgreement` exposes raw X9.63 public-key encoding
// (`x963Representation`) which IS the 65B uncompressed-point format the
// protocol uses on the wire. No custom point parsing needed.

public struct EphemeralKeyPair: Sendable {
    public let privateKey: P256.KeyAgreement.PrivateKey
    public let publicKey65: Data   // 04 || X || Y

    public init() {
        let priv = P256.KeyAgreement.PrivateKey()
        self.privateKey = priv
        self.publicKey65 = priv.publicKey.x963Representation
    }

    /// Construct from a previously-saved private key (e.g. for replay tests).
    public init(privateKey: P256.KeyAgreement.PrivateKey) {
        self.privateKey = privateKey
        self.publicKey65 = privateKey.publicKey.x963Representation
    }

    /// Construct from a private scalar while overriding the public point sent
    /// on the wire. Native first-pair `process2(5)` derives the Phase 3 public
    /// point through a separate fixed-point path, while Phase 5 still needs the
    /// accepted null-branch scalar/entropy.
    public init(
        nativeScalarWindowLE: Data,
        publicKey65Override: Data
    ) throws {
        guard publicKey65Override.count == 65, publicKey65Override.first == 0x04 else {
            throw EphemeralExchangeError.invalidEncoding
        }
        let raw = try Self.rawPrivateKeyRepresentation(nativeScalarWindowLE: nativeScalarWindowLE)
        self.privateKey = try P256.KeyAgreement.PrivateKey(rawRepresentation: raw)
        self.publicKey65 = publicKey65Override
    }

    /// Construct the Phase 3 ephemeral key from the native first-pair
    /// null-branch scalar window. Native stores this scalar little-endian in a
    /// 70-byte window; CryptoKit expects the 32-byte scalar big-endian.
    public init(nativeScalarWindowLE: Data) throws {
        let raw = try Self.rawPrivateKeyRepresentation(nativeScalarWindowLE: nativeScalarWindowLE)
        let priv = try P256.KeyAgreement.PrivateKey(rawRepresentation: raw)
        self.init(privateKey: priv)
    }

    public static func publicKey65(nativeScalarWindowLE: Data) throws -> Data {
        try EphemeralKeyPair(nativeScalarWindowLE: nativeScalarWindowLE).publicKey65
    }

    private static func rawPrivateKeyRepresentation(nativeScalarWindowLE: Data) throws -> Data {
        guard nativeScalarWindowLE.count >= 32 else {
            throw EphemeralExchangeError.invalidScalarWindowLength(nativeScalarWindowLE.count)
        }
        return Data(nativeScalarWindowLE.prefix(32).reversed())
    }
}

public enum EphemeralExchange {

    /// Parse a 65-byte uncompressed P-256 point as a CryptoKit public key.
    public static func parsePeerPubkey(_ raw65: Data) throws -> P256.KeyAgreement.PublicKey {
        guard raw65.count == 65, raw65.first == 0x04 else {
            throw EphemeralExchangeError.invalidEncoding
        }
        return try P256.KeyAgreement.PublicKey(x963Representation: raw65)
    }

    /// Compute a single ECDH shared secret as raw 32 bytes.
    public static func sharedSecret(
        privateKey: P256.KeyAgreement.PrivateKey,
        peer: P256.KeyAgreement.PublicKey
    ) throws -> Data {
        let s = try privateKey.sharedSecretFromKeyAgreement(with: peer)
        return s.withUnsafeBytes { Data($0) }
    }
}

public enum EphemeralExchangeError: Error, Equatable {
    case invalidEncoding
    case invalidScalarWindowLength(Int)
}
