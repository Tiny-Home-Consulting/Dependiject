// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "swiftdi",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(name: "swiftdi", targets: ["swiftdi"])
    ],
    targets: [
        .target(name: "swiftdi", path: "swiftdi")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
