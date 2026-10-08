// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "EAIntroView",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "EAIntroView", targets: ["EAIntroView"]),
    ],
    targets: [
        // Vendored ObjC EARestrictedScrollView 1.1.0 (MIT). Upstream 2.x is a Swift rewrite without @objc API.
        .target(
            name: "EARestrictedScrollView",
            path: "Vendor/EARestrictedScrollView",
            exclude: ["LICENSE"],
            publicHeadersPath: "include"
        ),
        // Uses the original CocoaPods/Carthage layout as-is.
        .target(
            name: "EAIntroView",
            dependencies: ["EARestrictedScrollView"],
            path: "EAIntroView",
            publicHeadersPath: "."
        ),
    ]
)
