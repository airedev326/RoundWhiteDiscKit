// SensorScannerNG -- event-driven CBCentralManager wrapper.
//
// Every CB delegate callback yields a single typed event on the
// events() stream. There are no pending-operation dictionaries, no
// continuation pools, no DispatchWorkItems for timeouts. Callers
// drive their own state machines off the events.
//
// This is the planned replacement for SensorScanner. Once consumers
// are migrated over, the old class will be removed.

import Foundation
import CoreBluetooth

public final class SensorScannerNG: NSObject, @unchecked Sendable {

    // MARK: - Events

    public enum Event: @unchecked Sendable {
        case stateChanged(CBManagerState)
        case didDiscover(DiscoveredSensor)
        case didConnect(CBPeripheral)
        case didFailToConnect(CBPeripheral, error: Error?)
        /// CB.didDisconnectPeripheral. Caller's cue to invalidate any
        /// outstanding session state.
        case didDisconnect(CBPeripheral, error: Error?)
        /// connectionEventDidOccur(_:for:) -- requires
        /// registerForConnectionEvents to be active.
        case connectionEvent(CBConnectionEvent, peripheral: CBPeripheral)
        case willRestoreState(SensorRestorationEvent)
    }


    private let configuration: SensorScannerConfiguration
    /// Internal queue the CBCentralManager dispatches delegate callbacks
    /// on. Exposed publicly because callers who construct a SensorSession
    /// from a `.didConnect`'d peripheral typically want to use the same
    /// queue so CB peripheral-delegate callbacks land in the same
    /// serialization context as the central's events.
    public let centralQueue = DispatchQueue(label: "org.roundwhitedisc.ng", qos: .userInitiated)
    private lazy var central: CBCentralManager = {
        CBCentralManager(delegate: self, queue: centralQueue, options: configuration.centralOptions)
    }()

    /// AsyncStream continuations -- one per active events() subscriber,
    /// keyed by a UUID we hand back on subscription for termination.
    /// Mutated only on centralQueue.
    private var eventContinuations: [UUID: AsyncStream<Event>.Continuation] = [:]

    /// Restoration events arrive before any consumer has a chance to
    /// subscribe (CB delivers them before we even return from init()).
    /// Buffer them and replay to the first subscriber.
    private var pendingRestorationEvents: [SensorRestorationEvent] = []

    /// Strong references to the peripherals we're actively using. Core
    /// Bluetooth does NOT retain CBPeripheral objects for you -- a peripheral
    /// with a pending connect (or one handed back by state restoration) is
    /// deallocated once the last strong ref goes away, and iOS then silently
    /// drops the pending connect / tears down the restored connection. That
    /// manifested as a reconnect that never completes and, on a restored link,
    /// a handshake failing with `missingCharacteristic` + "the specified
    /// device has disconnected from us". We retain on requestConnect and on
    /// willRestoreState. We release only when an operation reaches a TERMINAL
    /// state, never merely when the CoreBluetooth command was issued: an
    /// intentional cancelConnection of a connected/disconnecting peripheral keeps
    /// the ref until its didDisconnect/didFailToConnect lands (owning it through
    /// the cancellation handoff), while cancelling a pending `.connecting` connect
    /// releases immediately (iOS fires no terminal callback for that). A plain
    /// unexpected didDisconnect keeps the ref -- it's still a reconnect candidate.
    /// Mutated only on centralQueue.
    private var retainedPeripherals: [UUID: CBPeripheral] = [:]

    /// Peripherals for which we issued an intentional `cancelPeripheralConnection`
    /// and are awaiting the terminal didDisconnect/didFailToConnect before dropping
    /// the retained strong ref. Distinguishes an intentional cancel (release on the
    /// terminal callback) from an unexpected disconnect (keep retaining). Mutated
    /// only on centralQueue.
    private var cancellingPeripherals: Set<UUID> = []

    public init(configuration: SensorScannerConfiguration = .foreground) {
        self.configuration = configuration
        super.init()
        _ = central // force lazy init
    }

    // MARK: - State + events

    /// Snapshot of the central's current state.
    public var centralState: CBManagerState {
        var state: CBManagerState = .unknown
        centralQueue.sync { state = self.central.state }
        return state
    }

    /// Subscribe to the event stream. Each subscriber gets an
    /// independent stream. On subscribe, the current central state is
    /// replayed as `.stateChanged(currentState)` so consumers don't
    /// race with already-fired transitions (e.g., a subscribe right
    /// after foreground-restore where CB has already settled to
    /// `.poweredOn`). Buffered restoration events from app launch are
    /// also flushed once to the first subscriber.
    public func events() -> AsyncStream<Event> {
        let id = UUID()
        return AsyncStream { continuation in
            centralQueue.async { [weak self] in
                guard let self else {
                    continuation.finish()
                    return
                }
                self.eventContinuations[id] = continuation
                // Snapshot of the current state so a consumer that
                // subscribes after CB has already settled doesn't have
                // to wait forever for the next transition. This is
                // analogous to the old SensorScanner.stateEvents()
                // contract that yielded the current state on subscribe.
                continuation.yield(.stateChanged(self.central.state))
                if !self.pendingRestorationEvents.isEmpty {
                    for event in self.pendingRestorationEvents {
                        continuation.yield(.willRestoreState(event))
                    }
                    self.pendingRestorationEvents.removeAll()
                }
                continuation.onTermination = { [weak self] _ in
                    self?.centralQueue.async {
                        self?.eventContinuations.removeValue(forKey: id)
                    }
                }
            }
        }
    }

    // MARK: - Scan (fire-and-forget)

    public func startScan(services: [CBUUID]? = [LibreSensorGATT.serviceUUID]) {
        centralQueue.async { [weak self] in
            guard let self else { return }
            self.central.scanForPeripherals(
                withServices: services,
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
            )
        }
    }

    public func stopScan() {
        centralQueue.async { [weak self] in
            self?.central.stopScan()
        }
    }

    // MARK: - Connect / disconnect (fire-and-forget)

    public func requestConnect(_ peripheral: CBPeripheral) {
        centralQueue.async { [weak self] in
            guard let self else { return }
            // A fresh connect intent supersedes any pending cancellation handoff,
            // so a superseded cancel's terminal callback won't drop this new ref.
            self.cancellingPeripherals.remove(peripheral.identifier)
            // Retain the peripheral for the lifetime of the connect intent --
            // CB won't, and a deallocated peripheral drops the pending connect.
            self.retainedPeripherals[peripheral.identifier] = peripheral
            // central.connect is idempotent; if the peripheral is
            // already connecting or connected, this is a no-op.
            self.central.connect(peripheral, options: self.configuration.connectOptions)
        }
    }

    public func cancelConnection(_ peripheral: CBPeripheral) {
        centralQueue.async { [weak self] in
            guard let self else { return }
            let state = peripheral.state
            self.central.cancelPeripheralConnection(peripheral)
            switch state {
            case .connected, .disconnecting:
                // A terminal didDisconnect/didFailToConnect is coming -- keep the
                // strong ref (marked as an intentional cancel) until it lands, so we
                // don't drop the handle while CB still has a callback outstanding.
                self.cancellingPeripherals.insert(peripheral.identifier)
            default:
                // .connecting/.disconnected: cancelling a pending connect fires no
                // terminal callback, so there's nothing to retain through.
                self.cancellingPeripherals.remove(peripheral.identifier)
                self.retainedPeripherals[peripheral.identifier] = nil
            }
        }
    }

    // MARK: - Lookup helpers

    public func retrievePeripherals(withIdentifiers ids: [UUID]) -> [CBPeripheral] {
        var result: [CBPeripheral] = []
        centralQueue.sync { result = self.central.retrievePeripherals(withIdentifiers: ids) }
        return result
    }

    public func retrieveConnectedPeripherals(serviceUUIDs: [CBUUID] = [LibreSensorGATT.serviceUUID]) -> [CBPeripheral] {
        var result: [CBPeripheral] = []
        centralQueue.sync { result = self.central.retrieveConnectedPeripherals(withServices: serviceUUIDs) }
        return result
    }

    // MARK: - Background

    public func registerForConnectionEvents(
        peripheralIDs: [UUID]? = nil,
        serviceUUIDs: [CBUUID]? = nil
    ) {
        #if os(iOS)
        centralQueue.async { [weak self] in
            guard let self else { return }
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

    // MARK: - Internal: emit

    /// Yield an event to every subscriber. Must be called on centralQueue.
    private func emit(_ event: Event) {
        for continuation in eventContinuations.values {
            continuation.yield(event)
        }
    }
}

// MARK: - CBCentralManagerDelegate

extension SensorScannerNG: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        emit(.stateChanged(central.state))
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
        let discovered = DiscoveredSensor(
            id: peripheral.identifier,
            name: peripheral.name ?? (advertisementData[CBAdvertisementDataLocalNameKey] as? String),
            rssi: RSSI.intValue,
            advertisedServices: advertisedServices,
            advertisementData: advSummary,
            peripheral: peripheral
        )
        emit(.didDiscover(discovered))
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        emit(.didConnect(peripheral))
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        releaseIfCancelling(peripheral)
        emit(.didFailToConnect(peripheral, error: error))
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        releaseIfCancelling(peripheral)
        emit(.didDisconnect(peripheral, error: error))
    }

    /// Terminal callback for a peripheral we intentionally cancelled: the
    /// cancellation handoff is complete, so drop the retained strong ref now.
    /// An unexpected disconnect (not marked cancelling) is left retained -- it's
    /// still a reconnect candidate. Runs on centralQueue (a CB delegate callback).
    private func releaseIfCancelling(_ peripheral: CBPeripheral) {
        if cancellingPeripherals.remove(peripheral.identifier) != nil {
            retainedPeripherals[peripheral.identifier] = nil
        }
    }

    #if os(iOS)
    public func centralManager(
        _ central: CBCentralManager,
        connectionEventDidOccur event: CBConnectionEvent,
        for peripheral: CBPeripheral
    ) {
        emit(.connectionEvent(event, peripheral: peripheral))
    }
    #endif

    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
        let peripherals = (dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral]) ?? []
        // Retain the restored peripherals immediately (this delegate call is on
        // centralQueue). iOS hands them back connected, but if we don't hold a
        // strong ref they deallocate and the restored connection is torn down
        // before the reconnect can use it. (Mirrors G7's handleDiscoveredPeripheral
        // retaining each restored peripheral in managedPeripherals.)
        for peripheral in peripherals {
            retainedPeripherals[peripheral.identifier] = peripheral
        }
        let scanServices = (dict[CBCentralManagerRestoredStateScanServicesKey] as? [CBUUID]) ?? []
        let scanOptions = (dict[CBCentralManagerRestoredStateScanOptionsKey] as? [String: Any]) ?? [:]
        let event = SensorRestorationEvent(
            peripherals: peripherals,
            scanServices: scanServices,
            scanOptions: scanOptions.reduce(into: [String: String]()) { out, item in
                out[item.key] = String(describing: item.value)
            }
        )
        // willRestoreState fires before consumers can subscribe; buffer
        // until the first events() subscription, then replay.
        if eventContinuations.isEmpty {
            pendingRestorationEvents.append(event)
        } else {
            emit(.willRestoreState(event))
        }
    }
}
