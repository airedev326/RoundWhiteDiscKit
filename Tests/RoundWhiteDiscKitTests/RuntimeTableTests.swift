import XCTest
@testable import RoundWhiteDiscKit

final class RuntimeTableTests: XCTestCase {
    override func setUpWithError() throws {
        try installRuntimeTablesForTests()
    }

    func testAllTablesLoadable() throws {
        let expectedSizes: [(RuntimeTable, Int)] = [
            (.sbox19,    524_288),
            (.sbox12,  2_097_152),
            (.decode,     65_536),
            (.params,     56_364),
            (.bytecode,  413_696),
            (.t5Seed,      1_560),
            (.singleton,  16_384),
            (.gfReduce,      256),
            (.bitMask,        16),
            (.phase5KeySchedRegion, 8_192),
            (.child23ProgramRegion, 279_808),
            (.child23VMStart, 1_000),
            (.child23VMDesc, 324_816),
            (.child23StaticTable, 2_120),
            (.child23StaticCopyCode, 4_904),
            (.child23TTableBExt, 1_048_576),
            (.firstPairProg64e2b8, 592),
            (.firstPairProg638840, 33_280),
            (.firstPair6388f0SharedContext, 1_312),
            (.firstPair6388f0CallerLoopInterleaved, 10_384),
            (.firstPair6388f0LaneTables, 4_680),
            (.firstPair6388f0SelectorMul, 32),
            (.firstPair6388f0SelectorAdd, 32),
            (.firstPair63c278U32Tables, 83_856),
            (.firstPair63c278FoldTables, 15_200),
            (.firstPair633fa8NullTables, 5_135),
            (.firstPair633fa8NullNibble, 64),
            (.firstPairProcess2PublicTables, 1_304),
            (.firstPairProg67cc18, 24_832),
            (.firstPairFinalLenTables, 1_536),
            (.firstPairDF80RoundTables, 1_170),
            (.firstPairFinalizerTables, 4_818),
            (.firstPair679f48SeedTables, 1_746),
            (.firstPairReducer67ea28Nibble, 64),
            (.firstPairProg67076c, 132),
        ]
        for (table, expected) in expectedSizes {
            let data = try table.load()
            XCTAssertEqual(data.count, expected, "\(table.rawValue) wrong size")
        }
    }
}

final class RemoteRuntimeTablesBlobTests: XCTestCase {
    func testRejectsGarbage() {
        XCTAssertThrowsError(try RoundWhiteDiscKit.installRuntimeTables(Data([1, 2, 3])))
    }

    func testRejectsTamperedPayload() throws {
        let blob = try runtimeTablesBlobForTests()
        var payload = try (blob as NSData).decompressed(using: .lzma) as Data
        XCTAssertNoThrow(try RemoteRuntimeTables.decode(blob))

        payload[RemoteRuntimeTables.headerLength + 0x30000] ^= 0xff  // inside sbox19/sbox12 overlap
        let tampered = try (payload as NSData).compressed(using: .lzma) as Data
        XCTAssertThrowsError(try RemoteRuntimeTables.decode(tampered)) { error in
            guard case RuntimeTablesError.digestMismatch = error else {
                return XCTFail("expected digestMismatch, got \(error)")
            }
        }
    }
}
