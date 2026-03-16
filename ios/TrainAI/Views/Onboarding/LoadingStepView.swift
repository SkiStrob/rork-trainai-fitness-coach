import SwiftUI

struct LoadingStepView: View {
    let viewModel: OnboardingViewModel
    @State private var percentage: Int = 0
    @State private var completedItems: Set<Int> = []
    @State private var barProgress: CGFloat = 0

    private let items = [
        "Calories",
        "Carbs",
        "Protein",
        "Fats",
        "Body Score",
        "Workout Program"
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
            .padding(.top, 32)

            VStack(alignment: .leading, spacing: 12) {
                Text("We're setting everything\nup for you")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.primary)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 0.9, green: 0.9, blue: 0.91))

                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 1, green: 0.42, blue: 0.42), Color(red: 0.29, green: 0.56, blue: 0.85)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * barProgress)
                    }
                }
                .frame(height: 8)

                Text("Customizing health plan...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            Spacer().frame(height: 40)

            VStack(alignment: .leading, spacing: 16) {
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
                                .foregroundStyle(.primary)
                                .transition(.opacity)
                        } else {
                            SkeletonView(height: 16, cornerRadius: 4)
                                .frame(width: CGFloat.random(in: 80...140))
                        }

                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .onAppear {
            startLoading()
        }
    }

    private func startLoading() {
        Task {
            for i in 1...100 {
                try? await Task.sleep(for: .milliseconds(60))
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
                for i in 0..<items.count {
                    completedItems.insert(i)
                }
            }

            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                viewModel.nextStep()
            }
        }
    }
}
