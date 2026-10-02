import Foundation

// Phone certificate — 162 bytes, sent as the first phone-→sensor write
// during a fresh-pair handshake (Phase 1, handle 0x002d).
//
// Format:
//
//   [0..2)    msg_type / version  (e.g. 03 03 or 03 00)
//   [2..18)   16B test pattern    (canonically 01 02 03 ... 0f 10)
//   [18..33)  15B header          (00 01 61 89 76 55 01 + 8 zero bytes)
//   [33]      0x04 (P-256 uncompressed-point prefix)
//   [34..98)  X(32) || Y(32)      ← phone STATIC pubkey
//   [98..162) ECDSA signature     (64B raw r || s)
//
// Cert family and live first-pair status:
// The package-bundled `phone_cert_firstpair.bin` (`03 00...`) is rejected by
// live fresh sensors and is kept only as a default for tests and controlled
// experiments. Working first-pair uses the `03 03` family cert
// (`phone_cert_162b.bin`), now also bundled by this package and loadable via
// `bundled162b()`. The `03 03` prefix selects the native index-1 static
// scalar window below via `phase5StaticScalarWindowOverride`.
//
// Provenance of the `03 03` cert: `phone_cert_162b.bin` is byte-exact
// Juggluco's `LIBRE3_APP_CERTIFICATES_B[1]` (open-source app, repo
// `github.com/j-kaltes/Juggluco`, `ECDHCrypto.java`). It is a static, public
// artifact shipped identically to every Juggluco install — a universal cert,
// not per-user/per-device material — which is why it pairs fresh sensors
// generally and is safe to vendor here.
//
// 2026-06-25 update — supersedes the earlier "still failed before Phase 6"
// note: fresh-pair now completes through Phase 6 on live sensors and has in
// production for weeks (LoopKit/LibreLoop's `LibreLoopPairingService`). The
// missing piece was not the cert alone but coupling the `03 03` cert to a
// deterministic native ephemeral: derive a keypair plus matching entropy with
// `SessionKey.makeFirstPairNativeEphemeral(entropySource:)`, pass the keypair
// as `PairingFlow(phoneEph:)`, and feed the SAME entropy into
// `runCommandGatedFirstPairHandshake(blePIN:maxEntropyAttempts:1,
// entropySource:)` so the phone ephemeral and the Phase 5 key source derive
// from one native entropy. A random ephemeral does not pair.

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

    /// First-pair Phase 5 static-scalar policy keyed on the cert family.
    /// `03 00` uses the entry-source-derived scalar; `03 03` uses the index-1
    /// native scalar window, which is the family that pairs live sensors when
    /// combined with the native-ephemeral Phase 5 derivation (see the cert
    /// family note above).
    public var phase5StaticScalarWindowOverride: Data? {
        guard raw.prefix(2).elementsEqual([0x03, 0x03]) else { return nil }
        return FirstPairStaticScalarWindow.firstPairIndex1
    }

    /// Loads `phone_cert_firstpair` (`03 00`) from the installed runtime tables. This is
    /// the default resource for tests and controlled experiments only — live
    /// fresh sensors reject it. For live first-pair use ``bundled162b()``.
    public static func bundledFirstPair() throws -> PhoneCert {
        try bundled(named: "phone_cert_firstpair")
    }

    /// Loads `phone_cert_162b` (`03 03`) from the installed runtime tables, the cert
    /// family that pairs live fresh sensors when combined with the
    /// native-ephemeral Phase 5 derivation (see the cert-family note above).
    /// This is Juggluco's universal `LIBRE3_APP_CERTIFICATES_B[1]`; clients no
    /// longer need to vendor their own copy.
    public static func bundled162b() throws -> PhoneCert {
        try bundled(named: "phone_cert_162b")
    }

    static func bundled(named resource: String) throws -> PhoneCert {
        try PhoneCert(raw: try RemoteRuntimeTables.data(named: resource))
    }
}

public enum FirstPairStaticScalarWindow {
    private static let firstPairIndex1Prefix: [UInt8] = [
        0x97, 0x8d, 0x11, 0xed, 0x64, 0x6e, 0xe3, 0x55,
        0x93, 0x36, 0xd5, 0xfe, 0xba, 0x58, 0x7c, 0xe9,
        0x84, 0x12, 0x31, 0x98, 0xcd, 0x9e, 0x88, 0x0d,
        0x34, 0xba, 0xd0, 0xfa, 0xc8, 0xa9, 0x97, 0xbf,
    ]

    /// Native `0x6388f0` row-59 static scalar window for the Abbott
    /// cert-private index 1 (`03 03` cert family).
    public static let firstPairIndex1 = Data(
        firstPairIndex1Prefix + [UInt8](repeating: 0, count: 38)
    )
}

public enum PhoneCertError: Error, Equatable {
    case wrongSize(Int)
    case notUncompressedPoint
    case bundledResourceMissing(String)
}
