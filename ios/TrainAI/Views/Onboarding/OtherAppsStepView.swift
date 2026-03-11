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
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)

            Spacer()

            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                        .frame(height: 200)

                    VStack(spacing: 16) {
                        Text("Your weight")
                            .font(.subheadline.bold())
                            .foregroundStyle(.primary)

                        ZStack {
                            Path { path in
                                path.move(to: CGPoint(x: 20, y: 80))
                                path.addCurve(
                                    to: CGPoint(x: 260, y: 40),
                                    control1: CGPoint(x: 80, y: 60),
                                    control2: CGPoint(x: 160, y: 90)
                                )
                            }
                            .stroke(Color(.systemGray3), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                            .frame(width: 280, height: 120)

                            Path { path in
                                path.move(to: CGPoint(x: 20, y: 80))
                                path.addCurve(
                                    to: CGPoint(x: 260, y: 20),
                                    control1: CGPoint(x: 100, y: 70),
                                    control2: CGPoint(x: 180, y: 30)
                                )
                            }
                            .stroke(Color.primary, lineWidth: 2.5)
                            .frame(width: 280, height: 120)

                            Text("Traditional")
                                .font(.system(size: 9))
                                .foregroundStyle(.secondary)
                                .position(x: 250, y: 48)

                            HStack(spacing: 4) {
                                ZStack {
                                    ScanBrackets()
                                        .stroke(Color.primary.opacity(0.4), style: StrokeStyle(lineWidth: 1, lineCap: .round))
                                        .frame(width: 14, height: 14)
                                }
                                Text("TrainAI")
                                    .font(.system(size: 9, weight: .bold))
                            }
                            .foregroundStyle(.primary)
                            .position(x: 248, y: 26)
                        }
                        .frame(height: 120)

                        Text("80% of TrainAI users maintain their progress even 6 months later")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.horizontal, 16)

                VStack(spacing: 12) {
                    Button {
                        HapticManager.selection()
                        viewModel.hasTriedOtherApps = false
                    } label: {
                        OnboardingOptionCard(
                            title: "No",
                            isSelected: viewModel.hasTriedOtherApps == false,
                            icon: "xmark.circle"
                        )
                    }

                    Button {
                        HapticManager.selection()
                        viewModel.hasTriedOtherApps = true
                    } label: {
                        OnboardingOptionCard(
                            title: "Yes",
                            isSelected: viewModel.hasTriedOtherApps == true,
                            icon: "checkmark.circle"
                        )
                    }
                }
                .padding(.horizontal, 16)
            }

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: viewModel.hasTriedOtherApps != nil) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
