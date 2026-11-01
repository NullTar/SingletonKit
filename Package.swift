// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "Singleton",
    platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v10), .macCatalyst(.v15)],
    products: [
        .library(
            name: "Singleton",
            targets: ["Singleton"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "604.0.0"),
    ],
    targets: [
        .macro(
            name: "SingletonMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        .target(
            name: "Singleton",
            dependencies: ["SingletonMacros"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),

//        .executableTarget(
//            name: "SingletonClient",
//            dependencies: ["Singleton"],
//            swiftSettings: [
//                .enableUpcomingFeature("ApproachableConcurrency"),
//            ]
//        ),
    ]
)
