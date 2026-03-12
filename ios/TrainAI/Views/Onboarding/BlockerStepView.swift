import SwiftUI

struct BlockerStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options: [(String, String)] = [
        ("Lack of consistency", "chart.bar.fill"),
        ("Unhealthy eating habits", "fork.knife"),
        ("Lack of support", "person.2.fill"),
        ("Busy schedule", "clock.fill"),
        ("Lack of meal inspiration", "lightbulb.fill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("What's stopping you from reaching your goals?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .padding(.top, 24)
                        .padding(.bottom, 24)

                    ForEach(options, id: \.0) { option in
                        Button {
                            HapticManager.selection()
                            viewModel.selectedBlocker = option.0
                        } label: {
                            OnboardingOptionCard(
                                title: option.0,
                                isSelected: viewModel.selectedBlocker == option.0,
                                icon: option.1
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            OnboardingCTAButton(title: "Continue", enabled: !viewModel.selectedBlocker.isEmpty) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}