import Foundation

/// Local per-step BLE timing instrumentation. Callers
/// register a sink via `setBLEEventLogger(_:)`; SensorScanner.connect and
/// SensorSession.discoverAndSubscribe push timed events through it so we
/// can see where the 30-60s reconnect window is actually going.
///
/// Not upstreamable in this form — uses a global sink and lives as a
/// local patch on the RoundWhiteDiscKit SwiftPM checkout. Will not survive a
/// SwiftPM re-resolve.
public enum BLETiming {
    nonisolated(unsafe) private static var sink: ((String) -> Void)?
    private static let lock = NSLock()

    public static func setLogger(_ logger: ((String) -> Void)?) {
        lock.lock()
        defer { lock.unlock() }
        sink = logger
    }

    static func log(_ message: String) {
        lock.lock()
        let s = sink
        lock.unlock()
        s?(message)
    }
}
