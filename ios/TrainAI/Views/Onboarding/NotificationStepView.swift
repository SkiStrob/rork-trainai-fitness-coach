import SwiftUI

struct NotificationStepView: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 120, height: 120)

                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.primary)
                        .symbolEffect(.pulse, options: .repeating)
                }

                Text("Stay on Track")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)

                Text("Get reminders for workouts, meals, scan days, and celebrate your PRs.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                VStack(alignment: .leading, spacing: 14) {
                    NotificationPreviewRow(icon: "dumbbell.fill", color: .blue, text: "Morning workout reminders")
                    NotificationPreviewRow(icon: "fork.knife", color: .green, text: "Post-meal logging nudges")
                    NotificationPreviewRow(icon: "chart.bar.fill", color: .purple, text: "Weekly progress reports")
                    NotificationPreviewRow(icon: "camera.fill", color: .orange, text: "Scan day reminders")
                    NotificationPreviewRow(icon: "trophy.fill", color: .yellow, text: "PR celebrations")
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
                Text("Maybe later")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 16)
        }
    }
}

struct NotificationPreviewRow: View {
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(color)
                .frame(width: 28)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
    }
}
