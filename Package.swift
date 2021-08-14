// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StorablePropertyWrapper",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "StorablePropertyWrapper",
            targets: ["StorablePropertyWrapper"]),
    ],
    dependencies: [
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "StorablePropertyWrapper"),
        .testTarget(
            name: "StorablePropertyWrapperTests",
            dependencies: ["StorablePropertyWrapper"]),
    ]
)
