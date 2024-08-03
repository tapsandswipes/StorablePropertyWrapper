// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "StorablePropertyWrapper",
    products: [
        .library(
            name: "StorablePropertyWrapper",
            targets: ["StorablePropertyWrapper"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "StorablePropertyWrapper"),
        .testTarget(
            name: "StorablePropertyWrapperTests",
            dependencies: ["StorablePropertyWrapper"]),
    ]
)
