import Foundation

public struct HistoricalBackfillGap: Equatable, Sendable {
    public let afterLifeCount: UInt16
    public let beforeLifeCount: UInt16

    public init(afterLifeCount: UInt16, beforeLifeCount: UInt16) {
        self.afterLifeCount = afterLifeCount
        self.beforeLifeCount = beforeLifeCount
    }
}

public struct HistoricalBackfill: Equatable, Sendable {
    public private(set) var pages: [HistoricalReadingPage]

    public init(pages: [HistoricalReadingPage] = []) {
        self.pages = pages
    }

    public mutating func append(_ page: HistoricalReadingPage) {
        pages.append(page)
    }

    public var samples: [HistoricalReadingSample] {
        pages
            .flatMap(\.samples)
            .sorted { $0.lifeCount < $1.lifeCount }
    }

    public var firstLifeCount: UInt16? {
        samples.first?.lifeCount
    }

    public var lastLifeCount: UInt16? {
        samples.last?.lifeCount
    }

    public var gaps: [HistoricalBackfillGap] {
        let ordered = samples
        guard ordered.count > 1 else {
            return []
        }
        return zip(ordered, ordered.dropFirst()).compactMap { previous, next in
            next.lifeCount > previous.lifeCount + HistoricalReadingPage.sampleSpacingLifeCounts
                ? HistoricalBackfillGap(afterLifeCount: previous.lifeCount, beforeLifeCount: next.lifeCount)
                : nil
        }
    }

    public var isContiguous: Bool {
        gaps.isEmpty
    }
}

public enum BackfillStream: Equatable, Sendable {
    case historical
    case clinical

    var wireValue: UInt8 {
        switch self {
        case .historical:
            return 0x00
        case .clinical:
            return 0x01
        }
    }

    var label: String {
        switch self {
        case .historical:
            return "historic"
        case .clinical:
            return "clinical"
        }
    }
}
