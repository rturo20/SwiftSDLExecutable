// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MySDLProject",
    products: [
        .executable(name: "MySDLProject", targets: ["MySDLProject"]),
    ],
    dependencies: [
        .package(url: "https://github.com/rturo20/SwiftSDL.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "MySDLProject",
            dependencies: ["SwiftSDL"]
        )
    ]
)
