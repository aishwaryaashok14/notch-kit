# NotchKit

An agent skill for building macOS notch apps. Give this to your AI coding agent (Claude, Cursor, Copilot) and build a notch app in minutes.

---

## What is this?

NotchKit is a ready-to-use starter kit that any AI coding agent can pick up and extend. It handles the hard parts of building a macOS notch app — panel configuration, notch detection, hover behavior, shape math — so you (or your agent) can focus on the actual app logic.

Think of it as a skill your agent already knows how to use.

## Use with your agent

Paste this into Claude Code, Cursor, or any AI coding assistant:

```
I want to build a macOS notch app. Use the NotchKit starter kit from
https://github.com/aishwaryaashok14/notch-kit as the foundation.

Clone it, then modify NotchContentView.swift to build [describe your app].
The collapsed view shows content on both sides of the notch camera.
The expanded view is the full tray that appears on hover.
```

Your agent will clone the repo, understand the architecture, and start building on top of it.

## What you get

| File | Purpose |
|------|---------|
| `NotchPanel.swift` | Floating `NSPanel` — non-activating, always on top, transparent, all spaces |
| `NotchShape.swift` | Curved shape matching the MacBook notch (animatable corner radii) |
| `NotchWindow.swift` | Notch detection, hover expand/collapse, clean teardown |
| `NotchContentView.swift` | Template: collapsed wings + expanded tray — **edit this file** |
| `NotchAppDelegate.swift` | Menu bar icon + app lifecycle |
| `build-app.sh` | One command to build a `.app` bundle |

## Quick start

```bash
git clone https://github.com/aishwaryaashok14/notch-kit.git
cd notch-kit
chmod +x build-app.sh
bash build-app.sh
open dist/NotchKit.app
```

You should see a notch bar with "NotchKit" on the left and "Ready" on the right. Hover to expand the tray.

## Build your own notch app

All your UI lives in `NotchKit/NotchContentView.swift`. Two sections to customize:

**Collapsed view** — always visible, on both sides of the camera:

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

**Expanded view** — the full tray on hover:

```swift
var expandedContent: some View {
    VStack {
        Text("Your app content here")
        Button("Do something") { /* ... */ }
    }
}
```

## Customization

In `NotchWindow.swift`:

```swift
var expandedWidth: CGFloat = 420    // Tray width
var expandedHeight: CGFloat = 240   // Tray height
var wingExtension: CGFloat = 180    // Wing width beyond the notch
```

In `NotchShape.swift` (corner radii):

```
Collapsed: top = 6,  bottom = 14
Expanded:  top = 19, bottom = 24
```

## Architecture

```
NotchKit/
  NotchApp.swift           App entry point
  NotchAppDelegate.swift   Menu bar + lifecycle
  NotchPanel.swift         NSPanel configuration
  NotchShape.swift         Curved notch shape (animatable)
  NotchWindow.swift        Notch detection + expand/collapse
  NotchContentView.swift   YOUR UI GOES HERE
  Info.plist               Agent app (no dock icon)
```

## Ideas to build with NotchKit

- Pomodoro timer in the notch
- Now playing music widget
- CPU / memory monitor
- Meeting countdown
- Weather at a glance
- Clipboard history
- Quick notes
- Habit tracker

## How it works under the hood

1. `NotchWindow` detects the notch via `NSScreen.auxiliaryTopLeftArea` and `auxiliaryTopRightArea`
2. A `NotchPanel` (floating `NSPanel` at `.mainMenu + 3` level) is positioned at the notch
3. `NotchTrackingView` handles mouse enter/exit for hover behavior
4. On hover: panel animates to expanded size via `NSAnimationContext`
5. `NotchViewModel.isExpanded` triggers the SwiftUI transition between collapsed and expanded
6. On mouse leave: 0.8s delay, then collapse
7. On quit: `destroy()` closes the panel and removes it — no ghost windows

## Requirements

- macOS 13+
- Swift 5.9+
- No Xcode project needed (Swift Package Manager)
- Works on MacBooks with and without a notch

## Built with NotchKit

- [WalkOS](https://walkos.aishashok.com) — A walking reminder that lives in your MacBook notch ($4.99)

## License

MIT — use it for anything.
