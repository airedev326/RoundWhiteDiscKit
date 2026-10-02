import Foundation

public struct Libre3SensorState: Equatable, Sendable {
    public let serialNumber: String?
    public let bleAddress: String?
    public let blePIN: Data
    public let receiverID: Libre3ReceiverID?
    public let source: String?
    public let lastGlucoseLifeCount: UInt16?
    public let lastGlucoseMgDL: UInt16?
    public let warmupDurationMinutes: Int?
    public let wearDurationMinutes: Int?

    public init(
        serialNumber: String?,
        blePIN: Data,
        bleAddress: String? = nil,
        receiverID: Libre3ReceiverID? = nil,
        source: String? = nil,
        lastGlucoseLifeCount: UInt16? = nil,
        lastGlucoseMgDL: UInt16? = nil,
        warmupDurationMinutes: Int? = nil,
        wearDurationMinutes: Int? = nil
    ) throws {
        guard blePIN.count == 4 else {
            throw Libre3SensorStateError.wrongBlePINSize(blePIN.count)
        }
        self.serialNumber = serialNumber
        self.bleAddress = bleAddress
        self.blePIN = blePIN
        self.receiverID = receiverID
        self.source = source
        self.lastGlucoseLifeCount = lastGlucoseLifeCount
        self.lastGlucoseMgDL = lastGlucoseMgDL
        self.warmupDurationMinutes = warmupDurationMinutes.map { max(0, $0) }
        self.wearDurationMinutes = wearDurationMinutes.map { max(0, $0) }
    }

    public func updatingLastGlucose(lifeCount: UInt16, mgDL: UInt16?) throws -> Libre3SensorState {
        try Libre3SensorState(
            serialNumber: serialNumber,
            blePIN: blePIN,
            bleAddress: bleAddress,
            receiverID: receiverID,
            source: source,
            lastGlucoseLifeCount: lifeCount,
            lastGlucoseMgDL: mgDL,
            warmupDurationMinutes: warmupDurationMinutes,
            wearDurationMinutes: wearDurationMinutes
        )
    }

    /// Persist the sensor's warmup/wear cycle taken from the NFC patch info, so
    /// reconnects (which do not re-scan NFC) can build lifecycle from the
    /// sensor's reported durations rather than the assumed defaults.
    public func applyingSensorCycle(from patchInfo: Libre3NFCPatchInfo) throws -> Libre3SensorState {
        try Libre3SensorState(
            serialNumber: serialNumber,
            blePIN: blePIN,
            bleAddress: bleAddress,
            receiverID: receiverID,
            source: source,
            lastGlucoseLifeCount: lastGlucoseLifeCount,
            lastGlucoseMgDL: lastGlucoseMgDL,
            warmupDurationMinutes: Int(patchInfo.warmupMinutes),
            wearDurationMinutes: Int(patchInfo.wearDurationMinutes)
        )
    }

    public func updatingLastAcceptedGlucose(from dataPlaneState: Libre3DataPlaneState) throws -> Libre3SensorState {
        guard let lifeCount = dataPlaneState.lastAcceptedGlucoseLifeCount else {
            return self
        }
        return try updatingLastGlucose(
            lifeCount: lifeCount,
            mgDL: dataPlaneState.lastAcceptedGlucoseMgDL
        )
    }
}

public enum Libre3SensorStateError: Error, Equatable {
    case invalidJSON
    case missingBlePIN
    case invalidBlePIN(String)
    case invalidReceiverID(String)
    case wrongBlePINSize(Int)
}

public enum Libre3SensorStateLoader {
    private struct JSONState: Codable {
        let serialNumber: String?
        let bleAddress: String?
        let blePIN: String?
        let receiverID: String?
        let source: String?
        let lastGlucoseLifeCount: UInt16?
        let lastGlucoseMgDL: UInt16?
        let warmupDurationMinutes: Int?
        let wearDurationMinutes: Int?
    }

    public static func load(fromJSON jsonData: Data) throws -> Libre3SensorState {
        let decoded: JSONState
        do {
            decoded = try JSONDecoder().decode(JSONState.self, from: jsonData)
        } catch {
            throw Libre3SensorStateError.invalidJSON
        }
        guard let rawPIN = decoded.blePIN else {
            throw Libre3SensorStateError.missingBlePIN
        }
        let pin = try parsePIN(rawPIN)
        let receiverID = try decoded.receiverID.map { raw in
            guard let value = Libre3ReceiverID.parseLittleEndianHex(raw) ?? parseUInt32(raw) else {
                throw Libre3SensorStateError.invalidReceiverID(raw)
            }
            return Libre3ReceiverID(value)
        }
        return try Libre3SensorState(
            serialNumber: decoded.serialNumber,
            blePIN: pin,
            bleAddress: decoded.bleAddress,
            receiverID: receiverID,
            source: decoded.source,
            lastGlucoseLifeCount: decoded.lastGlucoseLifeCount,
            lastGlucoseMgDL: decoded.lastGlucoseMgDL,
            warmupDurationMinutes: decoded.warmupDurationMinutes,
            wearDurationMinutes: decoded.wearDurationMinutes
        )
    }

    public static func jsonData(from state: Libre3SensorState) throws -> Data {
        let encoded = JSONState(
            serialNumber: state.serialNumber,
            bleAddress: state.bleAddress,
            blePIN: hex(state.blePIN),
            receiverID: state.receiverID?.littleEndianHex,
            source: state.source,
            lastGlucoseLifeCount: state.lastGlucoseLifeCount,
            lastGlucoseMgDL: state.lastGlucoseMgDL,
            warmupDurationMinutes: state.warmupDurationMinutes,
            wearDurationMinutes: state.wearDurationMinutes
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(encoded)
    }

    public static func write(_ state: Libre3SensorState, to url: URL) throws {
        try jsonData(from: state).write(to: url, options: .atomic)
    }

    private static func parsePIN(_ value: String) throws -> Data {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if let hex = parseHex(trimmed) {
            return hex
        }
        if let base64 = Data(base64Encoded: trimmed) {
            return base64
        }
        throw Libre3SensorStateError.invalidBlePIN(value)
    }

    private static func parseHex(_ value: String) -> Data? {
        let compact = value.filter { !$0.isWhitespace && $0 != ":" && $0 != "-" }
        guard compact.count % 2 == 0, !compact.isEmpty else { return nil }
        var out = Data(capacity: compact.count / 2)
        var idx = compact.startIndex
        while idx < compact.endIndex {
            let next = compact.index(idx, offsetBy: 2)
            guard let byte = UInt8(compact[idx..<next], radix: 16) else {
                return nil
            }
            out.append(byte)
            idx = next
        }
        return out
    }

    private static func parseUInt32(_ raw: String) -> UInt32? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.lowercased().hasPrefix("0x") {
            return UInt32(trimmed.dropFirst(2), radix: 16)
        }
        return UInt32(trimmed, radix: 10) ?? UInt32(trimmed, radix: 16)
    }

    private static func hex(_ data: Data) -> String {
        data.map { String(format: "%02x", $0) }.joined()
    }
}
