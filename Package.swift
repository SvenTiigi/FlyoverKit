// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "FlyoverKit",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "FlyoverKit",
            targets: [
                "FlyoverKit"
            ]
        )
    ],
    targets: [
        .target(
            name: "FlyoverKit",
            path: "Sources"
        ),
        .testTarget(
            name: "FlyoverKitTests",
            dependencies: [
                "FlyoverKit"
            ],
            path: "Tests"
        )
    ]
)
