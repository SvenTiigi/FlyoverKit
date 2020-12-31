// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "FlyoverKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "FlyoverKit",
            targets: ["FlyoverKit"]
        ),
        .library(
            name: "FlyoverKitSwiftUI",
            targets: ["FlyoverKitSwiftUI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FlyoverKit",
            path: "Sources",
            exclude: ["SwiftUI"]
        ),
        .target(
            name: "FlyoverKitSwiftUI",
            dependencies: ["FlyoverKit"],
            path: "Sources",
            sources: ["SwiftUI"]
        ),
        .testTarget(
            name: "FlyoverKitTests",
            dependencies: ["FlyoverKit"],
            path: "Tests"
        ),
    ]
)
