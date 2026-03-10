import SwiftUI

struct GoalStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options: [(String, String)] = [
        ("Build Muscle", "💪"),
        ("Lose Fat", "🔥"),
        ("Get Toned", "✨"),
        ("Competition Prep", "🏆"),
        ("Stay Healthy", "🌱"),
        ("Get Stronger", "⚡")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("What's your main goal?")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)
                        .padding(.top, 24)

                    Text("This will be used to calibrate your custom plan.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 16)

                    ForEach(options, id: \.0) { option in
                        Button {
                            HapticManager.selection()
                            viewModel.selectedGoal = option.0
                        } label: {
                            OnboardingOptionCard(title: option.0, isSelected: viewModel.selectedGoal == option.0, emoji: option.1)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            OnboardingCTAButton(title: "Next", enabled: !viewModel.selectedGoal.isEmpty) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
