import SwiftUI

struct WelcomeStepView: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.white.opacity(0.6), style: StrokeStyle(lineWidth: 2, dash: [12, 8]))
                            .frame(width: 100, height: 100)
                        Image(systemName: "figure.stand")
                            .font(.system(size: 48, weight: .light))
                            .foregroundStyle(.white)
                    }

                    Text("TrainAI")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Your AI Physique Coach")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.6))
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
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
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
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .preferredColorScheme(.dark)
    }
}