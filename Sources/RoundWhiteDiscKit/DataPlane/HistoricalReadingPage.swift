import Foundation

public struct HistoricalReadingSample: Equatable, Sendable {
    public let lifeCount: UInt16
    public let rawValue: UInt16

    public var glucoseMgDL: UInt16? {
        glucoseStatus.displayMgDL
    }

    public var glucoseStatus: Libre3GlucoseValueStatus {
        Libre3GlucoseValueStatus(rawSensorValue: rawValue)
    }
}

public struct HistoricalReadingPage: Equatable, Sendable {
    public static let plaintextSize = 14
    public static let sampleSpacingLifeCounts: UInt16 = 5

    public let startLifeCount: UInt16
    public let values: [UInt16]

    public init(plaintext: Data) throws {
        guard plaintext.count == Self.plaintextSize else {
            throw HistoricalReadingPageError.wrongPlaintextSize(plaintext.count)
        }
        let words = stride(from: 0, to: plaintext.count, by: 2).map { offset -> UInt16 in
            UInt16(plaintext[offset]) | (UInt16(plaintext[offset + 1]) << 8)
        }
        self.startLifeCount = words[0]
        self.values = Array(words.dropFirst())
    }

    public var samples: [HistoricalReadingSample] {
        values.enumerated().map { index, value in
            HistoricalReadingSample(
                lifeCount: startLifeCount + UInt16(index) * Self.sampleSpacingLifeCounts,
                rawValue: value
            )
        }
    }

    public var endLifeCount: UInt16 {
        startLifeCount + UInt16(values.count - 1) * Self.sampleSpacingLifeCounts
    }
}

public enum HistoricalReadingPageError: Error, Equatable {
    case wrongPlaintextSize(Int)
}
