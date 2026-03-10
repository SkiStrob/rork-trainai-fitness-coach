import SwiftUI

struct WelcomeStepView: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 56))
                    .foregroundStyle(.primary)

                Text("TrainAI")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Your AI Physique Coach")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 12) {
                Button {
                    HapticManager.light()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        viewModel.nextStep()
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "apple.logo")
                            .font(.title3)
                        Text("Continue with Apple")
                            .font(.headline)
                    }
                    .foregroundStyle(Color(.systemBackground))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primary)
                    .clipShape(.rect(cornerRadius: 14))
                }

                Button {
                    HapticManager.light()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        viewModel.nextStep()
                    }
                } label: {
                    Text("Other sign-in options")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
    }
}
