import SwiftUI

struct SignInStepView: View {
    let viewModel: OnboardingViewModel
    @State private var appeared: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("Sign in")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))

                VStack(spacing: 12) {
                    Button {
                        HapticManager.light()
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                            viewModel.nextStep()
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 18))
                            Text("Sign in with Apple")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                        .clipShape(.rect(cornerRadius: 16))
                    }

                    Button {
                        HapticManager.light()
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                            viewModel.nextStep()
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Text("G")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color(red: 0.26, green: 0.52, blue: 0.96))
                            Text("Continue with Google")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.separator), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)

            Spacer()

            Text("By continuing, you agree to our [Terms of Service](https://example.com) and [Privacy Policy](https://example.com)")
                .font(.caption)
                .foregroundStyle(Color(.tertiaryLabel))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 32)
                .opacity(appeared ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82).delay(0.1)) {
                appeared = true
            }
        }
    }
}
