import SwiftUI

struct ExperienceStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options: [(String, String, String)] = [
        ("0-2", "Workouts now and then", "circle.fill"),
        ("3-5", "A few workouts per week", "circle.grid.2x1.fill"),
        ("6+", "Dedicated athlete", "circle.grid.3x3.fill")
    ]

    private let expOptions = [
        "Beginner (0-6 months)",
        "Intermediate (6mo-2yr)",
        "Advanced (2+ years)",
        "Coming back after a break"
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("How many workouts do you do per week?")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)
                        .padding(.top, 24)

                    Text("This will be used to calibrate your custom plan.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 24)

                    ForEach(expOptions, id: \.self) { option in
                        Button {
                            HapticManager.selection()
                            viewModel.selectedExperience = option
                        } label: {
                            OnboardingOptionCard(
                                title: option,
                                isSelected: viewModel.selectedExperience == option
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            OnboardingCTAButton(title: "Next", enabled: !viewModel.selectedExperience.isEmpty) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
