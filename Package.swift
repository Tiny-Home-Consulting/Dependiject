// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "Dependiject",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v9),
        .tvOS(.v15),
        .visionOS(.v1)
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
    swiftLanguageModes: [
        .v6
    ]
)
