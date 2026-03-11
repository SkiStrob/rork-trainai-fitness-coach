import SwiftUI

struct ComparisonStepView: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Transform faster with TrainAI vs on your own")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)

            Spacer()

            HStack(spacing: 16) {
                VStack(spacing: 16) {
                    Text("Without\nTrainAI")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                            .frame(height: 180)

                        VStack(spacing: 12) {
                            Image(systemName: "figure.stand")
                                .font(.system(size: 44))
                                .foregroundStyle(.secondary)

                            Text("Slow progress")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)

                            HStack(spacing: 4) {
                                Text("20%")
                                    .font(.title3.bold())
                                    .foregroundStyle(.primary)
                            }
                        }
                    }

                    VStack(spacing: 4) {
                        Text("No tracking")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("No structure")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(spacing: 16) {
                    Text("With\nTrainAI")
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)

                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.primary)
                            .frame(height: 180)

                        VStack(spacing: 12) {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 44))
                                .foregroundStyle(Color(.systemBackground))

                            Text("2x faster")
                                .font(.caption.bold())
                                .foregroundStyle(Color(.systemBackground))

                            HStack(spacing: 4) {
                                Text("2X")
                                    .font(.title3.bold())
                                    .foregroundStyle(Color(.systemBackground))
                            }
                        }
                    }

                    VStack(spacing: 4) {
                        Text("AI-guided plans")
                            .font(.caption)
                            .foregroundStyle(.primary)
                        Text("Photo tracking")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            Text("TrainAI makes it easy and holds\nyou accountable.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
