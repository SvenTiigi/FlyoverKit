// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "FlyoverKit",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10)
    ],
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
