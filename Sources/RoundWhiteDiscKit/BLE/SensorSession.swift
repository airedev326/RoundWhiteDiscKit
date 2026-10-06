import Foundation
@preconcurrency import CoreBluetooth

#if canImport(UIKit) || canImport(AppKit)

// Connected-and-discovered session against a Libre 3 sensor. After
// `discoverAndSubscribe()` returns the session is ready to send/receive
// fragments per the BleFraming protocol.

public struct NotifyEvent: Sendable {
    public let characteristic: CBUUID
    public let fragment: Data       // raw notify payload (1B seq + chunk)
    public let receivedAt: Date
}

public struct SensorCharacteristicSnapshot: Sendable {
    public let uuidString: String
    public let serviceUUIDString: String
    public let properties: [String]
    public let isNotifying: Bool
}

/// Session (post-connect GATT) errors.
///
/// **Classification note for clients:** *every* case here is a **transport**
/// failure — a GATT/link-level fault, not a credential problem. They are
/// expected to occur on marginal links and should be retried (reconnect /
/// re-arm), and must **not** contribute to a terminal / re-pair escalation.
/// In particular, a `notifyFailed` on a data-plane CCCD (a timed-out
/// notification-state write) is a routine transient, not a sign the sensor
/// needs replacing.
public enum SensorSessionError: Error {
    /// Transport: an expected characteristic wasn't present after discovery
    /// (often a stale handle — re-discover / reconnect).
    case missingCharacteristic(CBUUID)
    /// Transport: enabling/disabling notifications (CCCD write) failed or timed
    /// out. The `Bool` is the desired notify state; the `String` is detail.
    case notifyFailed(CBUUID, Bool, String)
    /// Transport: a GATT read failed.
    case readFailed(CBUUID, String)
    /// Transport: a GATT write failed. (Inspect the ATT code for auth/encryption
    /// rejections, but treat the failure itself as transport — retry.)
    case writeFailed(CBUUID, String)
    /// Transport: the link dropped.
    case disconnected(String?)
    /// Transport: service/characteristic discovery failed.
    case discoveryFailed(String)
}

extension SensorSessionError: CustomStringConvertible {
    /// Semantic description with associated values, so logs read
    /// "disconnected — link dropped: …" instead of the opaque NSError-bridged
    /// "SensorSessionError error 4" (the bare case ordinal).
    public var description: String {
        switch self {
        case .missingCharacteristic(let uuid):
            return "missingCharacteristic(\(uuid.uuidString)) — expected characteristic absent after discovery (stale handle; reconnect)"
        case .notifyFailed(let uuid, let enabled, let detail):
            return "notifyFailed(\(uuid.uuidString), enable=\(enabled)) — \(detail)"
        case .readFailed(let uuid, let detail):
            return "readFailed(\(uuid.uuidString)) — \(detail)"
        case .writeFailed(let uuid, let detail):
            return "writeFailed(\(uuid.uuidString)) — \(detail)"
        case .disconnected(let detail):
            return "disconnected — link dropped\(detail.map { ": \($0)" } ?? "")"
        case .discoveryFailed(let detail):
            return "discoveryFailed — \(detail)"
        }
    }
}

/// Formats a CoreBluetooth error with its raw domain + ATT/CB code. The
/// peripheral-returned "Unknown ATT error" string hides the code that tells
/// us *why* a write was rejected: ATT 0x01/0x0e = invalid/stale handle (needs
/// re-discovery), 0x05/0x0f = insufficient auth/encryption, 0x03 = write not
/// permitted, 0x80+ = a vendor/state rejection. Surface it for field logs.
func attErrorDescription(_ error: Error) -> String {
    let ns = error as NSError
    return "\(error.localizedDescription) [\(ns.domain) code=0x\(String(ns.code, radix: 16))]"
}

public final class SensorSession: NSObject, @unchecked Sendable {
    public let peripheral: CBPeripheral
    private let queue: DispatchQueue
    private var characteristics: [CBUUID: CBCharacteristic] = [:]
    private var discoveryContinuation: CheckedContinuation<Void, Error>?
    private var discoveryTimeoutWorkItem: DispatchWorkItem?
    private struct PendingWrite {
        let id: UUID
        let continuation: CheckedContinuation<Void, Error>
        let timeoutWorkItem: DispatchWorkItem?
    }
    private struct PendingRead {
        let box: PendingReadBox
    }
    private struct PendingNotifyChange {
        let enabled: Bool
        let box: PendingNotifyBox
    }
    private final class PendingReadBox: @unchecked Sendable {
        let id: UUID
        private let lock = NSLock()
        private var continuation: CheckedContinuation<Data, Error>?

        init(id: UUID, continuation: CheckedContinuation<Data, Error>) {
            self.id = id
            self.continuation = continuation
        }

        func resume(returning data: Data) -> Bool {
            let cont = takeContinuation()
            guard let cont else { return false }
            cont.resume(returning: data)
            return true
        }

        func resume(throwing error: Error) -> Bool {
            let cont = takeContinuation()
            guard let cont else { return false }
            cont.resume(throwing: error)
            return true
        }

        private func takeContinuation() -> CheckedContinuation<Data, Error>? {
            lock.lock()
            defer { lock.unlock() }
            let cont = continuation
            continuation = nil
            return cont
        }
    }
    private final class PendingNotifyBox: @unchecked Sendable {
        let id: UUID
        private let lock = NSLock()
        private var continuation: CheckedContinuation<Void, Error>?

        init(id: UUID, continuation: CheckedContinuation<Void, Error>) {
            self.id = id
            self.continuation = continuation
        }

        func resume() -> Bool {
            let cont = takeContinuation()
            guard let cont else { return false }
            cont.resume()
            return true
        }

        func resume(throwing error: Error) -> Bool {
            let cont = takeContinuation()
            guard let cont else { return false }
            cont.resume(throwing: error)
            return true
        }

        private func takeContinuation() -> CheckedContinuation<Void, Error>? {
            lock.lock()
            defer { lock.unlock() }
            let cont = continuation
            continuation = nil
            return cont
        }
    }
    private var pendingWrites: [CBUUID: [PendingWrite]] = [:]
    private var pendingReads: [CBUUID: [PendingRead]] = [:]
    private var pendingNotifyChanges: [CBUUID: [PendingNotifyChange]] = [:]
    private var notifyContinuations: [AsyncStream<NotifyEvent>.Continuation] = []
    private var servicesPendingChars: Int = 0
    private var notifyPending: Set<CBUUID> = []
    /// Which discovered characteristics to enable notifications on during
    /// `discoverAndSubscribe`. Defaults to the handshake set; data-plane
    /// characteristics are subscribed later by `refreshDataPlaneNotifications`.
    private var subscribeUUIDs: Set<CBUUID> = Set(LibreSensorGATT.Char.handshakeNotifying)
    private var discoveryStartedAt: Date?
    private var serviceDiscoveredAt: Date?
    private var charsDiscoveredAt: Date?

    /// Build a session for a peripheral the caller has already
    /// connected. Used by SensorScannerNG consumers who manage CB
    /// state directly: subscribe to scanner.events(), wait for
    /// `.didConnect`, then construct a SensorSession on the same
    /// queue the scanner uses. All GATT operations the session
    /// performs serialize onto `queue`, so it must be the queue the
    /// CBCentralManager was initialized with.
    public init(peripheral: CBPeripheral, queue: DispatchQueue) {
        self.peripheral = peripheral
        self.queue = queue
        super.init()
        peripheral.delegate = self
    }

    /// Discovers the Libre 3 services + characteristics and subscribes to the
    /// requested notify-capable characteristics. Resolves once discovery is
    /// complete.
    /// Requests BOTH the data service (glucose/log channels) AND the security
    /// service (cert exchange + challenge channels) — Phase 1–6 needs both.
    public func discoverAndSubscribe(
        subscribe: [CBUUID] = LibreSensorGATT.Char.handshakeNotifying,
        timeout: TimeInterval = 10
    ) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            queue.async {
                self.discoveryContinuation = cont
                self.discoveryStartedAt = Date()
                self.subscribeUUIDs = Set(subscribe)
                // A silently-dead link leaves the GATT discovery delegate
                // callbacks pending forever. Without this bound the reconnect
                // Task that awaits discoverAndSubscribe never returns, which
                // pins the single-flight reconnect guard and blocks every
                // future reconnect attempt.
                let timeoutWorkItem = DispatchWorkItem { [weak self] in
                    self?.finishDiscovery(.failure(SensorSessionError.discoveryFailed(
                        String(format: "Timed out waiting %.1fs for service/characteristic discovery", timeout)
                    )))
                }
                self.discoveryTimeoutWorkItem = timeoutWorkItem
                self.queue.asyncAfter(deadline: .now() + timeout, execute: timeoutWorkItem)
                let cachedServices = (self.peripheral.services ?? []).map { $0.uuid.uuidString }
                BLETiming.log("discoverAndSubscribe: starting (peripheral.services cached count=\(cachedServices.count))")
                self.peripheral.discoverServices([
                    LibreSensorGATT.serviceUUID,
                    LibreSensorGATT.securityServiceUUID,
                ])
            }
        }
    }

    /// Stream of every incoming notify fragment, tagged by characteristic UUID.
    /// Multiple subscribers each get their own stream (broadcast). Yields on a
    /// terminated continuation are no-ops, so we never bother removing dead
    /// entries from the broadcast list.
    public func notifications() -> AsyncStream<NotifyEvent> {
        AsyncStream { cont in
            self.queue.async {
                self.notifyContinuations.append(cont)
            }
        }
    }

    public func characteristicSnapshots() async -> [SensorCharacteristicSnapshot] {
        await withCheckedContinuation { cont in
            queue.async {
                let snapshots = self.characteristics.values.map { chr in
                    SensorCharacteristicSnapshot(
                        uuidString: chr.uuid.uuidString,
                        serviceUUIDString: chr.service?.uuid.uuidString ?? "unknown",
                        properties: Self.propertyNames(chr.properties),
                        isNotifying: chr.isNotifying
                    )
                }.sorted { $0.uuidString < $1.uuidString }
                cont.resume(returning: snapshots)
            }
        }
    }

    /// Explicitly updates a characteristic notification subscription and waits
    /// for CoreBluetooth's CCCD acknowledgement.
    public func setNotify(_ enabled: Bool, for uuid: CBUUID, timeout: TimeInterval) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            queue.async {
                guard let chr = self.characteristics[uuid] else {
                    cont.resume(throwing: SensorSessionError.missingCharacteristic(uuid))
                    return
                }
                guard chr.properties.contains(.notify) || chr.properties.contains(.indicate) else {
                    cont.resume(
                        throwing: SensorSessionError.notifyFailed(uuid, enabled, "Characteristic is not notifiable")
                    )
                    return
                }
                if chr.isNotifying == enabled {
                    // CoreBluetooth sends no CCCD write when the state already
                    // matches. Log it so field captures reveal when a "refresh"
                    // was actually a no-op — e.g. iOS retaining a characteristic's
                    // CCCD across a reconnect, which leaves the sensor un-rearmed.
                    BLETiming.log("setNotify: \(uuid.uuidString) already \(enabled ? "on" : "off") — no CCCD write")
                    cont.resume()
                    return
                }

                let box = PendingNotifyBox(id: UUID(), continuation: cont)
                self.pendingNotifyChanges[uuid, default: []].append(
                    PendingNotifyChange(enabled: enabled, box: box)
                )
                // Log the real CCCD write so field captures show when each enable is
                // issued vs when its didUpdateNotificationStateFor ack lands — the
                // sensor serializes acks (~1.5s each), so with many chars armed the
                // trailing ones race the per-char timeout.
                BLETiming.log("setNotify: \(uuid.uuidString) writing setNotifyValue(\(enabled)) — awaiting ack (timeout \(Int(timeout))s)")
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + timeout) { [weak self, box] in
                    guard box.resume(
                        throwing: SensorSessionError.notifyFailed(
                            uuid,
                            enabled,
                            String(format: "Timed out waiting %.1fs for notification state", timeout)
                        )
                    ) else { return }
                    self?.queue.async {
                        self?.removePendingNotifyChange(uuid: uuid, id: box.id)
                    }
                }
                self.peripheral.setNotifyValue(enabled, for: chr)
            }
        }
    }

    /// Refresh CCCDs on the data-plane characteristics with an off→on cycle.
    ///
    /// After Phase 6 (or any subsequent re-handshake against the same
    /// sensor) the BLE link is open but the sensor will not start streaming
    /// glucose/status until each data-plane notify characteristic has its
    /// CCCD re-armed. Calling this method right after the handshake
    /// completes is what kicks the sensor into broadcasting; without it
    /// the link stays silent and eventually drops.
    ///
    /// By default this refreshes the five characteristics that experimental
    /// captures show the sensor expects to be re-armed
    /// (`LibreSensorGATT.Char.dataPlaneNotifying`): `patchControl`,
    /// `eventLog`, `factoryData`, `glucoseData`, `patchStatus`. Callers can
    /// pass an alternative list for narrower refreshes.
    ///
    /// - Parameters:
    ///   - characteristics: UUIDs to refresh. Defaults to
    ///     `LibreSensorGATT.Char.dataPlaneNotifying`.
    ///   - perCharacteristicTimeout: Per-`setNotify` timeout.
    ///   - settleDelay: Retained for source compatibility. Data-plane
    ///     notifications are now first-time enables, so no settle delay is used.
    public func refreshDataPlaneNotifications(
        characteristics: [CBUUID] = LibreSensorGATT.Char.dataPlaneNotifying,
        forceReArm: Set<CBUUID> = Set(LibreSensorGATT.Char.dataPlaneNotifying),
        // The sensor acknowledges CCCD writes serially (~1.56s each), so with the
        // full data-plane set armed concurrently the trailing char's ack lands
        // ~count·1.56s out. With 7 chars the 7th ack lands ~8.85s after the writes,
        // so an 8s per-char timeout failed the whole refresh (field logs 2026-07-23:
        // 6 acks in, the 7th missed the 8s deadline by ~0.85s). 15s clears the
        // serial-ack tail with margin (confirmed: 7th ack at 8.85s, refresh
        // complete in 7.9s). A count-scaled bound — e.g. max(8, count·2) — would
        // stay robust if the arm set grows.
        perCharacteristicTimeout: TimeInterval = 15,
        settleDelay: TimeInterval = 0.09
    ) async throws {
        // Post-Phase-6 the sensor won't start broadcasting until each data-plane
        // characteristic gets a fresh CCCD write. iOS retains the CCCD-on state
        // across a reconnect to the same peripheral, so a plain setNotify(true)
        // short-circuits (isNotifying already true) and never actually writes.
        //
        // First observed on the command channel (patchControl): un-rearmed
        // encrypted writes returned "Unknown ATT error" → 100% backfill-request
        // failure. Subsequent field logs also show extended runs with zero
        // patchStatus notifications, matching the same silent-short-circuit
        // pattern (Abbott's own app expects patchStatus ~1/min alongside
        // glucoseData). So the default forceReArm now covers every UUID in
        // dataPlaneNotifying — one extra CCCD round-trip per reconnect, but
        // aligned with the vendor's post-Phase-6 toggle-all pattern captured
        // in findings/IOS_LIVE_TAKEOVER_DEPLOY_2026_05_06.md. Run concurrently
        // so acks overlap.
        _ = settleDelay
        let start = DispatchTime.now()
        BLETiming.log("refreshDataPlaneNotifications: \(characteristics.count) char(s), \(forceReArm.count) re-armed off→on")
        try await withThrowingTaskGroup(of: Void.self) { group in
            for uuid in characteristics {
                let rearm = forceReArm.contains(uuid)
                group.addTask {
                    if rearm {
                        // Force a real CCCD write even when iOS reports it as
                        // already notifying (retained across reconnect).
                        try await self.setNotify(false, for: uuid, timeout: perCharacteristicTimeout)
                    }
                    try await self.setNotify(true, for: uuid, timeout: perCharacteristicTimeout)
                }
            }
            try await group.waitForAll()
        }
        let ms = Int(Double(DispatchTime.now().uptimeNanoseconds &- start.uptimeNanoseconds) / 1_000_000)
        BLETiming.log("refreshDataPlaneNotifications: complete in \(ms)ms")
    }


    /// Fragments `payload` per BleFraming and writes each fragment with response.
    /// Resolves when all fragments have been ACKed by the peripheral.
    public func send(_ payload: Data, to uuid: CBUUID, timeout: TimeInterval = 5) async throws {
        let fragments = BleFraming.fragmentForWrite(payload)
        for frag in fragments {
            try await writeFragment(frag, to: uuid, timeout: timeout)
        }
    }

    /// Raw write — no BleFraming offset prefix. For single-byte command-channel
    /// writes (e.g. the security state-machine clock byte on 0x0027). The
    /// response timeout defaults to a short bound so a write whose ATT ACK
    /// never arrives (silent link death) fails promptly instead of hanging.
    public func writeRaw(_ data: Data, to uuid: CBUUID, timeout: TimeInterval = 5) async throws {
        try await writeFragment(data, to: uuid, timeout: timeout)
    }

    /// Raw read with a response timeout. CoreBluetooth delivers read responses
    /// through the same delegate callback as notifications, so callers should
    /// expect the returned value to also appear on `notifications()`.
    public func readRaw(_ uuid: CBUUID, timeout: TimeInterval) async throws -> Data {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Data, Error>) in
            queue.async {
                guard let chr = self.characteristics[uuid] else {
                    cont.resume(throwing: SensorSessionError.missingCharacteristic(uuid))
                    return
                }
                guard chr.properties.contains(.read) else {
                    cont.resume(throwing: SensorSessionError.readFailed(uuid, "Characteristic is not readable"))
                    return
                }
                let box = PendingReadBox(id: UUID(), continuation: cont)
                self.pendingReads[uuid, default: []].append(PendingRead(box: box))
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + timeout) { [weak self, box] in
                    guard box.resume(
                        throwing: SensorSessionError.readFailed(
                            uuid,
                            String(format: "Timed out waiting %.1fs for read response", timeout)
                        )
                    ) else { return }
                    self?.queue.async {
                        self?.removePendingRead(uuid: uuid, id: box.id)
                    }
                }
                self.peripheral.readValue(for: chr)
            }
        }
    }

    /// Direct GATT read of the current `patchStatus` value.
    ///
    /// Vendor-parity fallback for `patchStatus`. Abbott's own app expects
    /// `patchStatus` notifications approximately once per minute alongside
    /// `glucoseData` and, when the notify channel goes quiet for ~60 s,
    /// issues a direct read on this characteristic rather than waiting
    /// further (see `findings/DATA_PLANE_LIFECYCLE_BACKFILL_2026_05_10.md`
    /// and `findings/IOS_FIRSTPAIR_PHASE6_2026_05_10.md`). The response is
    /// delivered through the standard notification stream — CoreBluetooth
    /// uses the same delegate callback for reads and notifies — so callers
    /// that already parse `notifications()` will see the read result there
    /// like any other frame, no separate decode path required.
    ///
    /// Cheap and idempotent: the sensor tolerates the extra read, and it
    /// converts a silent-subscription failure (CCCD short-circuit, iOS
    /// notification loss) into a self-healing one on the channel that
    /// carries lifecycle / error / terminal-failure signals.
    public func readPatchStatus(timeout: TimeInterval = 5) async throws -> Data {
        try await readRaw(LibreSensorGATT.Char.patchStatus, timeout: timeout)
    }

    private func removePendingRead(uuid: CBUUID, id: UUID) {
        guard var reads = pendingReads[uuid],
              let index = reads.firstIndex(where: { $0.box.id == id }) else {
            return
        }
        reads.remove(at: index)
        if reads.isEmpty {
            pendingReads.removeValue(forKey: uuid)
        } else {
            pendingReads[uuid] = reads
        }
    }

    private func removePendingNotifyChange(uuid: CBUUID, id: UUID) {
        guard var changes = pendingNotifyChanges[uuid],
              let index = changes.firstIndex(where: { $0.box.id == id }) else {
            return
        }
        changes.remove(at: index)
        if changes.isEmpty {
            pendingNotifyChanges.removeValue(forKey: uuid)
        } else {
            pendingNotifyChanges[uuid] = changes
        }
    }

    private func writeFragment(_ fragment: Data, to uuid: CBUUID, timeout: TimeInterval? = nil) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            queue.async {
                guard let chr = self.characteristics[uuid] else {
                    cont.resume(throwing: SensorSessionError.missingCharacteristic(uuid))
                    return
                }
                let writeID = UUID()
                let timeoutWorkItem: DispatchWorkItem?
                if let timeout {
                    timeoutWorkItem = DispatchWorkItem { [weak self] in
                        guard let self else { return }
                        guard var writes = self.pendingWrites[uuid],
                              let index = writes.firstIndex(where: { $0.id == writeID }) else {
                            return
                        }
                        let pending = writes.remove(at: index)
                        if writes.isEmpty {
                            self.pendingWrites.removeValue(forKey: uuid)
                        } else {
                            self.pendingWrites[uuid] = writes
                        }
                        pending.continuation.resume(
                            throwing: SensorSessionError.writeFailed(
                                uuid,
                                String(format: "Timed out waiting %.1fs for write response", timeout)
                            )
                        )
                    }
                } else {
                    timeoutWorkItem = nil
                }
                self.pendingWrites[uuid, default: []].append(
                    PendingWrite(id: writeID, continuation: cont, timeoutWorkItem: timeoutWorkItem)
                )
                self.peripheral.writeValue(fragment, for: chr, type: .withResponse)
                if let timeout, let timeoutWorkItem {
                    self.queue.asyncAfter(deadline: .now() + timeout, execute: timeoutWorkItem)
                }
            }
        }
    }

    /// Fails all outstanding GATT operations with
    /// SensorSessionError.disconnected. SensorScannerNG consumers
    /// who own sessions directly must call this when they observe
    /// `.didDisconnect` from the scanner; otherwise pending
    /// writes/reads/notify-toggle awaiters can leak.
    public func handleDisconnect(error: Error?) {
        let msg = error?.localizedDescription
        queue.async {
            for (_, conts) in self.pendingWrites {
                for c in conts {
                    c.timeoutWorkItem?.cancel()
                    c.continuation.resume(throwing: SensorSessionError.disconnected(msg))
                }
            }
            self.pendingWrites.removeAll()
            for (_, conts) in self.pendingReads {
                for c in conts {
                    _ = c.box.resume(throwing: SensorSessionError.disconnected(msg))
                }
            }
            self.pendingReads.removeAll()
            for (_, conts) in self.pendingNotifyChanges {
                for c in conts {
                    _ = c.box.resume(throwing: SensorSessionError.disconnected(msg))
                }
            }
            self.pendingNotifyChanges.removeAll()
            for cont in self.notifyContinuations { cont.finish() }
            self.notifyContinuations.removeAll()
            self.finishDiscovery(.failure(SensorSessionError.disconnected(msg)))
        }
    }

    private static func propertyNames(_ properties: CBCharacteristicProperties) -> [String] {
        var names: [String] = []
        if properties.contains(.read) { names.append("read") }
        if properties.contains(.write) { names.append("write") }
        if properties.contains(.writeWithoutResponse) { names.append("writeWithoutResponse") }
        if properties.contains(.notify) { names.append("notify") }
        if properties.contains(.indicate) { names.append("indicate") }
        if properties.contains(.authenticatedSignedWrites) { names.append("authenticatedSignedWrites") }
        if properties.contains(.extendedProperties) { names.append("extendedProperties") }
        if properties.contains(.notifyEncryptionRequired) { names.append("notifyEncryptionRequired") }
        if properties.contains(.indicateEncryptionRequired) { names.append("indicateEncryptionRequired") }
        return names
    }
}

extension SensorSession: CBPeripheralDelegate {

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            finishDiscovery(.failure(SensorSessionError.discoveryFailed(error.localizedDescription)))
            return
        }
        let wanted: Set<CBUUID> = [
            LibreSensorGATT.serviceUUID,
            LibreSensorGATT.securityServiceUUID,
        ]
        let services = (peripheral.services ?? []).filter { wanted.contains($0.uuid) }
        if let start = discoveryStartedAt {
            let ms = Int(Date().timeIntervalSince(start) * 1000)
            BLETiming.log("didDiscoverServices: \(services.count) wanted service(s) found after \(ms)ms")
        }
        serviceDiscoveredAt = Date()
        guard !services.isEmpty else {
            finishDiscovery(.failure(SensorSessionError.discoveryFailed("no Libre 3 services found")))
            return
        }
        // Track how many service-discoveries we expect before finishing.
        servicesPendingChars = services.count
        for svc in services {
            let cachedChars = (svc.characteristics ?? []).count
            BLETiming.log("discoverCharacteristics for service \(svc.uuid.uuidString) (cached count=\(cachedChars))")
            peripheral.discoverCharacteristics(LibreSensorGATT.Char.all, for: svc)
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            finishDiscovery(.failure(SensorSessionError.discoveryFailed(error.localizedDescription)))
            return
        }
        if let start = serviceDiscoveredAt {
            let ms = Int(Date().timeIntervalSince(start) * 1000)
            BLETiming.log("didDiscoverCharacteristicsFor \(service.uuid.uuidString) after \(ms)ms; \((service.characteristics ?? []).count) char(s)")
        }
        var notifyRequested = 0
        for chr in service.characteristics ?? [] {
            characteristics[chr.uuid] = chr
            // Only subscribe the requested set at connect (the handshake
            // characteristics). Data-plane characteristics are left unsubscribed
            // and enabled once, post-handshake, so their CCCD enable is a fresh
            // write that kicks streaming — no off→on toggle.
            if chr.properties.contains(.notify), subscribeUUIDs.contains(chr.uuid) {
                if chr.isNotifying {
                    BLETiming.log("setNotifyValue: skipping \(chr.uuid.uuidString) — already notifying")
                } else {
                    notifyPending.insert(chr.uuid)
                    notifyRequested += 1
                    peripheral.setNotifyValue(true, for: chr)
                }
            }
        }
        if notifyRequested > 0 {
            BLETiming.log("setNotifyValue(true) issued for \(notifyRequested) char(s) on \(service.uuid.uuidString)")
        }
        servicesPendingChars -= 1
        // Wait for ALL services' characteristic discovery and all notify
        // subscriptions to be acknowledged before reporting the session ready.
        if servicesPendingChars <= 0 && notifyPending.isEmpty {
            if let start = discoveryStartedAt {
                let ms = Int(Date().timeIntervalSince(start) * 1000)
                BLETiming.log("discoverAndSubscribe: complete in \(ms)ms (all notify subs already on)")
            }
            finishDiscovery(.success(()))
        } else if servicesPendingChars <= 0 {
            charsDiscoveredAt = Date()
            BLETiming.log("discoverAndSubscribe: char discovery done; awaiting \(notifyPending.count) notify ack(s)")
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let pending = pendingNotifyChanges[characteristic.uuid]?.first {
            pendingNotifyChanges[characteristic.uuid] = Array(pendingNotifyChanges[characteristic.uuid]!.dropFirst())
            if pendingNotifyChanges[characteristic.uuid]?.isEmpty == true {
                pendingNotifyChanges.removeValue(forKey: characteristic.uuid)
            }

            if let error {
                _ = pending.box.resume(
                    throwing: SensorSessionError.notifyFailed(
                        characteristic.uuid,
                        pending.enabled,
                        error.localizedDescription
                    )
                )
            } else if characteristic.isNotifying == pending.enabled {
                _ = pending.box.resume()
            } else {
                _ = pending.box.resume(
                    throwing: SensorSessionError.notifyFailed(
                        characteristic.uuid,
                        pending.enabled,
                        "Characteristic state did not match requested state"
                    )
                )
            }
        } else if let error {
            finishDiscovery(.failure(SensorSessionError.discoveryFailed(error.localizedDescription)))
            return
        }

        if characteristic.isNotifying {
            notifyPending.remove(characteristic.uuid)
        }
        if servicesPendingChars <= 0 && notifyPending.isEmpty {
            if let start = discoveryStartedAt {
                let totalMs = Int(Date().timeIntervalSince(start) * 1000)
                let charsToNotifyMs = charsDiscoveredAt.map { Int(Date().timeIntervalSince($0) * 1000) } ?? -1
                BLETiming.log("discoverAndSubscribe: complete in \(totalMs)ms (notify-ack phase \(charsToNotifyMs)ms)")
            }
            finishDiscovery(.success(()))
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let conts = pendingReads[characteristic.uuid], !conts.isEmpty {
            pendingReads[characteristic.uuid] = Array(conts.dropFirst())
            let pending = conts.first!
            if let error = error {
                _ = pending.box.resume(
                    throwing: SensorSessionError.readFailed(characteristic.uuid, attErrorDescription(error))
                )
            } else if let value = characteristic.value {
                _ = pending.box.resume(returning: value)
            } else {
                _ = pending.box.resume(
                    throwing: SensorSessionError.readFailed(characteristic.uuid, "Read returned no value")
                )
            }
        }

        guard error == nil, let value = characteristic.value else { return }
        let event = NotifyEvent(characteristic: characteristic.uuid, fragment: value, receivedAt: Date())
        for cont in notifyContinuations { cont.yield(event) }
    }

    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        let conts = pendingWrites[characteristic.uuid] ?? []
        if !conts.isEmpty {
            pendingWrites[characteristic.uuid] = Array(conts.dropFirst())
            conts.first!.timeoutWorkItem?.cancel()
            if let error = error {
                conts.first!.continuation.resume(
                    throwing: SensorSessionError.writeFailed(characteristic.uuid, attErrorDescription(error))
                )
            } else {
                conts.first!.continuation.resume()
            }
        }
    }

    private func finishDiscovery(_ result: Result<Void, Error>) {
        discoveryTimeoutWorkItem?.cancel()
        discoveryTimeoutWorkItem = nil
        guard let cont = discoveryContinuation else { return }
        discoveryContinuation = nil
        switch result {
        case .success: cont.resume()
        case .failure(let e): cont.resume(throwing: e)
        }
    }
}

#endif
