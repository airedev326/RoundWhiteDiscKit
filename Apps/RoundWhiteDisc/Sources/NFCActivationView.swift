import SwiftUI
import Security
@preconcurrency import CoreBluetooth
import RoundWhiteDiscKit
#if canImport(UIKit)
import UIKit
#endif

struct NFCActivationView: View {
    @StateObject private var model = NFCActivationViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    statusRow
                    receiverSection
                    controls
                    decodedDataSection
                    connectionSection
                    persistenceSection
                    patchSection
                    activationSection
                    bleHandoffSection
                    lifecycleSection
                    if let error = model.lastError {
                        Divider()
                        Text("Error").font(.headline).foregroundStyle(.red)
                        Text(error).font(.caption).textSelection(.enabled)
                    }
                }
                .padding()
            }
            .navigationTitle("NFC")
        }
        .task {
            model.runLaunchAutomationIfRequested()
        }
        .onChange(of: scenePhase) { _, phase in
            model.recordScenePhase(phase)
        }
    }

    private var statusRow: some View {
        HStack {
            Circle()
                .fill(model.scanning ? Color.orange : Color.green)
                .frame(width: 10, height: 10)
            Text(model.statusText)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private var receiverSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Receiver").font(.headline)
            monoLabel("uniqueID", model.uniqueID)
            monoLabel("receiverID", model.receiverIDHex)
            monoLabel("source", model.receiverIDSource)
        }
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                model.readPatchInfo()
            } label: {
                Label("Read sensor", systemImage: "wave.3.right")
            }
            .buttonStyle(.borderedProminent)
            .disabled(model.scanning)

            Button {
                model.runFirstPairCandidate()
            } label: {
                Label("Run pairing candidate", systemImage: "antenna.radiowaves.left.and.right")
            }
            .buttonStyle(.bordered)
            .disabled(model.scanning)
        }
    }

    @ViewBuilder
    private var decodedDataSection: some View {
        if model.latestGlucose != nil || model.latestPatchStatus != nil || !model.recentDecodedPackets.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Divider()
                HStack {
                    Text("Decoded data").font(.headline)
                    Spacer()
                    Button {
                        model.clearDecodedData()
                    } label: {
                        Label("Clear", systemImage: "trash")
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Clear decoded data")
                }

                if let glucose = model.latestGlucose {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(glucose.currentDisplay)
                            .font(.system(size: 40, weight: .semibold, design: .rounded))
                        monoLabel("lifeCount", "\(glucose.lifeCount)")
                        monoLabel("rate", glucose.rateDisplay)
                        monoLabel("trend", "\(glucose.trend)")
                        monoLabel("history", glucose.historicalDisplay)
                        monoLabel("tempRaw", "\(glucose.temperatureRaw)")
                        monoLabel("statusBits", "\(glucose.statusBits)")
                        monoLabel("seq", glucose.sequenceDisplay)
                        Text(glucose.receivedDisplay)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if let patch = model.latestPatchStatus {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Patch status").font(.subheadline).bold()
                        monoLabel("state", "\(patch.patchState) \(patch.patchStateKind)")
                        monoLabel("lifeCount", "\(patch.currentLifeCount)")
                        monoLabel("phase", patch.lifecyclePhase)
                        monoLabel("wearLeft", patch.remainingWearDisplay)
                        monoLabel("events", "\(patch.totalEvents)")
                        monoLabel("stackDisc", "\(patch.stackDisconnectReason)")
                        monoLabel("appDisc", "\(patch.appDisconnectReason)")
                        monoLabel("seq", patch.sequenceDisplay)
                    }
                }

                if model.historicalBackfill.samples.count > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Backfill").font(.subheadline).bold()
                        monoLabel("samples", "\(model.historicalBackfill.samples.count)")
                        monoLabel("range", model.historicalBackfillRangeDisplay)
                        monoLabel("gaps", model.historicalBackfillGapDisplay)
                    }
                }

                if !model.glucoseReadings.isEmpty {
                    Text("Recent glucose").font(.subheadline).bold()
                    ForEach(model.glucoseReadings.prefix(6)) { reading in
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(reading.currentDisplay)  lc \(reading.lifeCount)  rate \(reading.rateDisplay)")
                                .font(.system(.caption, design: .monospaced))
                            Text(reading.receivedDisplay)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                if !model.recentDecodedPackets.isEmpty {
                    Text("Recent packets").font(.subheadline).bold()
                    ForEach(model.recentDecodedPackets.prefix(8)) { packet in
                        Text(packet.summary)
                            .font(.system(.caption2, design: .monospaced))
                            .textSelection(.enabled)
                    }
                }
            }
        }
    }

    private var connectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
            Text("Pairing connection").font(.headline)
            monoLabel("status", model.bleHandoffStatus)
            monoLabel("reconnect", model.reconnectStatus)
            monoLabel("active", model.activeConnectionDisplay)
            HStack {
                Button {
                    model.disconnectActiveSession()
                } label: {
                    Label("Disconnect", systemImage: "bolt.slash")
                }
                .buttonStyle(.bordered)
                .disabled(!model.hasActiveConnection)

                Button {
                    model.registerWakeEvents()
                } label: {
                    Label("Register wake", systemImage: "alarm")
                }
                .buttonStyle(.bordered)
            }
        }
    }

    @ViewBuilder
    private var persistenceSection: some View {
        if model.activatedSensorState != nil || model.persistedSensorState != nil ||
            model.savedSensorStateURL != nil {
            VStack(alignment: .leading, spacing: 8) {
                Divider()
                Text("Saved sensor state").font(.headline)
                if let url = model.savedSensorStateURL {
                    monoLabel("file", url.lastPathComponent)
                }
                if let state = model.persistedSensorState ?? model.activatedSensorState {
                    monoLabel("serial", state.serialNumber ?? "")
                    monoLabel("ble", state.bleAddress ?? "")
                    monoLabel("blePIN", hex(state.blePIN))
                    monoLabel("receiverID", state.receiverID?.displayString ?? "nil")
                    monoLabel("lastGlucoseLC", state.lastGlucoseLifeCount.map(String.init) ?? "nil")
                    monoLabel("lastGlucose", state.lastGlucoseMgDL.map { "\($0) mg/dL" } ?? "nil")
                    if let source = state.source {
                        monoLabel("source", source)
                    }
                }
                HStack {
                    Button {
                        model.reloadPersistedState()
                    } label: {
                        Label("Reload", systemImage: "arrow.triangle.2.circlepath")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        model.connectPersistedState()
                    } label: {
                        Label("Pair saved", systemImage: "link")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(model.bleHandoffRunning || (model.persistedSensorState == nil && model.activatedSensorState == nil))
                }
            }
        }
    }

    @ViewBuilder
    private var patchSection: some View {
        if let patch = model.patchInfo {
            VStack(alignment: .leading, spacing: 6) {
                Divider()
                Text("Patch").font(.headline)
                monoLabel("serial", patch.serialNumber)
                monoLabel("state", String(format: "0x%02x", patch.stateByte))
                monoLabel("fw", patch.firmwareVersion)
                monoLabel("next", patch.recommendedCommandCode == .activate ? "A0" : "A8")
                Text(hex(patch.raw))
                    .font(.system(.caption2, design: .monospaced))
                    .textSelection(.enabled)
            }
        }
    }

    @ViewBuilder
    private var activationSection: some View {
        if let activation = model.activationResponse {
            VStack(alignment: .leading, spacing: 6) {
                Divider()
                Text("Activation").font(.headline).foregroundStyle(.green)
                monoLabel("ble", activation.bleAddressDisplay)
                monoLabel("blePIN", hex(activation.blePIN))
                monoLabel("raw", hex(activation.raw))
                if let state = model.activatedSensorState {
                    monoLabel("state", stateJSON(state))
                }
            }
        }
    }

    @ViewBuilder
    private var bleHandoffSection: some View {
        if model.activatedSensorState != nil || model.bleHandoffRunning ||
            model.savedSensorStateURL != nil || model.bleBootstrapSummary != nil {
            VStack(alignment: .leading, spacing: 6) {
                Divider()
                Text("Pairing transcript").font(.headline)
                monoLabel("status", model.bleHandoffStatus)
                if let url = model.savedSensorStateURL {
                    monoLabel("stateFile", url.lastPathComponent)
                }
                if let summary = model.bleBootstrapSummary {
                    Text(summary)
                        .font(.system(.caption2, design: .monospaced))
                        .textSelection(.enabled)
                }
                Button {
                    model.retryBLEHandoff()
                } label: {
                    Label("Retry pairing", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.bordered)
                .disabled(model.bleHandoffRunning || model.activatedSensorState == nil)
            }
        }
    }

    @ViewBuilder
    private var lifecycleSection: some View {
        if !model.lifecycleEvents.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                Divider()
                HStack {
                    Text("Lifecycle").font(.headline)
                    Spacer()
                    Button {
                        model.copyLifecycleEventsToPasteboard()
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Copy lifecycle events")
                }
                monoLabel("scene", model.latestScenePhase)
                ForEach(Array(model.lifecycleEvents.suffix(12))) { event in
                    Text(event.summary)
                        .font(.system(.caption2, design: .monospaced))
                        .textSelection(.enabled)
                }
            }
        }
    }

    private func monoLabel(_ name: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(name).font(.caption).foregroundStyle(.secondary).frame(width: 80, alignment: .leading)
            Text(value).font(.system(.caption2, design: .monospaced)).textSelection(.enabled)
        }
    }

    private func hex(_ data: Data) -> String {
        data.map { String(format: "%02x", $0) }.joined()
    }

    private func stateJSON(_ state: Libre3SensorState) -> String {
        var fields = [
            "\"serialNumber\":\"\(state.serialNumber ?? "")\"",
            "\"bleAddress\":\"\(state.bleAddress ?? "")\"",
            "\"blePIN\":\"\(hex(state.blePIN))\"",
        ]
        if let receiverID = state.receiverID {
            fields.append("\"receiverID\":\"\(receiverID.littleEndianHex)\"")
        }
        if let lastGlucoseLifeCount = state.lastGlucoseLifeCount {
            fields.append("\"lastGlucoseLifeCount\":\(lastGlucoseLifeCount)")
        }
        if let lastGlucoseMgDL = state.lastGlucoseMgDL {
            fields.append("\"lastGlucoseMgDL\":\(lastGlucoseMgDL)")
        }
        if let source = state.source {
            fields.append("\"source\":\"\(source)\"")
        }
        return "{\(fields.joined(separator: ","))}"
    }
}

struct GlucoseDisplay: Identifiable, Equatable {
    let id = UUID()
    let receivedAt: Date
    let sequenceNumber: UInt16
    let lifeCount: UInt16
    let currentGlucoseMgDL: UInt16?
    let rateOfChangeMgDLPerMinute: Float?
    let trend: UInt8
    let statusBits: UInt8
    let historicalLifeCount: UInt16
    let historicalGlucoseMgDL: UInt16?
    let temperatureRaw: UInt16
    let fastDataWordsLE: [UInt16]
    let plaintextHex: String

    var currentDisplay: String {
        currentGlucoseMgDL.map { "\($0) mg/dL" } ?? "invalid"
    }

    var rateDisplay: String {
        rateOfChangeMgDLPerMinute.map { String(format: "%.2f mg/dL/min", $0) } ?? "nil"
    }

    var historicalDisplay: String {
        let value = historicalGlucoseMgDL.map(String.init) ?? "invalid"
        return "\(value) @ \(historicalLifeCount)"
    }

    var sequenceDisplay: String {
        String(format: "0x%04x", sequenceNumber)
    }

    var receivedDisplay: String {
        receivedAt.formatted(date: .omitted, time: .standard)
    }
}

struct PatchStatusDisplay: Identifiable, Equatable {
    let id = UUID()
    let receivedAt: Date
    let sequenceNumber: UInt16
    let patchState: Int8
    let patchStateKind: Libre3PatchState
    let currentLifeCount: Int16
    let lifecyclePhase: String
    let remainingWarmupMinutes: Int
    let remainingWearMinutes: Int?
    let totalEvents: Int
    let stackDisconnectReason: Int8
    let appDisconnectReason: Int8

    var sequenceDisplay: String {
        String(format: "0x%04x", sequenceNumber)
    }

    var remainingWearDisplay: String {
        remainingWearMinutes.map(String.init) ?? "unknown"
    }
}

struct DecodedPacketDisplay: Identifiable, Equatable {
    let id = UUID()
    let receivedAt: Date
    let summary: String
}

struct LifecycleEventDisplay: Identifiable, Equatable {
    let id = UUID()
    let occurredAt: Date
    let message: String

    var summary: String {
        "[\(occurredAt.formatted(date: .omitted, time: .standard))] \(message)"
    }
}

@MainActor
final class NFCActivationViewModel: ObservableObject {
    private static let buildMarker = "2026-05-10-bounded-saved-state-backfill"

    @Published var statusText = "Ready"
    @Published var scanning = false
    @Published var patchInfo: Libre3NFCPatchInfo?
    @Published var activationResponse: Libre3NFCActivationResponse?
    @Published var activatedSensorState: Libre3SensorState?
    @Published var savedSensorStateURL: URL?
    @Published var persistedSensorState: Libre3SensorState?
    @Published var bleHandoffStatus = "Idle"
    @Published var bleHandoffRunning = false
    @Published var bleBootstrapSummary: String?
    @Published var lastError: String?
    @Published var latestGlucose: GlucoseDisplay?
    @Published var glucoseReadings: [GlucoseDisplay] = []
    @Published var latestPatchStatus: PatchStatusDisplay?
    @Published var historicalBackfill = HistoricalBackfill()
    @Published var recentDecodedPackets: [DecodedPacketDisplay] = []
    @Published var lifecycleEvents: [LifecycleEventDisplay] = []
    @Published var latestScenePhase = "unknown"
    @Published var hasActiveConnection = false
    @Published var activeConnectionDisplay = "none"
    @Published var reconnectStatus = "idle"

    let uniqueID: String
    let receiverID: UInt32
    let receiverIDSource: String
    private let reader = Libre3NFCActivationReader()
    private let scanner = SensorScanner(
        configuration: SensorScannerConfiguration(
            restorationIdentifier: "org.roundwhitedisc.pairing-central",
            notifyOnConnection: true,
            notifyOnDisconnection: true,
            notifyOnNotification: true
        )
    )
    private let bleWindowTimeout: TimeInterval = 150
    private let postAuthInitialListenDuration: TimeInterval = 160
    private var activeSession: SensorSession?
    private var activePeripheralID: UUID?
    private var activePeripheralName: String?
    private var targetPeripheralID: UUID?
    private var desiredSensorState: Libre3SensorState?
    private var activeSessionMaterial: Phase6SessionMaterial?
    private var postAuthListenTask: Task<Void, Never>?
    private var postAuthListenerGeneration = 0
    private var reconnectTask: Task<Void, Never>?
    private var foregroundRefreshTask: Task<Void, Never>?
    private var pendingReconnectReason: String?
    private var pendingReconnectPeripheral: CBPeripheral?
    private var autoReconnectEnabled = false
    private var dataPlaneSessionEstablished = false
    private var reconnectAttempt = 0
    private let launchSendCandidatePhase5 = ProcessInfo.processInfo.arguments.contains("--send-candidate-firstpair-phase5") ||
        ProcessInfo.processInfo.arguments.contains("--auto-firstpair-candidate")
    private let autoNFCRead = ProcessInfo.processInfo.arguments.contains("--auto-nfc-read")
    private let autoNFCActivate = ProcessInfo.processInfo.arguments.contains("--auto-nfc-activate")
    private let autoNFCSwitchReceiver = ProcessInfo.processInfo.arguments.contains("--auto-nfc-switch-receiver")
    private let autoNFCActivateOrSwitch = ProcessInfo.processInfo.arguments.contains("--auto-nfc-activate-or-switch")
    private let autoNFCForceA0 = ProcessInfo.processInfo.arguments.contains("--auto-nfc-force-a0")
    private let autoNFCForceA8 = ProcessInfo.processInfo.arguments.contains("--auto-nfc-force-a8")
    private let autoFirstPairCandidate = ProcessInfo.processInfo.arguments.contains("--auto-firstpair-candidate")
    private let allowLateA8FirstPairCandidate = ProcessInfo.processInfo.arguments.contains("--allow-late-a8-firstpair-candidate")
    private let debugClinicalAfterHistory = ProcessInfo.processInfo.arguments.contains("--post-auth-clinical")
    private let skipPostAuthHistory = ProcessInfo.processInfo.arguments.contains("--skip-post-auth-history")
    private let autoConnectSavedState = !ProcessInfo.processInfo.arguments.contains("--no-auto-connect-saved-state")
    private let launchUseCapturedUserCert = ProcessInfo.processInfo.arguments.contains("--phone-cert-162b") ||
        ProcessInfo.processInfo.arguments.contains("--user-fresh-pair-cert")
    private var manualSendCandidatePhase5 = false
    private var manualUseCapturedUserCert = false
    private var launchAutomationStarted = false

    private var sendCandidatePhase5: Bool {
        launchSendCandidatePhase5 || manualSendCandidatePhase5
    }

    private var useCapturedUserCert: Bool {
        launchUseCapturedUserCert || manualUseCapturedUserCert || autoFirstPairCandidate
    }

    private var phoneCertLabel: String {
        useCapturedUserCert ? "phone_cert_162b" : "phone_cert_firstpair"
    }

    var receiverIDHex: String {
        Libre3ReceiverID(receiverID).displayString
    }

    init() {
        let key = "RoundWhiteDiscAccountlessUniqueID"
        if let existing = UserDefaults.standard.string(forKey: key) {
            uniqueID = existing
        } else {
            let created = UUID().uuidString.lowercased()
            UserDefaults.standard.set(created, forKey: key)
            uniqueID = created
        }
        if let override = Self.receiverIDOverride(from: ProcessInfo.processInfo.arguments) {
            receiverID = override.id
            receiverIDSource = override.source
        } else {
            receiverID = NFCActivationCommand.accountlessReceiverID(from: uniqueID)
            receiverIDSource = "accountless uniqueID"
        }
        appendHandoffLog(
            "App build marker=\(Self.buildMarker) " +
            "args=\(ProcessInfo.processInfo.arguments.dropFirst().joined(separator: " "))"
        )
        loadPersistedSensorState()
        observeScannerLifecycle()
    }

    func readPatchInfo() {
        manualSendCandidatePhase5 = false
        manualUseCapturedUserCert = false
        run(.readPatchInfo)
    }

    func activateFreshSensor() {
        manualSendCandidatePhase5 = false
        manualUseCapturedUserCert = false
        run(.activateFreshSensor(receiverID: receiverID))
    }

    func runFirstPairCandidate() {
        manualSendCandidatePhase5 = true
        manualUseCapturedUserCert = true
        appendHandoffLog("Manual pairing candidate: activate-or-switch with candidate Phase 5 and phone_cert_162b")
        activateOrSwitchReceiver()
    }

    func switchReceiver() {
        run(.switchReceiver(receiverID: receiverID))
    }

    func activateOrSwitchReceiver() {
        run(.activateOrSwitchReceiver(receiverID: receiverID))
    }

    func forceActivationCommand(_ commandCode: NFCActivationCommandCode) {
        run(.forceActivationCommand(commandCode: commandCode, receiverID: receiverID))
    }

    func runLaunchAutomationIfRequested() {
        guard !launchAutomationStarted, !scanning else { return }
        launchAutomationStarted = true
        if autoFirstPairCandidate {
            appendHandoffLog("Launch automation: auto first-pair candidate")
            activateOrSwitchReceiver()
        } else if autoNFCForceA0 {
            appendHandoffLog("Launch automation: auto NFC force A0")
            forceActivationCommand(.activate)
        } else if autoNFCForceA8 {
            appendHandoffLog("Launch automation: auto NFC force A8")
            forceActivationCommand(.switchReceiver)
        } else if autoNFCActivateOrSwitch {
            appendHandoffLog("Launch automation: auto NFC activate-or-switch")
            activateOrSwitchReceiver()
        } else if autoNFCSwitchReceiver {
            appendHandoffLog("Launch automation: auto NFC switch receiver")
            switchReceiver()
        } else if autoNFCActivate {
            appendHandoffLog("Launch automation: auto NFC activate")
            activateFreshSensor()
        } else if autoNFCRead {
            appendHandoffLog("Launch automation: auto NFC read")
            readPatchInfo()
        } else if sendCandidatePhase5 {
            appendHandoffLog("Launch automation: NFC tab selected; waiting for manual activate")
        } else if autoConnectSavedState, persistedSensorState != nil || activatedSensorState != nil {
            appendHandoffLog("Launch automation: saved-state reconnect")
            connectPersistedState()
        }
    }

    private func run(_ mode: Libre3NFCScanMode) {
        scanning = true
        lastError = nil
        activationResponse = nil
        activatedSensorState = nil
        bleBootstrapSummary = nil
        statusText = "Scanning…"
        appendHandoffLog(
            "NFC scan started sendCandidatePhase5=\(sendCandidatePhase5) " +
            "phoneCert=\(phoneCertLabel) " +
            "receiverID=\(receiverIDHex) receiverSource=\(receiverIDSource)"
        )

        Task {
            do {
                let result = try await reader.scan(mode: mode)
                patchInfo = result.patchInfo
                activationResponse = result.activationResponse
                appendHandoffLog(
                    "NFC patch serial=\(result.patchInfo.serialNumber) " +
                    "state=0x\(String(format: "%02x", result.patchInfo.stateByte)) " +
                    "next=\(result.patchInfo.recommendedCommandCode == .activate ? "A0" : "A8") " +
                    "raw=\(Self.hex(result.patchInfo.raw)) " +
                    "inputRaw=\(Self.hex(result.patchInfo.inputRaw))"
                )
                if let activation = result.activationResponse {
                    let source = result.commandCode == .switchReceiver
                        ? "NFC switch receiver response"
                        : "NFC activation response"
                    let state = try activation.sensorState(
                        serialNumber: result.patchInfo.serialNumber,
                        receiverID: Libre3ReceiverID(receiverID),
                        patchInfo: result.patchInfo,
                        source: source
                    )
                    activatedSensorState = state
                    savedSensorStateURL = try saveActivatedState(state)
                    statusText = result.commandCode == .switchReceiver
                        ? "Switched \(activation.bleAddressDisplay)"
                        : "Activated \(activation.bleAddressDisplay)"
                    appendHandoffLog(
                        "NFC response command=\(result.commandCode == .switchReceiver ? "A8" : "A0") " +
                        "ble=\(activation.bleAddressDisplay) " +
                        "blePIN=\(Self.hex(activation.blePIN)) " +
                        "activationTimeRaw=\(Self.hex(activation.activationTimeRaw)) " +
                        "stateFile=\(savedSensorStateURL?.lastPathComponent ?? "")"
                    )
                    if shouldSkipFirstPairCandidateBLE(
                        patchInfo: result.patchInfo,
                        commandCode: result.commandCode
                    ) {
                        bleHandoffStatus = "Skipped late A8 first-pair candidate"
                        appendHandoffLog(
                            "BLE handoff skipped reason=late-a8-firstpair-candidate " +
                            "state=0x\(String(format: "%02x", result.patchInfo.stateByte)) " +
                            "override=--allow-late-a8-firstpair-candidate"
                        )
                    } else {
                        startBLEHandoff(with: state, reason: "nfc-scan")
                    }
                } else {
                    statusText = "Read \(result.patchInfo.serialNumber)"
                }
            } catch {
                lastError = String(describing: error)
                statusText = "NFC failed"
                appendHandoffLog("NFC failed error=\(String(describing: error))")
            }
            scanning = false
        }
    }

    func retryBLEHandoff() {
        guard let state = activatedSensorState else { return }
        if let patchInfo,
           shouldSkipFirstPairCandidateBLE(
               patchInfo: patchInfo,
               commandCode: patchInfo.recommendedCommandCode
           ) {
            bleHandoffStatus = "Skipped late A8 first-pair candidate"
            appendHandoffLog(
                "BLE handoff retry skipped reason=late-a8-firstpair-candidate " +
                "state=0x\(String(format: "%02x", patchInfo.stateByte)) " +
                "override=--allow-late-a8-firstpair-candidate"
            )
            return
        }
        startBLEHandoff(with: state, reason: "retry")
    }

    private func shouldSkipFirstPairCandidateBLE(
        patchInfo: Libre3NFCPatchInfo,
        commandCode: NFCActivationCommandCode?
    ) -> Bool {
        sendCandidatePhase5 &&
            commandCode == .switchReceiver &&
            patchInfo.stateByte >= 0x04 &&
            !manualSendCandidatePhase5 &&
            !allowLateA8FirstPairCandidate
    }

    private func saveActivatedState(_ state: Libre3SensorState) throws -> URL {
        let url = sensorStateFileURL()
        try Libre3SensorStateLoader.write(state, to: url)
        persistedSensorState = state
        savedSensorStateURL = url
        appendLifecycleEvent(
            "persisted sensor serial=\(state.serialNumber ?? "") " +
            "ble=\(state.bleAddress ?? "") receiverID=\(state.receiverID?.littleEndianHex ?? "nil")"
        )
        return url
    }

    private func persistLastGlucose(lifeCount: UInt16, mgDL: UInt16?) {
        guard let state = persistedSensorState ?? activatedSensorState ?? desiredSensorState else {
            return
        }
        guard state.lastGlucoseLifeCount != lifeCount || state.lastGlucoseMgDL != mgDL else {
            return
        }
        do {
            let updated = try state.updatingLastGlucose(lifeCount: lifeCount, mgDL: mgDL)
            let url = sensorStateFileURL()
            try Libre3SensorStateLoader.write(updated, to: url)
            persistedSensorState = updated
            savedSensorStateURL = url
            if activatedSensorState?.serialNumber == state.serialNumber {
                activatedSensorState = updated
            }
            if desiredSensorState?.serialNumber == state.serialNumber {
                desiredSensorState = updated
            }
            appendLifecycleEvent(
                "persisted last glucose lc=\(lifeCount) value=\(mgDL.map(String.init) ?? "nil")"
            )
        } catch {
            appendLifecycleEvent("last glucose persist failed: \(String(describing: error))")
        }
    }

    func reloadPersistedState() {
        loadPersistedSensorState(reportMissing: true)
    }

    func connectPersistedState() {
        guard let state = persistedSensorState ?? activatedSensorState else {
            lastError = "No saved sensor state"
            appendLifecycleEvent("saved-state pairing requested without saved state")
            return
        }
        manualSendCandidatePhase5 = true
        manualUseCapturedUserCert = true
        appendHandoffLog(
            "Saved-state pairing requested serial=\(state.serialNumber ?? "") " +
            "ble=\(state.bleAddress ?? "") receiverID=\(state.receiverID?.littleEndianHex ?? "nil")"
        )
        startBLEHandoff(with: state, reason: "saved-state")
    }

    func disconnectActiveSession() {
        guard let session = activeSession else {
            appendLifecycleEvent("disconnect requested with no active session")
            return
        }
        autoReconnectEnabled = false
        pendingReconnectReason = nil
        pendingReconnectPeripheral = nil
        reconnectTask?.cancel()
        reconnectTask = nil
        foregroundRefreshTask?.cancel()
        foregroundRefreshTask = nil
        postAuthListenTask?.cancel()
        postAuthListenTask = nil
        postAuthListenerGeneration += 1
        reconnectStatus = "disabled by manual disconnect"
        appendLifecycleEvent("disconnect requested target=\(activeConnectionDisplay)")
        registerWakeEventsForCurrentSession(reason: "before-disconnect")
        scanner.disconnect(session)
        clearActiveSession(resetTarget: false)
        bleHandoffStatus = "Disconnect requested"
    }

    func registerWakeEvents() {
        registerWakeEventsForCurrentSession(reason: "manual")
    }

    private func registerWakeEventsForCurrentSession(reason: String) {
        let ids = activePeripheralID.map { [$0] }
        scanner.registerForConnectionEvents(
            peripheralIDs: ids,
            serviceUUIDs: [LibreSensorGATT.serviceUUID]
        )
        appendLifecycleEvent(
            "registered connection events reason=\(reason) peripheral=" +
            "\(activePeripheralID?.uuidString ?? "any") service=\(LibreSensorGATT.serviceUUID.uuidString)"
        )
    }

    func clearDecodedData() {
        latestGlucose = nil
        glucoseReadings.removeAll()
        latestPatchStatus = nil
        historicalBackfill = HistoricalBackfill()
        recentDecodedPackets.removeAll()
        appendLifecycleEvent("decoded data cleared")
    }

    func copyLifecycleEventsToPasteboard() {
        let text = lifecycleEvents
            .map(\.summary)
            .joined(separator: "\n")
#if canImport(UIKit)
        UIPasteboard.general.string = text
        appendLifecycleEvent("copied \(lifecycleEvents.count) lifecycle events")
#else
        _ = text
#endif
    }

    var historicalBackfillRangeDisplay: String {
        guard let first = historicalBackfill.firstLifeCount,
              let last = historicalBackfill.lastLifeCount else {
            return "none"
        }
        return "\(first)...\(last)"
    }

    var historicalBackfillGapDisplay: String {
        historicalBackfill.gaps.isEmpty
            ? "none"
            : historicalBackfill.gaps
                .prefix(4)
                .map { "\($0.afterLifeCount)->\($0.beforeLifeCount)" }
                .joined(separator: ",")
    }

    func recordScenePhase(_ phase: ScenePhase) {
        let display: String
        switch phase {
        case .active:
            display = "active"
        case .inactive:
            display = "inactive"
        case .background:
            display = "background"
        @unknown default:
            display = "unknown"
        }
        latestScenePhase = display
        appendLifecycleEvent("scene \(display)")
        if phase == .active {
            handleSceneBecameActive()
        }
    }

    private func handleSceneBecameActive() {
        guard autoReconnectEnabled || desiredSensorState != nil || persistedSensorState != nil else {
            return
        }
        if hasActiveConnection {
            refreshActiveDataPlane(reason: "foreground")
        } else {
            requestReconnect(reason: "foreground-active-no-session", immediate: true)
        }
    }

    private func refreshActiveDataPlane(reason: String) {
        guard let session = activeSession, let material = activeSessionMaterial else {
            requestReconnect(reason: "\(reason)-missing-session-material", immediate: true)
            return
        }
        foregroundRefreshTask?.cancel()
        foregroundRefreshTask = Task { @MainActor [weak self, session, material] in
            guard let self else { return }
            do {
                let crypto = try DataPlaneCrypto(sessionMaterial: material)
                self.appendLifecycleEvent("foreground data-plane refresh reason=\(reason)")
                if self.postAuthListenTask == nil {
                    self.startPersistentPostAuthListener(
                        session: session,
                        crypto: crypto,
                        counter: FirstPairPostAuthCounter(),
                        reason: "\(reason)-listener-restart"
                    )
                }
                await self.refreshFirstPairPostAuthNotifications(via: session)
                await self.readFirstPairPatchStatus(via: session, crypto: crypto)
                self.reconnectStatus = "active session refreshed"
            } catch {
                self.appendLifecycleEvent("foreground refresh failed: \(String(describing: error))")
                self.requestReconnect(reason: "\(reason)-refresh-failed", immediate: true)
            }
            self.foregroundRefreshTask = nil
        }
    }

    private func requestReconnect(
        reason: String,
        preferredPeripheral: CBPeripheral? = nil,
        immediate: Bool = false
    ) {
        if let preferredPeripheral {
            pendingReconnectPeripheral = preferredPeripheral
            targetPeripheralID = preferredPeripheral.identifier
        }
        guard autoReconnectEnabled else {
            appendLifecycleEvent("reconnect ignored reason=\(reason) autoReconnect=false")
            return
        }
        guard desiredSensorState ?? persistedSensorState ?? activatedSensorState != nil else {
            appendLifecycleEvent("reconnect ignored reason=\(reason) no saved sensor state")
            return
        }
        if bleHandoffRunning {
            pendingReconnectReason = reason
            reconnectStatus = "pending: \(reason)"
            appendLifecycleEvent("reconnect pending reason=\(reason)")
            return
        }
        scheduleReconnect(reason: reason, preferredPeripheral: preferredPeripheral, immediate: immediate)
    }

    private func scheduleReconnect(
        reason: String,
        preferredPeripheral: CBPeripheral? = nil,
        immediate: Bool = false
    ) {
        guard reconnectTask == nil else {
            appendLifecycleEvent("reconnect already scheduled reason=\(reason)")
            return
        }
        guard let state = desiredSensorState ?? persistedSensorState ?? activatedSensorState else {
            appendLifecycleEvent("reconnect schedule skipped reason=\(reason) no saved sensor state")
            return
        }

        reconnectAttempt += 1
        let attempt = reconnectAttempt
        let delay = immediate ? 0 : Self.reconnectDelay(forAttempt: attempt)
        reconnectStatus = delay > 0
            ? "scheduled in \(Int(delay))s (\(reason))"
            : "scheduled now (\(reason))"
        appendLifecycleEvent(
            "reconnect scheduled attempt=\(attempt) delay=\(Int(delay))s reason=\(reason)"
        )

        reconnectTask = Task { @MainActor [weak self, state, preferredPeripheral] in
            if delay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            guard let self, !Task.isCancelled else { return }
            let directPeripheral = preferredPeripheral ?? self.pendingReconnectPeripheral
            self.pendingReconnectPeripheral = nil
            self.reconnectTask = nil
            self.startBLEHandoff(
                with: state,
                reason: "auto-reconnect:\(reason)",
                preferredPeripheral: directPeripheral
            )
        }
    }

    nonisolated private static func reconnectDelay(forAttempt attempt: Int) -> TimeInterval {
        switch attempt {
        case ..<2:
            return 0
        case 2:
            return 10
        case 3:
            return 30
        default:
            return 60
        }
    }

    private func sensorStateFileURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Libre3SensorState.json")
    }

    private func loadPersistedSensorState(reportMissing: Bool = false) {
        let url = sensorStateFileURL()
        savedSensorStateURL = FileManager.default.fileExists(atPath: url.path) ? url : nil
        guard let data = try? Data(contentsOf: url) else {
            persistedSensorState = nil
            if reportMissing {
                appendLifecycleEvent("no saved sensor state found")
            }
            return
        }
        do {
            let state = try Libre3SensorStateLoader.load(fromJSON: data)
            persistedSensorState = state
            desiredSensorState = state
            autoReconnectEnabled = autoConnectSavedState
            reconnectStatus = autoConnectSavedState ? "loaded saved state" : "saved-state auto-connect disabled"
            savedSensorStateURL = url
            appendLifecycleEvent(
                "loaded saved state serial=\(state.serialNumber ?? "") " +
                "ble=\(state.bleAddress ?? "") receiverID=\(state.receiverID?.littleEndianHex ?? "nil") " +
                "lastGlucoseLC=\(state.lastGlucoseLifeCount.map(String.init) ?? "nil")"
            )
        } catch {
            persistedSensorState = nil
            lastError = "Saved sensor state: \(error)"
            appendLifecycleEvent("saved state load failed: \(String(describing: error))")
        }
    }

    private func observeScannerLifecycle() {
        Task { [weak self] in
            guard let self else { return }
            for await event in self.scanner.restorationEvents() {
                let peripheralIDs = event.peripherals
                    .map { String($0.identifier.uuidString.prefix(8)) }
                    .joined(separator: ",")
                let services = event.scanServices
                    .map(\.uuidString)
                    .joined(separator: ",")
                self.appendLifecycleEvent(
                    "restored peripherals=[\(peripheralIDs)] scanServices=[\(services)]"
                )
            }
        }

        Task { [weak self] in
            guard let self else { return }
            for await event in self.scanner.connectionEvents() {
                let name = event.peripheral.name ?? String(event.peripheral.identifier.uuidString.prefix(8))
                self.appendLifecycleEvent(
                    "connectionEvent \(Self.connectionEventName(event.event)) target=\(name)"
                )
                switch event.event {
                case .peerConnected:
                    self.requestReconnect(
                        reason: "connection-event-peerConnected",
                        preferredPeripheral: event.peripheral,
                        immediate: true
                    )
                case .peerDisconnected:
                    if self.hasActiveConnection && event.peripheral.identifier == self.activePeripheralID {
                        self.requestReconnect(
                            reason: "connection-event-peerDisconnected",
                            preferredPeripheral: event.peripheral,
                            immediate: false
                        )
                    }
                @unknown default:
                    break
                }
            }
        }
    }

    private func appendLifecycleEvent(_ message: String) {
        lifecycleEvents.append(LifecycleEventDisplay(occurredAt: Date(), message: message))
        if lifecycleEvents.count > 40 {
            lifecycleEvents.removeFirst(lifecycleEvents.count - 40)
        }
        appendHandoffLog("lifecycle \(message)")
    }

    private func setActiveSession(_ session: SensorSession, name: String) {
        activeSession = session
        activePeripheralID = session.peripheral.identifier
        targetPeripheralID = session.peripheral.identifier
        activePeripheralName = name
        hasActiveConnection = true
        activeConnectionDisplay = "\(name) \(String(session.peripheral.identifier.uuidString.prefix(8)))"
        appendLifecycleEvent("connected target=\(activeConnectionDisplay)")
    }

    private func clearActiveSession(resetTarget: Bool = false) {
        activeSession = nil
        activePeripheralID = nil
        activePeripheralName = nil
        activeSessionMaterial = nil
        hasActiveConnection = false
        activeConnectionDisplay = "none"
        if resetTarget {
            targetPeripheralID = nil
        }
    }

    private func recordDecodedPacket(
        _ packet: DataPlaneDecodedPacket,
        channelName: String,
        receivedAt: Date
    ) {
        let sequence = packet.frame.sequenceNumber
        let kind = packet.usedPreferredKind ? "\(packet.kind.rawValue)" : "\(packet.kind.rawValue) fallback"
        var summary = "\(channelName) seq=\(String(format: "0x%04x", sequence)) kind=\(kind)"
        switch packet.payload {
        case .realtimeGlucose(let reading):
            let item = GlucoseDisplay(
                receivedAt: receivedAt,
                sequenceNumber: sequence,
                lifeCount: reading.lifeCount,
                currentGlucoseMgDL: reading.currentGlucoseMgDL,
                rateOfChangeMgDLPerMinute: reading.rateOfChangeMgDLPerMinute,
                trend: reading.trend,
                statusBits: reading.statusBits,
                historicalLifeCount: reading.historicalLifeCount,
                historicalGlucoseMgDL: reading.historicalGlucoseMgDL,
                temperatureRaw: reading.temperature,
                fastDataWordsLE: reading.fastDataWordsLE,
                plaintextHex: Self.hex(packet.plaintext)
            )
            latestGlucose = item
            glucoseReadings.insert(item, at: 0)
            if glucoseReadings.count > 36 {
                glucoseReadings.removeLast(glucoseReadings.count - 36)
            }
            persistLastGlucose(lifeCount: reading.lifeCount, mgDL: reading.currentGlucoseMgDL)
            summary += " glucose=\(item.currentDisplay) rate=\(item.rateDisplay) tempRaw=\(item.temperatureRaw)"

        case .patchStatus(let status):
            let lifecycle = status.lifecycle(
                wearDurationMinutes: patchInfo.map { Int($0.wearDurationMinutes) }
            )
            let item = PatchStatusDisplay(
                receivedAt: receivedAt,
                sequenceNumber: sequence,
                patchState: status.patchState,
                patchStateKind: status.patchStateKind,
                currentLifeCount: status.currentLifeCount,
                lifecyclePhase: lifecycle.phase.rawValue,
                remainingWarmupMinutes: lifecycle.remainingWarmupMinutes,
                remainingWearMinutes: lifecycle.remainingWearMinutes,
                totalEvents: status.totalEvents,
                stackDisconnectReason: status.stackDisconnectReason,
                appDisconnectReason: status.appDisconnectReason
            )
            latestPatchStatus = item
            summary += " patchState=\(status.patchState) lc=\(status.currentLifeCount)"

        case .historicalReadingPage(let page):
            var updatedBackfill = historicalBackfill
            updatedBackfill.append(page)
            historicalBackfill = updatedBackfill
            let values = page.values.map(String.init).joined(separator: ",")
            summary += " histLC=\(page.startLifeCount)..\(page.endLifeCount) values=[\(values)]"

        case .raw:
            summary += " pt=\(Self.hex(packet.plaintext))"
        }

        recentDecodedPackets.insert(
            DecodedPacketDisplay(receivedAt: receivedAt, summary: summary),
            at: 0
        )
        if recentDecodedPackets.count > 48 {
            recentDecodedPackets.removeLast(recentDecodedPackets.count - 48)
        }
    }

    private func startBLEHandoff(
        with state: Libre3SensorState,
        reason: String,
        preferredPeripheral: CBPeripheral? = nil
    ) {
        desiredSensorState = state
        autoReconnectEnabled = true
        if let preferredPeripheral {
            pendingReconnectPeripheral = preferredPeripheral
            targetPeripheralID = preferredPeripheral.identifier
        }
        guard !bleHandoffRunning else {
            pendingReconnectReason = reason
            reconnectStatus = "pending: \(reason)"
            appendLifecycleEvent("BLE handoff already running; pending reconnect reason=\(reason)")
            return
        }
        reconnectTask?.cancel()
        reconnectTask = nil
        bleHandoffRunning = true
        bleHandoffStatus = "Waiting for Bluetooth"
        reconnectStatus = "handoff running (\(reason))"
        bleBootstrapSummary = nil
        appendHandoffLog(
            "BLE pairing started reason=\(reason) serial=\(state.serialNumber ?? "") " +
            "ble=\(state.bleAddress ?? "") blePIN=\(Self.hex(state.blePIN))"
        )

        Task { [weak self] in
            guard let self else { return }
            do {
                let summary = try await self.runBLEHandoff(
                    state: state,
                    preferredPeripheral: preferredPeripheral
                )
                self.bleBootstrapSummary = summary
                self.appendHandoffLog("BLE pairing succeeded\n\(summary)")
                self.bleHandoffStatus = self.sendCandidatePhase5
                    ? "Pairing complete"
                    : "Pairing preamble complete"
                self.reconnectStatus = "connected"
                self.reconnectAttempt = 0
            } catch {
                self.lastError = "BLE pairing: \(error)"
                self.bleHandoffStatus = "BLE pairing failed"
                self.appendHandoffLog("BLE pairing failed error=\(String(describing: error))")
                self.clearActiveSession(resetTarget: false)
                if self.autoReconnectEnabled && (self.dataPlaneSessionEstablished || reason.hasPrefix("auto-reconnect")) {
                    self.scheduleReconnect(reason: "handoff-failed:\(reason)", immediate: false)
                } else {
                    self.reconnectStatus = "failed"
                }
            }
            self.bleHandoffRunning = false
            if let pending = self.pendingReconnectReason {
                self.pendingReconnectReason = nil
                self.requestReconnect(reason: pending, immediate: false)
            }
        }
    }

    private func runBLEHandoff(
        state: Libre3SensorState,
        preferredPeripheral: CBPeripheral? = nil
    ) async throws -> String {
        try await scanner.waitUntilReady()
        bleHandoffStatus = "Scanning for Libre 3 service"
        let targetBLEName = Self.normalizedBLEAddress(state.bleAddress)

        let directCandidate: CBPeripheral?
        if let preferredPeripheral {
            directCandidate = preferredPeripheral
        } else {
            directCandidate = await reconnectPeripheral(targetBLEName: targetBLEName)
        }

        if let direct = directCandidate {
            do {
                return try await connectAndRunFirstPairPreamble(
                    peripheral: direct,
                    state: state,
                    targetName: direct.name ?? String(direct.identifier.uuidString.prefix(8)),
                    targetRSSI: nil,
                    source: "known-peripheral"
                )
            } catch {
                appendHandoffLog(
                    "BLE known-peripheral reconnect failed target=" +
                    "\(direct.name ?? String(direct.identifier.uuidString.prefix(8))) " +
                    "error=\(String(describing: error)); falling back to scan"
                )
            }
        }

        appendHandoffLog("BLE scan started timeout=\(Int(bleWindowTimeout))s")
        let discovered = try await firstLibreDiscovery(timeout: bleWindowTimeout, targetBLEName: targetBLEName)
        let name = discovered.name ?? String(discovered.id.uuidString.prefix(8))
        appendHandoffLog("BLE discovered target=\(name) rssi=\(discovered.rssi)")
        return try await connectAndRunFirstPairPreamble(
            peripheral: discovered.peripheral,
            state: state,
            targetName: name,
            targetRSSI: discovered.rssi,
            source: "scan"
        )
    }

    private func reconnectPeripheral(targetBLEName: String?) async -> CBPeripheral? {
        if let id = targetPeripheralID {
            let retrieved = await scanner.retrievePeripherals(withIdentifiers: [id])
            if let peripheral = retrieved.first {
                appendHandoffLog(
                    "BLE retrieved prior peripheral id=\(String(id.uuidString.prefix(8))) " +
                    "name=\(peripheral.name ?? "nil")"
                )
                return peripheral
            }
        }

        let connected = await scanner.retrieveConnectedPeripherals()
        if let targetBLEName {
            return connected.first { Self.normalizedBLEAddress($0.name) == targetBLEName }
        }
        return connected.first
    }

    private func connectAndRunFirstPairPreamble(
        peripheral: CBPeripheral,
        state: Libre3SensorState,
        targetName: String,
        targetRSSI: Int?,
        source: String
    ) async throws -> String {
        bleHandoffStatus = "Connecting to \(targetName)"
        appendHandoffLog(
            "BLE connect source=\(source) target=\(targetName) " +
            "id=\(String(peripheral.identifier.uuidString.prefix(8)))"
        )
        let session = try await scanner.connect(peripheral, timeout: bleWindowTimeout)
        bleHandoffStatus = "Connected; running first-pair preamble"
        appendHandoffLog("BLE connected target=\(targetName)")
        setActiveSession(session, name: targetName)
        return try await runFirstPairPreamble(
            session: session,
            state: state,
            targetName: targetName,
            targetRSSI: targetRSSI
        )
    }

    private func firstLibreDiscovery(timeout: TimeInterval, targetBLEName: String?) async throws -> DiscoveredSensor {
        let timeoutTask = Task { [scanner] in
            try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
            scanner.stopScan()
        }
        defer {
            timeoutTask.cancel()
            scanner.stopScan()
        }

        let stream = scanner.startScan(filter: [LibreSensorGATT.serviceUUID])
        for await found in stream {
            if let targetBLEName {
                let discoveredName = Self.normalizedBLEAddress(found.name)
                guard discoveredName == targetBLEName else {
                    appendHandoffLog(
                        "BLE skipped non-target discovery " +
                        "target=\(targetBLEName) found=\(found.name ?? String(found.id.uuidString.prefix(8))) " +
                        "rssi=\(found.rssi)"
                    )
                    continue
                }
            }
            return found
        }
        throw SensorScannerError.timeout("scan timed out after \(Int(timeout))s")
    }

    private func runFirstPairPreamble(
        session: SensorSession,
        state: Libre3SensorState,
        targetName: String,
        targetRSSI: Int?
    ) async throws -> String {
        appendHandoffLog("First-pair flow started sendCandidatePhase5=\(sendCandidatePhase5)")
        let phoneCert = try loadPhoneCert()
        appendHandoffLog("First-pair phone cert=\(phoneCert.label) len=\(phoneCert.cert.raw.count)")
        let nativeEphemeral = try await Task.detached(priority: .userInitiated) {
            try SessionKey.makeFirstPairNativeEphemeral { requestedCount in
                try Self.secureRandomData(count: requestedCount)
            }
        }.value
        appendHandoffLog(
            "First-pair native phone ephemeral attempts=\(nativeEphemeral.attempts) " +
            "pub=\(Self.hex(nativeEphemeral.keyPair.publicKey65))"
        )
        let eventLogger = makeHandoffEventLogger()
        let transport = SensorSessionTransport(session: session, eventLogger: eventLogger)
        let flow = PairingFlow(
            transport: transport,
            phoneCert: phoneCert.cert,
            phoneEph: nativeEphemeral.keyPair,
            eventLogger: eventLogger
        )
        if sendCandidatePhase5 {
            return try await runFirstPairCandidateHandshake(
                flow: flow,
                session: session,
                nativeEphemeral: nativeEphemeral,
                state: state,
                targetName: targetName,
                targetRSSI: targetRSSI
            )
        }

        let result = try await flow.runCommandGatedFirstPairPreamble()
        bleHandoffStatus = "Deriving candidate Phase 5 material"
        let staticScalarOverride = result.phaseHandshake.phoneCert.phase5StaticScalarWindowOverride
        let phase5Material = try await Task.detached(priority: .userInitiated) {
            try SessionKey.deriveFirstPairPhase5Material(
                preamble: result,
                nullEntropy11A: nativeEphemeral.nullEntropy11A,
                staticScalarWindow: staticScalarOverride
            )
        }.value

        return [
            "target=\(targetName) rssi=\(targetRSSI.map(String.init) ?? "unknown")",
            "nfcSerial=\(state.serialNumber ?? "")",
            "nfcBLE=\(state.bleAddress ?? "")",
            "blePIN=\(Self.hex(state.blePIN))",
            "sensorCert=\(result.phaseHandshake.sensorCert.raw.count)B " +
                "sensorEph=\(result.phaseHandshake.sensorEphPub.x963Representation.count)B",
            "S_eph_static=\(Self.hex(result.phaseHandshake.sharedEphStatic))",
            "S_eph_eph=\(Self.hex(result.phaseHandshake.sharedEphEph))",
            "R1=\(Self.hex(result.sensorR1))",
            "nonce7=\(Self.hex(result.nonce7))",
            "phoneEphPub=\(Self.hex(nativeEphemeral.keyPair.publicKey65))",
            "candidateStaticScalarOverride=\(staticScalarOverride?.count ?? 0)B",
            "candidateNullAttempts=\(phase5Material.nullAttempts)",
            "nativeNullAttempts=\(nativeEphemeral.attempts)",
            "candidateNullEntropy11A=\(Self.hex(phase5Material.nullEntropy11A))",
            "candidateNullScalarWindow=\(Self.hex(phase5Material.nullScalarWindow))",
            "candidatePhase5Source66=\(Self.hex(phase5Material.source66))",
            "candidatePhase5RawKey=\(Self.hex(phase5Material.rawKey))",
            "phase5=not sent",
        ].joined(separator: "\n")
    }

    private func runFirstPairCandidateHandshake(
        flow: PairingFlow,
        session: SensorSession,
        nativeEphemeral: FirstPairNativeEphemeralMaterial,
        state: Libre3SensorState,
        targetName: String,
        targetRSSI: Int?
    ) async throws -> String {
        bleHandoffStatus = "Running candidate first-pair Phase 5"
        let result = try await flow.runCommandGatedFirstPairHandshake(
            blePIN: state.blePIN,
            maxEntropyAttempts: 1,
            entropySource: { requestedCount in
                try Self.fixedEntropySource(nativeEphemeral.nullEntropy11A, requestedCount: requestedCount)
            },
            r2Provider: {
                try Self.secureRandomData(count: 16)
            }
        )
        let handshake = result.handshake
        let phase5Material = result.phase5Material
        let staticScalarOverride = handshake.preamble.phaseHandshake.phoneCert.phase5StaticScalarWindowOverride
        let phase6NoncePrefix = Self.phase6NoncePrefix(fromNonce: handshake.phase6.nonce)
        let historyStart = Self.historyBackfillStart(
            phase6NoncePrefix: phase6NoncePrefix,
            savedLastLifeCount: state.lastGlucoseLifeCount
        )
        bleHandoffStatus = "Phase 6 complete; listening for data"
        let postAuthSummary = try await runFirstPairPostAuthData(
            session: session,
            material: handshake.sessionMaterial,
            historicalLifeCount: historyStart,
            savedLastGlucoseLifeCount: state.lastGlucoseLifeCount
        )

        return ([
            "target=\(targetName) rssi=\(targetRSSI.map(String.init) ?? "unknown")",
            "nfcSerial=\(state.serialNumber ?? "")",
            "nfcBLE=\(state.bleAddress ?? "")",
            "blePIN=\(Self.hex(state.blePIN))",
            "sensorCert=\(handshake.preamble.phaseHandshake.sensorCert.raw.count)B " +
                "sensorEph=\(handshake.preamble.phaseHandshake.sensorEphPub.x963Representation.count)B",
            "S_eph_static=\(Self.hex(handshake.preamble.phaseHandshake.sharedEphStatic))",
            "S_eph_eph=\(Self.hex(handshake.preamble.phaseHandshake.sharedEphEph))",
            "R1=\(Self.hex(handshake.preamble.sensorR1))",
            "nonce7=\(Self.hex(handshake.preamble.nonce7))",
            "phoneEphPub=\(Self.hex(nativeEphemeral.keyPair.publicKey65))",
            "candidateStaticScalarOverride=\(staticScalarOverride?.count ?? 0)B",
            "candidateNullAttempts=\(phase5Material.nullAttempts)",
            "nativeNullAttempts=\(nativeEphemeral.attempts)",
            "candidateNullEntropy11A=\(Self.hex(phase5Material.nullEntropy11A))",
            "candidateNullScalarWindow=\(Self.hex(phase5Material.nullScalarWindow))",
            "candidatePhase5Source66=\(Self.hex(phase5Material.source66))",
            "candidatePhase5RawKey=\(Self.hex(phase5Material.rawKey))",
            "phase5=sent",
            "phase5Wire=\(Self.hex(handshake.phase5Sent.wireBytes))",
            "phase6Raw=\(Self.hex(handshake.phase6Raw))",
            "phase6NonceU16LE=\(phase6NoncePrefix.map(String.init) ?? "nil")",
            "savedLastGlucoseLC=\(state.lastGlucoseLifeCount.map(String.init) ?? "nil")",
            "historyBackfillStart=\(historyStart)",
            "sessionKEnc=\(Self.hex(handshake.sessionMaterial.kEnc))",
            "sessionIVEnc8=\(Self.hex(handshake.sessionMaterial.ivEnc))",
        ] + postAuthSummary).joined(separator: "\n")
    }

    private func runFirstPairPostAuthData(
        session: SensorSession,
        material: Phase6SessionMaterial,
        historicalLifeCount: UInt16,
        savedLastGlucoseLifeCount: UInt16?
    ) async throws -> [String] {
        let crypto = try DataPlaneCrypto(sessionMaterial: material)
        let counter = FirstPairPostAuthCounter()
        activeSessionMaterial = material
        autoReconnectEnabled = true
        dataPlaneSessionEstablished = true
        reconnectStatus = "data plane active"
        startPersistentPostAuthListener(
            session: session,
            crypto: crypto,
            counter: counter,
            reason: "phase6"
        )

        await refreshFirstPairPostAuthNotifications(via: session)
        try await sendFirstPairPostAuthBootstrapCommands(
            via: session,
            crypto: crypto,
            counter: counter,
            historicalLifeCount: historicalLifeCount,
            savedLastGlucoseLifeCount: savedLastGlucoseLifeCount
        )
        await listenForFirstPairPostAuthData(
            via: session,
            crypto: crypto,
            counter: counter,
            duration: postAuthInitialListenDuration,
            patchStatusFallbackAfter: 75
        )
        let total = await counter.value()
        bleHandoffStatus = "First-pair data listener active"
        return ["postAuthDataNotifies=\(total)"]
    }

    private func startPersistentPostAuthListener(
        session: SensorSession,
        crypto: DataPlaneCrypto,
        counter: FirstPairPostAuthCounter,
        reason: String
    ) {
        postAuthListenTask?.cancel()
        postAuthListenerGeneration += 1
        let generation = postAuthListenerGeneration
        let assembler = DataPlaneNotificationAssembler()
        appendHandoffLog("post-auth data-plane listener started reason=\(reason)")
        postAuthListenTask = Task { [weak self, session, crypto, counter] in
            for await ev in session.notifications() {
                guard let channel = DataPlaneChannel(uuidString: ev.characteristic.uuidString) else {
                    continue
                }
                let count = await counter.mark(receivedAt: ev.receivedAt)
                let channelName = Self.dataPlaneChannelName(channel)
                await MainActor.run { [weak self] in
                    self?.appendHandoffLog(
                        "post-auth notify \(channelName) #\(count) " +
                        "len=\(ev.fragment.count) raw=\(Self.hex(ev.fragment))"
                    )
                }

                guard let frameRaw = assembler.feed(fragment: ev.fragment, channel: channel) else {
                    await MainActor.run { [weak self] in
                        self?.appendHandoffLog(
                            "post-auth \(channelName) partial \(ev.fragment.count)B buffered"
                        )
                    }
                    continue
                }

                do {
                    let frame = try DataFrame.parse(frameRaw)
                    let packet = try DataPlaneDecoder(crypto: crypto).decrypt(frame: frame, channel: channel)
                    let decoded = Self.decodedDataPlaneSummary(packet)
                    let fallback = packet.usedPreferredKind ? "" : " fallback"
                    await MainActor.run { [weak self] in
                        self?.recordDecodedPacket(
                            packet,
                            channelName: channelName,
                            receivedAt: ev.receivedAt
                        )
                        self?.appendHandoffLog(
                            "post-auth data \(channelName) " +
                            "seq=0x\(String(format: "%04x", frame.sequenceNumber)) " +
                            "kind=\(packet.kind.rawValue)\(fallback) " +
                            "pt(\(packet.plaintext.count)B)=\(Self.hex(packet.plaintext))" +
                            decoded
                        )
                    }
                } catch {
                    await MainActor.run { [weak self] in
                        self?.appendHandoffLog(
                            "post-auth data \(channelName) decrypt pending: \(String(describing: error))"
                        )
                    }
                }
            }

            guard !Task.isCancelled else { return }
            await counter.markStreamEnded()
            await MainActor.run { [weak self] in
                self?.handlePostAuthNotifyStreamEnded(generation: generation)
            }
        }
    }

    private func handlePostAuthNotifyStreamEnded(generation: Int) {
        guard generation == postAuthListenerGeneration else {
            appendLifecycleEvent("stale notify stream ended generation=\(generation)")
            return
        }
        appendHandoffLog("post-auth notify stream ended")
        appendLifecycleEvent("notify stream ended")
        postAuthListenTask = nil
        registerWakeEventsForCurrentSession(reason: "notify-stream-ended")
        clearActiveSession(resetTarget: false)
        requestReconnect(reason: "notify-stream-ended", immediate: false)
    }

    private func sendFirstPairPostAuthBootstrapCommands(
        via session: SensorSession,
        crypto: DataPlaneCrypto,
        counter: FirstPairPostAuthCounter,
        historicalLifeCount: UInt16,
        savedLastGlucoseLifeCount: UInt16?
    ) async throws {
        guard !skipPostAuthHistory else {
            appendHandoffLog("post-auth historical backfill disabled by --skip-post-auth-history")
            return
        }

        await setPostAuthNotification(
            true,
            name: "historicData",
            uuid: LibreSensorGATT.Char.historicData,
            via: session
        )
        let historicBaseline = await counter.value()
        do {
            try await sendFirstPairPatchControlCommand(
                .historicalBackfillGreaterEqual(lifeCount: historicalLifeCount),
                sequence: 0x0001,
                via: session,
                crypto: crypto,
                critical: true
            )
            await waitForFirstPairDataPlaneQuiet(
                label: "historicData",
                counter: counter,
                afterNotifyCount: historicBaseline,
                firstActivityTimeout: savedLastGlucoseLifeCount == nil ? 12 : 8,
                quietSeconds: savedLastGlucoseLifeCount == nil ? 3 : 2,
                maxSeconds: savedLastGlucoseLifeCount == nil ? 90 : 12
            )
        } catch {
            await setPostAuthNotification(
                false,
                name: "historicData",
                uuid: LibreSensorGATT.Char.historicData,
                via: session
            )
            throw error
        }
        await setPostAuthNotification(
            false,
            name: "historicData",
            uuid: LibreSensorGATT.Char.historicData,
            via: session
        )

        guard debugClinicalAfterHistory else {
            appendHandoffLog("post-auth clinical backfill disabled by default")
            return
        }

        await setPostAuthNotification(
            true,
            name: "clinicalData",
            uuid: LibreSensorGATT.Char.clinicalData,
            via: session
        )
        let clinicalBaseline = await counter.value()
        let sent = try await sendFirstPairPatchControlCommand(
            .clinicalBackfillGreaterEqual(lifeCount: historicalLifeCount),
            sequence: 0x0002,
            via: session,
            crypto: crypto,
            critical: false
        )
        if sent {
            await waitForFirstPairDataPlaneQuiet(
                label: "clinicalData",
                counter: counter,
                afterNotifyCount: clinicalBaseline,
                firstActivityTimeout: 8,
                quietSeconds: 3,
                maxSeconds: 30
            )
        }
        await setPostAuthNotification(
            false,
            name: "clinicalData",
            uuid: LibreSensorGATT.Char.clinicalData,
            via: session
        )
    }

    @discardableResult
    private func sendFirstPairPatchControlCommand(
        _ command: PatchControlCommand,
        sequence: UInt16,
        via session: SensorSession,
        crypto: DataPlaneCrypto,
        critical: Bool
    ) async throws -> Bool {
        let frame = try crypto.encrypt(
            plaintext: command.plaintext,
            sequence: sequence,
            kind: .patchControlWrite
        )
        appendHandoffLog(
            "post-auth patchControl \(command.label) " +
            "seq=0x\(String(format: "%04x", sequence)) " +
            "pt=\(Self.hex(command.plaintext)) raw=\(Self.hex(frame.raw))"
        )
        do {
            try await session.writeRaw(
                frame.raw,
                to: LibreSensorGATT.Char.patchControl,
                timeout: critical ? 10 : 8
            )
            appendHandoffLog("post-auth patchControl ACK")
            return true
        } catch {
            appendHandoffLog(
                "post-auth patchControl \(command.label) write not accepted: \(String(describing: error))"
            )
            if critical { throw error }
            return false
        }
    }

    private func waitForFirstPairDataPlaneQuiet(
        label: String,
        counter: FirstPairPostAuthCounter,
        afterNotifyCount baseline: Int,
        firstActivityTimeout: TimeInterval,
        quietSeconds: TimeInterval,
        maxSeconds: TimeInterval
    ) async {
        let start = Date()
        var sawActivity = (await counter.value()) > baseline
        var lastProgressLog = Date.distantPast

        while true {
            let now = Date()
            let elapsed = now.timeIntervalSince(start)
            let notifyCount = await counter.value()
            if notifyCount > baseline {
                sawActivity = true
            }

            if sawActivity, let last = await counter.lastNotifyAt() {
                let quietFor = now.timeIntervalSince(last)
                if quietFor >= quietSeconds {
                    appendHandoffLog(
                        "post-auth \(label) quiet for \(String(format: "%.1f", quietSeconds))s " +
                        "after \(notifyCount - baseline) notifies"
                    )
                    return
                }
            } else if elapsed >= firstActivityTimeout {
                appendHandoffLog(
                    "post-auth \(label) produced no data within " +
                    "\(String(format: "%.1f", firstActivityTimeout))s"
                )
                return
            }

            if elapsed >= maxSeconds {
                appendHandoffLog(
                    "post-auth \(label) still active after \(String(format: "%.1f", maxSeconds))s " +
                    "(\(max(0, notifyCount - baseline)) notifies); postponing later requests"
                )
                return
            }

            if now.timeIntervalSince(lastProgressLog) >= 15 {
                appendHandoffLog(
                    "post-auth waiting for \(label) quiet " +
                    "(\(max(0, notifyCount - baseline)) notifies so far)"
                )
                lastProgressLog = now
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
        }
    }

    private func refreshFirstPairPostAuthNotifications(via session: SensorSession) async {
        let order: [(String, CBUUID)] = [
            ("patchControl", LibreSensorGATT.Char.patchControl),
            ("eventLog", LibreSensorGATT.Char.eventLog),
            ("factoryData", LibreSensorGATT.Char.factoryData),
            ("glucoseData", LibreSensorGATT.Char.glucoseData),
            ("patchStatus", LibreSensorGATT.Char.patchStatus),
        ]
        appendHandoffLog("post-auth data notification refresh")
        for (name, uuid) in order {
            do {
                appendHandoffLog("post-auth notify \(name) off")
                try await session.setNotify(false, for: uuid, timeout: 8)
                try await Task.sleep(nanoseconds: 90_000_000)
                appendHandoffLog("post-auth notify \(name) on")
                try await session.setNotify(true, for: uuid, timeout: 8)
                appendHandoffLog("post-auth notify \(name) refreshed")
                try await Task.sleep(nanoseconds: 90_000_000)
            } catch {
                appendHandoffLog("post-auth notify \(name) refresh failed: \(String(describing: error))")
            }
        }
    }

    private func setPostAuthNotification(
        _ enabled: Bool,
        name: String,
        uuid: CBUUID,
        via session: SensorSession
    ) async {
        do {
            appendHandoffLog("post-auth notify \(name) \(enabled ? "on" : "off")")
            try await session.setNotify(enabled, for: uuid, timeout: 8)
            appendHandoffLog("post-auth notify \(name) \(enabled ? "enabled" : "disabled")")
            try await Task.sleep(nanoseconds: 90_000_000)
        } catch {
            appendHandoffLog(
                "post-auth notify \(name) \(enabled ? "enable" : "disable") failed: \(String(describing: error))"
            )
        }
    }

    private func listenForFirstPairPostAuthData(
        via session: SensorSession,
        crypto: DataPlaneCrypto,
        counter: FirstPairPostAuthCounter,
        duration: TimeInterval,
        patchStatusFallbackAfter: TimeInterval
    ) async {
        let baseline = await counter.value()
        let start = Date()
        var didPatchStatusFallback = false
        var lastProgressLog = Date.distantPast
        appendHandoffLog(
            "post-auth data listen for \(Int(duration))s; " +
            "patchStatus read fallback after \(Int(patchStatusFallbackAfter))s"
        )

        while true {
            let now = Date()
            let elapsed = now.timeIntervalSince(start)
            let newNotifies = max(0, await counter.value() - baseline)
            if await counter.isStreamEnded() {
                appendHandoffLog("post-auth data listen ended by notify stream newNotifies=\(newNotifies)")
                return
            }
            if elapsed >= duration {
                appendHandoffLog("post-auth data listen complete newNotifies=\(newNotifies)")
                return
            }

            if !didPatchStatusFallback && elapsed >= patchStatusFallbackAfter {
                didPatchStatusFallback = true
                if newNotifies == 0 {
                    await readFirstPairPatchStatus(via: session, crypto: crypto)
                } else {
                    appendHandoffLog("post-auth patchStatus read fallback skipped; data already active")
                }
            }

            if now.timeIntervalSince(lastProgressLog) >= 30 {
                appendHandoffLog("post-auth listen \(Int(elapsed))s newNotifies=\(newNotifies)")
                lastProgressLog = now
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
        }
    }

    private func readFirstPairPatchStatus(via session: SensorSession, crypto: DataPlaneCrypto) async {
        appendHandoffLog("post-auth read patchStatus after one-minute quiet")
        do {
            let raw = try await session.readRaw(LibreSensorGATT.Char.patchStatus, timeout: 15)
            appendHandoffLog("post-auth patchStatus read \(raw.count)B raw=\(Self.hex(raw))")
            do {
                let frame = try DataFrame.parse(raw)
                let packet = try DataPlaneDecoder(crypto: crypto).decrypt(frame: frame, channel: .patchStatus)
                let fallback = packet.usedPreferredKind ? "" : " fallback"
                recordDecodedPacket(packet, channelName: "patchStatus", receivedAt: Date())
                appendHandoffLog(
                    "post-auth patchStatus read decrypt " +
                    "seq=0x\(String(format: "%04x", frame.sequenceNumber)) " +
                    "kind=\(packet.kind.rawValue)\(fallback) " +
                    "pt(\(packet.plaintext.count)B)=\(Self.hex(packet.plaintext))" +
                    Self.decodedDataPlaneSummary(packet)
                )
            } catch {
                appendHandoffLog("post-auth patchStatus read decrypt pending: \(String(describing: error))")
            }
        } catch {
            appendHandoffLog("post-auth patchStatus read failed: \(String(describing: error))")
        }
    }

    nonisolated private static func hex(_ data: Data) -> String {
        data.map { String(format: "%02x", $0) }.joined()
    }

    nonisolated private static func dataPlaneChannelName(_ channel: DataPlaneChannel) -> String {
        switch channel {
        case .patchControl: return "patchControl"
        case .patchStatus: return "patchStatus"
        case .glucoseData: return "glucoseData"
        case .historicData: return "historicData"
        case .eventLog: return "eventLog"
        case .clinicalData: return "clinicalData"
        case .factoryData: return "factoryData"
        }
    }

    nonisolated private static func connectionEventName(_ event: CBConnectionEvent) -> String {
        switch event {
        case .peerConnected:
            return "peerConnected"
        case .peerDisconnected:
            return "peerDisconnected"
        @unknown default:
            return "unknown"
        }
    }

    nonisolated private static func decodedDataPlaneSummary(_ packet: DataPlaneDecodedPacket) -> String {
        switch packet.payload {
        case .historicalReadingPage(let page):
            let values = page.values.map(String.init).joined(separator: ",")
            return " histLC=\(page.startLifeCount)..\(page.endLifeCount) values=[\(values)]"
        case .realtimeGlucose(let reading):
            let rate = reading.rateOfChangeMgDLPerMinute.map { String(format: "%.2f", $0) } ?? "nil"
            let current = reading.currentGlucoseMgDL.map(String.init) ?? "invalid"
            return " glucoseLC=\(reading.lifeCount) current=\(current) " +
                "rate=\(rate) trend=\(reading.trend) histLC=\(reading.historicalLifeCount) " +
                "hist=\(reading.historicalReading) tempRaw=\(reading.temperature) " +
                "statusBits=\(reading.statusBits) fastWords=\(reading.fastDataWordsLE)"
        case .patchStatus(let status):
            let lifecycle = status.lifecycle()
            return " patchState=\(status.patchState) currentLC=\(status.currentLifeCount) " +
                "phase=\(lifecycle.phase.rawValue) warmupLeft=\(lifecycle.remainingWarmupMinutes) " +
                "events=\(status.totalEvents) stackDisconnect=\(status.stackDisconnectReason) " +
                "appDisconnect=\(status.appDisconnectReason)"
        case .raw:
            if packet.channel == .glucoseData {
                return " glucoseWordsLE=\(littleEndianWordSummary(packet.plaintext))"
            }
            if packet.channel == .patchStatus {
                return " patchStatusWordsLE=\(littleEndianWordSummary(packet.plaintext))"
            }
            return ""
        }
    }

    nonisolated private static func littleEndianWordSummary(_ data: Data) -> String {
        var words: [String] = []
        var index = data.startIndex
        while data.distance(from: data.startIndex, to: index) + 1 < data.count {
            let next = data.index(after: index)
            let value = UInt16(data[index]) | (UInt16(data[next]) << 8)
            words.append(String(value))
            index = data.index(index, offsetBy: 2)
        }
        if data.count % 2 == 1, let last = data.last {
            words.append(String(format: "tail:%02x", last))
        }
        return "[" + words.joined(separator: ",") + "]"
    }

    nonisolated private static func phase6NoncePrefix(fromNonce nonce: Data) -> UInt16? {
        guard nonce.count >= 2 else { return nil }
        return UInt16(nonce[nonce.startIndex]) | (UInt16(nonce[nonce.startIndex + 1]) << 8)
    }

    nonisolated private static func historyBackfillStart(
        phase6NoncePrefix: UInt16?,
        savedLastLifeCount: UInt16?
    ) -> UInt16 {
        if let savedLastLifeCount {
            let overlap: UInt16 = 10
            return savedLastLifeCount > overlap ? savedLastLifeCount - overlap : 0
        }
        guard let phase6NoncePrefix else {
            return 5
        }
        let lookback: UInt16 = 180
        return phase6NoncePrefix > lookback ? phase6NoncePrefix - lookback : 0
    }

    nonisolated private static func normalizedBLEAddress(_ value: String?) -> String? {
        guard let value else { return nil }
        let normalized = value
            .filter { $0.isHexDigit }
            .uppercased()
        return normalized.isEmpty ? nil : normalized
    }

    nonisolated private static func secureRandomData(count: Int) throws -> Data {
        guard count >= 0 else {
            throw NFCActivationHandoffError.randomFailed(errSecParam)
        }
        var bytes = [UInt8](repeating: 0, count: count)
        let status = bytes.withUnsafeMutableBytes { rawBuffer in
            guard let baseAddress = rawBuffer.baseAddress else { return errSecParam }
            return SecRandomCopyBytes(kSecRandomDefault, rawBuffer.count, baseAddress)
        }
        guard status == errSecSuccess else {
            throw NFCActivationHandoffError.randomFailed(status)
        }
        return Data(bytes)
    }

    nonisolated private static func fixedEntropySource(_ entropy: Data, requestedCount: Int) throws -> Data {
        guard requestedCount == entropy.count else {
            throw NFCActivationHandoffError.fixedEntropySizeMismatch(
                expected: requestedCount,
                actual: entropy.count
            )
        }
        return entropy
    }

    private func loadPhoneCert() throws -> (cert: PhoneCert, label: String) {
        guard useCapturedUserCert else {
            return (try PhoneCert.bundledFirstPair(), "phone_cert_firstpair")
        }
        return (try PhoneCert.bundled162b(), "phone_cert_162b")
    }

    private func appendHandoffLog(_ msg: String) {
        let ts = String(format: "%.3f", Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 1000))
        let line = "[\(ts)] \(msg)"
        persistHandoffLogLine(line)
        print("[RoundWhiteDisc:NFC] \(line)")
    }

    private func makeHandoffEventLogger() -> @Sendable (String) -> Void {
        { [weak self] message in
            Task { @MainActor [weak self] in
                self?.appendHandoffLog(message)
            }
        }
    }

    private func handoffLogURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("RoundWhiteDisc-nfc-handoff-log.txt")
    }

    private func persistHandoffLogLine(_ line: String) {
        guard let data = "\(line)\n".data(using: .utf8) else { return }
        let url = handoffLogURL()
        if FileManager.default.fileExists(atPath: url.path),
           let handle = try? FileHandle(forWritingTo: url) {
            defer { try? handle.close() }
            _ = try? handle.seekToEnd()
            try? handle.write(contentsOf: data)
        } else {
            try? data.write(to: url)
        }
    }

    private static func receiverIDOverride(from arguments: [String]) -> (id: UInt32, source: String)? {
        if let raw = argumentValue(after: "--nfc-receiver-id", in: arguments),
           let id = parseUInt32(raw) {
            return (id, "--nfc-receiver-id \(raw)")
        }
        if let raw = argumentValue(after: "--nfc-receiver-le-hex", in: arguments),
           let id = Libre3ReceiverID.parseLittleEndianHex(raw) {
            return (id, "--nfc-receiver-le-hex \(raw)")
        }
        return nil
    }

    private static func argumentValue(after flag: String, in arguments: [String]) -> String? {
        guard let index = arguments.firstIndex(of: flag) else { return nil }
        let next = arguments.index(after: index)
        guard next < arguments.endIndex else { return nil }
        return arguments[next]
    }

    private static func parseUInt32(_ raw: String) -> UInt32? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.lowercased().hasPrefix("0x") {
            return UInt32(trimmed.dropFirst(2), radix: 16)
        }
        return UInt32(trimmed, radix: 10) ?? UInt32(trimmed, radix: 16)
    }

}

private enum NFCActivationHandoffError: Error {
    case fixedEntropySizeMismatch(expected: Int, actual: Int)
    case randomFailed(OSStatus)
}

private actor FirstPairPostAuthCounter {
    private var notifyCount = 0
    private var streamEnded = false
    private var lastReceivedAt: Date?

    func mark(receivedAt: Date) -> Int {
        notifyCount += 1
        lastReceivedAt = receivedAt
        return notifyCount
    }

    func value() -> Int {
        notifyCount
    }

    func lastNotifyAt() -> Date? {
        lastReceivedAt
    }

    func markStreamEnded() {
        streamEnded = true
    }

    func isStreamEnded() -> Bool {
        streamEnded
    }
}
