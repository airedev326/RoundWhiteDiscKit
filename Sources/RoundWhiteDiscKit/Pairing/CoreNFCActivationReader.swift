import Foundation

#if os(iOS) && canImport(CoreNFC)
@preconcurrency import CoreNFC

@available(iOS 17.0, *)
public final class Libre3NFCActivationReader: NSObject, @unchecked Sendable {
    private let queue = DispatchQueue(label: "org.roundwhitedisc.nfc", qos: .userInitiated)
    private let lock = NSLock()
    private var session: NFCTagReaderSession?
    private var continuation: CheckedContinuation<Libre3NFCScanResult, Error>?
    private var mode: Libre3NFCScanMode?

    public func scan(mode: Libre3NFCScanMode) async throws -> Libre3NFCScanResult {
        guard NFCTagReaderSession.readingAvailable else {
            throw Libre3NFCError.readerUnavailable
        }

        return try await withCheckedThrowingContinuation { continuation in
            lock.lock()
            if self.continuation != nil {
                lock.unlock()
                continuation.resume(throwing: Libre3NFCError.sessionAlreadyActive)
                return
            }
            self.continuation = continuation
            self.mode = mode
            lock.unlock()

            let session = NFCTagReaderSession(pollingOption: [.iso15693], delegate: self, queue: queue)
            session?.alertMessage = LocalizedString(
                "Hold the TOP of your iPhone very close to the Sensor",
                comment: "NFC system sheet prompt while waiting for the sensor. TOP is capitalised deliberately: the antenna is at the iPhone's top edge, not its back."
            )
            self.session = session
            session?.begin()
        }
    }

    private func complete(_ result: Result<Libre3NFCScanResult, Error>, message: String? = nil) {
        lock.lock()
        let continuation = self.continuation
        self.continuation = nil
        self.mode = nil
        let session = self.session
        self.session = nil
        lock.unlock()

        switch result {
        case .success(let value):
            session?.alertMessage = message ?? LocalizedString(
                "Libre 3 NFC scan complete.",
                comment: "NFC system sheet, generic success when no more specific message applies"
            )
            session?.invalidate()
            continuation?.resume(returning: value)
        case .failure(let error):
            session?.invalidate(errorMessage: message ?? String(describing: error))
            continuation?.resume(throwing: error)
        }
    }

    private func run(tag: NFCISO15693Tag, in session: NFCTagReaderSession) async {
        do {
            guard let mode else {
                throw Libre3NFCError.noTag
            }

            let patchRaw = try await customCommand(
                tag: tag,
                code: 0xa1,
                parameters: NFCActivationCommand.readPatchInfoCustomRequestParameters
            )
            let patchInfo = try Libre3NFCPatchInfo(raw: patchRaw)

            switch mode {
            case .readPatchInfo:
                complete(
                    .success(Libre3NFCScanResult(patchInfo: patchInfo)),
                    message: LocalizedString(
                        "Libre 3 sensor read.",
                        comment: "NFC system sheet, success after reading patch info without changing the sensor"
                    )
                )

            case .activateFreshSensor(let receiverID, let explicitTime):
                guard patchInfo.recommendedCommandCode == .activate else {
                    throw Libre3NFCError.unexpectedSensorState(patchInfo: patchInfo)
                }
                try await runActivationCommand(
                    tag: tag,
                    patchInfo: patchInfo,
                    commandCode: .activate,
                    receiverID: receiverID,
                    explicitTime: explicitTime,
                    message: LocalizedString(
                        "Libre 3 sensor activated.",
                        comment: "NFC system sheet, success after activating a fresh sensor"
                    )
                )

            case .switchReceiver(let receiverID, let explicitTime):
                guard patchInfo.recommendedCommandCode == .switchReceiver else {
                    throw Libre3NFCError.unexpectedSensorState(patchInfo: patchInfo)
                }
                try await runActivationCommand(
                    tag: tag,
                    patchInfo: patchInfo,
                    commandCode: .switchReceiver,
                    receiverID: receiverID,
                    explicitTime: explicitTime,
                    message: LocalizedString(
                        "Libre 3 receiver switched.",
                        comment: "NFC system sheet, success after binding an already-active sensor to this phone"
                    )
                )

            case .activateOrSwitchReceiver(let receiverID, let explicitTime):
                let commandCode = patchInfo.recommendedCommandCode
                try await runActivationCommand(
                    tag: tag,
                    patchInfo: patchInfo,
                    commandCode: commandCode,
                    receiverID: receiverID,
                    explicitTime: explicitTime,
                    message: commandCode == .activate
                        ? LocalizedString(
                            "Libre 3 sensor activated.",
                            comment: "NFC system sheet, success after activating a fresh sensor"
                        )
                        : LocalizedString(
                            "Libre 3 receiver switched.",
                            comment: "NFC system sheet, success after binding an already-active sensor to this phone"
                        )
                )

            case .forceActivationCommand(let commandCode, let receiverID, let explicitTime):
                try await runActivationCommand(
                    tag: tag,
                    patchInfo: patchInfo,
                    commandCode: commandCode,
                    receiverID: receiverID,
                    explicitTime: explicitTime,
                    message: commandCode == .activate
                        ? LocalizedString(
                            "Libre 3 sensor activated.",
                            comment: "NFC system sheet, success after activating a fresh sensor"
                        )
                        : LocalizedString(
                            "Libre 3 receiver switched.",
                            comment: "NFC system sheet, success after binding an already-active sensor to this phone"
                        )
                )
            }
        } catch {
            complete(.failure(error))
        }
    }

    private func runActivationCommand(
        tag: NFCISO15693Tag,
        patchInfo: Libre3NFCPatchInfo,
        commandCode: NFCActivationCommandCode,
        receiverID: UInt32,
        explicitTime: UInt32?,
        message: String
    ) async throws {
        let timeSeconds = explicitTime ?? Self.defaultActivationTimeSeconds()
        let parameters = NFCActivationCommand.customRequestParameters(
            timeSeconds: timeSeconds,
            receiverID: receiverID
        )
        let activationRaw = try await customCommand(
            tag: tag,
            code: commandCode.rawValue,
            parameters: parameters
        )
        let activation: Libre3NFCActivationResponse
        do {
            activation = try Libre3NFCActivationResponse(raw: activationRaw)
        } catch Libre3NFCError.invalidActivationResponse(let raw) {
            throw Libre3NFCError.invalidActivationResponseForPatch(
                commandCode: commandCode,
                patchInfo: patchInfo,
                raw: raw
            )
        }
        complete(
            .success(
                Libre3NFCScanResult(
                    patchInfo: patchInfo,
                    commandCode: commandCode,
                    commandParameters: parameters,
                    activationResponse: activation
                )
            ),
            message: message
        )
    }

    private func customCommand(tag: NFCISO15693Tag, code: UInt8, parameters: Data) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            tag.customCommand(
                requestFlags: [.highDataRate],
                customCommandCode: Int(code),
                customRequestParameters: parameters
            ) { result in
                continuation.resume(with: result)
            }
        }
    }

    private static func defaultActivationTimeSeconds() -> UInt32 {
        let now = UInt64(Date().timeIntervalSince1970.rounded(.down))
        return UInt32(max(0, now - 1))
    }
}

@available(iOS 17.0, *)
extension Libre3NFCActivationReader: NFCTagReaderSessionDelegate {
    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {}

    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        lock.lock()
        let continuation = self.continuation
        self.continuation = nil
        self.mode = nil
        self.session = nil
        lock.unlock()
        continuation?.resume(throwing: error)
    }

    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard tags.count == 1, let tag = tags.first else {
            session.alertMessage = LocalizedString(
                "More than one tag detected.",
                comment: "NFC system sheet, several tags in range so the sensor is ambiguous. Polling restarts after this."
            )
            session.restartPolling()
            complete(.failure(tags.isEmpty ? Libre3NFCError.noTag : Libre3NFCError.multipleTags))
            return
        }

        guard case .iso15693(let isoTag) = tag else {
            complete(.failure(Libre3NFCError.nonISO15693Tag))
            return
        }

        Task { [weak self] in
            do {
                try await session.connect(to: tag)
                await self?.run(tag: isoTag, in: session)
            } catch {
                self?.complete(.failure(error))
            }
        }
    }
}
#endif
