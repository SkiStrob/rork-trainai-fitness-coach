import SwiftUI

struct GenderStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Choose your Gender")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .padding(.top, 24)

                    Text("This will be used to calibrate your custom plan.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 24)

                    ForEach(["Male", "Female", "Other"], id: \.self) { gender in
                        Button {
                            HapticManager.selection()
                            viewModel.selectedGender = gender
                        } label: {
                            OnboardingOptionCard(
                                title: gender,
                                isSelected: viewModel.selectedGender == gender
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            OnboardingCTAButton(title: "Continue", enabled: !viewModel.selectedGender.isEmpty) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
