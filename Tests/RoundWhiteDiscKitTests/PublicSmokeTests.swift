import XCTest
@testable import RoundWhiteDiscKit

final class PublicSmokeTests: XCTestCase {
    private let usableRealtimePlaintext = Data([
        0x31, 0x04, 0x97, 0x00, 0x44, 0x00, 0x00, 0x00,
        0xe4, 0x3e, 0x1f, 0x04, 0x84, 0x00, 0x0b, 0x97,
        0x00, 0x84, 0x00, 0x00, 0x80, 0xf0, 0x06, 0x58,
        0x4b, 0x76, 0x0e, 0x00, 0x08,
    ])

    func testReceiverIDLittleEndianRoundTrip() throws {
        let receiverID = try Libre3ReceiverID(littleEndianHex: "78563412")

        XCTAssertEqual(receiverID.value, 0x12345678)
        XCTAssertEqual(receiverID.littleEndianHex, "78563412")
    }

    func testSensorStateRoundTripUsesPublicShapeOnly() throws {
        let state = try Libre3SensorState(
            serialNumber: "TEST123",
            blePIN: Data([0x01, 0x02, 0x03, 0x04]),
            bleAddress: "00:11:22:33:44:55",
            receiverID: Libre3ReceiverID(0x12345678),
            source: "unit-test",
            lastGlucoseLifeCount: 1073,
            lastGlucoseMgDL: 151
        )

        let encoded = try Libre3SensorStateLoader.jsonData(from: state)
        let decoded = try Libre3SensorStateLoader.load(fromJSON: encoded)

        XCTAssertEqual(decoded, state)

        let dataPlaneState = Libre3DataPlaneState(sensorState: decoded)
        XCTAssertEqual(dataPlaneState.lastAcceptedGlucoseLifeCount, 1073)
        XCTAssertEqual(dataPlaneState.lastAcceptedGlucoseMgDL, 151)
        XCTAssertEqual(
            dataPlaneState.reconnectBackfillCommands(includeClinical: false).first?.plaintext,
            Data([0x01, 0x00, 0x01, 0x31, 0x04, 0x00, 0x00])
        )
    }

    func testAuthorizationHandshakeRejectsNonFourByteTailBeforeTransportUse() async throws {
        let flow = try PairingFlow(
            transport: FailingCommandPairingTransport(),
            phoneCert: dummyPhoneCert()
        )

        do {
            _ = try await flow.runCommandGatedAuthorizationHandshake(
                tail4: Data([0x01, 0x02, 0x03]),
                phase5RawKeyProvider: { _ in Data(repeating: 0, count: 16) }
            )
            XCTFail("Expected tail4 size validation failure")
        } catch PairingFlowError.tail4WrongSize(let count) {
            XCTAssertEqual(count, 3)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func testCachedReconnectHandshakeSkipsCertAndEphemeralExchange() async throws {
        try installRuntimeTablesForTests()
        let sensorR1 = Data((0x10..<0x20).map(UInt8.init))
        let challengeNonce = Data([0x21, 0x04, 0x00, 0x00, 0x8f, 0x8c, 0x4b])
        let phase6Nonce = Data([0x22, 0x04, 0x00, 0x00, 0x7f, 0x43, 0x8e])
        let phoneR2 = Data((0x30..<0x40).map(UInt8.init))
        let tail4 = Data([0x32, 0x25, 0xec, 0x72])
        let phase5RawKey = Data((0x40..<0x50).map(UInt8.init))
        let kEnc = Data((0x50..<0x60).map(UInt8.init))
        let ivEnc = Data((0x60..<0x68).map(UInt8.init))
        let aes = try LibAES.phase5BlockEncryptor(rawKey: phase5RawKey)
        let phase6Plaintext = phoneR2 + sensorR1 + kEnc + ivEnc
        let (phase6Ciphertext, phase6Tag) = try AESCCM.encrypt(
            nonce: phase6Nonce,
            plaintext: phase6Plaintext,
            tagLength: Phase6Response.tagSize,
            aes: aes
        )
        let transport = ScriptedCommandPairingTransport(
            commandResponses: [
                Data([0x08, 0x17]),
                Data([0x08, 0x43]),
            ],
            challengeNotifies: [
                sensorR1 + challengeNonce,
                phase6Ciphertext + phase6Tag + phase6Nonce,
            ]
        )
        let flow = PairingFlow(transport: transport)

        let result = try await flow.runCachedReconnectHandshake(
            tail4: tail4,
            phase5RawKeyProvider: { preamble in
                XCTAssertEqual(preamble.sensorR1, sensorR1)
                XCTAssertEqual(preamble.nonce7, challengeNonce)
                return phase5RawKey
            },
            r2Provider: { phoneR2 }
        )

        let commandWrites = await transport.commandWrites
        let messageWrites = await transport.messageWrites
        XCTAssertEqual(commandWrites, [0x11, 0x08])
        XCTAssertEqual(messageWrites.map(\.characteristic), [.challenge])
        XCTAssertEqual(messageWrites.first?.message.count, Phase5Challenge.wireSize)
        XCTAssertEqual(result.preamble.sensorR1Wire, sensorR1 + challengeNonce)
        XCTAssertEqual(result.sessionMaterial.phoneR2, phoneR2)
        XCTAssertEqual(result.sessionMaterial.sensorR1, sensorR1)
        XCTAssertEqual(result.sessionMaterial.kEnc, kEnc)
        XCTAssertEqual(result.sessionMaterial.ivEnc, ivEnc)
        XCTAssertEqual(
            try result.phase5Sent.decrypt(aes: aes, nonce: challengeNonce),
            sensorR1 + phoneR2 + tail4
        )
    }

    func testSensorCertificateVerifiesWithBundledPatchSigningKey() throws {
        let raw = try data(hex: "0157259416c6007ae00550043e1f46f25d44b3d72a8c37dcfebc7c339ed01fc5668a6387458084ac9cafebe7438b649f76b81eeca9343287da162b07c5c07362997e40e13035df14cdf3d5d81a5fe9ffc84de8c8ecc33be609bf0d8ebf97bed6bae899e181bb32960c81e99d5aab30b2fc7a77b0d45eff9885d46722371cd9375e14352d890f60fa1e7159e6")
        let cert = try SensorCert(raw: raw)

        XCTAssertEqual(cert.header, raw.prefix(11))
        XCTAssertEqual(cert.signedPayload, raw.prefix(76))
        XCTAssertFalse(try cert.verifyECDSA(with: Libre3PatchSigningKey.level0))
        XCTAssertTrue(try cert.verifyECDSA(with: Libre3PatchSigningKey.level1))
        XCTAssertEqual(try cert.verifiedSigningKeyIndex(), 1)
    }

    func testBundled162bCertIsLiveFirstPairFamilyAndEngagesPhase5Override() throws {
        try installRuntimeTablesForTests()
        let cert = try PhoneCert.bundled162b()

        XCTAssertEqual(cert.raw.count, PhoneCert.totalSize)
        XCTAssertTrue(cert.raw.prefix(2).elementsEqual([0x03, 0x03]))
        XCTAssertEqual(cert.staticPub.first, 0x04)
        XCTAssertEqual(
            cert.phase5StaticScalarWindowOverride,
            FirstPairStaticScalarWindow.firstPairIndex1
        )

        let firstPair = try PhoneCert.bundledFirstPair()
        XCTAssertTrue(firstPair.raw.prefix(2).elementsEqual([0x03, 0x00]))
        XCTAssertNil(firstPair.phase5StaticScalarWindowOverride)
    }

    func testRealtimeQualityFieldsGateUsability() throws {
        let reading = try RealtimeGlucoseReading(plaintext: usableRealtimePlaintext)

        XCTAssertEqual(reading.lifeCount, 1073)
        XCTAssertEqual(reading.currentGlucoseMgDL, 151)
        XCTAssertEqual(reading.historicalGlucoseMgDL, 132)
        XCTAssertEqual(reading.rateOfChangeMgDLPerMinute ?? .nan, 0.68, accuracy: 0.001)
        XCTAssertEqual(reading.trendKind, .stable)
        XCTAssertTrue(reading.isCurrentGlucoseUsable)
        XCTAssertTrue(reading.currentGlucoseQualityAssessment.isUsable)
    }

    func testWarmupLifecycleBlocksCurrentQualityAssessment() throws {
        let reading = try RealtimeGlucoseReading(plaintext: usableRealtimePlaintext)
        let lifecycle = SensorLifecycle(currentLifeCountMinutes: 12)
        let assessment = reading.currentGlucoseQualityAssessment(lifecycle: lifecycle)

        XCTAssertEqual(lifecycle.phase, .warmup)
        XCTAssertEqual(assessment.issues, [.sensorWarmup(remainingMinutes: 48)])
        XCTAssertFalse(assessment.isUsable)
        XCTAssertFalse(reading.isCurrentGlucoseUsable(lifecycle: lifecycle))
    }

    func testPatchStatusExposesDefaultWarmupLifecycle() throws {
        let plaintext = Data([
            0x0c, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x04, 0x0c, 0x00, 0x00, 0x00,
        ])

        let status = try PatchStatus(plaintext: plaintext)

        XCTAssertEqual(status.defaultLifecyclePhase, .warmup)
        XCTAssertTrue(status.isInDefaultWarmup)
        XCTAssertEqual(status.defaultLifecycle.remainingWarmupMinutes, 48)
    }

    func testDataPlaneStateCombinesPatchStatusLifecycleWithRealtimeQuality() throws {
        let reading = try RealtimeGlucoseReading(plaintext: usableRealtimePlaintext)
        let warmupStatus = try PatchStatus(plaintext: patchStatusPlaintext(currentLifeCount: 12))
        var state = Libre3DataPlaneState()

        let warmupUpdate = state.record(decodedPacket(payload: .patchStatus(warmupStatus), channel: .patchStatus))
        XCTAssertEqual(state.lifecyclePhase, .warmup)
        XCTAssertEqual(warmupUpdate, .patchStatus(warmupStatus, lifecycle: SensorLifecycle(currentLifeCountMinutes: 12)))

        let warmupReadingUpdate = state.record(decodedPacket(payload: .realtimeGlucose(reading), channel: .glucoseData))
        guard case .realtimeGlucose(_, let warmupAssessment) = warmupReadingUpdate else {
            return XCTFail("Expected realtime glucose update")
        }
        XCTAssertEqual(warmupAssessment.issues, [.sensorWarmup(remainingMinutes: 48)])
        XCTAssertFalse(warmupAssessment.isUsable)
        XCTAssertNil(state.lastAcceptedGlucoseLifeCount)

        let activeStatus = try PatchStatus(plaintext: patchStatusPlaintext(currentLifeCount: 75))
        _ = state.record(decodedPacket(payload: .patchStatus(activeStatus), channel: .patchStatus))
        XCTAssertTrue(state.latestQualityAssessment?.isUsable == true)
        XCTAssertEqual(state.lastAcceptedGlucoseLifeCount, 1073)

        let activeReadingUpdate = state.record(decodedPacket(payload: .realtimeGlucose(reading), channel: .glucoseData))
        guard case .realtimeGlucose(_, let activeAssessment) = activeReadingUpdate else {
            return XCTFail("Expected realtime glucose update")
        }
        XCTAssertEqual(state.lifecyclePhase, .active)
        XCTAssertTrue(activeAssessment.isUsable)
        XCTAssertEqual(state.lastAcceptedGlucoseLifeCount, 1073)
        XCTAssertEqual(state.lastAcceptedGlucoseMgDL, 151)
        XCTAssertEqual(
            state.reconnectBackfillCommands().map(\.plaintext),
            [
                Data([0x01, 0x00, 0x01, 0x31, 0x04, 0x00, 0x00]),
                Data([0x01, 0x01, 0x01, 0x31, 0x04, 0x00, 0x00]),
            ]
        )
        let persisted = try Libre3SensorState(
            serialNumber: "TEST123",
            blePIN: Data([0x01, 0x02, 0x03, 0x04])
        ).updatingLastAcceptedGlucose(from: state)
        XCTAssertEqual(persisted.lastGlucoseLifeCount, 1073)
        XCTAssertEqual(persisted.lastGlucoseMgDL, 151)

        let page = try HistoricalReadingPage(plaintext: historicalPagePlaintext(startLifeCount: 1050))
        _ = state.record(decodedPacket(payload: .historicalReadingPage(page), channel: .historicData))
        XCTAssertEqual(state.historicalBackfill.firstLifeCount, 1050)
        XCTAssertEqual(state.historicalBackfill.lastLifeCount, 1075)
    }

    func testNonDisplayableCurrentWordBlocksQualityAssessment() throws {
        var plaintext = usableRealtimePlaintext
        plaintext[2] = 0x97
        plaintext[3] = 0x80

        let reading = try RealtimeGlucoseReading(plaintext: plaintext)
        let assessment = reading.currentGlucoseQualityAssessment

        XCTAssertEqual(reading.dqError, .notDisplayable(rawValue: 0x8097))
        XCTAssertEqual(assessment.issues, [.currentDataQuality(.notDisplayable(rawValue: 0x8097))])
        XCTAssertFalse(assessment.isUsable)
    }

    func testNotActionableStatusIsAdvisoryAndDoesNotBlock() throws {
        var plaintext = usableRealtimePlaintext
        plaintext[14] = 0x03

        let reading = try RealtimeGlucoseReading(plaintext: plaintext)
        let assessment = reading.currentGlucoseQualityAssessment

        XCTAssertEqual(reading.actionability, .notActionable)
        // The issue is surfaced for visibility but classified as advisory, so it
        // does not suppress an otherwise-clean reading.
        XCTAssertEqual(assessment.issues, [.notActionable(.notActionable)])
        XCTAssertEqual(assessment.advisories, [.notActionable(.notActionable)])
        XCTAssertTrue(assessment.blockingIssues.isEmpty)
        XCTAssertTrue(assessment.isUsable)
        XCTAssertTrue(reading.isCurrentGlucoseUsable)
    }

    func testUnavailableCurrentGlucoseBlocksQualityAssessment() throws {
        var plaintext = usableRealtimePlaintext
        plaintext[15] = 0x00
        plaintext[16] = 0x00

        let reading = try RealtimeGlucoseReading(plaintext: plaintext)
        let assessment = reading.currentGlucoseQualityAssessment

        XCTAssertEqual(reading.currentGlucoseStatus, .unavailable(raw: 0))
        XCTAssertEqual(assessment.issues, [.currentGlucoseUnavailable(.unavailable(raw: 0))])
        XCTAssertFalse(assessment.isUsable)
    }

    private func patchStatusPlaintext(currentLifeCount: UInt16) -> Data {
        Data([
            UInt8(currentLifeCount & 0xff), UInt8((currentLifeCount >> 8) & 0xff),
            0x00, 0x00,
            0x00, 0x00,
            0x00,
            0x04,
            UInt8(currentLifeCount & 0xff), UInt8((currentLifeCount >> 8) & 0xff),
            0x00,
            0x00,
        ])
    }

    private func historicalPagePlaintext(startLifeCount: UInt16) -> Data {
        Data([
            UInt8(startLifeCount & 0xff), UInt8((startLifeCount >> 8) & 0xff),
            0x70, 0x00,
            0x71, 0x00,
            0x72, 0x00,
            0x73, 0x00,
            0x74, 0x00,
            0x75, 0x00,
        ])
    }

    private func dummyPhoneCert() throws -> PhoneCert {
        var bytes = [UInt8](repeating: 0, count: PhoneCert.totalSize)
        bytes[PhoneCert.pubkeyRange.lowerBound] = 0x04
        return try PhoneCert(raw: Data(bytes))
    }

    private func decodedPacket(
        payload: DataPlaneDecodedPayload,
        channel: DataPlaneChannel
    ) -> DataPlaneDecodedPacket {
        DataPlaneDecodedPacket(
            channel: channel,
            frame: DataFrame(encrypted: Data(), seq: 0, type: 0),
            kind: channel.preferredInboundKind ?? .kind0,
            preferredKind: channel.preferredInboundKind,
            plaintext: Data(),
            payload: payload
        )
    }

    private func data(hex: String) throws -> Data {
        let cleaned = hex.filter { !$0.isWhitespace }
        guard cleaned.count.isMultiple(of: 2) else {
            throw NSError(domain: "PublicSmokeTests", code: 1)
        }

        var bytes = [UInt8]()
        bytes.reserveCapacity(cleaned.count / 2)
        var index = cleaned.startIndex
        while index < cleaned.endIndex {
            let next = cleaned.index(index, offsetBy: 2)
            guard let byte = UInt8(cleaned[index..<next], radix: 16) else {
                throw NSError(domain: "PublicSmokeTests", code: 2)
            }
            bytes.append(byte)
            index = next
        }
        return Data(bytes)
    }
}

private final class FailingCommandPairingTransport: CommandPairingTransport, @unchecked Sendable {
    func write(_ message: Data, to characteristic: BleCharRef) async throws {
        XCTFail("Transport should not be used before tail4 validation")
        throw UnexpectedTransportUse()
    }

    func awaitNotify(on characteristic: BleCharRef, exactly n: Int) async throws -> Data {
        XCTFail("Transport should not be used before tail4 validation")
        throw UnexpectedTransportUse()
    }

    func writeCommand(_ command: UInt8) async throws {
        XCTFail("Transport should not be used before tail4 validation")
        throw UnexpectedTransportUse()
    }

    func awaitCommandResponse(timeout: TimeInterval) async throws -> Data {
        XCTFail("Transport should not be used before tail4 validation")
        throw UnexpectedTransportUse()
    }
}

private struct UnexpectedTransportUse: Error {}

private actor ScriptedCommandPairingTransport: CommandPairingTransport {
    struct MessageWrite: Equatable {
        let characteristic: BleCharRef
        let message: Data
    }

    private var pendingCommandResponses: [Data]
    private var pendingChallengeNotifies: [Data]
    private(set) var commandWrites: [UInt8] = []
    private(set) var messageWrites: [MessageWrite] = []

    init(commandResponses: [Data], challengeNotifies: [Data]) {
        self.pendingCommandResponses = commandResponses
        self.pendingChallengeNotifies = challengeNotifies
    }

    func write(_ message: Data, to characteristic: BleCharRef) async throws {
        messageWrites.append(MessageWrite(characteristic: characteristic, message: message))
    }

    func awaitNotify(on characteristic: BleCharRef, exactly n: Int) async throws -> Data {
        guard characteristic == .challenge, !pendingChallengeNotifies.isEmpty else {
            throw UnexpectedTransportUse()
        }
        let next = pendingChallengeNotifies.removeFirst()
        guard next.count == n else {
            throw UnexpectedTransportUse()
        }
        return next
    }

    func writeCommand(_ command: UInt8) async throws {
        commandWrites.append(command)
    }

    func awaitCommandResponse(timeout: TimeInterval) async throws -> Data {
        guard !pendingCommandResponses.isEmpty else {
            throw UnexpectedTransportUse()
        }
        return pendingCommandResponses.removeFirst()
    }
}
