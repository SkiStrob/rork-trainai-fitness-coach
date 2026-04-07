import SwiftUI

struct SignInStepView: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("Save your progress")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)

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
                            Text("Sign in with Apple")
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .clipShape(.rect(cornerRadius: 14))
                    }

                    Button {
                        HapticManager.light()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            viewModel.nextStep()
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Text("G")
                                .font(.title3.bold())
                                .foregroundStyle(Color(red: 0.26, green: 0.52, blue: 0.96))
                            Text("Sign in with Google")
                                .font(.headline)
                                .foregroundStyle(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        viewModel.nextStep()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Would you like to sign in later?")
                            .foregroundStyle(.secondary)
                        Text("Skip")
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }
                    .font(.subheadline)
                }
            }

            Spacer()
        }
    }
}

struct ReferralStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Enter referral code (optional)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)

                Text("You can skip this step")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            HStack(spacing: 8) {
                TextField("Referral Code", text: $viewModel.referralCode)
                    .font(.body)
                    .padding(16)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.95))
                    .clipShape(.rect(cornerRadius: 14))

                if !viewModel.referralCode.isEmpty {
                    Button {
                        HapticManager.light()
                    } label: {
                        Text("Submit")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .clipShape(.rect(cornerRadius: 10))
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Skip", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
