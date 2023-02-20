// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "CSVCodable",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "CSVCodable",
            targets: ["CSVCodable"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CSVCodable",
            dependencies: [],
            path: "Sources/CSVCodable")
    ]
)
