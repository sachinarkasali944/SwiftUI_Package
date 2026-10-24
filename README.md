# SwiftUI Components · MyLibrary

> Reusable glass cards, buttons, shimmer placeholders, and status toasts in a Swift package.

A small library of SwiftUI components for experimenting with reusable presentation code. The package product and importable module are named **MyLibrary**.

## Components

- **GlassCard:** a configurable container using material and decorative borders.
- **PremiumButton:** reusable button presentation and styling.
- **ShimmerPlaceholder / shimmering():** loading placeholders and shimmer effects.
- **StatusToast:** success, warning, error, and information messages.

## Add to an app

1. In Xcode, choose **File → Add Package Dependencies**.
2. Enter `https://github.com/sachinarkasali944/SwiftUI_Package.git`.
3. Select the `main` branch and add the **MyLibrary** product to your target. No versioned release is required for branch-based integration.
4. Import the module where needed:

```swift
import SwiftUI
import MyLibrary

struct ExampleView: View {
    var body: some View {
        StatusToast(style: .success, message: "Changes saved")
    }
}
```

## Package requirements

The committed manifest declares **Swift tools 6.3**, Swift 6 language mode, and platforms iOS 15, macOS 12, tvOS 15, and watchOS 8. Use a compatible Apple-platform toolchain. Declared platforms describe the manifest; component availability across every platform has not been verified in this documentation update.

## Source and tests

- [Package.swift](./Package.swift)
- [Components](./Sources/MyLibrary)
- [Test sources](./Tests/MyLibraryTests)

Open `Package.swift` in Xcode to inspect the package. Run tests on a supported Apple platform through Xcode; UIKit/SwiftUI packages are not Linux command-line apps.
