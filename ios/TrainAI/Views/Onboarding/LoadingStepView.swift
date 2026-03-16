import SwiftUI

struct LoadingStepView: View {
    let viewModel: OnboardingViewModel
    @State private var percentage: Int = 0
    @State private var completedItems: Set<Int> = []
    @State private var barProgress: CGFloat = 0
    @State private var cardAppeared: Bool = false
    @State private var ringProgress: CGFloat = 0
    @State private var calorieCount: Int = 0
    @State private var macroDots: [Bool] = [false, false, false, false]

    private let items = [
        "Calculating calorie target...",
        "Setting protein goal...",
        "Setting carb goal...",
        "Setting fat goal...",
        "Generating workout program...",
        "Finalizing your plan..."
    ]

    private var formattedCalories: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: calorieCount)) ?? "\(calorieCount)"
    }

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

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 8)
                    Circle()
                        .trim(from: 0, to: ringProgress)
                        .stroke(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.58, blue: 0.0), Color.black],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 2) {
                        Text(formattedCalories)
                            .font(.system(size: 24, weight: .bold))
                            .contentTransition(.numericText())
                            .monospacedDigit()
                        Text("Daily calories")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 100, height: 100)

                HStack(spacing: 12) {
                    macroDot(Color.black, visible: macroDots[0])
                    macroDot(Color(red: 1.0, green: 0.23, blue: 0.19), visible: macroDots[1])
                    macroDot(Color(red: 1.0, green: 0.58, blue: 0.0), visible: macroDots[2])
                    macroDot(Color(red: 0.0, green: 0.48, blue: 1.0), visible: macroDots[3])
                }
            }
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
                                .frame(width: CGFloat.random(in: 100...180))
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

    private func macroDot(_ color: Color, visible: Bool) -> some View {
        Circle()
            .fill(color)
            .frame(width: 10, height: 10)
            .opacity(visible ? 1 : 0.2)
            .scaleEffect(visible ? 1 : 0.5)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: visible)
    }

    private func startLoading() {
        let targetCalories = viewModel.calculatedDailyCalories

        Task {
            for i in 1...100 {
                try? await Task.sleep(for: .milliseconds(55))
                withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                    percentage = i
                    barProgress = CGFloat(i) / 100.0
                    ringProgress = CGFloat(i) / 100.0
                    calorieCount = Int(Double(targetCalories) * Double(i) / 100.0)
                }

                if i == 20 {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        macroDots[0] = true
                    }
                }
                if i == 40 {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        macroDots[1] = true
                    }
                }
                if i == 55 {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        macroDots[2] = true
                    }
                }
                if i == 70 {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        macroDots[3] = true
                    }
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
