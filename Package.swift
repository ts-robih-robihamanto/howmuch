// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Howmuch",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Howmuch",
            targets: ["Howmuch"]),
    ],
    dependencies: [
        .package(url: "https://github.com/rakutentech/ios-sdkutils.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .target(
            name: "Howmuch",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
