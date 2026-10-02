import Foundation

public enum DataPlaneChannel: String, CaseIterable, Sendable {
    case patchControl
    case patchStatus
    case glucoseData
    case historicData
    case eventLog
    case clinicalData
    case factoryData

    public init?(uuidString: String) {
        let lower = uuidString.lowercased()
        switch lower {
        case _ where lower.hasPrefix("08981338"):
            self = .patchControl
        case _ where lower.hasPrefix("08981482"):
            self = .patchStatus
        case _ where lower.hasPrefix("0898177a"):
            self = .glucoseData
        case _ where lower.hasPrefix("0898195a"):
            self = .historicData
        case _ where lower.hasPrefix("08981bee"):
            self = .eventLog
        case _ where lower.hasPrefix("08981ab8"):
            self = .clinicalData
        case _ where lower.hasPrefix("08981d24"):
            self = .factoryData
        default:
            return nil
        }
    }

    public var preferredInboundKind: DataPlanePacketKind? {
        switch self {
        case .patchStatus:
            return .kind2
        case .glucoseData:
            return .kind3
        case .historicData:
            return .kind4
        case .patchControl, .eventLog, .clinicalData, .factoryData:
            return nil
        }
    }
}

public enum DataPlaneDecodedPayload: Equatable, Sendable {
    case realtimeGlucose(RealtimeGlucoseReading)
    case patchStatus(PatchStatus)
    case historicalReadingPage(HistoricalReadingPage)
    case clinicalReadingRecord(ClinicalReadingRecord)
    case raw(Data)
}

public struct DataPlaneDecodedPacket: Equatable, Sendable {
    public let channel: DataPlaneChannel
    public let frame: DataFrame
    public let kind: DataPlanePacketKind
    public let preferredKind: DataPlanePacketKind?
    public let plaintext: Data
    public let payload: DataPlaneDecodedPayload

    public var usedPreferredKind: Bool {
        preferredKind == nil || preferredKind == kind
    }
}

public struct DataPlaneDecoder: Sendable {
    public let crypto: DataPlaneCrypto

    public init(crypto: DataPlaneCrypto) {
        self.crypto = crypto
    }

    public func decrypt(frame: DataFrame, channel: DataPlaneChannel) throws -> DataPlaneDecodedPacket {
        let preferredKind = channel.preferredInboundKind
        let result: DataPlaneDecryptResult
        if let preferredKind,
           let plaintext = try? crypto.decrypt(frame, kind: preferredKind) {
            result = DataPlaneDecryptResult(kind: preferredKind, plaintext: plaintext)
        } else {
            result = try crypto.decryptTryingAllKinds(frame)
        }

        return DataPlaneDecodedPacket(
            channel: channel,
            frame: frame,
            kind: result.kind,
            preferredKind: preferredKind,
            plaintext: result.plaintext,
            payload: Self.decodePayload(channel: channel, plaintext: result.plaintext)
        )
    }

    private static func decodePayload(channel: DataPlaneChannel, plaintext: Data) -> DataPlaneDecodedPayload {
        switch channel {
        case .glucoseData:
            if let reading = try? RealtimeGlucoseReading(plaintext: plaintext) {
                return .realtimeGlucose(reading)
            }
        case .patchStatus:
            if let status = try? PatchStatus(plaintext: plaintext) {
                return .patchStatus(status)
            }
        case .historicData:
            if let page = try? HistoricalReadingPage(plaintext: plaintext) {
                return .historicalReadingPage(page)
            }
        case .clinicalData:
            // Clinical pages have a different layout than historical
            // (single time-point record, not 6 samples at 5-min stride).
            // See ClinicalReadingRecord for field semantics.
            if let record = try? ClinicalReadingRecord(plaintext: plaintext) {
                return .clinicalReadingRecord(record)
            }
        case .patchControl, .eventLog, .factoryData:
            break
        }
        return .raw(plaintext)
    }
}

/// Reassembles post-auth notification bodies before `DataFrame.parse`.
///
/// `glucoseData` readings arrive as a 15-byte prefix followed by a 20-byte
/// suffix. The suffix contains the normal data-plane 2-byte sequence trailer, so
/// the two notifications must be concatenated before CCM tag verification.
public final class DataPlaneNotificationAssembler: @unchecked Sendable {
    private let lock = NSLock()
    private var glucosePrefix: Data?

    public init() {}

    public func feed(fragment: Data, channel: DataPlaneChannel) -> Data? {
        lock.lock()
        defer { lock.unlock() }

        guard channel == .glucoseData else {
            return fragment
        }

        if let prefix = glucosePrefix {
            glucosePrefix = nil
            return prefix + fragment
        }
        if fragment.count == 15 {
            glucosePrefix = fragment
            return nil
        }
        return fragment
    }

    public func reset() {
        lock.lock()
        glucosePrefix = nil
        lock.unlock()
    }
}
