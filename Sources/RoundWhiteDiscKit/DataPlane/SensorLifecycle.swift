import Foundation

public enum SensorLifecyclePhase: String, Equatable, Sendable {
    case warmup
    case active
    case expired
}

public struct SensorLifecycle: Equatable, Sendable {
    public static let defaultWarmupDurationMinutes = 60

    public let currentLifeCountMinutes: Int
    public let warmupDurationMinutes: Int
    public let wearDurationMinutes: Int?

    public init(
        currentLifeCountMinutes: Int,
        warmupDurationMinutes: Int = Self.defaultWarmupDurationMinutes,
        wearDurationMinutes: Int? = nil
    ) {
        self.currentLifeCountMinutes = currentLifeCountMinutes
        self.warmupDurationMinutes = max(0, warmupDurationMinutes)
        self.wearDurationMinutes = wearDurationMinutes.map { max(0, $0) }
    }

    public var elapsedMinutes: Int {
        max(0, currentLifeCountMinutes)
    }

    public var remainingWarmupMinutes: Int {
        max(0, warmupDurationMinutes - elapsedMinutes)
    }

    public var remainingWearMinutes: Int? {
        wearDurationMinutes.map { max(0, $0 - elapsedMinutes) }
    }

    public var isWarmupComplete: Bool {
        elapsedMinutes >= warmupDurationMinutes
    }

    public var isWarmingUp: Bool {
        !isWarmupComplete && !isExpired
    }

    public var isExpired: Bool {
        guard let wearDurationMinutes else {
            return false
        }
        return elapsedMinutes >= wearDurationMinutes
    }

    public var isActive: Bool {
        phase == .active
    }

    public var phase: SensorLifecyclePhase {
        if isExpired {
            return .expired
        }
        if !isWarmupComplete {
            return .warmup
        }
        return .active
    }
}
