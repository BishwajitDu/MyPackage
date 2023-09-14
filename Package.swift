// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DigiIDSwiftPackage",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DigiIDSwiftPackage",
            targets: ["DigiIDSwiftPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/getyoti/ios-sdk-button.git", from: "4.0.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DigiIDSwiftPackage",
            dependencies: [.product(name: "YotiButtonSDK",package: "ios-sdk-button")],
            path: "DigiIDSwiftPackage"),
        .testTarget(
            name: "DigiIDSwiftPackageTests",
            dependencies: ["DigiIDSwiftPackage"]),
    ]
)
