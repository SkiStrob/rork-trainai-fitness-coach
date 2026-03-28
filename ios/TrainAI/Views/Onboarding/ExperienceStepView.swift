import SwiftUI

struct ExperienceStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var appeared: Bool = false

    private let options: [(String, String)] = [
        ("Beginner (0-6 months)", "circle.fill"),
        ("Intermediate (6mo - 2yr)", "circle.grid.2x1.fill"),
        ("Advanced (2+ years)", "circle.grid.3x3.fill"),
        ("Coming back after a break", "arrow.uturn.backward.circle.fill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("How experienced are you?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                VStack(spacing: 10) {
                    ForEach(Array(options.enumerated()), id: \.element.0) { index, option in
                        Button {
                            HapticManager.selection()
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                                viewModel.selectedExperience = option.0
                            }
                        } label: {
                            OnboardingOptionCard(title: option.0, isSelected: viewModel.selectedExperience == option.0, icon: option.1)
                        }
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 12)
                        .animation(.spring(response: 0.4, dampingFraction: 0.82).delay(Double(index) * 0.08), value: appeared)
                    }
                }
                .padding(.horizontal, 16)
            }

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: !viewModel.selectedExperience.isEmpty) {
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
