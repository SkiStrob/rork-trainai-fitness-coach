import SwiftUI

struct TierBadgeView: View {
    let tierInfo: TierInfo
    var large: Bool = false

    @State private var shimmerPhase: CGFloat = -1

    var body: some View {
        Text(tierInfo.name)
            .font(large ? .title3.bold() : .subheadline.bold())
            .foregroundStyle(tierInfo.hasGlassEffect ? .white : .primary)
            .padding(.horizontal, large ? 24 : 16)
            .padding(.vertical, large ? 10 : 6)
            .background {
                if tierInfo.hasGlassEffect {
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.pink.opacity(0.15),
                                            Color.blue.opacity(0.15),
                                            Color.purple.opacity(0.1),
                                            Color.cyan.opacity(0.15)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.clear, .white.opacity(0.3), .clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .offset(x: shimmerPhase * 100)
                                .mask(Capsule())
                        )
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.4),
                                            .clear,
                                            .white.opacity(0.2),
                                            .clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: tierInfo.color.opacity(0.3), radius: 12)
                } else {
                    Capsule()
                        .fill(tierInfo.color.opacity(0.15))
                        .overlay(
                            Capsule()
                                .stroke(tierInfo.color.opacity(0.25), lineWidth: 1)
                        )
                }
            }
            .onAppear {
                if tierInfo.hasGlassEffect {
                    withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: false).delay(1)) {
                        shimmerPhase = 1
                    }
                }
            }
    }
}
