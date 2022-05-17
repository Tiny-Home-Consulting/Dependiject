// swift-tools-version:5.4
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
                .target(name: "Dependiject")
            ],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
