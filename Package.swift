// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "HSM",
    platforms: [
        .macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)
    ],
    products: [
        .library(
            name: "HSM",
            targets: ["HSM"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HSM",
            dependencies: []
//            , swiftSettings: [.define("DebugVerbosityLevel2")]
        ),
        .testTarget(
            name: "HSMTests",
            dependencies: ["HSM"]),
    ]
)
