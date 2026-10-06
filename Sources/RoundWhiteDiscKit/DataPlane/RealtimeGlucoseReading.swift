import Foundation

public struct RealtimeGlucoseReading: Equatable, Sendable {
    public static let plaintextSize = 29

    public let lifeCount: UInt16
    public let currentWord: UInt16
    public let readingMgDL: UInt16
    public let dqErrorRaw: UInt16
    public let dqError: Libre3DataQualityError
    public let sensorConditionRaw: UInt8
    public let sensorCondition: Libre3SensorCondition
    public let currentGlucoseMgDL: UInt16?
    public let isCurrentGlucoseValid: Bool
    public let rateOfChangeRaw: Int16
    public let rateOfChangeMgDLPerMinute: Float?
    public let trendRaw: UInt8
    public let esaDuration: UInt16
    public let temperatureStatus: UInt16
    public let projectedGlucose: UInt16
    public let historicalLifeCount: UInt16
    public let historicalWord: UInt16
    public let historicalReading: UInt16
    public let historicalReadingDQErrorRaw: UInt16
    public let historicalReadingDQError: Libre3DataQualityError
    public let historicResultRangeStatusRaw: UInt8
    public let historicResultRangeStatus: Libre3ResultRangeStatus
    public let historicalGlucoseMgDL: UInt16?
    public let isHistoricalGlucoseValid: Bool
    public let trendAndStatusByte: UInt8
    public let trend: UInt8
    public let trendKind: Libre3Trend
    public let rest: UInt8
    public let actionableStatus: UInt8
    public let actionability: Libre3ActionableStatus
    public let uncappedCurrentMgDL: UInt16
    public let uncappedHistoricMgDL: UInt16
    public let temperature: UInt16
    public let fastData: Data
    public let fastDataWordsLE: [UInt16]
    public let wordsLE: [UInt16]
    public let trailingByte: UInt8

    public var statusBits: UInt8 {
        rest
    }

    public var currentGlucoseStatus: Libre3GlucoseValueStatus {
        Libre3GlucoseValueStatus(rawSensorValue: uncappedCurrentMgDL)
    }

    public var historicalGlucoseStatus: Libre3GlucoseValueStatus {
        Libre3GlucoseValueStatus(rawSensorValue: uncappedHistoricMgDL)
    }

    public var rateOfChangeAvailable: Bool {
        rateOfChangeMgDLPerMinute != nil
    }

    public var isCurrentDQGood: Bool {
        dqError.isGood && sensorCondition == .ok
    }

    public var isHistoricalDQGood: Bool {
        historicalReadingDQError.isGood && historicResultRangeStatus == .inRange
    }

    public var isCurrentGlucoseUsable: Bool {
        isCurrentGlucoseValid && isCurrentDQGood
    }

    public var currentGlucoseQualityAssessment: Libre3GlucoseQualityAssessment {
        currentGlucoseQualityAssessment(lifecycle: nil)
    }

    public func isCurrentGlucoseUsable(lifecycle: SensorLifecycle?) -> Bool {
        currentGlucoseQualityAssessment(lifecycle: lifecycle).isUsable
    }

    public func currentGlucoseQualityAssessment(
        lifecycle: SensorLifecycle?
    ) -> Libre3GlucoseQualityAssessment {
        var issues: [Libre3GlucoseQualityIssue] = []

        if let lifecycle {
            if lifecycle.isExpired {
                issues.append(.sensorExpired)
            } else if lifecycle.isWarmingUp {
                issues.append(.sensorWarmup(remainingMinutes: lifecycle.remainingWarmupMinutes))
            }
        }

        if !currentGlucoseStatus.isDisplayable {
            issues.append(.currentGlucoseUnavailable(currentGlucoseStatus))
        }
        if !dqError.isGood {
            issues.append(.currentDataQuality(dqError))
        }
        if sensorCondition != .ok {
            issues.append(.sensorCondition(sensorCondition))
        }
        if actionability != .actionable {
            issues.append(.notActionable(actionability))
        }

        return Libre3GlucoseQualityAssessment(
            isUsable: !issues.contains { $0.isUsabilityBlocking },
            issues: issues,
            evidence: qualityEvidence
        )
    }

    public var qualityEvidence: RealtimeGlucoseQualityEvidence {
        RealtimeGlucoseQualityEvidence(
            dqErrorRaw: dqErrorRaw,
            dqError: dqError,
            historicalReadingDQErrorRaw: historicalReadingDQErrorRaw,
            historicalReadingDQError: historicalReadingDQError,
            sensorConditionRaw: sensorConditionRaw,
            sensorCondition: sensorCondition,
            historicResultRangeStatusRaw: historicResultRangeStatusRaw,
            historicResultRangeStatus: historicResultRangeStatus,
            actionableStatus: actionableStatus,
            actionability: actionability,
            temperatureStatus: temperatureStatus,
            currentGlucose: currentGlucoseStatus,
            historicalGlucose: historicalGlucoseStatus,
            rateOfChangeAvailable: rateOfChangeAvailable,
            trend: trendKind,
            trendBits: trend,
            statusBits: statusBits,
            temperatureRaw: temperature,
            fastData: fastData,
            fastDataWordsLE: fastDataWordsLE
        )
    }

    public init(plaintext: Data) throws {
        guard plaintext.count == Self.plaintextSize else {
            throw RealtimeGlucoseReadingError.wrongPlaintextSize(plaintext.count)
        }
        let rateOfChangeRaw = Int16(bitPattern: Self.u16(plaintext, 4))
        let currentWord = Self.u16(plaintext, 2)
        let historicalWord = Self.u16(plaintext, 12)
        let trendAndRest = plaintext[plaintext.startIndex + 14]
        let trend = trendAndRest & 0x07
        let actionableStatus: UInt8 = (trendAndRest & 0x08) == 0 ? 0 : 1
        let uncappedCurrentMgDL = Self.u16(plaintext, 15)
        let currentGlucoseMgDL = Self.normalizedGlucoseMgDL(uncappedCurrentMgDL)
        let uncappedHistoricMgDL = Self.u16(plaintext, 17)
        let historicalGlucoseMgDL = Self.normalizedGlucoseMgDL(uncappedHistoricMgDL)

        self.lifeCount = Self.u16(plaintext, 0)
        self.currentWord = currentWord
        self.readingMgDL = Self.glucoseValue(fromPackedWord: currentWord)
        self.dqErrorRaw = Self.dqErrorRaw(fromPackedWord: currentWord)
        self.dqError = Libre3DataQualityError(rawValue: self.dqErrorRaw)
        self.sensorConditionRaw = Self.statusBits13To14(fromPackedWord: currentWord)
        self.sensorCondition = Libre3SensorCondition(rawValue: self.sensorConditionRaw)
        self.currentGlucoseMgDL = currentGlucoseMgDL
        self.isCurrentGlucoseValid = currentGlucoseMgDL != nil
        self.rateOfChangeRaw = rateOfChangeRaw
        self.rateOfChangeMgDLPerMinute = rateOfChangeRaw == Int16.min
            ? nil
            : Float(rateOfChangeRaw) / 100.0
        self.trendRaw = trend
        self.esaDuration = 0
        self.temperatureStatus = Self.u16(plaintext, 6)
        self.projectedGlucose = Self.u16(plaintext, 8)
        self.historicalLifeCount = Self.u16(plaintext, 10)
        self.historicalWord = historicalWord
        self.historicalReading = Self.glucoseValue(fromPackedWord: historicalWord)
        self.historicalReadingDQErrorRaw = Self.dqErrorRaw(fromPackedWord: historicalWord)
        self.historicalReadingDQError = Libre3DataQualityError(rawValue: self.historicalReadingDQErrorRaw)
        self.historicResultRangeStatusRaw = Self.statusBits13To14(fromPackedWord: historicalWord)
        self.historicResultRangeStatus = Libre3ResultRangeStatus(rawValue: self.historicResultRangeStatusRaw)
        self.historicalGlucoseMgDL = historicalGlucoseMgDL
        self.isHistoricalGlucoseValid = historicalGlucoseMgDL != nil
        self.trendAndStatusByte = trendAndRest
        self.trend = trend
        self.trendKind = Libre3Trend(rawValue: trend)
        self.rest = trendAndRest >> 3
        self.actionableStatus = actionableStatus
        self.actionability = Libre3ActionableStatus(rawValue: actionableStatus)
        self.uncappedCurrentMgDL = uncappedCurrentMgDL
        self.uncappedHistoricMgDL = uncappedHistoricMgDL
        self.temperature = Self.u16(plaintext, 19)
        self.fastData = plaintext.subdata(in: (plaintext.startIndex + 21)..<(plaintext.startIndex + 29))
        self.fastDataWordsLE = stride(from: 21, to: 29, by: 2).map {
            Self.u16(plaintext, $0)
        }

        var words: [UInt16] = []
        var offset = 0
        while offset + 1 < plaintext.count {
            words.append(Self.u16(plaintext, offset))
            offset += 2
        }
        self.wordsLE = words
        self.trailingByte = plaintext[plaintext.startIndex + plaintext.count - 1]
    }

    private static func u16(_ data: Data, _ offset: Int) -> UInt16 {
        let i = data.startIndex + offset
        return UInt16(data[i]) | (UInt16(data[i + 1]) << 8)
    }

    private static func normalizedGlucoseMgDL(_ value: UInt16) -> UInt16? {
        Libre3GlucoseValueStatus(rawSensorValue: value).displayMgDL
    }

    private static func glucoseValue(fromPackedWord value: UInt16) -> UInt16 {
        value & 0x1fff
    }

    private static func dqErrorRaw(fromPackedWord value: UInt16) -> UInt16 {
        (value & 0x8000) == 0 ? 0 : value
    }

    private static func statusBits13To14(fromPackedWord value: UInt16) -> UInt8 {
        UInt8((value >> 13) & 0x03)
    }
}

public enum RealtimeGlucoseReadingError: Error, Equatable {
    case wrongPlaintextSize(Int)
}

public enum Libre3DataQualityError: Equatable, Sendable, CustomStringConvertible {
    case good
    case sensorTooHot(rawValue: UInt16)
    case sensorTooCold(rawValue: UInt16)
    case notDisplayable(rawValue: UInt16)
    case raw(UInt16)

    public init(rawValue: UInt16) {
        switch rawValue {
        case 0:
            self = .good
        case let value where (value & 0xE000) == 0xA000:
            self = .sensorTooHot(rawValue: value)
        case let value where (value & 0xE000) == 0xC000:
            self = .sensorTooCold(rawValue: value)
        case let value where (value & 0x8000) != 0:
            self = .notDisplayable(rawValue: value)
        default:
            self = .raw(rawValue)
        }
    }

    public var rawValue: UInt16 {
        switch self {
        case .good:
            return 0
        case .sensorTooHot(let rawValue):
            return rawValue
        case .sensorTooCold(let rawValue):
            return rawValue
        case .notDisplayable(let rawValue):
            return rawValue
        case .raw(let rawValue):
            return rawValue
        }
    }

    public var isGood: Bool {
        self == .good
    }

    public var isNotDisplayable: Bool {
        switch self {
        case .sensorTooHot, .sensorTooCold, .notDisplayable:
            return true
        case .good, .raw:
            return false
        }
    }

    public var description: String {
        switch self {
        case .good:
            return "good"
        case .sensorTooHot(let rawValue):
            return "sensorTooHot(0x\(String(format: "%04x", rawValue)))"
        case .sensorTooCold(let rawValue):
            return "sensorTooCold(0x\(String(format: "%04x", rawValue)))"
        case .notDisplayable(let rawValue):
            return "notDisplayable(0x\(String(format: "%04x", rawValue)))"
        case .raw(let rawValue):
            return "raw(0x\(String(format: "%04x", rawValue)))"
        }
    }
}

public enum Libre3SensorCondition: Equatable, Sendable, CustomStringConvertible {
    case ok
    case invalid
    case esa
    case raw(UInt8)

    public init(rawValue: UInt8) {
        switch rawValue {
        case 0:
            self = .ok
        case 1:
            self = .invalid
        case 2:
            self = .esa
        default:
            self = .raw(rawValue)
        }
    }

    public var rawValue: UInt8 {
        switch self {
        case .ok:
            return 0
        case .invalid:
            return 1
        case .esa:
            return 2
        case .raw(let rawValue):
            return rawValue
        }
    }

    public var description: String {
        switch self {
        case .ok:
            return "ok"
        case .invalid:
            return "invalid"
        case .esa:
            return "esa"
        case .raw(let rawValue):
            return "raw(\(rawValue))"
        }
    }
}

public enum Libre3ResultRangeStatus: Equatable, Sendable, CustomStringConvertible {
    case inRange
    case belowRange
    case aboveRange
    case raw(UInt8)

    public init(rawValue: UInt8) {
        switch rawValue {
        case 0:
            self = .inRange
        case 1:
            self = .belowRange
        case 2:
            self = .aboveRange
        default:
            self = .raw(rawValue)
        }
    }

    public var rawValue: UInt8 {
        switch self {
        case .inRange:
            return 0
        case .belowRange:
            return 1
        case .aboveRange:
            return 2
        case .raw(let rawValue):
            return rawValue
        }
    }

    public var description: String {
        switch self {
        case .inRange:
            return "inRange"
        case .belowRange:
            return "belowRange"
        case .aboveRange:
            return "aboveRange"
        case .raw(let rawValue):
            return "raw(\(rawValue))"
        }
    }
}

public enum Libre3ActionableStatus: Equatable, Sendable, CustomStringConvertible {
    case notActionable
    case actionable
    case raw(UInt8)

    public init(rawValue: UInt8) {
        switch rawValue {
        case 0:
            self = .notActionable
        case 1:
            self = .actionable
        default:
            self = .raw(rawValue)
        }
    }

    public var rawValue: UInt8 {
        switch self {
        case .notActionable:
            return 0
        case .actionable:
            return 1
        case .raw(let rawValue):
            return rawValue
        }
    }

    public var description: String {
        switch self {
        case .notActionable:
            return "notActionable"
        case .actionable:
            return "actionable"
        case .raw(let rawValue):
            return "raw(\(rawValue))"
        }
    }
}

public enum Libre3Trend: Equatable, Sendable, CustomStringConvertible {
    case notDetermined
    case fallingQuickly
    case falling
    case stable
    case rising
    case risingQuickly
    case raw(UInt8)

    public init(rawValue: UInt8) {
        switch rawValue {
        case 0:
            self = .notDetermined
        case 1:
            self = .fallingQuickly
        case 2:
            self = .falling
        case 3:
            self = .stable
        case 4:
            self = .rising
        case 5:
            self = .risingQuickly
        default:
            self = .raw(rawValue)
        }
    }

    public var rawValue: UInt8 {
        switch self {
        case .notDetermined:
            return 0
        case .fallingQuickly:
            return 1
        case .falling:
            return 2
        case .stable:
            return 3
        case .rising:
            return 4
        case .risingQuickly:
            return 5
        case .raw(let rawValue):
            return rawValue
        }
    }

    public var description: String {
        switch self {
        case .notDetermined:
            return "notDetermined"
        case .fallingQuickly:
            return "fallingQuickly"
        case .falling:
            return "falling"
        case .stable:
            return "stable"
        case .rising:
            return "rising"
        case .risingQuickly:
            return "risingQuickly"
        case .raw(let rawValue):
            return "raw(\(rawValue))"
        }
    }
}

public enum Libre3GlycemicAlarmStatus: Equatable, Sendable, CustomStringConvertible {
    case alarmNotDetermined
    case lowGlucose
    case projectedLowGlucose
    case normalGlucose
    case projectedHighGlucose
    case highGlucose
    case raw(UInt8)

    public init(rawValue: UInt8) {
        switch rawValue {
        case 0:
            self = .alarmNotDetermined
        case 1:
            self = .lowGlucose
        case 2:
            self = .projectedLowGlucose
        case 3:
            self = .normalGlucose
        case 4:
            self = .projectedHighGlucose
        case 5:
            self = .highGlucose
        default:
            self = .raw(rawValue)
        }
    }

    public var rawValue: UInt8 {
        switch self {
        case .alarmNotDetermined:
            return 0
        case .lowGlucose:
            return 1
        case .projectedLowGlucose:
            return 2
        case .normalGlucose:
            return 3
        case .projectedHighGlucose:
            return 4
        case .highGlucose:
            return 5
        case .raw(let rawValue):
            return rawValue
        }
    }

    public var description: String {
        switch self {
        case .alarmNotDetermined:
            return "alarmNotDetermined"
        case .lowGlucose:
            return "lowGlucose"
        case .projectedLowGlucose:
            return "projectedLowGlucose"
        case .normalGlucose:
            return "normalGlucose"
        case .projectedHighGlucose:
            return "projectedHighGlucose"
        case .highGlucose:
            return "highGlucose"
        case .raw(let rawValue):
            return "raw(\(rawValue))"
        }
    }
}

public enum Libre3GlucoseValueStatus: Equatable, Sendable {
    case valid(mgDL: UInt16)
    case belowDisplayRange(raw: UInt16, displayMgDL: UInt16)
    case aboveDisplayRange(raw: UInt16, displayMgDL: UInt16)
    case unavailable(raw: UInt16)

    public init(rawSensorValue value: UInt16) {
        switch value {
        case 1..<39:
            self = .belowDisplayRange(raw: value, displayMgDL: 39)
        case 39...501:
            self = .valid(mgDL: value)
        case 502..<1000:
            self = .aboveDisplayRange(raw: value, displayMgDL: 501)
        default:
            self = .unavailable(raw: value)
        }
    }

    public var displayMgDL: UInt16? {
        switch self {
        case .valid(let mgDL):
            return mgDL
        case .belowDisplayRange(_, let displayMgDL):
            return displayMgDL
        case .aboveDisplayRange(_, let displayMgDL):
            return displayMgDL
        case .unavailable:
            return nil
        }
    }

    public var isDisplayable: Bool {
        displayMgDL != nil
    }
}

extension Libre3GlucoseValueStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .valid(let mgDL):
            return "valid(\(mgDL))"
        case .belowDisplayRange(let raw, let displayMgDL):
            return "belowDisplayRange(raw: \(raw), displayMgDL: \(displayMgDL))"
        case .aboveDisplayRange(let raw, let displayMgDL):
            return "aboveDisplayRange(raw: \(raw), displayMgDL: \(displayMgDL))"
        case .unavailable(let raw):
            return "unavailable(raw: \(raw))"
        }
    }
}

public enum Libre3GlucoseQualityIssue: Equatable, Sendable, CustomStringConvertible {
    case sensorWarmup(remainingMinutes: Int)
    case sensorExpired
    case currentGlucoseUnavailable(Libre3GlucoseValueStatus)
    case currentDataQuality(Libre3DataQualityError)
    case sensorCondition(Libre3SensorCondition)
    case notActionable(Libre3ActionableStatus)

    /// Whether this issue makes the reading unusable for dosing/display.
    ///
    /// `.notActionable` is advisory only: a non-actionable frame can still carry
    /// a displayable glucose number. It is surfaced as a quality issue so
    /// callers can see it, but it does not suppress the reading.
    public var isAdvisory: Bool {
        switch self {
        case .notActionable:
            return true
        case .sensorWarmup, .sensorExpired, .currentGlucoseUnavailable,
             .currentDataQuality, .sensorCondition:
            return false
        }
    }

    public var isUsabilityBlocking: Bool {
        !isAdvisory
    }

    public var description: String {
        switch self {
        case .sensorWarmup(let remainingMinutes):
            return "sensorWarmup(remainingMinutes: \(remainingMinutes))"
        case .sensorExpired:
            return "sensorExpired"
        case .currentGlucoseUnavailable(let status):
            return "currentGlucoseUnavailable(\(status))"
        case .currentDataQuality(let error):
            return "currentDataQuality(\(error))"
        case .sensorCondition(let condition):
            return "sensorCondition(\(condition))"
        case .notActionable(let status):
            return "notActionable(\(status))"
        }
    }
}

public struct Libre3GlucoseQualityAssessment: Equatable, Sendable {
    public let isUsable: Bool
    public let issues: [Libre3GlucoseQualityIssue]
    public let evidence: RealtimeGlucoseQualityEvidence

    /// Issues that suppress the reading (warmup, expiry, DQ error, etc.).
    public var blockingIssues: [Libre3GlucoseQualityIssue] {
        issues.filter { $0.isUsabilityBlocking }
    }

    /// Issues surfaced for visibility but that do not suppress the reading
    /// (currently only `.notActionable`).
    public var advisories: [Libre3GlucoseQualityIssue] {
        issues.filter { $0.isAdvisory }
    }
}

public struct RealtimeGlucoseQualityEvidence: Equatable, Sendable {
    public let dqErrorRaw: UInt16
    public let dqError: Libre3DataQualityError
    public let historicalReadingDQErrorRaw: UInt16
    public let historicalReadingDQError: Libre3DataQualityError
    public let sensorConditionRaw: UInt8
    public let sensorCondition: Libre3SensorCondition
    public let historicResultRangeStatusRaw: UInt8
    public let historicResultRangeStatus: Libre3ResultRangeStatus
    public let actionableStatus: UInt8
    public let actionability: Libre3ActionableStatus
    public let temperatureStatus: UInt16
    public let currentGlucose: Libre3GlucoseValueStatus
    public let historicalGlucose: Libre3GlucoseValueStatus
    public let rateOfChangeAvailable: Bool
    public let trend: Libre3Trend
    public let trendBits: UInt8
    public let statusBits: UInt8
    public let temperatureRaw: UInt16
    public let fastData: Data
    public let fastDataWordsLE: [UInt16]
}
