import Foundation
#if canImport(CoreBluetooth) && (canImport(UIKit) || canImport(AppKit))
@preconcurrency import CoreBluetooth

// Adapter that lets `PairingFlow` drive a real `SensorSession` (CoreBluetooth)
// using the same code path the unit tests exercise via `ScriptedTransport`.
//
// Responsibilities:
//   - Map `BleCharRef` enum values to actual `CBUUID`s
//     (decoded from `findings/ble_gatt_profile.md` + `BLE_PAIRING_TRANSCRIPT.md`).
//   - On `write(_:to:)`, fragment the message via `BleFraming.fragmentForWrite`
//     and forward each fragment to `SensorSession.send(_:to:)`.
//   - On `awaitNotify(on:exactly:)`, attach to the `SensorSession.notifications()`
//     stream, run a `BleFraming.NotifyReassembler` over fragments tagged for
//     the requested characteristic, and return once the requested byte count
//     has been buffered.

public final class SensorSessionTransport: CommandPairingTransport, @unchecked Sendable {
    /// Per-fragment bound for `awaitNotify`. A connected handshake step that
    /// never receives its expected notify fragment (silent link death) would
    /// otherwise wait forever and wedge the reconnect Task.
    private static let notifyFragmentTimeout: TimeInterval = 10

    let session: SensorSession
    let charMap: [BleCharRef: CBUUID]
    private let notifyStore: SensorSessionNotifyStore
    private let notifyPump: Task<Void, Never>
    private let eventLogger: (@Sendable (String) -> Void)?

    public init(
        session: SensorSession,
        charMap: [BleCharRef: CBUUID] = SensorSessionTransport.defaultCharMap,
        eventLogger: (@Sendable (String) -> Void)? = nil
    ) {
        self.session = session
        self.charMap = charMap
        self.eventLogger = eventLogger
        let store = SensorSessionNotifyStore()
        self.notifyStore = store
        self.notifyPump = Task { [session, store, eventLogger] in
            for await event in session.notifications() {
                eventLogger?(
                    "BLE notify char=\(event.characteristic.uuidString) " +
                    "len=\(event.fragment.count) data=\(Self.hex(event.fragment))"
                )
                await store.append(event)
            }
            eventLogger?("BLE notify stream ended")
            await store.finish()
        }
    }

    deinit {
        notifyPump.cancel()
    }

    /// Default mapping per the captured fresh-pair handles.
    /// `certHandshake` = handle 0x002d, `challenge` = handle 0x002a.
    /// CBUUIDs are looked up via `LibreSensorGATT.Char` so a single source
    /// of truth governs the GATT identifiers.
    public static let defaultCharMap: [BleCharRef: CBUUID] = [
        .certHandshake: LibreSensorGATT.Char.certHandshake,
        .challenge: LibreSensorGATT.Char.challenge,
    ]

    public func write(_ message: Data, to characteristic: BleCharRef) async throws {
        guard let uuid = charMap[characteristic] else {
            throw SensorSessionTransportError.unmappedCharacteristic(characteristic)
        }
        eventLogger?("BLE write \(characteristic) len=\(message.count) data=\(Self.hex(message))")
        try await session.send(message, to: uuid)
    }

    public func awaitNotify(on characteristic: BleCharRef, exactly n: Int) async throws -> Data {
        guard let uuid = charMap[characteristic] else {
            throw SensorSessionTransportError.unmappedCharacteristic(characteristic)
        }
        eventLogger?("BLE await notify \(characteristic) exactly=\(n) char=\(uuid.uuidString)")
        let reassembler = BleFraming.NotifyReassembler()
        while true {
            let event = try await notifyStore.next(for: uuid, timeout: Self.notifyFragmentTimeout)
            try reassembler.feed(event.fragment)
            eventLogger?(
                "BLE notify progress \(characteristic) available=\(reassembler.availableBytes) wanted=\(n)"
            )
            if reassembler.availableBytes >= n {
                let out = try reassembler.take(n)
                eventLogger?("BLE notify complete \(characteristic) len=\(out.count) data=\(Self.hex(out))")
                return out
            }
        }
    }

    public func writeCommand(_ command: UInt8) async throws {
        eventLogger?("BLE write command=0x\(String(format: "%02x", command))")
        try await session.writeRaw(Data([command]), to: LibreSensorGATT.Char.secCommandResponse)
    }

    public func awaitCommandResponse(timeout: TimeInterval) async throws -> Data {
        eventLogger?("BLE await command response timeout=\(String(format: "%.1f", timeout))s")
        let response = try await notifyStore.next(
            for: LibreSensorGATT.Char.secCommandResponse,
            timeout: timeout
        ).fragment
        eventLogger?("BLE command response len=\(response.count) data=\(Self.hex(response))")
        return response
    }

    private static func hex(_ data: Data) -> String {
        data.map { String(format: "%02x", $0) }.joined()
    }
}

public enum SensorSessionTransportError: Error {
    case unmappedCharacteristic(BleCharRef)
    case notifyStreamEnded(have: Int, want: Int)
    case notifyTimeout(characteristic: String, seconds: TimeInterval)
}

private actor SensorSessionNotifyStore {
    private final class Waiter: @unchecked Sendable {
        let id = UUID()
        private let lock = NSLock()
        private var continuation: CheckedContinuation<NotifyEvent, Error>?
        private var completed: Result<NotifyEvent, Error>?

        func install(_ continuation: CheckedContinuation<NotifyEvent, Error>) {
            lock.lock()
            if let completed {
                lock.unlock()
                continuation.resume(with: completed)
                return
            }
            self.continuation = continuation
            lock.unlock()
        }

        @discardableResult
        func resume(with result: Result<NotifyEvent, Error>) -> Bool {
            lock.lock()
            if completed != nil {
                lock.unlock()
                return false
            }
            if let continuation {
                self.continuation = nil
                completed = result
                lock.unlock()
                continuation.resume(with: result)
                return true
            }
            completed = result
            lock.unlock()
            return true
        }
    }

    private var pending: [String: [NotifyEvent]] = [:]
    private var waiters: [String: [Waiter]] = [:]
    private var closed = false

    func append(_ event: NotifyEvent) {
        let key = event.characteristic.uuidString
        if var queue = waiters[key], !queue.isEmpty {
            let waiter = queue.removeFirst()
            waiters[key] = queue.isEmpty ? nil : queue
            _ = waiter.resume(with: .success(event))
            return
        }
        pending[key, default: []].append(event)
    }

    func finish() {
        closed = true
        let allWaiters = waiters.values.flatMap { $0 }
        waiters.removeAll()
        for waiter in allWaiters {
            _ = waiter.resume(with: .failure(SensorSessionTransportError.notifyStreamEnded(have: 0, want: 0)))
        }
    }

    func next(for uuid: CBUUID, timeout: TimeInterval? = nil) async throws -> NotifyEvent {
        let key = uuid.uuidString
        if var queue = pending[key], !queue.isEmpty {
            let event = queue.removeFirst()
            pending[key] = queue.isEmpty ? nil : queue
            return event
        }
        if closed {
            throw SensorSessionTransportError.notifyStreamEnded(have: 0, want: 0)
        }

        let waiter = Waiter()
        waiters[key, default: []].append(waiter)
        let timeoutTask: Task<Void, Never>?
        if let timeout {
            timeoutTask = Task { [weak self] in
                try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                await self?.timeoutWaiter(
                    key: key,
                    id: waiter.id,
                    seconds: timeout
                )
            }
        } else {
            timeoutTask = nil
        }
        defer { timeoutTask?.cancel() }

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                waiter.install(continuation)
            }
        } onCancel: {
            Task { await self.cancelWaiter(key: key, id: waiter.id) }
        }
    }

    private func timeoutWaiter(key: String, id: UUID, seconds: TimeInterval) {
        guard let waiter = removeWaiter(key: key, id: id) else { return }
        _ = waiter.resume(with: .failure(
            SensorSessionTransportError.notifyTimeout(characteristic: key, seconds: seconds)
        ))
    }

    private func cancelWaiter(key: String, id: UUID) {
        guard let waiter = removeWaiter(key: key, id: id) else { return }
        _ = waiter.resume(with: .failure(CancellationError()))
    }

    private func removeWaiter(key: String, id: UUID) -> Waiter? {
        guard var queue = waiters[key],
              let index = queue.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        let waiter = queue.remove(at: index)
        waiters[key] = queue.isEmpty ? nil : queue
        return waiter
    }
}

#endif
