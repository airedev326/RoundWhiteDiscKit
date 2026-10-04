import CryptoKit
import Foundation

// Remote runtime tables.
//
// The package bundles no data files. Every lookup table (and the phone certs)
// ships in a single ~1 MB blob that the host app fetches and hands to
// RoundWhiteDiscKit.installRuntimeTables(_:) before any pairing / crypto call.
// The blob is built by Scripts/build_runtime_tables_blob.py; see that script
// for the format.
//
// Four of the large tables are overlapping dumps of one library region, so the
// blob stores that region once (`image`) plus small byte patches; the rest are
// stored by name. The SHA-256 of the whole decompressed payload is pinned here,
// so a corrupt or foreign blob is rejected before anything reads it.

public enum RuntimeTablesError: Error, CustomStringConvertible {
    case notInstalled(String)
    case decompressionFailed
    case badMagic
    case unsupportedVersion(UInt32)
    case malformed(String)
    case missingTable(String)
    case digestMismatch

    public var description: String {
        switch self {
        case .notInstalled(let name):
            return "runtime table \(name) unavailable: call RoundWhiteDiscKit.installRuntimeTables(_:) first"
        case .decompressionFailed: return "runtime tables blob is not a valid xz stream"
        case .badMagic: return "runtime tables blob has wrong magic"
        case .unsupportedVersion(let v): return "runtime tables blob version \(v) is not supported"
        case .malformed(let why): return "runtime tables blob malformed: \(why)"
        case .missingTable(let name): return "runtime table \(name) is not in the installed blob"
        case .digestMismatch: return "runtime tables blob failed SHA-256 verification (wrong blob for this build?)"
        }
    }
}

extension RoundWhiteDiscKit {
    /// Blob format version this build of RoundWhiteDiscKit accepts.
    public static let runtimeTablesFormatVersion: UInt32 = 3

    /// Decompresses, reconstructs and verifies the remote runtime tables blob.
    /// Throws without changing state if the blob is invalid. Safe to call again
    /// with the same blob.
    public static func installRuntimeTables(_ blob: Data) throws {
        let tables = try RemoteRuntimeTables.decode(blob)
        RemoteRuntimeTables.install(tables)
    }

    public static var runtimeTablesInstalled: Bool {
        RemoteRuntimeTables.isInstalled
    }
}

enum RemoteRuntimeTables {
    static let magic = Array("RWDKTBL\0".utf8)
    static let headerLength = 24

    // Offsets must match Scripts/build_runtime_tables_blob.py.
    static let sbox19Prefix = 0x20001
    static let sbox19Length = 0x80000
    static let ttableBExtLength = 0x100000

    /// SHA-256 of the decompressed payload, printed by the build script.
    static let expectedPayloadSHA256 = "a5bd1e3b2cc5d7ee6717f5eb9d8735a05e30b2fed6039a53be0dd2044040b58b"

    private static let lock = NSLock()
    private static var installed: [String: Data]?

    static var isInstalled: Bool {
        lock.lock(); defer { lock.unlock() }
        return installed != nil
    }

    static func install(_ tables: [String: Data]) {
        lock.lock(); defer { lock.unlock() }
        installed = tables
    }

    static func data(named name: String) throws -> Data {
        lock.lock(); defer { lock.unlock() }
        guard let installed else {
            throw RuntimeTablesError.notInstalled(name)
        }
        guard let data = installed[name] else {
            throw RuntimeTablesError.missingTable(name)
        }
        return data
    }

    static func decode(_ blob: Data) throws -> [String: Data] {
        let payload: Data
        do {
            payload = try (blob as NSData).decompressed(using: .lzma) as Data
        } catch {
            throw RuntimeTablesError.decompressionFailed
        }
        let digest = SHA256.hash(data: payload).map { String(format: "%02x", $0) }.joined()
        guard digest == expectedPayloadSHA256 else {
            throw RuntimeTablesError.digestMismatch
        }
        let p = [UInt8](payload)

        guard p.count >= headerLength, Array(p[0..<8]) == magic else {
            throw RuntimeTablesError.badMagic
        }
        let version = u32(p, 8)
        guard version == RoundWhiteDiscKit.runtimeTablesFormatVersion else {
            throw RuntimeTablesError.unsupportedVersion(version)
        }
        let imageLength = Int(u32(p, 12))
        let patchCount = Int(u32(p, 16))
        let namedCount = Int(u32(p, 20))
        guard imageLength == sbox19Prefix + ttableBExtLength else {
            throw RuntimeTablesError.malformed("image length \(imageLength)")
        }

        var pos = headerLength
        func take(_ n: Int) throws -> ArraySlice<UInt8> {
            guard n >= 0, pos + n <= p.count else {
                throw RuntimeTablesError.malformed("truncated at \(pos)")
            }
            defer { pos += n }
            return p[pos..<(pos + n)]
        }

        let image = try take(imageLength)

        let sbox12Start = image.startIndex + sbox19Prefix
        let sbox19 = image[image.startIndex..<(image.startIndex + sbox19Length)]
        var ttableBExt = Array(image[sbox12Start..<(sbox12Start + ttableBExtLength)])

        for _ in 0..<patchCount {
            let header = try take(7)
            let target = header[header.startIndex]
            let offset = Int(u32(p, header.startIndex + 1))
            let length = Int(p[header.startIndex + 5]) | (Int(p[header.startIndex + 6]) << 8)
            let bytes = try take(length)
            guard target == 0 else { throw RuntimeTablesError.malformed("patch target \(target)") }
            try applyPatch(&ttableBExt, offset, bytes)
        }
        var tables: [String: Data] = [
            RuntimeTable.sbox19.rawValue: Data(sbox19),
            RuntimeTable.child23TTableBExt.rawValue: Data(ttableBExt),
        ]
        for _ in 0..<namedCount {
            let nameLength = try take(2)
            let name = String(decoding: try take(Int(nameLength.first!) | (Int(nameLength.last!) << 8)), as: UTF8.self)
            let length = try take(4)
            tables[name] = Data(try take(Int(u32(p, length.startIndex))))
        }
        guard pos == p.count else {
            throw RuntimeTablesError.malformed("\(p.count - pos) trailing bytes")
        }
        return tables
    }

    private static func applyPatch(_ table: inout [UInt8], _ offset: Int, _ bytes: ArraySlice<UInt8>) throws {
        guard offset + bytes.count <= table.count else {
            throw RuntimeTablesError.malformed("patch at \(offset) out of range")
        }
        table.replaceSubrange(offset..<(offset + bytes.count), with: bytes)
    }

    private static func u32(_ p: [UInt8], _ at: Int) -> UInt32 {
        UInt32(p[at]) | (UInt32(p[at + 1]) << 8) | (UInt32(p[at + 2]) << 16) | (UInt32(p[at + 3]) << 24)
    }
}

/// Lazily builds a value once, caching only success: a table cache touched
/// before installRuntimeTables(_:) fails now and succeeds after install.
final class SuccessCache<Value> {
    private let lock = NSLock()
    private var value: Value?
    private let make: () throws -> Value

    init(_ make: @escaping () throws -> Value) {
        self.make = make
    }

    func get() throws -> Value {
        lock.lock(); defer { lock.unlock() }
        if let value { return value }
        let built = try make()
        value = built
        return built
    }
}
