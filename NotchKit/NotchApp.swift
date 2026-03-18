import SwiftUI

/// Entry point for a NotchKit app.
/// Replace the content in NotchContentProvider with your own UI.
@main
struct NotchKitApp: App {
    @NSApplicationDelegateAdaptor(NotchAppDelegate.self) var appDelegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}
