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

                        ZStack(alignment: .topTrailing) {
                            ZStack {
                                Path { path in
                                    path.move(to: CGPoint(x: 20, y: 80))
                                    path.addCurve(
                                        to: CGPoint(x: 240, y: 50),
                                        control1: CGPoint(x: 80, y: 60),
                                        control2: CGPoint(x: 160, y: 85)
                                    )
                                }
                                .stroke(Color(.systemGray3), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                                .frame(height: 100)

                                Path { path in
                                    path.move(to: CGPoint(x: 20, y: 80))
                                    path.addCurve(
                                        to: CGPoint(x: 240, y: 20),
                                        control1: CGPoint(x: 100, y: 65),
                                        control2: CGPoint(x: 180, y: 25)
                                    )
                                }
                                .stroke(Color.primary, lineWidth: 2.5)
                                .frame(height: 100)
                            }
                            .padding(.horizontal, 16)

                            VStack(alignment: .trailing, spacing: 4) {
                                HStack(spacing: 3) {
                                    ScanBrackets()
                                        .stroke(Color.primary.opacity(0.5), style: StrokeStyle(lineWidth: 1, lineCap: .round))
                                        .frame(width: 12, height: 12)
                                    Text("TrainAI")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(.primary)
                                }
                                Text("Traditional")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.trailing, 12)
                            .padding(.top, 4)
                        }
                        .frame(height: 110)

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
