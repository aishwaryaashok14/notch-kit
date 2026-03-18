import AppKit

/// A floating, non-activating panel that sits above all windows.
/// This is the foundation for any notch-hugging UI.
///
/// Key properties:
/// - Always on top (level: .mainMenu + 3)
/// - Doesn't steal focus from the active app
/// - Transparent background (content defines the shape)
/// - Visible on all spaces and in fullscreen
/// - Clean teardown (no ghost windows)
class NotchPanel: NSPanel {
    override init(
        contentRect: NSRect,
        styleMask: NSWindow.StyleMask,
        backing: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        super.init(contentRect: contentRect, styleMask: styleMask, backing: backing, defer: flag)

        isFloatingPanel = true
        isOpaque = false
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        backgroundColor = .clear
        isMovable = false
        hasShadow = false

        collectionBehavior = [
            .fullScreenAuxiliary,
            .stationary,
            .canJoinAllSpaces,
            .ignoresCycle,
        ]

        isReleasedWhenClosed = false
        level = .mainMenu + 3
    }

    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}
