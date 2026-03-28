import SwiftUI

struct GenderStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var appeared: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                Text("What's your gender?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .multilineTextAlignment(.center)

                VStack(spacing: 10) {
                    ForEach(Array(["Male", "Female", "Other"].enumerated()), id: \.element) { index, gender in
                        Button {
                            HapticManager.selection()
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                                viewModel.selectedGender = gender
                            }
                        } label: {
                            OnboardingOptionCard(title: gender, isSelected: viewModel.selectedGender == gender)
                        }
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 12)
                        .animation(.spring(response: 0.4, dampingFraction: 0.82).delay(Double(index) * 0.08), value: appeared)
                    }
                }
                .padding(.horizontal, 16)
            }

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: !viewModel.selectedGender.isEmpty) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                appeared = true
            }
        }
    }
}
