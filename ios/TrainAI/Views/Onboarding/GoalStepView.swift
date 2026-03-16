import SwiftUI

struct GoalStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options: [(String, String)] = [
        ("Build Muscle", "dumbbell.fill"),
        ("Lose Fat", "flame.fill"),
        ("Get Toned", "figure.run"),
        ("Competition Prep", "trophy.fill"),
        ("Stay Healthy", "heart.fill"),
        ("Get Stronger", "bolt.fill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("What is your goal?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .padding(.top, 24)

                    Text("Select all that apply.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 16)

                    ForEach(options, id: \.0) { option in
                        Button {
                            HapticManager.selection()
                            toggleGoal(option.0)
                        } label: {
                            OnboardingOptionCard(title: option.0, isSelected: viewModel.selectedGoals.contains(option.0), icon: option.1)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            OnboardingCTAButton(title: "Continue", enabled: !viewModel.selectedGoals.isEmpty) {
                viewModel.selectedGoal = viewModel.selectedGoals.first ?? ""
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }

    private func toggleGoal(_ goal: String) {
        if let idx = viewModel.selectedGoals.firstIndex(of: goal) {
            viewModel.selectedGoals.remove(at: idx)
        } else {
            viewModel.selectedGoals.append(goal)
        }
    }
}
