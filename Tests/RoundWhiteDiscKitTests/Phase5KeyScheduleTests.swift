import XCTest
@testable import RoundWhiteDiscKit

final class Phase5KeyScheduleTests: XCTestCase {
    override func setUpWithError() throws {
        try installRuntimeTablesForTests()
    }

    func testPythonReferenceVectors() throws {
        let vectors: [(String, String)] = [
            (
                String(repeating: "00", count: 66),
                "4facb8db3692f2714ebaea5f9ff22de6"
            ),
            (
                "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f" +
                "202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f4041",
                "56120a7e63561935008ef24e76f45d2a"
            ),
            (
                "050404000106040200060403000402060006030600010305070302070500030500020" +
                "605020406000607050606000507060103030207040705040406030200060507",
                "3b16168843c299ad7fa311ba2440d58a"
            ),
            (
                "02040702070305000006040006040206030003020605000105000301050000010202" +
                "0605060500000207040000060507020702060304070705050502060603000407",
                "3b16168843c299ad7fa311ba2440d58a"
            ),
            (
                "070705010506010205030100000305050600030300060304010205050201050606000407" +
                "010102020704030606050705010404060101060507010404000200000204",
                "3e2199e34b872cec7ea8b621542c77ff"
            ),
            (
                "040407050401050502030004070502010204000007030103030500070704060304" +
                "040404000206070605020103020500020404000203010107040404070403050004",
                "83f168a697970f7288c8a0abd0d83fee"
            ),
        ]

        for (inputHex, expectedHex) in vectors {
            let input = Data(hexString: inputHex)
            let key = try Phase5KeySchedule.deriveRawKey(input66: input)
            XCTAssertEqual(key.hex, expectedHex)
        }
    }

    func testRejectsWrongInputLength() {
        XCTAssertThrowsError(try Phase5KeySchedule.deriveRawKey(input66: Data(count: 65))) { error in
            XCTAssertEqual(error as? Phase5KeyScheduleError, .invalidInputLength(65))
        }
    }

    func testPhase5SessionDataRejectsWrongLength() {
        XCTAssertThrowsError(try Phase5SessionData(Data(count: 65))) { error in
            XCTAssertEqual(error as? Phase5SessionDataError, .invalidLength(65))
        }
    }

    func testPhase5SessionDataRejectsNon3BitBytes() {
        var bytes = Data(repeating: 0, count: Phase5SessionData.byteCount)
        bytes[17] = 0x08

        XCTAssertThrowsError(try Phase5SessionData(bytes)) { error in
            XCTAssertEqual(error as? Phase5SessionDataError, .non3BitByte(index: 17, value: 0x08))
        }
    }

    func testPhase5SessionDataDerivesRawKey() throws {
        let sessionData = try Phase5SessionData(Data(repeating: 0, count: Phase5SessionData.byteCount))
        XCTAssertEqual(try sessionData.phase5RawKey().hex, "4facb8db3692f2714ebaea5f9ff22de6")
    }

    func testRandomPhase5SessionDataIs66MaskedBytes() throws {
        let sessionData = try Phase5SessionData.random()

        XCTAssertEqual(sessionData.bytes.count, Phase5SessionData.byteCount)
        XCTAssertTrue(sessionData.bytes.allSatisfy { $0 <= 0x07 })
        XCTAssertEqual(try sessionData.phase5RawKey().count, 16)
    }
}

private extension Data {
    init(hexString: String) {
        var data = Data(capacity: hexString.count / 2)
        var idx = hexString.startIndex
        while idx < hexString.endIndex {
            let next = hexString.index(idx, offsetBy: 2)
            if let byte = UInt8(hexString[idx..<next], radix: 16) {
                data.append(byte)
            }
            idx = next
        }
        self = data
    }
}
