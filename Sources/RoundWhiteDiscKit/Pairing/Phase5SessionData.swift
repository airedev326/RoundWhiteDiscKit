import Foundation
import Security

public struct Phase5SessionData: Equatable, Sendable {
    public static let byteCount = 66

    public let bytes: Data

    public init(_ bytes: Data) throws {
        guard bytes.count == Self.byteCount else {
            throw Phase5SessionDataError.invalidLength(bytes.count)
        }
        for (index, byte) in bytes.enumerated() {
            guard byte <= 0x07 else {
                throw Phase5SessionDataError.non3BitByte(index: index, value: byte)
            }
        }
        self.bytes = bytes
    }

    /// Diagnostic generator for table/key-schedule tests only. Current
    /// first-pair evidence does not support arbitrary local random bytes as a
    /// protocol-agreed Phase 5 source.
    public static func random() throws -> Phase5SessionData {
        var bytes = [UInt8](repeating: 0, count: Self.byteCount)
        let status = bytes.withUnsafeMutableBytes { rawBuffer in
            guard let baseAddress = rawBuffer.baseAddress else { return errSecParam }
            return SecRandomCopyBytes(kSecRandomDefault, rawBuffer.count, baseAddress)
        }
        guard status == errSecSuccess else {
            throw Phase5SessionDataError.randomFailed(status)
        }
        for index in bytes.indices {
            bytes[index] &= 0x07
        }
        return try Phase5SessionData(Data(bytes))
    }

    public func phase5RawKey() throws -> Data {
        try Phase5KeySchedule.deriveRawKey(input66: bytes)
    }
}

public enum Phase5SessionDataError: Error, Equatable, Sendable {
    case invalidLength(Int)
    case non3BitByte(index: Int, value: UInt8)
    case randomFailed(OSStatus)
}
