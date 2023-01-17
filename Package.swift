// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Howmuch",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Howmuch",
            targets: ["Howmuch"]),
    ],
    dependencies: [
        .package(url: "https://github.com/rakutentech/ios-sdkutils.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.1.0")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "6.1.0")),
    ],
    targets: [
        .target(
            name: "Howmuch",
            dependencies: [
                .product(name: "RSDKUtilsMain", package: "ios-sdkutils")
            ]
        ),
        .testTarget(
            name: "Tests",
            dependencies: [
                "Howmuch",
                "Nimble",
                "Quick",
            ]
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
