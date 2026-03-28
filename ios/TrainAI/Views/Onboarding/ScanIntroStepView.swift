import SwiftUI

struct ScanIntroStepView: View {
    let viewModel: OnboardingViewModel
    @State private var appeared: Bool = false
    @State private var linesTrimmed: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("\(displayName) time to scan your physique")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                scanIllustration
                    .frame(height: 280)
                    .opacity(appeared ? 1 : 0)

                HStack(spacing: 10) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(.tertiaryLabel))
                    Text("Your privacy and security matter to us. We're committed to keeping your personal information private and secure.")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(.secondaryLabel))
                }
                .padding(.horizontal, 24)
            }

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82).delay(0.1)) {
                appeared = true
            }
            withAnimation(.easeInOut(duration: 0.8).delay(0.4)) {
                linesTrimmed = 1.0
            }
        }
    }

    private var displayName: String {
        viewModel.userName.isEmpty ? "" : viewModel.userName + ","
    }

    private var scanIllustration: some View {
        ZStack {
            Image(systemName: "figure.stand")
                .font(.system(size: 120, weight: .ultraLight))
                .foregroundStyle(Color(.systemGray4).opacity(0.5))

            ScanBrackets(cornerSegmentLength: 0.22)
                .stroke(Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.3), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .frame(width: 140, height: 200)

            GeometryReader { geo in
                let centerX = geo.size.width / 2
                let centerY = geo.size.height / 2

                Path { path in
                    path.move(to: CGPoint(x: centerX - 50, y: centerY - 40))
                    path.addLine(to: CGPoint(x: centerX + 50, y: centerY - 40))
                }
                .trim(from: 0, to: linesTrimmed)
                .stroke(Color.white, lineWidth: 1.5)

                Path { path in
                    path.move(to: CGPoint(x: centerX - 30, y: centerY + 10))
                    path.addLine(to: CGPoint(x: centerX + 30, y: centerY + 10))
                }
                .trim(from: 0, to: linesTrimmed)
                .stroke(Color.white, lineWidth: 1.5)

                Path { path in
                    path.move(to: CGPoint(x: centerX - 40, y: centerY + 40))
                    path.addLine(to: CGPoint(x: centerX + 40, y: centerY + 40))
                }
                .trim(from: 0, to: linesTrimmed)
                .stroke(Color.white, lineWidth: 1.5)

                if linesTrimmed > 0.5 {
                    measurementPill("6.4", x: centerX + 55, y: centerY - 40)
                    measurementPill("5.7", x: centerX + 35, y: centerY + 10)
                    measurementPill("5.2", x: centerX + 45, y: centerY + 40)
                }
            }
        }
    }

    private func measurementPill(_ text: String, x: CGFloat, y: CGFloat) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.6))
            .clipShape(Capsule())
            .position(x: x, y: y)
            .transition(.opacity)
    }
}
