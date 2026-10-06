import Foundation

// Phone certificate — 162 bytes, sent as the first phone→sensor write during a
// fresh-pair handshake (Phase 1, handle 0x002d). The host supplies the bytes;
// see AppIdentity.
//
// Format:
//   [0..2)    msg_type / version
//   [2..18)   16B test pattern
//   [18..33)  15B header
//   [33]      0x04 (P-256 uncompressed-point prefix)
//   [34..98)  X(32) || Y(32)      ← phone STATIC pubkey
//   [98..162) ECDSA signature     (64B raw r || s)
public struct PhoneCert: Equatable, Sendable {
    public let raw: Data           // full 162B blob
    public let staticPub: Data     // 65B uncompressed P-256 point (with 0x04 prefix)

    public static let totalSize: Int = 162
    public static let pubkeyRange: Range<Int> = 33..<98

    public init(raw: Data) throws {
        guard raw.count == Self.totalSize else { throw PhoneCertError.wrongSize(raw.count) }
        let pub = raw.subdata(in: Self.pubkeyRange)
        guard pub.first == 0x04 else { throw PhoneCertError.notUncompressedPoint }
        self.raw = raw
        self.staticPub = pub
    }
}

public enum PhoneCertError: Error, Equatable {
    case wrongSize(Int)
    case notUncompressedPoint
}
