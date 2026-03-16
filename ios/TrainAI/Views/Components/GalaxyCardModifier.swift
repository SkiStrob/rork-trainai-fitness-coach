import SwiftUI

struct GalaxyCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 24

    func body(content: Content) -> some View {
        content
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.95, green: 0.93, blue: 0.97),
                                Color(red: 0.96, green: 0.94, blue: 0.96),
                                Color(red: 0.93, green: 0.95, blue: 0.98),
                                Color(red: 0.96, green: 0.93, blue: 0.95)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RadialGradient(
                            colors: [.white.opacity(0.4), .clear, Color.purple.opacity(0.03), .clear],
                            center: .topTrailing,
                            startRadius: 0,
                            endRadius: 300
                        )
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.white.opacity(0.6), lineWidth: 1)
                    )
                    .shadow(color: Color.purple.opacity(0.06), radius: 20, y: 8)
            )
    }
}

extension View {
    func galaxyCard(cornerRadius: CGFloat = 24) -> some View {
        modifier(GalaxyCardModifier(cornerRadius: cornerRadius))
    }
}
