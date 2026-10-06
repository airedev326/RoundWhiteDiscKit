// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "RoundWhiteDiscKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "RoundWhiteDiscKit", targets: ["RoundWhiteDiscKit"]),
    ],
    targets: [
        .target(
            name: "RoundWhiteDiscKit",
            path: "Sources/RoundWhiteDiscKit",
            resources: [
                .process("Resources/Localizations"),
            ]
        ),
        .testTarget(
            name: "RoundWhiteDiscKitTests",
            dependencies: ["RoundWhiteDiscKit"],
            path: "Tests/RoundWhiteDiscKitTests"
        ),
    ]
)
