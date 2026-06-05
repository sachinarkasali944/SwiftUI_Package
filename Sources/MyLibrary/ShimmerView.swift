import SwiftUI

/// A view modifier that applies a smooth, premium skeleton shimmering loading animation to any SwiftUI view.
public struct ShimmerModifier: ViewModifier {
    @State private var offset: CGFloat = -1.5
    
    public let colors: [Color]
    public let speed: Double
    public let isActive: Bool
    
    public init(
        colors: [Color] = [
            Color.gray.opacity(0.15),
            Color.gray.opacity(0.35),
            Color.gray.opacity(0.15)
        ],
        speed: Double = 1.5,
        isActive: Bool = true
    ) {
        self.colors = colors
        self.speed = speed
        self.isActive = isActive
    }
    
    public func body(content: Content) -> some View {
        if isActive {
            content
                .overlay(
                    GeometryReader { geo in
                        let width = geo.size.width
                        let height = geo.size.height
                        
                        LinearGradient(
                            colors: colors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .rotationEffect(.degrees(20))
                        .scaleEffect(1.5)
                        .offset(x: offset * (width + height))
                        .onAppear {
                            withAnimation(
                                .linear(duration: speed)
                                .repeatForever(autoreverses: false)
                            ) {
                                offset = 1.5
                            }
                        }
                    }
                )
                .mask(content)
        } else {
            content
        }
    }
}

public extension View {
    /// Applies a continuous glistening/shimmering animation to the view, typically used to represent loading skeletons.
    /// - Parameters:
    ///   - isActive: Toggle whether the shimmer animation is active.
    ///   - colors: The color stops of the shimmering gradient.
    ///   - speed: The duration of one complete cycle of the shimmer animation in seconds.
    func shimmering(
        isActive: Bool = true,
        colors: [Color] = [
            Color.gray.opacity(0.15),
            Color.gray.opacity(0.35),
            Color.gray.opacity(0.15)
        ],
        speed: Double = 1.5
    ) -> some View {
        self.modifier(ShimmerModifier(colors: colors, speed: speed, isActive: isActive))
    }
}

/// A standard skeleton cell component that can be used directly to construct placeholder layouts.
public struct ShimmerPlaceholder: View {
    private let height: CGFloat
    private let width: CGFloat?
    private let cornerRadius: CGFloat
    
    public init(width: CGFloat? = nil, height: CGFloat = 20, cornerRadius: CGFloat = 8) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.15))
            .frame(width: width, height: height)
            .shimmering()
    }
}

// SwiftUI Previews support
#if DEBUG
struct ShimmerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Text shimmer
            Text("Loading beautiful UI...")
                .font(.title3)
                .fontWeight(.bold)
                .redacted(reason: .placeholder)
                .shimmering()
            
            // Custom skeletons
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .shimmering()
                
                VStack(alignment: .leading, spacing: 8) {
                    ShimmerPlaceholder(width: 150, height: 16)
                    ShimmerPlaceholder(width: 250, height: 12)
                }
            }
            
            // Shimmer on a card mockup
            GlassCard(cornerRadius: 15) {
                VStack(alignment: .leading, spacing: 12) {
                    ShimmerPlaceholder(width: 80, height: 14, cornerRadius: 4)
                    ShimmerPlaceholder(height: 100, cornerRadius: 10)
                }
            }
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
#endif
