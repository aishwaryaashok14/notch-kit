import SwiftUI

/// The main content view for the notch.
///
/// This view handles two states:
/// - **Collapsed**: Content on both sides of the notch camera (always visible)
/// - **Expanded**: Full tray panel that appears on hover
///
/// CUSTOMIZE THIS FILE to build your notch app.
/// Replace the placeholder content with your own UI.
struct NotchContentView: View {
    @ObservedObject var viewModel: NotchViewModel

    private var topRadius: CGFloat { viewModel.isExpanded ? 19 : 6 }
    private var bottomRadius: CGFloat { viewModel.isExpanded ? 24 : 14 }

    var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .top) {
                // Notch-shaped background (only when expanded)
                if viewModel.isExpanded {
                    NotchShape(topCornerRadius: topRadius, bottomCornerRadius: bottomRadius)
                        .fill(Color.black)
                        .shadow(color: Color.green.opacity(0.15), radius: 8, y: 4)
                        .padding(.horizontal, viewModel.shadowPadding)
                }

                // Content
                Group {
                    if viewModel.isExpanded {
                        expandedContent
                            .padding(.top, viewModel.notchHeight + 6)
                            .padding(.bottom, bottomRadius + 4)
                    } else {
                        collapsedContent
                    }
                }
                .padding(.horizontal, viewModel.isExpanded ? viewModel.shadowPadding + topRadius + 4 : 0)
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.isExpanded)
        }
    }

    // MARK: - Collapsed View
    // Content on both sides of the notch camera.
    // Left wing + camera gap + right wing.

    var collapsedContent: some View {
        HStack(spacing: 0) {
            // LEFT WING — your app name / icon
            HStack(spacing: 4) {
                Circle().fill(Color.green).frame(width: 6, height: 6)
                Text("NotchKit")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.5))
            }
            .frame(maxWidth: .infinity, alignment: .center)

            // CAMERA GAP — keep clear
            Color.clear.frame(width: viewModel.notchWidth - 30)

            // RIGHT WING — status / info
            HStack(spacing: 4) {
                Text("Ready")
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .foregroundColor(.green)
            }
            .fixedSize()
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .clipShape(NotchShape(topCornerRadius: 6, bottomCornerRadius: 14))
    }

    // MARK: - Expanded View
    // Full tray that appears on hover.
    // Replace this with your app's main UI.

    var expandedContent: some View {
        VStack(spacing: 12) {
            Text("Your Notch App")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.white)

            Text("This is the expanded tray. Replace this\nwith your own SwiftUI content.")
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                ExampleButton(title: "Action 1", color: .green)
                ExampleButton(title: "Action 2", color: .yellow)
            }

            Spacer()

            // Example toolbar
            HStack(spacing: 0) {
                ToolbarItem(label: "Tab 1", isActive: true)
                ToolbarDivider()
                ToolbarItem(label: "Tab 2", isActive: false)
                ToolbarDivider()
                ToolbarItem(label: "Settings", isActive: false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Example UI Components (replace with your own)

struct ExampleButton: View {
    let title: String
    let color: Color

    var body: some View {
        Button(action: {}) {
            Text(title)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(color)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.08))
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(color.opacity(0.15), lineWidth: 1))
                )
        }
        .buttonStyle(.plain)
    }
}

struct ToolbarItem: View {
    let label: String
    let isActive: Bool

    var body: some View {
        Text(label)
            .font(.system(size: 9, design: .monospaced))
            .foregroundColor(isActive ? .green : .white.opacity(0.35))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
    }
}

struct ToolbarDivider: View {
    var body: some View {
        Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 12)
    }
}
