# NotchKit

A starter kit for building macOS notch apps. Drop your own UI into the MacBook notch in minutes.

---

## What you get

- **NotchPanel** — A floating `NSPanel` configured for notch apps (non-activating, always on top, transparent, visible on all spaces)
- **NotchShape** — The curved shape that matches the MacBook notch aesthetic (animatable corner radii for smooth expand/collapse)
- **NotchWindow** — Detects the actual notch dimensions, handles hover-to-expand, collapse-on-leave, and clean teardown
- **NotchContentView** — Template with collapsed (both sides of camera) and expanded (full tray) states
- **Menu bar icon** — Basic setup with quit
- **Build script** — One command to build a `.app` bundle

## Quick start

```bash
git clone https://github.com/aishwaryaashok14/notch-kit.git
cd notch-kit
chmod +x build-app.sh
bash build-app.sh
open dist/NotchKit.app
```

You should see a notch bar with "NotchKit" on the left and "Ready" on the right. Hover to expand the tray.

## Make it yours

All the UI lives in `NotchKit/NotchContentView.swift`. Edit two sections:

**Collapsed view** — Content on both sides of the notch camera. This is always visible.

```swift
var collapsedContent: some View {
    HStack(spacing: 0) {
        // LEFT WING
        Text("My App").font(.system(size: 9, design: .monospaced))

        Color.clear.frame(width: viewModel.notchWidth - 30) // camera gap

        // RIGHT WING
        Text("Status").font(.system(size: 9, design: .monospaced))
    }
}
```

**Expanded view** — The full tray panel that appears on hover.

```swift
var expandedContent: some View {
    VStack {
        Text("Your app content here")
        Button("Do something") { /* ... */ }
    }
}
```

## Customization

In `NotchWindow.swift`, adjust these properties:

```swift
var expandedWidth: CGFloat = 420    // Width of expanded tray
var expandedHeight: CGFloat = 240   // Height of expanded tray
var wingExtension: CGFloat = 180    // How far wings extend beyond the notch
```

In `NotchShape.swift`, the corner radii:

```
Collapsed: topCornerRadius = 6,  bottomCornerRadius = 14
Expanded:  topCornerRadius = 19, bottomCornerRadius = 24
```

## Architecture

```
NotchKit/
  NotchApp.swift           App entry point
  NotchAppDelegate.swift   Menu bar + lifecycle
  NotchPanel.swift         NSPanel configuration
  NotchShape.swift         The curved notch shape (animatable)
  NotchWindow.swift        Notch detection, expand/collapse, hover
  NotchContentView.swift   YOUR UI GOES HERE
  Info.plist               LSUIElement (menu bar agent app)
```

## Requirements

- macOS 13+
- Swift 5.9+
- Works on MacBooks with and without a notch

## How it works

1. `NotchWindow` detects the notch via `NSScreen.auxiliaryTopLeftArea` / `auxiliaryTopRightArea`
2. A `NotchPanel` (floating `NSPanel`) is positioned at the exact notch location
3. `NotchTrackingView` handles mouse enter/exit for hover behavior
4. On hover: panel animates to expanded size, `NotchViewModel.isExpanded` updates the SwiftUI content
5. On mouse leave: 0.8s delay, then collapses back to notch size
6. On quit: `destroy()` ensures no ghost windows persist

## Built with NotchKit

- [WalkOS](https://walkos.aishashok.com) — A walking reminder that lives in your MacBook notch

## License

MIT
