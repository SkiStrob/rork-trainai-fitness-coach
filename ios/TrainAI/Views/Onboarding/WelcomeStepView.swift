import SwiftUI

struct ScanBrackets: Shape {
    var cornerSegmentLength: CGFloat = 0.28

    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerLength: CGFloat = rect.width * cornerSegmentLength

        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerLength))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + cornerLength, y: rect.minY))

        path.move(to: CGPoint(x: rect.maxX - cornerLength, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerLength))

        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerLength))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerLength, y: rect.maxY))

        path.move(to: CGPoint(x: rect.minX + cornerLength, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerLength))

        return path
    }
}

struct WelcomeStepView: View {
    let viewModel: OnboardingViewModel
    @State private var phoneOpacity: Double = 0
    @State private var phoneOffset: CGFloat = -30
    @State private var textOpacity: Double = 0
    @State private var buttonOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 60)

                phoneMockup
                    .opacity(phoneOpacity)
                    .offset(y: phoneOffset)

                Spacer()
                    .frame(height: 32)

                VStack(spacing: 4) {
                    Text("Your personal AI")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.black)
                    Text("training assistant")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.black)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(textOpacity)

                Spacer()

                bottomSection
                    .opacity(buttonOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                phoneOpacity = 1
                phoneOffset = 0
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                textOpacity = 1
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.3)) {
                buttonOpacity = 1
            }
        }
    }

    private var phoneMockup: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36)
                .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                .frame(width: 240, height: 440)
                .overlay(
                    RoundedRectangle(cornerRadius: 36)
                        .stroke(Color.black, lineWidth: 8)
                )
                .overlay(alignment: .top) {
                    Capsule()
                        .fill(.black)
                        .frame(width: 80, height: 24)
                        .offset(y: 12)
                }
                .overlay {
                    phoneContent
                }
                .clipShape(RoundedRectangle(cornerRadius: 36))
                .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
                .rotationEffect(.degrees(-2))
        }
    }

    private var phoneContent: some View {
        VStack(spacing: 8) {
            Spacer()
                .frame(height: 50)

            Text("5.7")
                .font(.system(size: 48, weight: .bold, design: .default))
                .foregroundStyle(.white)
                .monospacedDigit()

            TierBadgeView(tierInfo: TierInfo.tier(for: 5.7, gender: "male"))
                .scaleEffect(0.7)

            RadarChartView(
                values: [6.5, 5.3, 5.9, 5.5, 5.7, 5.2],
                labels: ["SYM", "DEF", "MASS", "PROP", "V-TAP", "CORE"],
                maxValue: 10.0,
                animated: false
            )
            .frame(width: 140, height: 140)

            Spacer()
        }
    }

    private var bottomSection: some View {
        VStack(spacing: 12) {
            Button {
                HapticManager.light()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            } label: {
                Text("Get Started")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .clipShape(.rect(cornerRadius: 16))
            }
            .padding(.horizontal, 20)

            Button {
                HapticManager.light()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            } label: {
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundStyle(Color(.secondaryLabel))
                    Text("Sign In")
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }
                .font(.subheadline)
            }
            .padding(.bottom, 16)
        }
    }
}
