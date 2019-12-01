// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Cleverbot",
    products: [
        .library(name: "Cleverbot", targets: ["Cleverbot"])
    ],
    targets: [
        .target(name: "Cleverbot")
    ]
)
