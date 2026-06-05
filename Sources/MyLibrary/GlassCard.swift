import SwiftUI

/// A container view that provides a modern, premium glassmorphism effect (frosted glass)
/// with subtle gradient borders and soft drop shadows.
public struct GlassCard<Content: View>: View {
    private let content: Content
    private let cornerRadius: CGFloat
    private let blurMaterial: Material
    private let borderColor: Color
    private let shadowColor: Color
    
    public init(
        cornerRadius: CGFloat = 20,
        blurMaterial: Material = .ultraThinMaterial,
        borderColor: Color = .white.opacity(0.25),
        shadowColor: Color = .black.opacity(0.15),
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.blurMaterial = blurMaterial
        self.borderColor = borderColor
        self.shadowColor = shadowColor
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(blurMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                borderColor,
                                borderColor.opacity(0.1),
                                borderColor.opacity(0.05),
                                borderColor.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.2
                    )
            )
            .shadow(
                color: shadowColor,
                radius: 12,
                x: 0,
                y: 8
            )
    }
}

// SwiftUI Previews support
#if DEBUG
struct GlassCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Background with rich colorful patterns to showcase the blur material effect
            LinearGradient(
                colors: [.purple, .indigo, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Glassmorphism")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("This is a beautiful glassmorphic card component built with native material blurs.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        HStack {
                            Spacer()
                            PremiumButton("Tap Me") {
                                print("Glass card button tapped")
                            }
                        }
                        .padding(.top, 5)
                    }
                }
                .padding()
            }
        }
    }
}
#endif
