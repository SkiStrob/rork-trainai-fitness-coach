import SwiftUI

struct TierBadgeView: View {
    let tierInfo: TierInfo
    var large: Bool = false

    @State private var shimmerPhase: CGFloat = -1

    var body: some View {
        Text(tierInfo.name)
            .font(large ? .title3.bold() : .subheadline.bold())
            .foregroundStyle(tierInfo.hasGlassEffect ? .white : tierInfo.color)
            .padding(.horizontal, large ? 24 : 16)
            .padding(.vertical, large ? 10 : 6)
            .background {
                if tierInfo.hasGlassEffect {
                    Capsule()
                        .fill(tierInfo.color.opacity(0.2))
                        .overlay(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.clear, .white.opacity(0.25), .clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .offset(x: shimmerPhase * 100)
                                .mask(Capsule())
                        )
                        .overlay(
                            Capsule()
                                .stroke(tierInfo.color.opacity(0.4), lineWidth: 1)
                        )
                } else {
                    Capsule()
                        .fill(tierInfo.color.opacity(0.12))
                        .overlay(
                            Capsule()
                                .stroke(tierInfo.color.opacity(0.2), lineWidth: 1)
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
