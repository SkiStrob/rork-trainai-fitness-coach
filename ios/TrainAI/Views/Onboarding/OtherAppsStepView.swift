import SwiftUI

struct OtherAppsStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Have you tried other fitness tracking apps?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            HStack(spacing: 12) {
                Button {
                    HapticManager.selection()
                    viewModel.hasTriedOtherApps = false
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(viewModel.hasTriedOtherApps == false ? .white : .primary)
                        Text("No")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(viewModel.hasTriedOtherApps == false ? .white : .primary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(viewModel.hasTriedOtherApps == false ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.94, green: 0.94, blue: 0.95))
                    )
                }

                Button {
                    HapticManager.selection()
                    viewModel.hasTriedOtherApps = true
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(viewModel.hasTriedOtherApps == true ? .white : .primary)
                        Text("Yes")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(viewModel.hasTriedOtherApps == true ? .white : .primary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(viewModel.hasTriedOtherApps == true ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.94, green: 0.94, blue: 0.95))
                    )
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: viewModel.hasTriedOtherApps != nil) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
