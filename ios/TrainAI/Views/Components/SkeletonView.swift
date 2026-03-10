import SwiftUI

struct SkeletonView: View {
    var height: CGFloat = 20
    var cornerRadius: CGFloat = 8

    @State private var phase: CGFloat = -200

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(.systemGray5))
            .frame(height: height)
            .overlay(
                LinearGradient(
                    colors: [.clear, Color(.systemGray4), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(RoundedRectangle(cornerRadius: cornerRadius))
            )
            .clipShape(.rect(cornerRadius: cornerRadius))
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 400
                }
            }
    }
}

struct SkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkeletonView(height: 16, cornerRadius: 4)
                .frame(width: 120)
            SkeletonView(height: 12, cornerRadius: 4)
            SkeletonView(height: 12, cornerRadius: 4)
                .frame(width: 180)
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 16))
    }
}
