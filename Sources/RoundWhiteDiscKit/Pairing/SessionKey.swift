import Foundation
import CryptoKit

// First-pair Phase 5 key surfaces.
//
// Current ground truth (2026-05-06):
//
// - `Phase5KeySchedule.deriveRawKey` maps a 66-byte, 3-bit-per-byte source
//   into the raw Phase 5 wire key.
//
// - `Phase5SessionData` can validate 66-byte source bytes for diagnostics and
//   table tests.
//
// - The current clean-room first-pair source path composes the accepted null
//   entropy, the candidate invariant entry source, the Phase 4 sensor
//   ephemeral point, and the sensor certificate's static point.
//
// `SessionKey.derive(_:)` remains only as an older ECDH-only injection point
// used by tests and capture-era scaffolding. It deliberately still throws
// `.notYetSpecified` rather than implying that ECDH alone derives the Phase 5
// raw key.

public struct SessionKeyInputs: Equatable, Sendable {
    /// ECDH(phone_eph_priv, sensor_static_pub).
    public let sharedEphStatic: Data
    /// ECDH(phone_eph_priv, sensor_eph_pub).
    public let sharedEphEph: Data
    /// Static keys from the lib (present in every kAuth blob).
    public let k1: Data
    public let k2: Data
    /// Optional protocol-side material (per-session nonce, sensor R1
    /// challenge, etc.) — caller may pack any extra material here.
    public let extra: Data

    public init(
        sharedEphStatic: Data,
        sharedEphEph: Data,
        k1: Data,
        k2: Data,
        extra: Data = Data()
    ) {
        self.sharedEphStatic = sharedEphStatic
        self.sharedEphEph = sharedEphEph
        self.k1 = k1
        self.k2 = k2
        self.extra = extra
    }
}

public struct FirstPairPhase5KeyInputs: Equatable, Sendable {
    /// Candidate invariant 532-byte entry source consumed by the row-0
    /// low-seed path.
    public let entrySource: Data
    /// Accepted 282-byte entropy block for the null scalar branch.
    public let nullEntropy11A: Data
    /// Sensor ephemeral P-256 point from Phase 4, encoded as `04 || X || Y`.
    public let sensorEphemeralPub65: Data
    /// Sensor static P-256 point from the certificate, encoded as `04 || X || Y`.
    public let sensorStaticPub65: Data
    /// Optional native 70-byte static-scalar window for cert families whose
    /// Phase 5 static branch is not the bundled entry-source-derived default.
    public let staticScalarWindow: Data?

    public init(
        entrySource: Data = FirstPairSourceSlice.bundled6388f0LowSeedEntrySource,
        nullEntropy11A: Data,
        sensorEphemeralPub65: Data,
        sensorStaticPub65: Data,
        staticScalarWindow: Data? = nil
    ) {
        self.entrySource = entrySource
        self.nullEntropy11A = nullEntropy11A
        self.sensorEphemeralPub65 = sensorEphemeralPub65
        self.sensorStaticPub65 = sensorStaticPub65
        self.staticScalarWindow = staticScalarWindow
    }
}

public struct FirstPairPhase5KeyMaterial: Equatable, Sendable {
    public let source66: Data
    public let rawKey: Data
    public let nullEntropy11A: Data
    public let nullScalarWindow: Data
    public let nullAttempts: Int

    public init(
        source66: Data,
        rawKey: Data,
        nullEntropy11A: Data,
        nullScalarWindow: Data,
        nullAttempts: Int
    ) {
        self.source66 = source66
        self.rawKey = rawKey
        self.nullEntropy11A = nullEntropy11A
        self.nullScalarWindow = nullScalarWindow
        self.nullAttempts = nullAttempts
    }
}

public struct FirstPairNativeEphemeralMaterial: Sendable {
    public let keyPair: EphemeralKeyPair
    public let nullEntropy11A: Data
    public let nullScalarWindow: Data
    public let attempts: Int

    public init(
        keyPair: EphemeralKeyPair,
        nullEntropy11A: Data,
        nullScalarWindow: Data,
        attempts: Int
    ) {
        self.keyPair = keyPair
        self.nullEntropy11A = nullEntropy11A
        self.nullScalarWindow = nullScalarWindow
        self.attempts = attempts
    }
}

public enum SessionKeyError: Error {
    /// Returned by `derive` until the empirical construction is pinned
    /// down. The capture path that will resolve this lives at
    /// `cleanroom_kauth/lldb_capture/cipher_fn_initECDH_capture.py`.
    case notYetSpecified
    case invalidSensorPointEncoding(label: String, count: Int, prefix: UInt8?)
}

public enum SessionKey {

    /// Generate the Phase 3 phone material in the same way native first-pair
    /// does: sample the accepted null-branch entropy, derive the native
    /// null scalar for Phase 5, and send the `process2(5)` fixed-point public
    /// point derived from that same entropy.
    public static func makeFirstPairNativeEphemeral(
        maxAttempts: Int = 64,
        entropySource: (Int) throws -> Data
    ) throws -> FirstPairNativeEphemeralMaterial {
        let result = try FirstPairSourceSlice.builder633fa8NullScalarWindowFromEntropySource(
            maxAttempts: maxAttempts,
            entropySource: entropySource
        )
        let publicKey65 = try FirstPairSourceSlice.builderProcess2P5PublicKey65FromEntropy(
            entropy11A: result.entropy11A
        )
        let keyPair = try EphemeralKeyPair(
            nativeScalarWindowLE: result.scalarWindow,
            publicKey65Override: publicKey65
        )
        return FirstPairNativeEphemeralMaterial(
            keyPair: keyPair,
            nullEntropy11A: result.entropy11A,
            nullScalarWindow: result.scalarWindow,
            attempts: result.attempts
        )
    }

    /// Derive the 16-byte session key from the Phase 1-4 ECDH outputs +
    /// any protocol-side material. Currently throws `.notYetSpecified`
    /// pending empirical confirmation of the construction.
    ///
    /// Callers should treat this as an injection point: tests can pass
    /// a pre-computed key around `SessionKey.derive` until the real
    /// derivation lands.
    public static func derive(_ inputs: SessionKeyInputs) throws -> Data {
        _ = inputs
        throw SessionKeyError.notYetSpecified
    }

    /// Derive the 66-byte Phase 5 source for first-pair from the clean-room
    /// source builder. Row 0 uses the Phase 4 sensor ephemeral point; row 59
    /// uses the sensor certificate's static public point.
    public static func deriveFirstPairPhase5Source(_ inputs: FirstPairPhase5KeyInputs) throws -> Data {
        try deriveFirstPairPhase5Material(inputs).source66
    }

    public static func deriveFirstPairPhase5Material(_ inputs: FirstPairPhase5KeyInputs) throws -> FirstPairPhase5KeyMaterial {
        let row0Point = try uncompressedPointXYBE(
            inputs.sensorEphemeralPub65,
            label: "sensor ephemeral"
        )
        let row59Point = try uncompressedPointXYBE(
            inputs.sensorStaticPub65,
            label: "sensor static"
        )
        let nullScalar = try FirstPairSourceSlice.builder633fa8NullScalarWindowFromEntropy(
            entropy11A: inputs.nullEntropy11A
        )
        let staticScalar: Data
        if let override = inputs.staticScalarWindow {
            staticScalar = override
        } else {
            staticScalar = try FirstPairSourceSlice.builder633fa8StaticScalarWindowFromEntrySource(
                inputs.entrySource
            )
        }
        let seeds = try FirstPairSourceSlice.builder6388f0FirstPairStreamSeedsFromScalarsAndSensorPoints(
            entrySource: inputs.entrySource,
            nullScalarWindow: nullScalar,
            staticScalarWindow: staticScalar,
            row0SensorPointXYBE: row0Point,
            row59SensorPointXYBE: row59Point,
            nullEntropy11A: inputs.nullEntropy11A,
            nullAttempts: 1
        )
        return try material(from: seeds)
    }

    public static func deriveFirstPairPhase5Source(
        preamble: FirstPairPreambleResult,
        nullEntropy11A: Data,
        entrySource: Data = FirstPairSourceSlice.bundled6388f0LowSeedEntrySource,
        staticScalarWindow: Data? = nil
    ) throws -> Data {
        try deriveFirstPairPhase5Source(
            FirstPairPhase5KeyInputs(
                entrySource: entrySource,
                nullEntropy11A: nullEntropy11A,
                sensorEphemeralPub65: preamble.phaseHandshake.sensorEphPub.x963Representation,
                sensorStaticPub65: preamble.phaseHandshake.sensorCert.staticPub,
                staticScalarWindow: staticScalarWindow ??
                    preamble.phaseHandshake.phoneCert.phase5StaticScalarWindowOverride
            )
        )
    }

    public static func deriveFirstPairPhase5RawKey(_ inputs: FirstPairPhase5KeyInputs) throws -> Data {
        try deriveFirstPairPhase5Material(inputs).rawKey
    }

    public static func deriveFirstPairPhase5RawKey(
        preamble: FirstPairPreambleResult,
        nullEntropy11A: Data,
        entrySource: Data = FirstPairSourceSlice.bundled6388f0LowSeedEntrySource,
        staticScalarWindow: Data? = nil
    ) throws -> Data {
        let source = try deriveFirstPairPhase5Source(
            preamble: preamble,
            nullEntropy11A: nullEntropy11A,
            entrySource: entrySource,
            staticScalarWindow: staticScalarWindow
        )
        return try Phase5KeySchedule.deriveRawKey(input66: source)
    }

    public static func deriveFirstPairPhase5Material(
        preamble: FirstPairPreambleResult,
        nullEntropy11A: Data,
        entrySource: Data = FirstPairSourceSlice.bundled6388f0LowSeedEntrySource,
        staticScalarWindow: Data? = nil
    ) throws -> FirstPairPhase5KeyMaterial {
        try deriveFirstPairPhase5Material(
            FirstPairPhase5KeyInputs(
                entrySource: entrySource,
                nullEntropy11A: nullEntropy11A,
                sensorEphemeralPub65: preamble.phaseHandshake.sensorEphPub.x963Representation,
                sensorStaticPub65: preamble.phaseHandshake.sensorCert.staticPub,
                staticScalarWindow: staticScalarWindow ??
                    preamble.phaseHandshake.phoneCert.phase5StaticScalarWindowOverride
            )
        )
    }

    public static func deriveFirstPairPhase5Material(
        entrySource: Data = FirstPairSourceSlice.bundled6388f0LowSeedEntrySource,
        sensorEphemeralPub65: Data,
        sensorStaticPub65: Data,
        staticScalarWindow: Data? = nil,
        maxAttempts: Int = 64,
        entropySource: (Int) throws -> Data
    ) throws -> FirstPairPhase5KeyMaterial {
        let row0Point = try uncompressedPointXYBE(
            sensorEphemeralPub65,
            label: "sensor ephemeral"
        )
        let row59Point = try uncompressedPointXYBE(
            sensorStaticPub65,
            label: "sensor static"
        )
        let seeds: Builder6388f0FirstPairStreamSeeds
        if let staticScalarWindow {
            let nullResult = try FirstPairSourceSlice.builder633fa8NullScalarWindowFromEntropySource(
                maxAttempts: maxAttempts,
                entropySource: entropySource
            )
            seeds = try FirstPairSourceSlice.builder6388f0FirstPairStreamSeedsFromScalarsAndSensorPoints(
                entrySource: entrySource,
                nullScalarWindow: nullResult.scalarWindow,
                staticScalarWindow: staticScalarWindow,
                row0SensorPointXYBE: row0Point,
                row59SensorPointXYBE: row59Point,
                nullEntropy11A: nullResult.entropy11A,
                nullAttempts: nullResult.attempts
            )
        } else {
            seeds = try FirstPairSourceSlice.builder6388f0FirstPairStreamSeedsFromEntropySourceAndSensorPoints(
                entrySource: entrySource,
                row0SensorPointXYBE: row0Point,
                row59SensorPointXYBE: row59Point,
                maxAttempts: maxAttempts,
                entropySource: entropySource
            )
        }
        return try material(from: seeds)
    }

    public static func deriveFirstPairPhase5Material(
        preamble: FirstPairPreambleResult,
        entrySource: Data = FirstPairSourceSlice.bundled6388f0LowSeedEntrySource,
        staticScalarWindow: Data? = nil,
        maxAttempts: Int = 64,
        entropySource: (Int) throws -> Data
    ) throws -> FirstPairPhase5KeyMaterial {
        try deriveFirstPairPhase5Material(
            entrySource: entrySource,
            sensorEphemeralPub65: preamble.phaseHandshake.sensorEphPub.x963Representation,
            sensorStaticPub65: preamble.phaseHandshake.sensorCert.staticPub,
            staticScalarWindow: staticScalarWindow ??
                preamble.phaseHandshake.phoneCert.phase5StaticScalarWindowOverride,
            maxAttempts: maxAttempts,
            entropySource: entropySource
        )
    }

    private static func uncompressedPointXYBE(_ point65: Data, label: String) throws -> Data {
        guard point65.count == 65, point65.first == 0x04 else {
            throw SessionKeyError.invalidSensorPointEncoding(
                label: label,
                count: point65.count,
                prefix: point65.first
            )
        }
        return Data(point65.dropFirst())
    }

    private static func material(from seeds: Builder6388f0FirstPairStreamSeeds) throws -> FirstPairPhase5KeyMaterial {
        let source = try FirstPairSourceSlice.deriveFrom6388f0FirstPairStreamSeeds(seeds: seeds)
        let rawKey = try Phase5KeySchedule.deriveRawKey(input66: source)
        return FirstPairPhase5KeyMaterial(
            source66: source,
            rawKey: rawKey,
            nullEntropy11A: seeds.nullEntropy11A,
            nullScalarWindow: seeds.nullScalarWindow,
            nullAttempts: seeds.nullAttempts
        )
    }
}
