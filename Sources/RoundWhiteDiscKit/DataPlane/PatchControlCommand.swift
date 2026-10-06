import Foundation

// Plaintext builders for patchControl writes.
//
// Each command is exactly 7 bytes before the post-auth AES-CCM data-plane
// wrapper turns it into an 11-byte encrypted body plus a 2-byte sequence.

public struct PatchControlCommand: Equatable, Sendable {
    public let label: String
    public let plaintext: Data

    public init(label: String, plaintext: Data) throws {
        guard plaintext.count == 7 else {
            throw PatchControlCommandError.wrongPlaintextSize(plaintext.count)
        }
        self.label = label
        self.plaintext = plaintext
    }

    public static func historicalBackfillGreaterEqual(
        lifeCount: UInt16,
        selector: UInt8 = 0x01
    ) -> PatchControlCommand {
        backfillGreaterEqual(stream: .historical, lifeCount: lifeCount, selector: selector)
    }

    public static func clinicalBackfillGreaterEqual(
        lifeCount: UInt16,
        selector: UInt8 = 0x01
    ) -> PatchControlCommand {
        backfillGreaterEqual(stream: .clinical, lifeCount: lifeCount, selector: selector)
    }

    public static func backfillGreaterEqual(
        stream: BackfillStream,
        lifeCount: UInt16,
        selector: UInt8 = 0x01
    ) -> PatchControlCommand {
        makeRangeCommand(
            label: "\(stream.label) >= \(lifeCount)",
            command: 0x01,
            stream: stream.wireValue,
            selector: selector,
            lifeCount: lifeCount,
            aux: nil
        )
    }

    public static func eventLog(index: UInt8) -> PatchControlCommand {
        PatchControlCommand(
            label: "event log >= \(index)",
            plaintext: Data([0x04, index, 0x00, 0x00, 0x00, 0x00, 0x00]),
            unchecked: ()
        )
    }

    public static func factoryData() -> PatchControlCommand {
        PatchControlCommand(
            label: "factory data",
            plaintext: Data([0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
            unchecked: ()
        )
    }

    /// Request sensor shutdown/end-session.
    ///
    /// This is a terminal patch-control command. It is not needed for routine
    /// disconnect, reconnect, or backfill workflows.
    public static func shutdownPatch() -> PatchControlCommand {
        PatchControlCommand(
            label: "shutdown patch",
            plaintext: Data([0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
            unchecked: ()
        )
    }

    private init(label: String, plaintext: Data, unchecked: Void) {
        self.label = label
        self.plaintext = plaintext
    }

    private static func makeRangeCommand(
        label: String,
        command: UInt8,
        stream: UInt8,
        selector: UInt8,
        lifeCount: UInt16,
        aux: UInt16?
    ) -> PatchControlCommand {
        var bytes = Data([
            command,
            stream,
            selector,
            UInt8(lifeCount & 0xff),
            UInt8((lifeCount >> 8) & 0xff),
            0x00,
            0x00,
        ])
        if let aux {
            bytes[5] = UInt8(aux & 0xff)
            bytes[6] = UInt8((aux >> 8) & 0xff)
        }
        return PatchControlCommand(label: label, plaintext: bytes, unchecked: ())
    }
}

public enum PatchControlCommandError: Error, Equatable {
    case wrongPlaintextSize(Int)
}
