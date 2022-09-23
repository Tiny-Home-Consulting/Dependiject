// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Dependiject",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Dependiject",
            targets: ["Dependiject"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/tcldr/Entwine.git",
            .upToNextMajor(from: "0.9.1")
        )
    ],
    targets: [
        .target(
            name: "Dependiject",
            path: "Dependiject",
            linkerSettings: [
                .linkedFramework("SwiftUI"),
                .linkedFramework("Combine")
            ]
        ),
        .testTarget(
            name: "DependijectTests",
            dependencies: [
                .target(name: "Dependiject"),
                .product(name: "EntwineTest", package: "Entwine")
            ],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
