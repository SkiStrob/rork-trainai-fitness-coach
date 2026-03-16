import SwiftUI

struct LoadingStepView: View {
    let viewModel: OnboardingViewModel
    @State private var percentage: Int = 0
    @State private var completedItems: Set<Int> = []
    @State private var barProgress: CGFloat = 0
    @State private var cardAppeared: Bool = false
    @State private var bracketsDraw: CGFloat = 0
    @State private var silhouetteVisible: Bool = false
    @State private var measureLines: Bool = false
    @State private var scoreVisible: Bool = false
    @State private var radarVisible: Bool = false
    @State private var macrosVisible: Bool = false

    private let items = [
        "Analyzing physique",
        "Calculating ratios",
        "Setting calorie targets",
        "Generating workout plan",
        "Building meal suggestions",
        "Finalizing results"
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("\(percentage)%")
                    .font(.system(size: 56, weight: .bold))
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
                    .monospacedDigit()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)

            VStack(alignment: .leading, spacing: 12) {
                Text("We're building your plan")
                    .font(.system(size: 20, weight: .bold))

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 1.0, green: 0.58, blue: 0.0), Color(red: 0.11, green: 0.11, blue: 0.12)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * barProgress)
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 20)

            ZStack {
                ScanBrackets()
                    .trim(from: 0, to: bracketsDraw)
                    .stroke(Color.black.opacity(0.7), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .frame(width: 140, height: 160)

                if silhouetteVisible {
                    RealisticSilhouetteShape()
                        .fill(Color(.systemGray4))
                        .frame(width: 80, height: 140)
                        .transition(.opacity)
                }

                if measureLines {
                    VStack(spacing: 0) {
                        Rectangle().fill(Color.black.opacity(0.3)).frame(width: 90, height: 1.5).clipShape(Capsule())
                        Spacer().frame(height: 25)
                        Rectangle().fill(Color.black.opacity(0.2)).frame(width: 60, height: 1.5).clipShape(Capsule())
                    }
                    .offset(y: -10)
                    .transition(.opacity)
                }

                if scoreVisible {
                    Text("5.7")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)
                        .transition(.scale.combined(with: .opacity))
                }

                if radarVisible {
                    RegularHexagon()
                        .stroke(Color(red: 1.0, green: 0.58, blue: 0.0).opacity(0.4), lineWidth: 1.5)
                        .frame(width: 60, height: 60)
                        .offset(y: 90)
                        .transition(.scale.combined(with: .opacity))
                }

                if macrosVisible {
                    HStack(spacing: 8) {
                        Circle().fill(Color.black).frame(width: 12, height: 12)
                        Circle().fill(Color(red: 1.0, green: 0.23, blue: 0.19)).frame(width: 12, height: 12)
                        Circle().fill(Color(red: 1.0, green: 0.58, blue: 0.0)).frame(width: 12, height: 12)
                        Circle().fill(Color(red: 0.0, green: 0.48, blue: 1.0)).frame(width: 12, height: 12)
                    }
                    .offset(y: 130)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(height: 300)
            .galaxyCard()
            .padding(.horizontal, 20)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer().frame(height: 20)

            VStack(alignment: .leading, spacing: 14) {
                ForEach(0..<items.count, id: \.self) { i in
                    HStack(spacing: 12) {
                        if completedItems.contains(i) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.body)
                                .foregroundStyle(.green)
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            SkeletonView(height: 20, cornerRadius: 4)
                                .frame(width: 20)
                        }

                        if completedItems.contains(i) {
                            Text(items[i])
                                .font(.subheadline)
                                .transition(.opacity)
                        } else {
                            SkeletonView(height: 16, cornerRadius: 4)
                                .frame(width: CGFloat.random(in: 100...160))
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
            startLoading()
        }
    }

    private func startLoading() {
        Task {
            withAnimation(.easeOut(duration: 1.0)) {
                bracketsDraw = 1.0
            }
            try? await Task.sleep(for: .seconds(1))

            withAnimation(.easeOut(duration: 0.5)) {
                silhouetteVisible = true
            }
            try? await Task.sleep(for: .milliseconds(800))

            withAnimation(.easeOut(duration: 0.5)) {
                measureLines = true
            }
            try? await Task.sleep(for: .milliseconds(800))

            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                scoreVisible = true
            }
            try? await Task.sleep(for: .milliseconds(800))

            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                radarVisible = true
            }
            try? await Task.sleep(for: .milliseconds(600))

            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                macrosVisible = true
            }

            for i in 1...100 {
                try? await Task.sleep(for: .milliseconds(55))
                withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                    percentage = i
                    barProgress = CGFloat(i) / 100.0
                }

                let itemIndex = Int(Double(i) / 100.0 * Double(items.count))
                if itemIndex > 0 && !completedItems.contains(itemIndex - 1) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        completedItems.insert(itemIndex - 1)
                    }
                }
            }

            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                for i in 0..<items.count { completedItems.insert(i) }
            }

            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                viewModel.nextStep()
            }
        }
    }
}

struct RegularHexagon: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let cx = rect.midX
        let cy = rect.midY
        let r = min(rect.width, rect.height) / 2
        for i in 0..<6 {
            let angle = Double(i) * 60 - 90
            let x = cx + r * cos(angle * .pi / 180)
            let y = cy + r * sin(angle * .pi / 180)
            if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
            else { path.addLine(to: CGPoint(x: x, y: y)) }
        }
        path.closeSubpath()
        return path
    }
}
