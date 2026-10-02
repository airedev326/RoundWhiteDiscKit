import Foundation
import RoundWhiteDiscKit
import XCTest

extension Data {
    var hex: String {
        map { String(format: "%02x", $0) }.joined()
    }
}

/// Reads the runtime-tables blob from $ROUNDWHITEDISCKIT_RUNTIME_TABLES, else
/// RemoteTables/roundwhitedisckit-runtime-tables-v2.xz at the repo root (build it
/// with Scripts/build_runtime_tables_blob.py). Skips the test if it is absent.
func runtimeTablesBlobForTests() throws -> Data {
    let url: URL
    if let path = ProcessInfo.processInfo.environment["ROUNDWHITEDISCKIT_RUNTIME_TABLES"] {
        url = URL(fileURLWithPath: path)
    } else {
        url = URL(fileURLWithPath: "\(#filePath)")
            .deletingLastPathComponent()  // RoundWhiteDiscKitTests
            .deletingLastPathComponent()  // Tests
            .deletingLastPathComponent()  // repo root
            .appendingPathComponent("RemoteTables/roundwhitedisckit-runtime-tables-v2.xz")
    }
    guard let blob = try? Data(contentsOf: url) else {
        throw XCTSkip("runtime tables blob not found at \(url.path); run Scripts/build_runtime_tables_blob.py")
    }
    return blob
}

/// Installs the runtime-tables blob for tests that need the tables.
func installRuntimeTablesForTests() throws {
    if RoundWhiteDiscKit.runtimeTablesInstalled { return }
    try RoundWhiteDiscKit.installRuntimeTables(try runtimeTablesBlobForTests())
}
