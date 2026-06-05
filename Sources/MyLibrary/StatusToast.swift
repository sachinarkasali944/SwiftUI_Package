import SwiftUI

/// Defines the style and semantic intent of the toast notification.
public enum StatusToastStyle {
    case success
    case warning
    case error
    case info
    
    public var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    public var tintColor: Color {
        switch self {
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        case .info: return .blue
        }
    }
}

/// A premium floating toast notification view that pops up on top of screen content.
public struct StatusToast: View {
    let style: StatusToastStyle
    let message: String
    let subtitle: String?
    
    public init(style: StatusToastStyle, message: String, subtitle: String? = nil) {
        self.style = style
        self.message = message
        self.subtitle = subtitle
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: style.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(style.tintColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(message)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            style.tintColor.opacity(0.4),
                            .clear,
                            .clear,
                            style.tintColor.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.2
                )
        )
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)
        .frame(maxWidth: 450)
    }
}

/// A ViewModifier that displays a status toast at the top of the view hierarchy when a boolean binding is true.
public struct StatusToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let style: StatusToastStyle
    let message: String
    let subtitle: String?
    let duration: TimeInterval
    
    public init(
        isPresented: Binding<Bool>,
        style: StatusToastStyle,
        message: String,
        subtitle: String? = nil,
        duration: TimeInterval = 3.0
    ) {
        self._isPresented = isPresented
        self.style = style
        self.message = message
        self.subtitle = subtitle
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    StatusToast(style: style, message: message, subtitle: subtitle)
                        .padding(.top, 10)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity),
                                removal: .opacity.combined(with: .scale(scale: 0.9))
                            )
                        )
                        .zIndex(999)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}

public extension View {
    /// Present a beautiful floating status toast at the top of the screen based on a state binding.
    /// - Parameters:
    ///   - isPresented: Binding to a boolean controlling toast visibility.
    ///   - style: The status style (success, warning, error, info).
    ///   - message: The primary message.
    ///   - subtitle: Optional secondary sub-text.
    ///   - duration: Time duration before the toast auto-dismisses.
    func statusToast(
        isPresented: Binding<Bool>,
        style: StatusToastStyle,
        message: String,
        subtitle: String? = nil,
        duration: TimeInterval = 3.0
    ) -> some View {
        self.modifier(
            StatusToastModifier(
                isPresented: isPresented,
                style: style,
                message: message,
                subtitle: subtitle,
                duration: duration
            )
        )
    }
}

// SwiftUI Previews support
#if DEBUG
struct StatusToast_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var showToast = false
        
        var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    PremiumButton("Show Success Toast") {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            showToast = true
                        }
                    }
                }
            }
            .statusToast(
                isPresented: $showToast,
                style: .success,
                message: "Changes Saved",
                subtitle: "Your profile has been updated successfully."
            )
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
#endif
