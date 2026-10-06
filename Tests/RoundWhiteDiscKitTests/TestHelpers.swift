import Foundation
import RoundWhiteDiscKit
import XCTest

extension Data {
    var hex: String {
        map { String(format: "%02x", $0) }.joined()
    }
}
