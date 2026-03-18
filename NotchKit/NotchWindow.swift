import SwiftUI
import AppKit

/// Handles mouse tracking for hover-to-expand behavior.
class NotchTrackingView: NSView {
    var onMouseEntered: (() -> Void)?
    var onMouseExited: (() -> Void)?

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach { removeTrackingArea($0) }
        addTrackingArea(NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
            owner: self
        ))
    }

    override func mouseEntered(with event: NSEvent) { onMouseEntered?() }
    override func mouseExited(with event: NSEvent) { onMouseExited?() }
}

/// The main notch window controller.
///
/// Creates a panel that:
/// - Detects the actual notch dimensions on the current screen
/// - Shows collapsed content (wings on either side of the camera) at rest
/// - Expands into a full tray panel on hover
/// - Collapses back when the mouse leaves
///
/// Customize by modifying `NotchContentView`.
class NotchWindow: NSObject {
    private var panel: NotchPanel!
    private(set) var isExpanded = false
    var viewModel: NotchViewModel!

    // Detected from the actual screen
    private(set) var notchWidth: CGFloat = 185
    private(set) var notchHeight: CGFloat = 32
    private let shadowPadding: CGFloat = 20

    // Customize these for your expanded panel size
    var expandedWidth: CGFloat = 420
    var expandedHeight: CGFloat = 240

    // How wide the collapsed wings extend beyond the notch
    var wingExtension: CGFloat = 180

    override init() {
        super.init()

        guard let screen = NSScreen.main else { return }
        detectNotch(screen: screen)

        let closedWidth = notchWidth + wingExtension
        let screenFrame = screen.frame
        let initialFrame = NSRect(
            x: screenFrame.midX - closedWidth / 2,
            y: screenFrame.maxY - notchHeight,
            width: closedWidth,
            height: notchHeight
        )

        panel = NotchPanel(
            contentRect: initialFrame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        let trackingView = NotchTrackingView(frame: NSRect(origin: .zero, size: initialFrame.size))
        trackingView.autoresizingMask = [.width, .height]
        trackingView.onMouseEntered = { [weak self] in self?.expand() }
        trackingView.onMouseExited = { [weak self] in self?.scheduleCollapse() }

        viewModel = NotchViewModel(
            notchWidth: notchWidth,
            notchHeight: notchHeight,
            shadowPadding: shadowPadding
        )

        let contentView = NotchContentView(viewModel: viewModel)
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.frame = trackingView.bounds
        hostingView.autoresizingMask = [.width, .height]

        trackingView.addSubview(hostingView)
        panel.contentView = trackingView
        panel.orderFrontRegardless()
    }

    // MARK: - Notch Detection

    private func detectNotch(screen: NSScreen) {
        if let topLeft = screen.auxiliaryTopLeftArea,
           let topRight = screen.auxiliaryTopRightArea {
            notchWidth = screen.frame.width - topLeft.width - topRight.width + 4
        }
        if screen.safeAreaInsets.top > 0 {
            notchHeight = screen.safeAreaInsets.top
        } else {
            notchHeight = 32  // Fallback for non-notch Macs
        }
    }

    // MARK: - Expand / Collapse

    private func scheduleCollapse() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            let padded = self.panel.frame.insetBy(dx: -15, dy: -15)
            if !padded.contains(NSEvent.mouseLocation) { self.collapse() }
        }
    }

    func expand() {
        guard !isExpanded else { return }
        isExpanded = true
        let screen = NSScreen.main!
        let sf = screen.frame
        let w = expandedWidth + shadowPadding * 2
        let h = expandedHeight + shadowPadding
        let newFrame = NSRect(x: sf.midX - w / 2, y: sf.maxY - h, width: w, height: h)
        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.4
            ctx.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            panel.animator().setFrame(newFrame, display: true)
        }
        DispatchQueue.main.async { self.viewModel.isExpanded = true }
    }

    func collapse() {
        guard isExpanded else { return }
        isExpanded = false
        DispatchQueue.main.async { self.viewModel.isExpanded = false }
        let screen = NSScreen.main!
        let sf = screen.frame
        let closedW = notchWidth + wingExtension
        let newFrame = NSRect(x: sf.midX - closedW / 2, y: sf.maxY - notchHeight, width: closedW, height: notchHeight)
        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.35
            ctx.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            panel.animator().setFrame(newFrame, display: true)
        }
    }

    // MARK: - Show / Hide / Destroy

    func hide() { panel.orderOut(nil) }
    func show() { panel.orderFrontRegardless() }
    var isVisible: Bool { panel.isVisible }

    func destroy() {
        panel.orderOut(nil)
        panel.contentView = nil
        panel.close()
    }
}

/// Observable state shared between NotchWindow and SwiftUI views.
class NotchViewModel: ObservableObject {
    @Published var isExpanded: Bool = false
    let notchWidth: CGFloat
    let notchHeight: CGFloat
    let shadowPadding: CGFloat

    init(notchWidth: CGFloat = 185, notchHeight: CGFloat = 32, shadowPadding: CGFloat = 20) {
        self.notchWidth = notchWidth
        self.notchHeight = notchHeight
        self.shadowPadding = shadowPadding
    }
}
