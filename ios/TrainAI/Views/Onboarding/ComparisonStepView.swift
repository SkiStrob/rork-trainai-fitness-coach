import SwiftUI

struct ComparisonStepView: View {
    let viewModel: OnboardingViewModel
    @State private var chartProgress: Double = 0
    @State private var showLabels: Bool = false
    @State private var cardAppeared: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("TrainAI creates\nlong-term results")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            VStack(spacing: 16) {
                ZStack {
                    VStack(spacing: 0) {
                        ForEach(0..<4, id: \.self) { _ in
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .frame(height: 0.5)
                            Spacer()
                        }
                    }
                    .frame(height: 180)

                    GeometryReader { geo in
                        let width = geo.size.width
                        let height: CGFloat = 180

                        ZStack {
                            TraditionalCurveAreaPath(width: width, height: height)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 1, green: 0.42, blue: 0.42).opacity(0.06), .clear],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                )
                                .opacity(chartProgress)

                            TraditionalCurvePath(width: width, height: height)
                                .trim(from: 0, to: chartProgress)
                                .stroke(
                                    Color(red: 1, green: 0.42, blue: 0.42).opacity(0.6),
                                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [6, 4])
                                )

                            TrainAICurveAreaPath(width: width, height: height)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.primary.opacity(0.08), .clear],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                )
                                .opacity(chartProgress)

                            TrainAICurvePath(width: width, height: height)
                                .trim(from: 0, to: chartProgress)
                                .stroke(Color.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round))

                            if showLabels {
                                Circle()
                                    .fill(Color(red: 1.0, green: 0.59, blue: 0.0))
                                    .frame(width: 10, height: 10)
                                    .position(x: width, y: height * 0.12)

                                Circle()
                                    .fill(Color(red: 1, green: 0.42, blue: 0.42))
                                    .frame(width: 8, height: 8)
                                    .position(x: width, y: height * 0.55)
                            }
                        }
                        .frame(height: height)
                    }
                    .frame(height: 180)
                }

                HStack {
                    Text("Month 1")
                    Spacer()
                    Text("Month 3")
                    Spacer()
                    Text("Month 6")
                }
                .font(.system(size: 10))
                .foregroundStyle(.secondary)

                HStack(spacing: 24) {
                    HStack(spacing: 6) {
                        Circle().fill(Color.primary).frame(width: 6, height: 6)
                        Text("TrainAI").font(.caption.bold()).foregroundStyle(.primary)
                    }
                    HStack(spacing: 6) {
                        Circle().fill(Color(red: 1, green: 0.42, blue: 0.42)).frame(width: 6, height: 6)
                        Text("Traditional").font(.caption).foregroundStyle(.secondary)
                    }
                }

                Text("80% of TrainAI users maintain their progress after 6 months")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(showLabels ? 1 : 0)
            }
            .galaxyCard()
            .padding(.horizontal, 20)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
            withAnimation(.easeInOut(duration: 1.5).delay(0.4)) {
                chartProgress = 1.0
            }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85).delay(1.5)) {
                showLabels = true
            }
        }
    }
}

struct TrainAICurvePath: Shape {
    let width: CGFloat
    let height: CGFloat
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: height * 0.85))
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.12),
            control1: CGPoint(x: width * 0.3, y: height * 0.6),
            control2: CGPoint(x: width * 0.6, y: height * 0.27)
        )
        return path
    }
}

struct TrainAICurveAreaPath: Shape {
    let width: CGFloat
    let height: CGFloat
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: height * 0.85))
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.12),
            control1: CGPoint(x: width * 0.3, y: height * 0.6),
            control2: CGPoint(x: width * 0.6, y: height * 0.27)
        )
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        return path
    }
}

struct TraditionalCurvePath: Shape {
    let width: CGFloat
    let height: CGFloat
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: height * 0.85))
        path.addCurve(
            to: CGPoint(x: width * 0.4, y: height * 0.45),
            control1: CGPoint(x: width * 0.15, y: height * 0.7),
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
        path.move(to: CGPoint(x: 0, y: height * 0.85))
        path.addCurve(
            to: CGPoint(x: width * 0.4, y: height * 0.45),
            control1: CGPoint(x: width * 0.15, y: height * 0.7),
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
