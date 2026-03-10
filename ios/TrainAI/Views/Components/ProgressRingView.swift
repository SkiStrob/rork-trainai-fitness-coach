import SwiftUI

struct ProgressRingView: View {
    @Environment(\.appColors) private var colors
    let progress: Double
    let gradient: [Color]
    let lineWidth: CGFloat
    let label: String
    let valueText: String

    @State private var animatedProgress: Double = 0

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .stroke(colors.progressTrack, lineWidth: lineWidth)

                Circle()
                    .trim(from: 0, to: min(animatedProgress, 1.0))
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: gradient),
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                Text(valueText)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(colors.primaryText)
                    .contentTransition(.numericText())
            }
            .frame(width: 80, height: 80)

            Text(label)
                .font(.caption2)
                .foregroundStyle(colors.secondaryText)
        }
        .onAppear {
            animatedProgress = 0
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8).delay(0.2)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}
