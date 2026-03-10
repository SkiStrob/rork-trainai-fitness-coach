import SwiftUI

struct AttributionStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options = ["TikTok", "Instagram", "YouTube", "Through a friend", "App Store", "Other"]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Where did you hear about us?")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)
                        .padding(.top, 24)

                    Text("This helps us improve our reach.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 16)

                    ForEach(options, id: \.self) { option in
                        Button {
                            HapticManager.selection()
                            viewModel.selectedAttribution = option
                        } label: {
                            OnboardingOptionCard(title: option, isSelected: viewModel.selectedAttribution == option)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            OnboardingCTAButton(title: "Next", enabled: !viewModel.selectedAttribution.isEmpty) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
