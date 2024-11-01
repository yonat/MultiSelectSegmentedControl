// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "MultiSelectSegmentedControl",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "MultiSelectSegmentedControl", targets: ["MultiSelectSegmentedControl"]),
    ],
    dependencies: [
        .package(url: "https://github.com/yonat/SweeterSwift", from: "1.0.4"),
    ],
    targets: [
        .target(name: "MultiSelectSegmentedControl", dependencies: ["SweeterSwift"], path: "Sources", resources: [.process("PrivacyInfo.xcprivacy")]),
    ],
    swiftLanguageVersions: [.v5]
)
