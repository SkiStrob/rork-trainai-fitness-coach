import SwiftUI

struct AgeStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options = ["Under 18", "18-24", "25-34", "35-44", "45-54", "55+"]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("How old are you?")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)
                        .padding(.top, 24)

                    Text("This will be used to calibrate your custom plan.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 16)

                    ForEach(options, id: \.self) { option in
                        Button {
                            HapticManager.selection()
                            viewModel.selectedAge = option
                        } label: {
                            OnboardingOptionCard(title: option, isSelected: viewModel.selectedAge == option)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            OnboardingCTAButton(title: "Next", enabled: !viewModel.selectedAge.isEmpty) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
