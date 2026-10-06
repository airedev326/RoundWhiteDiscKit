import Foundation

public enum Libre3DataPlaneStateUpdate: Equatable, Sendable {
    case patchStatus(PatchStatus, lifecycle: SensorLifecycle)
    case realtimeGlucose(RealtimeGlucoseReading, assessment: Libre3GlucoseQualityAssessment)
    case historicalReadingPage(HistoricalReadingPage)
    case clinicalReadingRecord(ClinicalReadingRecord)
    case raw(DataPlaneDecodedPacket)
}

public struct Libre3DataPlaneState: Equatable, Sendable {
    public let warmupDurationMinutes: Int
    public let wearDurationMinutes: Int?
    public private(set) var latestPatchStatus: PatchStatus?
    public private(set) var latestLifecycle: SensorLifecycle?
    public private(set) var latestRealtimeGlucose: RealtimeGlucoseReading?
    public private(set) var latestQualityAssessment: Libre3GlucoseQualityAssessment?
    public private(set) var lastAcceptedGlucoseLifeCount: UInt16?
    public private(set) var lastAcceptedGlucoseMgDL: UInt16?
    public private(set) var historicalBackfill: HistoricalBackfill

    public init(
        warmupDurationMinutes: Int = SensorLifecycle.defaultWarmupDurationMinutes,
        wearDurationMinutes: Int? = nil,
        latestPatchStatus: PatchStatus? = nil,
        lastAcceptedGlucoseLifeCount: UInt16? = nil,
        lastAcceptedGlucoseMgDL: UInt16? = nil,
        historicalBackfill: HistoricalBackfill = HistoricalBackfill()
    ) {
        self.warmupDurationMinutes = max(0, warmupDurationMinutes)
        self.wearDurationMinutes = wearDurationMinutes.map { max(0, $0) }
        self.latestPatchStatus = latestPatchStatus
        self.latestLifecycle = latestPatchStatus.map {
            $0.lifecycle(
                warmupDurationMinutes: max(0, warmupDurationMinutes),
                wearDurationMinutes: wearDurationMinutes.map { max(0, $0) }
            )
        }
        self.latestRealtimeGlucose = nil
        self.latestQualityAssessment = nil
        self.lastAcceptedGlucoseLifeCount = lastAcceptedGlucoseLifeCount
        self.lastAcceptedGlucoseMgDL = lastAcceptedGlucoseMgDL
        self.historicalBackfill = historicalBackfill
    }

    /// Seed reconnect state from persisted sensor state. When `warmup`/`wear`
    /// are not supplied, fall back to the sensor's persisted cycle (captured at
    /// pairing) and only then to the assumed default, so reconnects reflect the
    /// sensor's reported warmup/wear without re-scanning NFC.
    public init(
        sensorState: Libre3SensorState,
        warmupDurationMinutes: Int? = nil,
        wearDurationMinutes: Int? = nil,
        latestPatchStatus: PatchStatus? = nil,
        historicalBackfill: HistoricalBackfill = HistoricalBackfill()
    ) {
        self.init(
            warmupDurationMinutes: warmupDurationMinutes
                ?? sensorState.warmupDurationMinutes
                ?? SensorLifecycle.defaultWarmupDurationMinutes,
            wearDurationMinutes: wearDurationMinutes ?? sensorState.wearDurationMinutes,
            latestPatchStatus: latestPatchStatus,
            lastAcceptedGlucoseLifeCount: sensorState.lastGlucoseLifeCount,
            lastAcceptedGlucoseMgDL: sensorState.lastGlucoseMgDL,
            historicalBackfill: historicalBackfill
        )
    }

    /// Seed the data-plane state with warmup/wear durations taken from the NFC
    /// patch info, so lifecycle reflects the sensor's reported cycle rather
    /// than the assumed defaults.
    public init(
        patchInfo: Libre3NFCPatchInfo,
        latestPatchStatus: PatchStatus? = nil,
        lastAcceptedGlucoseLifeCount: UInt16? = nil,
        lastAcceptedGlucoseMgDL: UInt16? = nil,
        historicalBackfill: HistoricalBackfill = HistoricalBackfill()
    ) {
        self.init(
            warmupDurationMinutes: Int(patchInfo.warmupMinutes),
            wearDurationMinutes: Int(patchInfo.wearDurationMinutes),
            latestPatchStatus: latestPatchStatus,
            lastAcceptedGlucoseLifeCount: lastAcceptedGlucoseLifeCount,
            lastAcceptedGlucoseMgDL: lastAcceptedGlucoseMgDL,
            historicalBackfill: historicalBackfill
        )
    }

    public init(
        sensorState: Libre3SensorState,
        patchInfo: Libre3NFCPatchInfo,
        latestPatchStatus: PatchStatus? = nil,
        historicalBackfill: HistoricalBackfill = HistoricalBackfill()
    ) {
        self.init(
            patchInfo: patchInfo,
            latestPatchStatus: latestPatchStatus,
            lastAcceptedGlucoseLifeCount: sensorState.lastGlucoseLifeCount,
            lastAcceptedGlucoseMgDL: sensorState.lastGlucoseMgDL,
            historicalBackfill: historicalBackfill
        )
    }

    public var lifecyclePhase: SensorLifecyclePhase? {
        latestLifecycle?.phase
    }

    public var isInWarmup: Bool {
        latestLifecycle?.isWarmingUp ?? false
    }

    public var latestSensorAttention: Libre3SensorAttention {
        latestPatchStatus?.sensorAttention ?? .none
    }

    public var shouldNotifyUser: Bool {
        latestSensorAttention.shouldNotifyUser
    }

    public var shouldNotifyReplaceSensor: Bool {
        latestSensorAttention.isReplaceSensor
    }

    public mutating func record(_ packet: DataPlaneDecodedPacket) -> Libre3DataPlaneStateUpdate {
        switch packet.payload {
        case .patchStatus(let status):
            let lifecycle = status.lifecycle(
                warmupDurationMinutes: warmupDurationMinutes,
                wearDurationMinutes: wearDurationMinutes
            )
            latestPatchStatus = status
            latestLifecycle = lifecycle
            if let latestRealtimeGlucose {
                let assessment = latestRealtimeGlucose.currentGlucoseQualityAssessment(lifecycle: lifecycle)
                latestQualityAssessment = assessment
                recordAcceptedGlucoseIfUsable(latestRealtimeGlucose, assessment: assessment)
            }
            return .patchStatus(status, lifecycle: lifecycle)

        case .realtimeGlucose(let reading):
            let assessment = assess(reading)
            latestRealtimeGlucose = reading
            latestQualityAssessment = assessment
            recordAcceptedGlucoseIfUsable(reading, assessment: assessment)
            return .realtimeGlucose(reading, assessment: assessment)

        case .historicalReadingPage(let page):
            historicalBackfill.append(page)
            return .historicalReadingPage(page)

        case .clinicalReadingRecord(let record):
            // Pass through unchanged. Apps that want minute-resolution
            // backfill consume the record's currentGlucose at its
            // lifeCount; we don't fold clinical records into
            // historicalBackfill because the two streams have different
            // commit cadences and different per-value semantics.
            return .clinicalReadingRecord(record)

        case .raw:
            return .raw(packet)
        }
    }

    public func assess(_ reading: RealtimeGlucoseReading) -> Libre3GlucoseQualityAssessment {
        reading.currentGlucoseQualityAssessment(lifecycle: latestLifecycle)
    }

    private mutating func recordAcceptedGlucoseIfUsable(
        _ reading: RealtimeGlucoseReading,
        assessment: Libre3GlucoseQualityAssessment
    ) {
        guard assessment.isUsable, let mgDL = reading.currentGlucoseMgDL else {
            return
        }
        lastAcceptedGlucoseLifeCount = reading.lifeCount
        lastAcceptedGlucoseMgDL = mgDL
    }

    public var reconnectBackfillLowerBoundLifeCount: UInt16? {
        lastAcceptedGlucoseLifeCount
    }

    public func reconnectBackfillCommands(
        selector: UInt8 = 0x01,
        includeClinical: Bool = true
    ) -> [PatchControlCommand] {
        guard let lifeCount = reconnectBackfillLowerBoundLifeCount else {
            return []
        }

        var commands = [
            PatchControlCommand.historicalBackfillGreaterEqual(
                lifeCount: lifeCount,
                selector: selector
            )
        ]
        if includeClinical {
            commands.append(
                PatchControlCommand.clinicalBackfillGreaterEqual(
                    lifeCount: lifeCount,
                    selector: selector
                )
            )
        }
        return commands
    }
}
