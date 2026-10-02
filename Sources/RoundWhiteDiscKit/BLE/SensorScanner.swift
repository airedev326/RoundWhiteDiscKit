import Foundation
@preconcurrency import CoreBluetooth

#if canImport(UIKit) || canImport(AppKit)

// Async BLE scanner for Libre 3 sensors. Wraps a CBCentralManager and
// surfaces discoveries via an AsyncStream.
//
// Usage:
//   let scanner = SensorScanner()
//   try await scanner.waitUntilReady()
//   for await found in scanner.startScan() {
//       let session = try await scanner.connect(found.peripheral)
//       …
//   }
//
// Permissions: callers must include NSBluetoothAlwaysUsageDescription in
// their Info.plist (the RoundWhiteDisc app target sets this in project.yml).

public struct DiscoveredSensor: @unchecked Sendable, Hashable {
    public let id: UUID
    public let name: String?
    public let rssi: Int
    public let advertisedServices: [CBUUID]
    public let advertisementData: [String: String]   // String-summary view
    public let peripheral: CBPeripheral

    public static func == (lhs: DiscoveredSensor, rhs: DiscoveredSensor) -> Bool { lhs.id == rhs.id }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

public struct SensorScannerConfiguration: @unchecked Sendable {
    public let restorationIdentifier: String?
    public let notifyOnConnection: Bool
    public let notifyOnDisconnection: Bool
    public let notifyOnNotification: Bool

    public init(
        restorationIdentifier: String? = nil,
        notifyOnConnection: Bool = false,
        notifyOnDisconnection: Bool = false,
        notifyOnNotification: Bool = false
    ) {
        self.restorationIdentifier = restorationIdentifier
        self.notifyOnConnection = notifyOnConnection
        self.notifyOnDisconnection = notifyOnDisconnection
        self.notifyOnNotification = notifyOnNotification
    }

    public static let foreground = SensorScannerConfiguration()

    public static func background(restorationIdentifier: String = "org.roundwhitedisckit.libre3.central") -> SensorScannerConfiguration {
        SensorScannerConfiguration(restorationIdentifier: restorationIdentifier)
    }

    var centralOptions: [String: Any]? {
        guard let restorationIdentifier else { return nil }
        return [CBCentralManagerOptionRestoreIdentifierKey: restorationIdentifier]
    }

    var connectOptions: [String: Any]? {
        var options: [String: Any] = [:]
        if notifyOnConnection {
            options[CBConnectPeripheralOptionNotifyOnConnectionKey] = true
        }
        if notifyOnDisconnection {
            options[CBConnectPeripheralOptionNotifyOnDisconnectionKey] = true
        }
        if notifyOnNotification {
            options[CBConnectPeripheralOptionNotifyOnNotificationKey] = true
        }
        return options.isEmpty ? nil : options
    }
}

public struct SensorConnectionEvent: @unchecked Sendable {
    public let event: CBConnectionEvent
    public let peripheral: CBPeripheral
    public let occurredAt: Date
}

public struct SensorRestorationEvent: @unchecked Sendable {
    public let peripherals: [CBPeripheral]
    public let scanServices: [CBUUID]
    public let scanOptions: [String: String]
}

/// Scanner/connection errors.
///
/// **Classification note for clients:** when deciding whether a failure should
/// count toward a *terminal / re-pair* escalation, classify per case, not per
/// enum. None of these are credential failures:
/// - `connectionFailed` and `timeout` are **transport** failures — retry them;
///   they must not contribute to a re-pair threshold.
/// - `bluetoothUnavailable` / `bluetoothPoweredOff` / `bluetoothUnauthorized`
///   are **environment/permission** states, not sensor faults.
public enum SensorScannerError: Error, CustomStringConvertible, LocalizedError {
    case bluetoothUnavailable
    case bluetoothPoweredOff
    case bluetoothUnauthorized
    /// Transport: the link failed to establish. Retry.
    case connectionFailed(String)
    /// Transport: the application-level connect deadline elapsed. Retry.
    case timeout(String)

    /// Diagnostic text — always English, so logs and pairing transcripts stay
    /// comparable across locales. User-visible text goes through
    /// `errorDescription`.
    public var description: String {
        switch self {
        case .bluetoothUnavailable: return "Bluetooth unavailable"
        case .bluetoothPoweredOff: return "Bluetooth powered off"
        case .bluetoothUnauthorized: return "Bluetooth permission denied"
        case .connectionFailed(let m): return "BLE connect failed: \(m)"
        case .timeout(let m): return "BLE timeout: \(m)"
        }
    }

    /// Localized text for presentation, reached via `localizedDescription`. The
    /// English values match `description` verbatim, so behaviour on an English
    /// device is unchanged; `m` stays English because it carries internal
    /// transport detail.
    public var errorDescription: String? {
        switch self {
        case .bluetoothUnavailable:
            return LocalizedString(
                "Bluetooth unavailable",
                comment: "Error shown when the device has no usable Bluetooth radio"
            )
        case .bluetoothPoweredOff:
            return LocalizedString(
                "Bluetooth powered off",
                comment: "Error shown when Bluetooth is switched off; the user can fix this in Settings or Control Centre"
            )
        case .bluetoothUnauthorized:
            return LocalizedString(
                "Bluetooth permission denied",
                comment: "Error shown when the app was denied Bluetooth permission"
            )
        case .connectionFailed(let m):
            return String(
                format: LocalizedString(
                    "BLE connect failed: %@",
                    comment: "Error shown when the BLE link failed to establish. %@ is English transport detail."
                ),
                m
            )
        case .timeout(let m):
            return String(
                format: LocalizedString(
                    "BLE timeout: %@",
                    comment: "Error shown when the BLE connect deadline elapsed. %@ is English transport detail."
                ),
                m
            )
        }
    }
}

public final class SensorScanner: NSObject, @unchecked Sendable {
    private let configuration: SensorScannerConfiguration
    private let centralQueue = DispatchQueue(label: "org.roundwhitedisc.ble", qos: .userInitiated)
    private lazy var central: CBCentralManager = {
        CBCentralManager(delegate: self, queue: centralQueue, options: configuration.centralOptions)
    }()

    private var discoveryContinuation: AsyncStream<DiscoveredSensor>.Continuation?
    private var connectionEventContinuations: [AsyncStream<SensorConnectionEvent>.Continuation] = []
    private var restorationContinuations: [AsyncStream<SensorRestorationEvent>.Continuation] = []
    private var stateEventContinuations: [AsyncStream<CBManagerState>.Continuation] = []
    private var pendingRestorationEvents: [SensorRestorationEvent] = []
    private var stateContinuation: CheckedContinuation<Void, Error>?
    private var pendingConnects: [UUID: CheckedContinuation<CBPeripheral, Error>] = [:]
    private var pendingConnectTimeouts: [UUID: DispatchWorkItem] = [:]
    // Hold strong references to in-flight sessions while they connect.
    private var pendingSessions: [UUID: SensorSession] = [:]

    public init(configuration: SensorScannerConfiguration = .foreground) {
        self.configuration = configuration
        super.init()
        _ = central  // touch lazy
    }

    /// Suspends until the central manager reports `.poweredOn`, or throws if
    /// the user has denied Bluetooth permission / the radio is off.
    public func waitUntilReady() async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            centralQueue.async {
                if self.central.state == .poweredOn {
                    cont.resume(); return
                }
                if let err = SensorScanner.errorForState(self.central.state) {
                    cont.resume(throwing: err); return
                }
                self.stateContinuation = cont
            }
        }
    }

    /// Starts scanning. By default filters by the Libre 3 service UUID; pass
    /// `nil` to scan for everything (useful for debugging when the sensor
    /// doesn't show up — confirms the radio path and reveals what *is*
    /// advertising nearby).
    public func startScan(filter: [CBUUID]? = [LibreSensorGATT.serviceUUID]) -> AsyncStream<DiscoveredSensor> {
        AsyncStream { cont in
            centralQueue.async {
                self.discoveryContinuation = cont
                self.central.scanForPeripherals(
                    withServices: filter,
                    options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
                )
                cont.onTermination = { _ in
                    self.centralQueue.async { self.central.stopScan() }
                }
            }
        }
    }

    public func stopScan() {
        centralQueue.async {
            self.central.stopScan()
            self.discoveryContinuation?.finish()
            self.discoveryContinuation = nil
        }
    }

    /// Stream of CoreBluetooth connection events registered through
    /// `registerForConnectionEvents`. An integrating app can use this after a
    /// disconnect to be woken when iOS observes the target peripheral again.
    /// Stream of central-manager state transitions. Yields the current
    /// state immediately on subscribe (so callers don't need to also
    /// poll), then yields again every time `centralManagerDidUpdateState`
    /// fires. Use to drive G7-style "kick reconnect when Bluetooth comes
    /// back on" behavior: subscribe and act on `.poweredOn`.
    public func stateEvents() -> AsyncStream<CBManagerState> {
        AsyncStream { cont in
            centralQueue.async {
                self.stateEventContinuations.append(cont)
                cont.yield(self.central.state)
            }
        }
    }

    public func connectionEvents() -> AsyncStream<SensorConnectionEvent> {
        AsyncStream { cont in
            centralQueue.async {
                self.connectionEventContinuations.append(cont)
            }
        }
    }

    /// Stream of CoreBluetooth state-restoration callbacks. Apps that use a
    /// restoration identifier must re-create `SensorScanner` early at launch
    /// and then resume sessions for any restored peripherals.
    public func restorationEvents() -> AsyncStream<SensorRestorationEvent> {
        AsyncStream { cont in
            centralQueue.async {
                for event in self.pendingRestorationEvents {
                    cont.yield(event)
                }
                self.pendingRestorationEvents.removeAll()
                self.restorationContinuations.append(cont)
            }
        }
    }

    public func registerForConnectionEvents(
        peripheralIDs: [UUID]? = nil,
        serviceUUIDs: [CBUUID]? = [LibreSensorGATT.serviceUUID]
    ) {
#if os(iOS)
        centralQueue.async {
            var options: [CBConnectionEventMatchingOption: Any] = [:]
            if let peripheralIDs {
                options[.peripheralUUIDs] = peripheralIDs
            }
            if let serviceUUIDs {
                options[.serviceUUIDs] = serviceUUIDs
            }
            self.central.registerForConnectionEvents(options: options.isEmpty ? nil : options)
        }
#else
        _ = peripheralIDs
        _ = serviceUUIDs
#endif
    }

    /// Returns CoreBluetooth peripherals for identifiers remembered by this
    /// installation. This avoids waiting for a scan advertisement when we are
    /// reconnecting to the same sensor after a range loss.
    public func retrievePeripherals(withIdentifiers identifiers: [UUID]) async -> [CBPeripheral] {
        await withCheckedContinuation { cont in
            centralQueue.async {
                cont.resume(returning: self.central.retrievePeripherals(withIdentifiers: identifiers))
            }
        }
    }

    public func retrieveConnectedPeripherals(serviceUUIDs: [CBUUID] = [LibreSensorGATT.serviceUUID]) async -> [CBPeripheral] {
        await withCheckedContinuation { cont in
            centralQueue.async {
                cont.resume(returning: self.central.retrieveConnectedPeripherals(withServices: serviceUUIDs))
            }
        }
    }

    /// Background-safe connect with **no application-level timeout** — a named
    /// alias for `connect(peripheral, timeout: 0)` so callers don't depend on a
    /// magic zero. The underlying CoreBluetooth `connect` intent is left pending
    /// indefinitely; iOS keeps it alive across app suspension and can wake/
    /// relaunch the app when the peripheral becomes connectable. The client
    /// stays responsible for cancelling the intent (see
    /// `cancelPeripheralConnection(peripheralID:)`) once it no longer wants the
    /// sensor. See ``connect(_:timeout:)`` for the full timeout semantics.
    public func connectIndefinitely(_ peripheral: CBPeripheral) async throws -> SensorSession {
        try await connect(peripheral, timeout: 0)
    }

    /// Connects to `peripheral` and returns a fully-discovered `SensorSession`.
    ///
    /// The Libre 3 often only accepts connections on roughly minute-spaced
    /// windows, so the default timeout is deliberately longer than one interval.
    ///
    /// - Parameter timeout: Application-level connect deadline, in seconds.
    ///   A **positive** value schedules a client-side timeout: if the peripheral
    ///   hasn't connected by then, the pending `central.connect` is cancelled and
    ///   this throws `SensorScannerError.timeout`.
    ///
    ///   Pass **`0` (or any non-positive value) for an indefinite, background-safe
    ///   connect**: no application-level timeout is scheduled and the CoreBluetooth
    ///   `connect` request is left pending. Apple documents `connect` requests as
    ///   never timing out on their own, so iOS keeps the intent alive across app
    ///   suspension and can wake/relaunch the app when the peripheral becomes
    ///   connectable. Prefer this in a background-maintained client: a finite
    ///   timeout that fires while the app is suspended cancels the very thing that
    ///   could have woken it, stranding the connection until the next foreground.
    ///   ``connectIndefinitely(_:)`` is the named spelling of this mode.
    public func connect(_ peripheral: CBPeripheral, timeout: TimeInterval = 120) async throws -> SensorSession {
        let connectStart = Date()
        let alreadyConnected: Bool = await withCheckedContinuation { cont in
            centralQueue.async {
                cont.resume(returning: peripheral.state == .connected)
            }
        }
        BLETiming.log(alreadyConnected
                      ? "scanner.connect: peripheral already connected; skipping central.connect"
                      : "scanner.connect: issuing central.connect (state=\(peripheral.state.rawValue))")
        let connected: CBPeripheral = try await withCheckedThrowingContinuation { cont in
            centralQueue.async {
                if peripheral.state == .connected {
                    cont.resume(returning: peripheral)
                    return
                }
                self.pendingConnects[peripheral.identifier] = cont
                if timeout > 0 {
                    let timeoutWork = DispatchWorkItem { [weak self, weak peripheral] in
                        guard let self, let peripheral else { return }
                        if let pending = self.pendingConnects.removeValue(forKey: peripheral.identifier) {
                            self.pendingConnectTimeouts.removeValue(forKey: peripheral.identifier)
                            self.central.cancelPeripheralConnection(peripheral)
                            pending.resume(throwing: SensorScannerError.timeout(
                                "connect timed out after \(Int(timeout))s"
                            ))
                        }
                    }
                    self.pendingConnectTimeouts[peripheral.identifier] = timeoutWork
                    self.centralQueue.asyncAfter(deadline: .now() + timeout, execute: timeoutWork)
                }
                self.central.connect(peripheral, options: self.configuration.connectOptions)
            }
        }
        let connectMs = Int(Date().timeIntervalSince(connectStart) * 1000)
        BLETiming.log("scanner.connect: didConnect after \(connectMs)ms")
        let session = try await resumeSession(for: connected)
        let totalMs = Int(Date().timeIntervalSince(connectStart) * 1000)
        BLETiming.log("scanner.connect: complete (connect+discover+subscribe) in \(totalMs)ms")
        return session
    }

    /// Builds a `SensorSession` around a peripheral restored by CoreBluetooth
    /// and refreshes service discovery / notification state.
    public func resumeSession(for peripheral: CBPeripheral) async throws -> SensorSession {
        let session = SensorSession(peripheral: peripheral, queue: centralQueue)
        pendingSessions[peripheral.identifier] = session
        try await session.discoverAndSubscribe()
        return session
    }

    public func disconnect(_ session: SensorSession) {
        centralQueue.async {
            self.central.cancelPeripheralConnection(session.peripheral)
        }
    }

    /// Read a peripheral's current `CBPeripheralState` from the central
    /// queue. State reads must be queue-synchronized to be reliable
    /// across CB delegate callbacks.
    public func state(of peripheral: CBPeripheral) async -> CBPeripheralState {
        await withCheckedContinuation { cont in
            centralQueue.async {
                cont.resume(returning: peripheral.state)
            }
        }
    }

    /// Best-effort reset of any pending or active connection for this
    /// peripheral so the next `connect` starts from a clean
    /// `.disconnected` state. Use before reconnect to clear out:
    ///   - a `.connecting` from a previously abandoned attempt (pending
    ///     connect that iOS is still holding from a Task we cancelled)
    ///   - a `.connected` that the sensor side has dropped but iOS still
    ///     thinks is alive (phantom-connected)
    ///   - a `.disconnecting` mid-flight tear-down
    ///
    /// Polls the peripheral's state every 100ms (after issuing
    /// `cancelPeripheralConnection`) until it reaches `.disconnected`
    /// or `settleTimeout` elapses. Returns once the state is settled or
    /// the timeout passes — the next connect can proceed either way.
    public func ensureDisconnected(
        peripheralID: UUID,
        settleTimeout: TimeInterval = 2.0
    ) async {
        let peripherals = await retrievePeripherals(withIdentifiers: [peripheralID])
        guard let peripheral = peripherals.first else { return }

        let initial = await state(of: peripheral)
        guard initial != .disconnected else { return }

        await withCheckedContinuation { cont in
            centralQueue.async {
                self.central.cancelPeripheralConnection(peripheral)
                cont.resume()
            }
        }

        let deadline = Date().addingTimeInterval(settleTimeout)
        while Date() < deadline {
            try? await Task.sleep(nanoseconds: 100_000_000)
            if await state(of: peripheral) == .disconnected { return }
        }
    }

    /// Direct equivalent of `disconnect(_ session:)` for the case where
    /// we only have a peripheral ID (e.g., on reconnect when no session
    /// was ever built). Use `ensureDisconnected` instead unless you need
    /// fire-and-forget semantics.
    public func cancelPeripheralConnection(peripheralID: UUID) async {
        let peripherals = await retrievePeripherals(withIdentifiers: [peripheralID])
        guard let peripheral = peripherals.first else { return }
        await withCheckedContinuation { cont in
            centralQueue.async {
                self.central.cancelPeripheralConnection(peripheral)
                cont.resume()
            }
        }
    }

    // MARK: - Helpers

    private static func errorForState(_ state: CBManagerState) -> SensorScannerError? {
        switch state {
        case .poweredOff:    return .bluetoothPoweredOff
        case .unauthorized:  return .bluetoothUnauthorized
        case .unsupported:   return .bluetoothUnavailable
        case .resetting, .unknown: return nil
        case .poweredOn:     return nil
        @unknown default:    return .bluetoothUnavailable
        }
    }
}

extension SensorScanner: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if let cont = stateContinuation {
            stateContinuation = nil
            if central.state == .poweredOn {
                cont.resume()
            } else if let err = SensorScanner.errorForState(central.state) {
                cont.resume(throwing: err)
            } else {
                stateContinuation = cont  // not terminal yet, keep waiting
            }
        }
        for cont in stateEventContinuations {
            cont.yield(central.state)
        }
    }

    public func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        let advSummary = advertisementData.reduce(into: [String: String]()) { acc, kv in
            acc[kv.key] = String(describing: kv.value)
        }
        let advertisedServices = (advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID]) ?? []
        let found = DiscoveredSensor(
            id: peripheral.identifier,
            name: peripheral.name ?? (advertisementData[CBAdvertisementDataLocalNameKey] as? String),
            rssi: RSSI.intValue,
            advertisedServices: advertisedServices,
            advertisementData: advSummary,
            peripheral: peripheral
        )
        discoveryContinuation?.yield(found)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let cont = pendingConnects.removeValue(forKey: peripheral.identifier) {
            pendingConnectTimeouts.removeValue(forKey: peripheral.identifier)?.cancel()
            cont.resume(returning: peripheral)
        }
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let cont = pendingConnects.removeValue(forKey: peripheral.identifier) {
            pendingConnectTimeouts.removeValue(forKey: peripheral.identifier)?.cancel()
            cont.resume(throwing: SensorScannerError.connectionFailed(error?.localizedDescription ?? "unknown"))
        }
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let cont = pendingConnects.removeValue(forKey: peripheral.identifier) {
            pendingConnectTimeouts.removeValue(forKey: peripheral.identifier)?.cancel()
            cont.resume(throwing: SensorScannerError.connectionFailed(error?.localizedDescription ?? "disconnected"))
        }
        pendingSessions.removeValue(forKey: peripheral.identifier)?.handleDisconnect(error: error)
    }

#if os(iOS)
    public func centralManager(
        _ central: CBCentralManager,
        connectionEventDidOccur event: CBConnectionEvent,
        for peripheral: CBPeripheral
    ) {
        let event = SensorConnectionEvent(event: event, peripheral: peripheral, occurredAt: Date())
        for cont in connectionEventContinuations { cont.yield(event) }
    }
#endif

    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
        let peripherals = (dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral]) ?? []
        let scanServices = (dict[CBCentralManagerRestoredStateScanServicesKey] as? [CBUUID]) ?? []
        let scanOptions = (dict[CBCentralManagerRestoredStateScanOptionsKey] as? [String: Any]) ?? [:]
        let event = SensorRestorationEvent(
            peripherals: peripherals,
            scanServices: scanServices,
            scanOptions: scanOptions.reduce(into: [String: String]()) { out, item in
                out[item.key] = String(describing: item.value)
            }
        )
        if restorationContinuations.isEmpty {
            pendingRestorationEvents.append(event)
        } else {
            for cont in restorationContinuations { cont.yield(event) }
        }
    }
}

#endif
