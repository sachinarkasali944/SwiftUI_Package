import SwiftUI

/// A customizable, modern button featuring vibrant gradient fills, glowing shadows,
/// subtle micro-animations on press, and iOS-native haptic feedback.
public struct PremiumButton<Content: View>: View {
    private let action: () -> Void
    private let content: Content
    private let gradientColors: [Color]
    private let textColor: Color
    private let cornerRadius: CGFloat
    private let showGlow: Bool
    
    public init(
        action: @escaping () -> Void,
        gradientColors: [Color] = [Color.blue, Color.purple],
        textColor: Color = .white,
        cornerRadius: CGFloat = 12,
        showGlow: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.action = action
        self.gradientColors = gradientColors
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.showGlow = showGlow
        self.content = content()
    }
    
    /// Convenience initializer for simple title-based buttons
    public init(
        _ title: String,
        action: @escaping () -> Void,
        gradientColors: [Color] = [Color.blue, Color.purple],
        textColor: Color = .white,
        cornerRadius: CGFloat = 12,
        showGlow: Bool = true
    ) where Content == Text {
        self.init(
            action: action,
            gradientColors: gradientColors,
            textColor: textColor,
            cornerRadius: cornerRadius,
            showGlow: showGlow
        ) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
    
    public var body: some View {
        Button(action: {
            #if os(iOS)
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
            #endif
            action()
        }) {
            content
                .foregroundColor(textColor)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .frame(minWidth: 44, minHeight: 44) // Accessible touch target size
        }
        .buttonStyle(PremiumButtonStyle(
            gradientColors: gradientColors,
            cornerRadius: cornerRadius,
            showGlow: showGlow
        ))
    }
}

/// A button style that handles the background gradient, outer borders, custom glowing shadows,
/// and smooth spring-based scaling animations on hover or click.
public struct PremiumButtonStyle: ButtonStyle {
    let gradientColors: [Color]
    let cornerRadius: CGFloat
    let showGlow: Bool
    
    public init(
        gradientColors: [Color] = [Color.blue, Color.purple],
        cornerRadius: CGFloat = 12,
        showGlow: Bool = true
    ) {
        self.gradientColors = gradientColors
        self.cornerRadius = cornerRadius
        self.showGlow = showGlow
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.4), .clear, .black.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(
                color: (showGlow ? (gradientColors.first ?? .blue) : .clear).opacity(configuration.isPressed ? 0.3 : 0.6),
                radius: configuration.isPressed ? 8 : 16,
                x: 0,
                y: configuration.isPressed ? 4 : 8
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.6, blendDuration: 0), value: configuration.isPressed)
    }
}

// SwiftUI Previews support
#if DEBUG
struct PremiumButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            PremiumButton("Get Started") {
                print("Button tapped")
            }
            
            PremiumButton(action: {
                print("Custom button tapped")
            }, gradientColors: [.orange, .red], cornerRadius: 25) {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Unlock Premium")
                        .fontWeight(.bold)
                }
            }
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
#endif
