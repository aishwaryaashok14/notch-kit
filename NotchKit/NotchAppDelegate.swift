import SwiftUI

/// App delegate that sets up the notch window and menu bar icon.
/// Customize this to add your own menu items and app logic.
class NotchAppDelegate: NSObject, NSApplicationDelegate {
    var notchWindow: NotchWindow?
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        notchWindow = NotchWindow()
    }

    // MARK: - Menu Bar

    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        guard let button = statusItem?.button else { return }
        button.image = NSImage(systemSymbolName: "sparkles", accessibilityDescription: "NotchKit")
        button.image?.size = NSSize(width: 14, height: 14)
        button.image?.isTemplate = true

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "NotchKit", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        let quit = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)
        statusItem?.menu = menu
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    // MARK: - Clean Quit

    func applicationWillTerminate(_ notification: Notification) {
        notchWindow?.destroy()
        notchWindow = nil
        if let item = statusItem {
            NSStatusBar.system.removeStatusItem(item)
            statusItem = nil
        }
    }
}
