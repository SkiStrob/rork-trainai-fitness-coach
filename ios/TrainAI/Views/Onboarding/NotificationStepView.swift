import SwiftUI

struct NotificationStepView: View {
    let viewModel: OnboardingViewModel
    @State private var bounceOffset: CGFloat = 0

    private let notificationExamples: [(String, String, Color)] = [
        ("dumbbell.fill", "Leg day! Squats, RDLs, and leg press today.", Color(red: 0.3, green: 0.5, blue: 0.9)),
        ("camera.fill", "Time for your weekly body scan!", Color(red: 1.0, green: 0.59, blue: 0.21)),
        ("trophy.fill", "New PR! You benched 185 lbs!", Color(red: 0.13, green: 0.77, blue: 0.37)),
    ]

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .center, spacing: 0) {
                Text("Reach your goals\nwith notifications")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 32)
                    .padding(.horizontal, 24)

                Spacer().frame(height: 32)

                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 0.94, green: 0.94, blue: 0.95))
                                .frame(width: 36, height: 36)

                            ZStack {
                                ScanBrackets()
                                    .stroke(Color.black.opacity(0.7), style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                                    .frame(width: 18, height: 18)
                                Image(systemName: "figure.strengthtraining.traditional")
                                    .font(.system(size: 8, weight: .medium))
                                    .foregroundStyle(.black)
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("TrainAI")
                                    .font(.caption.bold())
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text("now")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Text("\"TrainAI\" Wants to Send You Notifications")
                                .font(.caption)
                                .foregroundStyle(.primary)
                                .lineLimit(2)

                            HStack(spacing: 20) {
                                Text("Don't Allow")
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                                Text("Allow")
                                    .font(.caption.bold())
                                    .foregroundStyle(.blue)
                            }
                            .padding(.top, 2)
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
                    )
                }
                .padding(.horizontal, 24)

                Text("5M+ TrainAI Users")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 16)

                Spacer().frame(height: 28)

                VStack(spacing: 10) {
                    ForEach(0..<notificationExamples.count, id: \.self) { i in
                        let example = notificationExamples[i]
                        HStack(spacing: 12) {
                            Image(systemName: example.0)
                                .font(.system(size: 14))
                                .foregroundStyle(example.2)
                                .frame(width: 28)

                            Text(example.1)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)

                            Spacer()
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.96, green: 0.96, blue: 0.97))
                        )
                    }
                }
                .padding(.horizontal, 24)
            }

            Spacer()

            OnboardingCTAButton(title: "Enable Notifications", enabled: true) {
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
