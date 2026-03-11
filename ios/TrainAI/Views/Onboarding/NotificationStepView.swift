import SwiftUI

struct NotificationStepView: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("Reach your goals with notifications")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(width: 300, height: 80)

                    HStack(spacing: 12) {
                        Image(systemName: "app.badge.fill")
                            .font(.title2)
                            .foregroundStyle(.primary)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("\"TrainAI\" Wants to Send You Notifications")
                                .font(.caption.bold())
                                .foregroundStyle(.primary)
                                .lineLimit(2)

                            HStack(spacing: 16) {
                                Text("Don't Allow")
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                                Text("Allow")
                                    .font(.caption.bold())
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                Image(systemName: "hand.point.up.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.primary)
                    .rotationEffect(.degrees(180))

                Text("5M+ TrainAI Users")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                NotificationService.requestPermission()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            } label: {
                Text("Not now")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 16)
        }
    }
}
