import SwiftUI

struct ExperienceStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options: [(String, String, String)] = [
        ("0-2", "Workouts now and then", "circle.fill"),
        ("3-5", "A few workouts per week", "circle.grid.2x1.fill"),
        ("6+", "Dedicated athlete", "circle.grid.3x3.fill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("How many workouts do you do per week?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .padding(.top, 24)

                    Text("This will be used to calibrate your custom plan.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 24)

                    ForEach(options, id: \.0) { option in
                        Button {
                            HapticManager.selection()
                            viewModel.selectedExperience = option.0
                        } label: {
                            OnboardingOptionCard(
                                title: option.0,
                                isSelected: viewModel.selectedExperience == option.0,
                                subtitle: option.1,
                                icon: option.2
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            OnboardingCTAButton(title: "Continue", enabled: !viewModel.selectedExperience.isEmpty) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
