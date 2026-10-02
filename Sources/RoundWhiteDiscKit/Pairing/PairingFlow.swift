import Foundation
import CryptoKit
import Security

// Drives the Libre 3 BLE pairing handshake (Phases 1..7) over a
// `PairingTransport`. This module contains ONLY the orchestration; the
// per-phase data formats live in `PhoneCert.swift`, `SensorCert.swift`,
// and `EphemeralExchange.swift`, and the transport-side framing lives
// in `BleFraming.swift`.
//
// What runs offline against captured wire bytes (covered by tests):
//   Phase 1  send phone cert (162B → 9 fragmented writes)
//   Phase 2  receive sensor cert (140B notify) + parse
//   Phase 3  send phone ephemeral pubkey (65B padded to 72B / 4 writes)
//   Phase 4  receive sensor ephemeral pubkey (65B notify) + 3DH ECDH math
//   Cached reconnect starts at StartAuthorization (0x11), then Phase 5/6.
//
// First-pair Phase 5 plaintext is pinned as `R1 || R2 || blePIN`. The wire
// driver still accepts an injected raw key; callers can now derive one from
// `SessionKey.deriveFirstPairPhase5Material(...)` once they have accepted null
// entropy and have chosen the bundled entry source policy.

public struct PairingHandshakeResult: Sendable {
    public let phoneCert: PhoneCert
    public let sensorCert: SensorCert
    public let sensorCertSigningKeyIndex: Int?
    public let phoneEph: EphemeralKeyPair
    public let sensorEphPub: P256.KeyAgreement.PublicKey
    /// ECDH(phone_eph_priv, sensor_static_pub).
    public let sharedEphStatic: Data
    /// ECDH(phone_eph_priv, sensor_eph_pub).
    public let sharedEphEph: Data
}

/// Result of running the takeover-mode handshake (Phases 1–6 with cached
/// kAuth state). On success, the sensor has accepted us as the authorized
/// peer and we hold all session keys needed for data exchange.
public struct TakeoverHandshakeResult: Sendable {
    public let phaseHandshake: PairingHandshakeResult
    /// Sensor's R1 challenge (16B random) extracted from Phase 4.5 notify.
    public let sensorR1: Data
    /// The Phase 5 message we sent (for replay/debug).
    public let phase5Sent: Phase5Challenge
    /// Raw 67B Phase 6 body we received from the sensor.
    public let phase6Raw: Data
    /// Parsed Phase 6 response (ct56 || tag4 || nonce7).
    public let phase6: Phase6Response
    /// Decrypted Phase 6 session material: R2 || R1 || kEnc || ivEnc8.
    public let sessionMaterial: Phase6SessionMaterial
    /// The unwrapped kAuth state used to drive this handshake.
    public let kAuthState: UnwrappedKAuth
}

/// Result of the command-gated fresh-pair preamble through the sensor's
/// Phase 10 R1 challenge. This intentionally stops before the Phase 5 phone
/// response because the first-pair Phase 5 key-source agreement path is not
/// grounded yet.
public struct FirstPairPreambleResult: Sendable {
    public let phaseHandshake: PairingHandshakeResult
    public let sensorR1Wire: Data
    public let sensorR1: Data
    public let nonce7: Data
}

/// The command-gated authorization preamble is the same wire operation used by
/// first-pair and reconnect after a sensor is already known. The older
/// `FirstPairPreambleResult` name is kept for source compatibility.
public typealias CommandGatedAuthorizationPreambleResult = FirstPairPreambleResult

/// Result of the command-gated fresh-pair handshake through Phase 6. The
/// Phase 5 raw key is supplied by the caller so the BLE state machine remains
/// decoupled from source-builder policy and entropy generation.
public struct FirstPairHandshakeResult: Sendable {
    public let preamble: FirstPairPreambleResult
    public let phase5Sent: Phase5Challenge
    public let phase6Raw: Data
    public let phase6: Phase6Response
    public let sessionMaterial: Phase6SessionMaterial
}

/// The Phase 5/6 command-gated authorization result. This is typealiased to the
/// historical first-pair result shape because the bytes and returned material
/// are identical once the caller supplies the accepted 4-byte Phase 5 tail.
public typealias CommandGatedAuthorizationHandshakeResult = FirstPairHandshakeResult

/// Result of the pristine-style cached/direct reconnect preamble. This starts
/// at `StartAuthorization` and intentionally skips certificate and ephemeral
/// exchange.
public struct CachedReconnectPreambleResult: Sendable {
    public let sensorR1Wire: Data
    public let sensorR1: Data
    public let nonce7: Data
}

/// Result of the cached/direct reconnect handshake through Phase 6.
public struct CachedReconnectHandshakeResult: Sendable {
    public let preamble: CachedReconnectPreambleResult
    public let phase5Sent: Phase5Challenge
    public let phase6Raw: Data
    public let phase6: Phase6Response
    public let sessionMaterial: Phase6SessionMaterial
}

/// Result of the command-gated fresh-pair handshake when the Phase 5 material
/// is derived by the clean-room first-pair source builder.
public struct FirstPairDerivedHandshakeResult: Sendable {
    public let handshake: FirstPairHandshakeResult
    public let phase5Material: FirstPairPhase5KeyMaterial
}

/// Pairing/handshake errors.
///
/// **Classification note for clients:** living in the *pairing* enum does not
/// make a case a *credential* failure. Classify per case before letting any of
/// these contribute to a terminal / re-pair escalation:
///
/// - **Transport** (retry; do NOT escalate to re-pair): `writeTimeout` — a
///   timed-out GATT write is a link fault, not a bad credential. Treat like the
///   `SensorSessionError` cases.
/// - **Genuinely credential-shaped** (may indicate re-pair, but use a *generous*
///   threshold — a full-handshake fallback has repaired apparently
///   credential-related failures on real hardware): `phase6VerificationFailed`,
///   `phase5EphemeralPublicKeyMismatch`, `sensorCertificateVerificationFailed`.
/// - **Configuration / programmer / data-shape** (a retry loop won't help):
///   `sessionKeyDerivationNotImplemented`, `commandTransportRequired`,
///   `phoneCertRequired`, `phase5MaterialUnavailable`, `randomFailed`,
///   `sensorR1WrongSize` / `blePINWrongSize` / `tail4WrongSize`,
///   `unexpectedCommandResponse`.
public enum PairingFlowError: Error {
    case sessionKeyDerivationNotImplemented
    case commandTransportRequired
    case phoneCertRequired
    case unexpectedCommandResponse(label: String, expectedPrefix: Data, actual: Data)
    case sensorR1WrongSize(Int)
    case blePINWrongSize(Int)
    case tail4WrongSize(Int)
    /// Credential-shaped: Phase 6 verification failed. Use a generous re-pair
    /// threshold — a full-handshake fallback often recovers this.
    case phase6VerificationFailed(String)
    case phase5MaterialUnavailable
    /// Credential-shaped: cached ephemeral public key mismatch.
    case phase5EphemeralPublicKeyMismatch(expected: Data, actual: Data)
    case randomFailed(OSStatus)
    /// Transport: a GATT write timed out during the handshake. Retry — this is a
    /// link fault, NOT a credential failure, despite living in this enum.
    case writeTimeout(label: String, seconds: TimeInterval)
    /// Credential-shaped: the sensor certificate failed verification.
    case sensorCertificateVerificationFailed
}

@usableFromInline
func defaultPhase5R2() throws -> Data {
    try secureRandomData(count: 16)
}

@usableFromInline
func secureRandomData(count: Int) throws -> Data {
    guard count >= 0 else {
        throw PairingFlowError.randomFailed(errSecParam)
    }
    var bytes = [UInt8](repeating: 0, count: count)
    let status = bytes.withUnsafeMutableBytes { rawBuffer in
        guard let baseAddress = rawBuffer.baseAddress else { return errSecParam }
        return SecRandomCopyBytes(kSecRandomDefault, rawBuffer.count, baseAddress)
    }
    guard status == errSecSuccess else {
        throw PairingFlowError.randomFailed(status)
    }
    return Data(bytes)
}

public actor PairingFlow {
    let transport: PairingTransport
    let phoneCert: PhoneCert?
    let phoneEph: EphemeralKeyPair
    let sensorCertSigningKeys: [Data]
    private let eventLogger: (@Sendable (String) -> Void)?

    /// Create a flow for cached/direct reconnects that do not send a phone
    /// certificate or ephemeral public key. Calling full cert/ephemeral
    /// authorization methods on this instance throws `phoneCertRequired`.
    public init(
        transport: PairingTransport,
        sensorCertSigningKeys: [Data] = Libre3PatchSigningKey.known,
        eventLogger: (@Sendable (String) -> Void)? = nil
    ) {
        self.transport = transport
        self.phoneCert = nil
        self.phoneEph = EphemeralKeyPair()
        self.sensorCertSigningKeys = sensorCertSigningKeys
        self.eventLogger = eventLogger
    }

    public init(
        transport: PairingTransport,
        phoneCert: PhoneCert,
        phoneEph: EphemeralKeyPair = EphemeralKeyPair(),
        sensorCertSigningKeys: [Data] = Libre3PatchSigningKey.known,
        eventLogger: (@Sendable (String) -> Void)? = nil
    ) {
        self.transport = transport
        self.phoneCert = phoneCert
        self.phoneEph = phoneEph
        self.sensorCertSigningKeys = sensorCertSigningKeys
        self.eventLogger = eventLogger
    }

    /// Run Phases 1..4. Phase 5+ requires the session-key derivation
    /// to be pinned down; that work happens in a follow-up.
    public func runPhases1To4() async throws -> PairingHandshakeResult {
        guard let phoneCert else {
            throw PairingFlowError.phoneCertRequired
        }
        // Phase 1 — send phone cert (162B; framed into 9× (2B offset + 18B chunk))
        try await transport.write(phoneCert.raw, to: .certHandshake)

        // Phase 2 — receive 140B sensor cert + parse
        let sensorCertRaw = try await transport.awaitNotify(on: .certHandshake, exactly: SensorCert.totalSize)
        let sensorCert = try SensorCert(raw: sensorCertRaw)
        let sensorCertSigningKeyIndex = try verifySensorCertificate(sensorCert)

        // Phase 3 — send phone ephemeral pubkey (65B). The captured fresh-pair
        // padded the message to 72B = 4 fragments × 18B; we replicate that so
        // the wire bytes round-trip.
        let phase3Wire = padTo(phoneEph.publicKey65, length: 72)
        try await transport.write(phase3Wire, to: .certHandshake)

        // Phase 4 — receive 65B sensor ephemeral pubkey + ECDH math
        let sensorEphRaw = try await transport.awaitNotify(on: .certHandshake, exactly: 65)
        let sensorEphPub = try EphemeralExchange.parsePeerPubkey(sensorEphRaw)
        let sensorStaticPub = try EphemeralExchange.parsePeerPubkey(sensorCert.staticPub)

        let sharedEphStatic = try EphemeralExchange.sharedSecret(
            privateKey: phoneEph.privateKey,
            peer: sensorStaticPub
        )
        let sharedEphEph = try EphemeralExchange.sharedSecret(
            privateKey: phoneEph.privateKey,
            peer: sensorEphPub
        )

        return PairingHandshakeResult(
            phoneCert: phoneCert,
            sensorCert: sensorCert,
            sensorCertSigningKeyIndex: sensorCertSigningKeyIndex,
            phoneEph: phoneEph,
            sensorEphPub: sensorEphPub,
            sharedEphStatic: sharedEphStatic,
            sharedEphEph: sharedEphEph
        )
    }

    /// Run the command-gated fresh-pair security preamble decoded from
    /// `captures/fresh_pair_2026_04_26/btsnoop_hci.log` and
    /// `findings/PROTOCOL_STATE_MACHINE_2026_05_02.md`.
    ///
    /// The sequence reaches the point where the sensor has emitted its 23B
    /// `R1 || nonce7` challenge. It does not send the Phase 5 phone response;
    /// that remains gated on capturing or deriving the real first-pair Phase 5
    /// key source.
    public func runCommandGatedFirstPairPreamble(
        commandTimeout: TimeInterval = 2
    ) async throws -> FirstPairPreambleResult {
        guard let phoneCert else {
            throw PairingFlowError.phoneCertRequired
        }
        guard let commandTransport = transport as? CommandPairingTransport else {
            throw PairingFlowError.commandTransportRequired
        }

        func waitFor(_ expectedPrefix: Data, label: String) async throws {
            log("wait \(label) expectedPrefix=\(Self.hex(expectedPrefix))")
            let actual = try await commandTransport.awaitCommandResponse(timeout: commandTimeout)
            log("got \(label) response=\(Self.hex(actual))")
            guard actual.starts(with: expectedPrefix) else {
                throw PairingFlowError.unexpectedCommandResponse(
                    label: label,
                    expectedPrefix: expectedPrefix,
                    actual: actual
                )
            }
        }

        let writeTimeout: TimeInterval = 2

        log("preamble start")
        log("send StartAuthentication 0x01")
        try await withWriteTimeout(writeTimeout, label: "StartAuthentication") {
            try await commandTransport.writeCommand(0x01)
        }
        log("send LoadCertificate 0x02")
        try await withWriteTimeout(writeTimeout, label: "LoadCertificate") {
            try await commandTransport.writeCommand(0x02)
        }

        log("send phone cert len=\(phoneCert.raw.count)")
        try await withWriteTimeout(writeTimeout, label: "phoneCertWrite") {
            try await self.transport.write(phoneCert.raw, to: .certHandshake)
        }

        log("send SendCertificateLoadDone 0x03")
        try await withWriteTimeout(writeTimeout, label: "SendCertificateLoadDone") {
            try await commandTransport.writeCommand(0x03)
        }
        try await waitFor(Data([0x04]), label: "CertificateAccepted")

        log("send GetCertificate 0x09")
        try await withWriteTimeout(writeTimeout, label: "GetCertificate") {
            try await commandTransport.writeCommand(0x09)
        }
        try await waitFor(Data([0x0a]), label: "CertificateReady")

        log("await sensor cert")
        let sensorCertRaw = try await transport.awaitNotify(on: .certHandshake, exactly: SensorCert.totalSize)
        let sensorCert = try SensorCert(raw: sensorCertRaw)
        let sensorCertSigningKeyIndex = try verifySensorCertificate(sensorCert)
        log("parsed sensor cert len=\(sensorCertRaw.count)")
        log("sensor static pub=\(Self.hex(sensorCert.staticPub)) certKeyIndex=\(sensorCertSigningKeyIndex.map(String.init) ?? "skipped")")

        log("send ValidateCertificate 0x0d")
        try await withWriteTimeout(writeTimeout, label: "ValidateCertificate") {
            try await commandTransport.writeCommand(0x0d)
        }

        let phase3Wire = padTo(phoneEph.publicKey65, length: 72)
        log("send phone ephemeral len=\(phase3Wire.count)")
        try await withWriteTimeout(writeTimeout, label: "phoneEphemeralWrite") {
            try await self.transport.write(phase3Wire, to: .certHandshake)
        }

        log("send SendEphemeralDone 0x0e")
        try await withWriteTimeout(writeTimeout, label: "SendEphemeralDone") {
            try await commandTransport.writeCommand(0x0e)
        }
        try await waitFor(Data([0x0f]), label: "EphemeralReady")

        log("await sensor ephemeral")
        let sensorEphRaw = try await transport.awaitNotify(on: .certHandshake, exactly: 65)
        let sensorEphPub = try EphemeralExchange.parsePeerPubkey(sensorEphRaw)
        log("sensor ephemeral pub=\(Self.hex(sensorEphRaw))")
        let sensorStaticPub = try EphemeralExchange.parsePeerPubkey(sensorCert.staticPub)
        let sharedEphStatic = try EphemeralExchange.sharedSecret(
            privateKey: phoneEph.privateKey,
            peer: sensorStaticPub
        )
        let sharedEphEph = try EphemeralExchange.sharedSecret(
            privateKey: phoneEph.privateKey,
            peer: sensorEphPub
        )
        let p4 = PairingHandshakeResult(
            phoneCert: phoneCert,
            sensorCert: sensorCert,
            sensorCertSigningKeyIndex: sensorCertSigningKeyIndex,
            phoneEph: phoneEph,
            sensorEphPub: sensorEphPub,
            sharedEphStatic: sharedEphStatic,
            sharedEphEph: sharedEphEph
        )
        log("computed ECDH static=\(sharedEphStatic.count)B eph=\(sharedEphEph.count)B")

        log("send StartAuthorization 0x11")
        try await commandTransport.writeCommand(0x11) // StartAuthorization
        try await waitFor(Data([0x08]), label: "ChallengeLoadDone")

        log("await R1 challenge")
        let r1Wire = try await transport.awaitNotify(on: .challenge, exactly: 23)
        guard r1Wire.count == 23 else {
            throw PairingFlowError.sensorR1WrongSize(r1Wire.count)
        }
        let sensorR1 = r1Wire.subdata(in: 0..<16)
        let nonce7 = r1Wire.subdata(in: 16..<23)
        log("preamble complete R1=\(Self.hex(sensorR1)) nonce7=\(Self.hex(nonce7))")
        return FirstPairPreambleResult(
            phaseHandshake: p4,
            sensorR1Wire: r1Wire,
            sensorR1: sensorR1,
            nonce7: nonce7
        )
    }

    /// Semantic alias for the command-gated cert/ephemeral/challenge preamble
    /// used by both first-pair candidates and saved-state reconnect/recovery.
    public func runCommandGatedAuthorizationPreamble(
        commandTimeout: TimeInterval = 2
    ) async throws -> CommandGatedAuthorizationPreambleResult {
        try await runCommandGatedFirstPairPreamble(commandTimeout: commandTimeout)
    }

    /// Run the cached/direct reconnect preamble observed in pristine
    /// post-pairing reconnects.
    ///
    /// Wire shape:
    ///   `0x11 StartAuthorization`
    ///   → command notify prefix `0x08`
    ///   → challenge notify `R1_16 || nonce7`.
    ///
    /// This path skips `StartAuthentication`, phone certificate, sensor
    /// certificate, phone ephemeral, and sensor ephemeral. It only succeeds
    /// when the caller already has cached Phase 5 material accepted by the
    /// sensor for the saved receiver/session state.
    public func runCachedReconnectPreamble(
        commandTimeout: TimeInterval = 2
    ) async throws -> CachedReconnectPreambleResult {
        guard let commandTransport = transport as? CommandPairingTransport else {
            throw PairingFlowError.commandTransportRequired
        }

        func waitFor(_ expectedPrefix: Data, label: String) async throws {
            log("wait \(label) expectedPrefix=\(Self.hex(expectedPrefix))")
            let actual = try await commandTransport.awaitCommandResponse(timeout: commandTimeout)
            log("got \(label) response=\(Self.hex(actual))")
            guard actual.starts(with: expectedPrefix) else {
                throw PairingFlowError.unexpectedCommandResponse(
                    label: label,
                    expectedPrefix: expectedPrefix,
                    actual: actual
                )
            }
        }

        log("cached reconnect preamble start")
        log("send StartAuthorization 0x11")
        try await withWriteTimeout(2, label: "StartAuthorization") {
            try await commandTransport.writeCommand(0x11)
        }
        try await waitFor(Data([0x08]), label: "ChallengeLoadDone")

        log("await cached reconnect R1 challenge")
        let r1Wire = try await transport.awaitNotify(on: .challenge, exactly: 23)
        guard r1Wire.count == 23 else {
            throw PairingFlowError.sensorR1WrongSize(r1Wire.count)
        }
        let sensorR1 = r1Wire.subdata(in: 0..<16)
        let nonce7 = r1Wire.subdata(in: 16..<23)
        log("cached reconnect preamble complete R1=\(Self.hex(sensorR1)) nonce7=\(Self.hex(nonce7))")
        return CachedReconnectPreambleResult(
            sensorR1Wire: r1Wire,
            sensorR1: sensorR1,
            nonce7: nonce7
        )
    }

    /// Run pristine-style cached/direct reconnect through Phase 6.
    ///
    /// This is the shortest observed successful post-pairing reconnect path:
    /// it starts at `StartAuthorization`, sends a Phase 5 response derived from
    /// cached/saved state, then verifies the Phase 6 session material. If the
    /// sensor rejects this path, integrations should fall back to the full
    /// command-gated authorization path.
    public func runCachedReconnectHandshake(
        tail4: Data,
        phase5RawKeyProvider: (CachedReconnectPreambleResult) throws -> Data,
        r2Provider: () throws -> Data = defaultPhase5R2,
        commandTimeout: TimeInterval = 2
    ) async throws -> CachedReconnectHandshakeResult {
        guard tail4.count == 4 else {
            throw PairingFlowError.tail4WrongSize(tail4.count)
        }

        log("cached reconnect handshake start tail4=\(Self.hex(tail4))")
        let preamble = try await runCachedReconnectPreamble(commandTimeout: commandTimeout)
        let phase5R2 = try r2Provider()
        log("generated R2 len=\(phase5R2.count) data=\(Self.hex(phase5R2))")
        guard phase5R2.count == 16 else {
            throw ChallengeError.wrongPlaintextSize(preamble.sensorR1.count + phase5R2.count + tail4.count)
        }

        let phase5RawKey = try phase5RawKeyProvider(preamble)
        log("derived cached reconnect Phase 5 raw key len=\(phase5RawKey.count) data=\(Self.hex(phase5RawKey))")
        guard phase5RawKey.count == 16 else {
            throw ChallengeError.wrongKeySize(phase5RawKey.count)
        }
        let phase5Block = try LibAES.phase5BlockEncryptor(rawKey: phase5RawKey)
        let phase5Plaintext = preamble.sensorR1 + phase5R2 + tail4
        let phase5 = try Phase5Challenge.encrypt(
            plaintext: phase5Plaintext,
            aes: phase5Block,
            nonce: preamble.nonce7
        )
        log("send cached reconnect Phase 5 len=\(phase5.wireBytes.count) data=\(Self.hex(phase5.wireBytes))")
        try await withWriteTimeout(2, label: "cachedReconnectPhase5Write") {
            try await self.transport.write(phase5.wireBytes, to: .challenge)
        }
        try await sendChallengeLoadDoneIfAvailable(commandTimeout: commandTimeout)

        log("await cached reconnect Phase 6")
        let phase6Raw = try await transport.awaitNotify(on: .challenge, exactly: Phase6Response.wireSize)
        let phase6 = try Phase6Response.decode(phase6Raw)
        let sessionMaterial = try phase6.decrypt(aes: phase5Block)
        guard sessionMaterial.phoneR2 == phase5R2 else {
            throw PairingFlowError.phase6VerificationFailed("Phase 6 R2 echo mismatch")
        }
        guard sessionMaterial.sensorR1 == preamble.sensorR1 else {
            throw PairingFlowError.phase6VerificationFailed("Phase 6 R1 echo mismatch")
        }

        return CachedReconnectHandshakeResult(
            preamble: preamble,
            phase5Sent: phase5,
            phase6Raw: phase6Raw,
            phase6: phase6,
            sessionMaterial: sessionMaterial
        )
    }

    /// Convenience overload for callers that already have the cached/direct
    /// reconnect Phase 5 raw key, for example from
    /// `Child23KAuthImport.phase5RawKey(forKAuthBlob:)`.
    public func runCachedReconnectHandshake(
        tail4: Data,
        phase5RawKey: Data,
        r2Provider: () throws -> Data = defaultPhase5R2,
        commandTimeout: TimeInterval = 2
    ) async throws -> CachedReconnectHandshakeResult {
        try await runCachedReconnectHandshake(
            tail4: tail4,
            phase5RawKeyProvider: { _ in phase5RawKey },
            r2Provider: r2Provider,
            commandTimeout: commandTimeout
        )
    }

    /// Run the command-gated authorization handshake through Phase 6 using an
    /// injected Phase 5 raw key.
    ///
    /// This is the reusable full authorization wire driver for initial pairing
    /// candidates and saved-state reconnect/recovery fallback. For the shorter
    /// pristine-style saved-state reconnect attempt, use
    /// `runCachedReconnectHandshake(...)`.
    ///
    /// The key provider is called after the cert/ephemeral preamble and the
    /// sensor's `R1 || nonce7` notify, so source derivation can use the sensor
    /// cert, both ECDH secrets, R1, nonce, and the accepted 4-byte Phase 5 tail
    /// without changing this wire driver.
    public func runCommandGatedAuthorizationHandshake(
        tail4: Data,
        phase5RawKeyProvider: (CommandGatedAuthorizationPreambleResult) throws -> Data,
        r2Provider: () throws -> Data = defaultPhase5R2,
        commandTimeout: TimeInterval = 2
    ) async throws -> CommandGatedAuthorizationHandshakeResult {
        guard tail4.count == 4 else {
            throw PairingFlowError.tail4WrongSize(tail4.count)
        }

        log("authorization handshake start tail4=\(Self.hex(tail4))")
        let preamble = try await runCommandGatedFirstPairPreamble(commandTimeout: commandTimeout)
        let phase5R2 = try r2Provider()
        log("generated R2 len=\(phase5R2.count) data=\(Self.hex(phase5R2))")
        guard phase5R2.count == 16 else {
            throw ChallengeError.wrongPlaintextSize(preamble.sensorR1.count + phase5R2.count + tail4.count)
        }

        let phase5RawKey = try phase5RawKeyProvider(preamble)
        log("derived Phase 5 raw key len=\(phase5RawKey.count) data=\(Self.hex(phase5RawKey))")
        guard phase5RawKey.count == 16 else {
            throw ChallengeError.wrongKeySize(phase5RawKey.count)
        }
        let phase5Block = try LibAES.phase5BlockEncryptor(rawKey: phase5RawKey)
        let phase5Plaintext = preamble.sensorR1 + phase5R2 + tail4
        let phase5 = try Phase5Challenge.encrypt(
            plaintext: phase5Plaintext,
            aes: phase5Block,
            nonce: preamble.nonce7
        )
        log("send Phase 5 len=\(phase5.wireBytes.count) data=\(Self.hex(phase5.wireBytes))")
        try await withWriteTimeout(2, label: "authorizationPhase5Write") {
            try await self.transport.write(phase5.wireBytes, to: .challenge)
        }
        try await sendChallengeLoadDoneIfAvailable(commandTimeout: commandTimeout)

        log("await Phase 6")
        let phase6Raw = try await transport.awaitNotify(on: .challenge, exactly: Phase6Response.wireSize)
        let phase6 = try Phase6Response.decode(phase6Raw)
        let sessionMaterial = try phase6.decrypt(aes: phase5Block)
        guard sessionMaterial.phoneR2 == phase5R2 else {
            throw PairingFlowError.phase6VerificationFailed("Phase 6 R2 echo mismatch")
        }
        guard sessionMaterial.sensorR1 == preamble.sensorR1 else {
            throw PairingFlowError.phase6VerificationFailed("Phase 6 R1 echo mismatch")
        }

        return FirstPairHandshakeResult(
            preamble: preamble,
            phase5Sent: phase5,
            phase6Raw: phase6Raw,
            phase6: phase6,
            sessionMaterial: sessionMaterial
        )
    }

    /// Backward-compatible first-pair spelling for callers that supply the NFC
    /// BLE PIN as the 4-byte Phase 5 tail.
    public func runCommandGatedFirstPairHandshake(
        blePIN: Data,
        phase5RawKeyProvider: (FirstPairPreambleResult) throws -> Data,
        r2Provider: () throws -> Data = defaultPhase5R2,
        commandTimeout: TimeInterval = 2
    ) async throws -> FirstPairHandshakeResult {
        guard blePIN.count == 4 else {
            throw PairingFlowError.blePINWrongSize(blePIN.count)
        }
        log("first-pair handshake start blePIN=\(Self.hex(blePIN))")
        return try await runCommandGatedAuthorizationHandshake(
            tail4: blePIN,
            phase5RawKeyProvider: phase5RawKeyProvider,
            r2Provider: r2Provider,
            commandTimeout: commandTimeout
        )
    }

    private func log(_ message: String) {
        eventLogger?("PairingFlow: \(message)")
    }

    /// Races `work` against a wall-clock timeout. Used to bound BLE
    /// `writeCommand` / `write` calls — those await CoreBluetooth's
    /// didWriteValueFor callback, which never fires on a half-dead link.
    /// Field log captured 10 minutes of foreground silence after
    /// `send StartAuthentication 0x01` was written but the sensor never
    /// acknowledged; without this the awaits park indefinitely.
    private func withWriteTimeout<T: Sendable>(
        _ seconds: TimeInterval,
        label: String,
        _ work: @Sendable @escaping () async throws -> T
    ) async throws -> T {
        let box = WriteTimeoutBox<T>()
        return try await withCheckedThrowingContinuation { (cont: CheckedContinuation<T, Error>) in
            let workTask = Task.detached {
                do {
                    let value = try await work()
                    box.resume(.success(value), with: cont)
                } catch {
                    box.resume(.failure(error), with: cont)
                }
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + seconds) {
                if box.timeout(with: cont, label: label, seconds: seconds) {
                    workTask.cancel()
                }
            }
        }
    }

    private func verifySensorCertificate(_ sensorCert: SensorCert) throws -> Int? {
        guard !sensorCertSigningKeys.isEmpty else {
            log("sensor cert verification skipped")
            return nil
        }
        guard let index = try sensorCert.verifiedSigningKeyIndex(in: sensorCertSigningKeys) else {
            throw PairingFlowError.sensorCertificateVerificationFailed
        }
        log("sensor cert verified signingKeyIndex=\(index)")
        return index
    }

    /// Atomic single-resume guard for `withWriteTimeout`. Earlier
    /// `withThrowingTaskGroup` + `Task.sleep` implementation didn't fire
    /// reliably in production logs — possibly an actor-isolation
    /// interaction when called from this actor. This version uses
    /// `Task.detached` + `DispatchQueue.asyncAfter`, both well-tested
    /// primitives that race independently of the cooperative scheduler.
    private final class WriteTimeoutBox<T>: @unchecked Sendable {
        private let lock = NSLock()
        private var resumed = false

        func resume(_ result: Result<T, Error>, with cont: CheckedContinuation<T, Error>) {
            lock.lock()
            let already = resumed
            resumed = true
            lock.unlock()
            guard !already else { return }
            switch result {
            case .success(let v): cont.resume(returning: v)
            case .failure(let e): cont.resume(throwing: e)
            }
        }

        /// Returns true if this is the side that actually resumed (caller
        /// cancels the still-running work task in that case).
        func timeout(
            with cont: CheckedContinuation<T, Error>,
            label: String,
            seconds: TimeInterval
        ) -> Bool {
            lock.lock()
            let already = resumed
            resumed = true
            lock.unlock()
            guard !already else { return false }
            cont.resume(throwing: PairingFlowError.writeTimeout(label: label, seconds: seconds))
            return true
        }
    }

    nonisolated private static func hex(_ data: Data) -> String {
        data.map { String(format: "%02x", $0) }.joined()
    }

    private func sendChallengeLoadDoneIfAvailable(commandTimeout: TimeInterval = 2) async throws {
        guard let commandTransport = transport as? CommandPairingTransport else {
            return
        }
        log("send SendChallengeLoadDone 0x08")
        try await commandTransport.writeCommand(0x08)
        let actual = try await commandTransport.awaitCommandResponse(timeout: commandTimeout)
        log("got PatchChallengeLoadDone response=\(Self.hex(actual))")
        guard actual.starts(with: Data([0x08])) else {
            throw PairingFlowError.unexpectedCommandResponse(
                label: "PatchChallengeLoadDone",
                expectedPrefix: Data([0x08]),
                actual: actual
            )
        }
    }

    /// Run the command-gated fresh-pair handshake through Phase 6, deriving the
    /// Phase 5 source and raw key from the clean-room first-pair source builder
    /// after the sensor cert, sensor ephemeral point, and R1 challenge arrive.
    public func runCommandGatedFirstPairHandshake(
        blePIN: Data,
        entrySource: Data = FirstPairSourceSlice.bundled6388f0LowSeedEntrySource,
        maxEntropyAttempts: Int = 64,
        entropySource: (Int) throws -> Data,
        r2Provider: () throws -> Data = defaultPhase5R2,
        commandTimeout: TimeInterval = 2
    ) async throws -> FirstPairDerivedHandshakeResult {
        var material: FirstPairPhase5KeyMaterial?
        let handshake = try await runCommandGatedFirstPairHandshake(
            blePIN: blePIN,
            phase5RawKeyProvider: { preamble in
                let staticScalarWindow = preamble.phaseHandshake.phoneCert.phase5StaticScalarWindowOverride
                let derived = try SessionKey.deriveFirstPairPhase5Material(
                    preamble: preamble,
                    entrySource: entrySource,
                    staticScalarWindow: staticScalarWindow,
                    maxAttempts: maxEntropyAttempts,
                    entropySource: entropySource
                )
                eventLogger?(
                    "PairingFlow: derived Phase 5 material attempts=\(derived.nullAttempts) " +
                    "staticScalarOverride=\(staticScalarWindow?.count ?? 0)B " +
                    "nullScalarWindow=\(Self.hex(derived.nullScalarWindow)) " +
                    "nullEntropy11A=\(Self.hex(derived.nullEntropy11A)) " +
                    "source66=\(Self.hex(derived.source66)) rawKey=\(Self.hex(derived.rawKey))"
                )
                let expectedPhoneEph = try FirstPairSourceSlice.builderProcess2P5PublicKey65FromEntropy(
                    entropy11A: derived.nullEntropy11A
                )
                guard preamble.phaseHandshake.phoneEph.publicKey65 == expectedPhoneEph else {
                    throw PairingFlowError.phase5EphemeralPublicKeyMismatch(
                        expected: expectedPhoneEph,
                        actual: preamble.phaseHandshake.phoneEph.publicKey65
                    )
                }
                material = derived
                return derived.rawKey
            },
            r2Provider: r2Provider,
            commandTimeout: commandTimeout
        )
        guard let material else {
            throw PairingFlowError.phase5MaterialUnavailable
        }
        return FirstPairDerivedHandshakeResult(handshake: handshake, phase5Material: material)
    }

    /// Run the legacy full takeover handshake using a previously-unwrapped kAuth
    /// state. Drives Phases 1–6 against the sensor and returns once the
    /// sensor has issued its Phase 6 verification. This is the entry point
    /// for "talk to a sensor that's already paired with another phone".
    ///
    /// Wire flow:
    ///  - Phase 1–4: cert exchange + ECDH (existing `runPhases1To4`).
    ///    NOTE: pristine reconnect captures later showed a shorter cached path;
    ///    prefer `runCachedReconnectHandshake(...)` when the caller has cached
    ///    accepted Phase 5 material.
    ///  - Phase 4.5: receive 23B notify on `.challenge` containing sensor's
    ///    R1 (16B at offset [0..16] + 4B counter `01000000` + 3B trailing).
    ///  - Phase 5: AES-CCM-M=4 encrypt `R1 || R2 || tail4`, send 54B.
    ///  - Phase 6: receive 67B body, decrypt it, and verify echoed R2/R1.
    ///
    /// Callers with the raw 149B kAuth blob should pass the child[23]/ptr05
    /// key from `Child23KAuthImport.phase5RawKey(forKAuthBlob:)`, and should
    /// pass the persisted sensor `blePIN` as `tail4Provider`. The defaults
    /// preserve older capture-vector behavior for offline tests.
    public func runTakeoverHandshake(
        using kAuthState: UnwrappedKAuth,
        phase5RawKeyProvider: (UnwrappedKAuth) -> Data = { $0.kEnc },
        r2Provider: () throws -> Data = defaultPhase5R2,
        tail4Provider: () -> Data = { Data([0x32, 0x25, 0xec, 0x72]) }
    ) async throws -> TakeoverHandshakeResult {

        // Phase 1–4 (cert exchange + ECDH) fallback path.
        let p4 = try await runPhases1To4()

        // Phase 4.5: sensor sends its R1 challenge as a 23B notify.
        let r1Wire = try await transport.awaitNotify(on: .challenge, exactly: 23)
        guard r1Wire.count == 23 else {
            throw PairingFlowError.sensorR1WrongSize(r1Wire.count)
        }
        // R1 is the first 16 bytes; bytes [16..20] are counter `01000000`,
        // bytes [20..23] are protocol trailing.
        let sensorR1 = r1Wire.subdata(in: 0..<16)
        let nonce7 = r1Wire.subdata(in: 16..<23)

        let phase5R2 = try r2Provider()
        guard phase5R2.count == 16 else {
            throw ChallengeError.wrongPlaintextSize(sensorR1.count + phase5R2.count)
        }
        let tail4 = tail4Provider()
        guard tail4.count == 4 else {
            throw ChallengeError.wrongPlaintextSize(sensorR1.count + phase5R2.count + tail4.count)
        }
        let phase5RawKey = phase5RawKeyProvider(kAuthState)
        let phase5Plaintext = sensorR1 + phase5R2 + tail4
        let phase5Block = try LibAES.phase5BlockEncryptor(rawKey: phase5RawKey)
        let phase5 = try Phase5Challenge.encrypt(
            plaintext: phase5Plaintext,
            aes: phase5Block,
            nonce: nonce7
        )
        try await transport.write(phase5.wireBytes, to: .challenge)
        try await sendChallengeLoadDoneIfAvailable()

        // Phase 6: sensor responds with ct56 || tag4 || nonce7. Decrypt to
        // R2 || R1 || kEnc || ivEnc8 and verify the challenge echoes before
        // returning session keys to the caller.
        let phase6Raw = try await transport.awaitNotify(on: .challenge, exactly: 67)
        let phase6 = try Phase6Response.decode(phase6Raw)
        let sessionMaterial = try phase6.decrypt(aes: phase5Block)
        guard sessionMaterial.phoneR2 == phase5R2 else {
            throw PairingFlowError.phase6VerificationFailed("Phase 6 R2 echo mismatch")
        }
        guard sessionMaterial.sensorR1 == sensorR1 else {
            throw PairingFlowError.phase6VerificationFailed("Phase 6 R1 echo mismatch")
        }

        return TakeoverHandshakeResult(
            phaseHandshake: p4,
            sensorR1: sensorR1,
            phase5Sent: phase5,
            phase6Raw: phase6Raw,
            phase6: phase6,
            sessionMaterial: sessionMaterial,
            kAuthState: kAuthState
        )
    }
}

@inline(__always) func padTo(_ data: Data, length: Int) -> Data {
    if data.count >= length { return data }
    var out = Data(capacity: length)
    out.append(data)
    out.append(Data(count: length - data.count))
    return out
}
