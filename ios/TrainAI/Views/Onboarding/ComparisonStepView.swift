import SwiftUI

struct ComparisonStepView: View {
    let viewModel: OnboardingViewModel
    @State private var chartProgress: Double = 0
    @State private var showLabels: Bool = false
    @State private var showContent: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("TrainAI creates\nlong-term results")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)

            Spacer()

            VStack(spacing: 0) {
                // Chart card
                VStack(spacing: 16) {
                    Text("Your progress")
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ZStack {
                        // Grid lines
                        VStack(spacing: 0) {
                            ForEach(0..<5, id: \.self) { i in
                                if i > 0 {
                                    Rectangle()
                                        .fill(Color(.systemGray5))
                                        .frame(height: 0.5)
                                }
                                Spacer()
                            }
                        }
                        .frame(height: 160)

                        // Y-axis labels
                        HStack {
                            VStack(alignment: .trailing) {
                                Text("Goal")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("75%")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("50%")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("Start")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 30, height: 160)

                            Spacer()
                        }

                        // Curves
                        HStack {
                            Spacer().frame(width: 36)

                            GeometryReader { geo in
                                let width = geo.size.width
                                let height: CGFloat = 160

                                ZStack {
                                    // Traditional diet curve (red) - goes up then back down
                                    TraditionalCurvePath(width: width, height: height)
                                        .trim(from: 0, to: chartProgress)
                                        .stroke(
                                            Color.red.opacity(0.6),
                                            style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                                        )

                                    // Traditional fill
                                    TraditionalCurveAreaPath(width: width, height: height)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.red.opacity(0.08), Color.red.opacity(0.01)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .opacity(chartProgress)

                                    // TrainAI curve (black/dark) - steady progress down
                                    TrainAICurvePath(width: width, height: height)
                                        .trim(from: 0, to: chartProgress)
                                        .stroke(
                                            Color.primary,
                                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                                        )

                                    // TrainAI fill
                                    TrainAICurveAreaPath(width: width, height: height)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.primary.opacity(0.06), Color.primary.opacity(0.01)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .opacity(chartProgress)

                                    // Start dot
                                    if showLabels {
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 2)
                                            .fill(Color(.systemBackground))
                                            .frame(width: 10, height: 10)
                                            .position(x: 0, y: height * 0.85)

                                        // End dot for TrainAI
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 2)
                                            .fill(Color(.systemBackground))
                                            .frame(width: 10, height: 10)
                                            .position(x: width, y: height * 0.12)
                                    }
                                }
                                .frame(height: height)
                            }
                            .frame(height: 160)
                        }
                    }
                    .frame(height: 160)

                    // X-axis
                    HStack {
                        Spacer().frame(width: 36)
                        Text("Month 1")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("Month 3")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("Month 6")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }

                    // Legend
                    HStack(spacing: 24) {
                        HStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.primary)
                                .frame(width: 16, height: 3)
                            Text("TrainAI")
                                .font(.caption.bold())
                                .foregroundStyle(.primary)
                        }

                        HStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.red.opacity(0.6))
                                .frame(width: 16, height: 3)
                            Text("On your own")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal, 16)
            }

            Spacer().frame(height: 24)

            Text("80% of TrainAI users maintain their\nprogress even 6 months later")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .opacity(showLabels ? 1 : 0)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).delay(0.3)) {
                chartProgress = 1.0
            }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85).delay(1.0)) {
                showLabels = true
            }
        }
    }
}

// TrainAI progress curve - steady improvement
struct TrainAICurvePath: Shape {
    let width: CGFloat
    let height: CGFloat

    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let startY = height * 0.85
        let endY = height * 0.12

        path.move(to: CGPoint(x: 0, y: startY))
        path.addCurve(
            to: CGPoint(x: width, y: endY),
            control1: CGPoint(x: width * 0.3, y: startY - height * 0.25),
            control2: CGPoint(x: width * 0.6, y: endY + height * 0.15)
        )
        return path
    }
}

struct TrainAICurveAreaPath: Shape {
    let width: CGFloat
    let height: CGFloat

    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let startY = height * 0.85
        let endY = height * 0.12

        path.move(to: CGPoint(x: 0, y: startY))
        path.addCurve(
            to: CGPoint(x: width, y: endY),
            control1: CGPoint(x: width * 0.3, y: startY - height * 0.25),
            control2: CGPoint(x: width * 0.6, y: endY + height * 0.15)
        )
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        return path
    }
}

// Traditional curve - initial progress then regression
struct TraditionalCurvePath: Shape {
    let width: CGFloat
    let height: CGFloat

    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let startY = height * 0.85

        path.move(to: CGPoint(x: 0, y: startY))
        path.addCurve(
            to: CGPoint(x: width * 0.4, y: height * 0.45),
            control1: CGPoint(x: width * 0.15, y: startY - height * 0.15),
            control2: CGPoint(x: width * 0.3, y: height * 0.45)
        )
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.55),
            control1: CGPoint(x: width * 0.55, y: height * 0.45),
            control2: CGPoint(x: width * 0.8, y: height * 0.6)
        )
        return path
    }
}

struct TraditionalCurveAreaPath: Shape {
    let width: CGFloat
    let height: CGFloat

    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let startY = height * 0.85

        path.move(to: CGPoint(x: 0, y: startY))
        path.addCurve(
            to: CGPoint(x: width * 0.4, y: height * 0.45),
            control1: CGPoint(x: width * 0.15, y: startY - height * 0.15),
            control2: CGPoint(x: width * 0.3, y: height * 0.45)
        )
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.55),
            control1: CGPoint(x: width * 0.55, y: height * 0.45),
            control2: CGPoint(x: width * 0.8, y: height * 0.6)
        )
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        return path
    }
}