// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "FlyoverKit",
    products: [
        .library(
            name: "FlyoverKit",
            targets: ["FlyoverKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FlyoverKit",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "FlyoverKitTests",
            dependencies: ["FlyoverKit"],
            path: "Tests"
        ),
    ]
)
