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
        .package(name: "RSDKUtils" ,url: "https://github.com/rakutentech/ios-sdkutils.git", .upToNextMajor(from: "4.0.0")),
    ],
    targets: [
        .target(
            name: "Howmuch",
            dependencies: [
                .product(name: "RSDKUtilsMain", package: "RSDKUtils")
            ]
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
