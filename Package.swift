// swift-tools-version:5.3

import Foundation
import PackageDescription

var sources = ["src/parser.c"]
if FileManager.default.fileExists(atPath: "src/scanner.c") {
    sources.append("src/scanner.c")
}

let package = Package(
    name: "TreeSitterTreeSitterVcl",
    products: [
        .library(name: "TreeSitterTreeSitterVcl", targets: ["TreeSitterTreeSitterVcl"]),
    ],
    dependencies: [
        .package(name: "SwiftTreeSitter", url: "https://github.com/tree-sitter/swift-tree-sitter", from: "0.9.0"),
    ],
    targets: [
        .target(
            name: "TreeSitterTreeSitterVcl",
            dependencies: [],
            path: ".",
            sources: sources,
            resources: [
                .copy("queries")
            ],
            publicHeadersPath: "bindings/swift",
            cSettings: [.headerSearchPath("src")]
        ),
        .testTarget(
            name: "TreeSitterTreeSitterVclTests",
            dependencies: [
                "SwiftTreeSitter",
                "TreeSitterTreeSitterVcl",
            ],
            path: "bindings/swift/TreeSitterTreeSitterVclTests"
        )
    ],
    cLanguageStandard: .c11
)
