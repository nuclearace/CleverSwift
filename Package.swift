import PackageDescription

let package = Package(
    name: "Cleverbot",
    targets: [
        Target(name: "Runner", dependencies: ["Cleverbot"]),
        Target(name: "Cleverbot")
    ],
    dependencies: [
        .Package(url: "https://github.com/krzyzanowskim/CryptoSwift", majorVersion: 0, minor: 6),
        .Package(url: "https://github.com/IBM-Swift/swift-html-entities.git", majorVersion: 3, minor: 0)
    ],
    exclude: ["Runner"]
)
