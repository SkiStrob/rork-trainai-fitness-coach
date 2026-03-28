import SwiftUI

struct GoalStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var appeared: Bool = false

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
            Spacer()

            VStack(spacing: 24) {
                Text("\(displayName) what's your main goal?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                VStack(spacing: 10) {
                    ForEach(Array(options.enumerated()), id: \.element.0) { index, option in
                        Button {
                            HapticManager.selection()
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                                viewModel.selectedGoal = option.0
                            }
                        } label: {
                            OnboardingOptionCard(title: option.0, isSelected: viewModel.selectedGoal == option.0, icon: option.1)
                        }
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 12)
                        .animation(.spring(response: 0.4, dampingFraction: 0.82).delay(Double(index) * 0.08), value: appeared)
                    }
                }
                .padding(.horizontal, 16)
            }

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: !viewModel.selectedGoal.isEmpty) {
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

    private var displayName: String {
        viewModel.userName.isEmpty ? "" : viewModel.userName + ","
    }
}
