import SwiftUI

struct CardStyle: ViewModifier {
    @Environment(\.appColors) private var colors

    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(colors.cardBackground)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }
}

struct GlassCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 20))
    }
}

struct PressableCard: ViewModifier {
    @State private var isPressed: Bool = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }

    func glassCardStyle() -> some View {
        modifier(GlassCardStyle())
    }

    func pressable() -> some View {
        modifier(PressableCard())
    }
}
