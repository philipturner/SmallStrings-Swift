// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmallStrings",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "SmallStrings",
                 targets: ["SmallStrings"]),
        .executable(name: "compress",
                    targets: ["Compress"])
    ],
    targets: [
        .target(name: "SmallStrings"),
        .target(name: "Compress")
    ]
)
