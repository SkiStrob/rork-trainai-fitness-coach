import SwiftUI

struct NotificationStepView: View {
    let viewModel: OnboardingViewModel
    @State private var cardAppeared: Bool = false
    @State private var card1Visible: Bool = false
    @State private var card2Visible: Bool = false
    @State private var card3Visible: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Text("Reach your goals\nwith notifications")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .padding(.top, 32)

            Spacer().frame(height: 28)

            ZStack {
                notificationCard("Weekly scan day!", offset: -16, opacity: card3Visible ? 0.6 : 0, scale: 0.92)
                notificationCard("Time for your body scan!", offset: -8, opacity: card2Visible ? 0.8 : 0, scale: 0.96)

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
                            Text("Trainity").font(.caption.bold())
                            Spacer()
                            Text("now").font(.caption2).foregroundStyle(.secondary)
                        }
                        Text("Push Day! Bench press, OHP, and lateral raises today.")
                            .font(.caption)
                            .lineLimit(2)
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
                )
                .opacity(card1Visible ? 1 : 0)
                .offset(y: card1Visible ? 0 : 10)
            }
            .galaxyCard()
            .padding(.horizontal, 20)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Text("5M+ Trainity Users")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 16)

            Spacer().frame(height: 24)

            VStack(spacing: 10) {
                notificationExample(icon: "dumbbell.fill", color: Color(red: 0.3, green: 0.5, blue: 0.9), text: "Leg day! Squats, RDLs, and leg press today.")
                notificationExample(icon: "camera.fill", color: Color(red: 1.0, green: 0.58, blue: 0.0), text: "Time for your weekly body scan!")
                notificationExample(icon: "trophy.fill", color: Color(red: 0.13, green: 0.77, blue: 0.37), text: "New PR! You benched 185 lbs!")
            }
            .padding(.horizontal, 24)

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
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
            withAnimation(.easeOut(duration: 0.3).delay(0.2)) {
                card3Visible = true
            }
            withAnimation(.easeOut(duration: 0.3).delay(0.4)) {
                card2Visible = true
            }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85).delay(0.6)) {
                card1Visible = true
            }
        }
    }

    private func notificationCard(_ text: String, offset: CGFloat, opacity: Double, scale: CGFloat) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: 28, height: 28)
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
        )
        .scaleEffect(scale)
        .offset(y: offset)
        .opacity(opacity)
    }

    private func notificationExample(icon: String, color: Color, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(color)
                .frame(width: 28)
            Text(text)
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
