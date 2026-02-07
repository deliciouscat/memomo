// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Memomo",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Memomo", targets: ["Memomo"])
    ],
    dependencies: [
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "Memomo",
            dependencies: [
                .product(name: "MarkdownUI", package: "swift-markdown-ui")
            ],
            path: "Memomo"
        )
    ]
)
