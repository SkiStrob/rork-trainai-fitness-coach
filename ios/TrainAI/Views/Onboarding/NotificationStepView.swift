import SwiftUI

struct NotificationStepView: View {
    let viewModel: OnboardingViewModel
    @State private var appeared: Bool = false
    @State private var bellPulse: Bool = false

    private let notifications: [(String, Color, String)] = [
        ("dumbbell.fill", Color(red: 0.3, green: 0.5, blue: 0.9), "Morning workout reminders"),
        ("fork.knife", Color(red: 0.2, green: 0.78, blue: 0.35), "Post-meal logging nudges"),
        ("chart.bar.fill", Color(red: 0.6, green: 0.4, blue: 0.9), "Weekly progress reports"),
        ("camera.fill", Color(red: 1.0, green: 0.58, blue: 0.0), "Scan day reminders"),
        ("trophy.fill", Color(red: 0.78, green: 0.66, blue: 0.32), "PR celebrations")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .symbolEffect(.pulse, options: .repeating, value: bellPulse)

                Text("Stay on Track")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))

                Text("Get reminders for workouts, meals, scan days, and celebrate your PRs.")
                    .font(.system(size: 16))
                    .foregroundStyle(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                VStack(spacing: 8) {
                    ForEach(Array(notifications.enumerated()), id: \.offset) { index, notif in
                        HStack(spacing: 14) {
                            Image(systemName: notif.0)
                                .font(.system(size: 16))
                                .foregroundStyle(notif.1)
                                .frame(width: 28)

                            Text(notif.2)
                                .font(.system(size: 15))
                                .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.93, green: 0.97, blue: 0.95))
                        .clipShape(.rect(cornerRadius: 12))
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 12)
                        .animation(.spring(response: 0.4, dampingFraction: 0.82).delay(0.2 + Double(index) * 0.08), value: appeared)
                    }
                }
                .padding(.horizontal, 16)
            }

            Spacer()

            OnboardingCTAButton(title: "Enable Notifications", enabled: true) {
                NotificationService.requestPermission()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.nextStep()
                }
            }

            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.nextStep()
                }
            } label: {
                Text("Maybe later")
                    .font(.subheadline)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            .padding(.bottom, 16)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                appeared = true
            }
            bellPulse = true
        }
    }
}
