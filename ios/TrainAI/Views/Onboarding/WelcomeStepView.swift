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
    @State private var phoneAppeared: Bool = false
    @State private var logoAppeared: Bool = false
    @State private var buttonAppeared: Bool = false
    @State private var scanLineY: CGFloat = -180
    @State private var scanLoop: Bool = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                phoneMockup
                    .offset(y: phoneAppeared ? 0 : -60)
                    .opacity(phoneAppeared ? 1 : 0)

                Spacer().frame(height: 32)

                logoSection
                    .opacity(logoAppeared ? 1 : 0)

                Spacer()

                bottomSection
                    .offset(y: buttonAppeared ? 0 : 40)
                    .opacity(buttonAppeared ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                phoneAppeared = true
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.3)) {
                logoAppeared = true
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.4)) {
                buttonAppeared = true
            }
            startScanLine()
        }
    }

    private var phoneMockup: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36)
                .stroke(Color.black, lineWidth: 2)
                .frame(width: 220, height: 440)
                .background(
                    RoundedRectangle(cornerRadius: 36)
                        .fill(Color.black)
                )
                .shadow(color: .black.opacity(0.12), radius: 20, y: 10)

            Capsule()
                .fill(Color(white: 0.15))
                .frame(width: 90, height: 26)
                .offset(y: -207)

            ZStack {
                RealisticSilhouetteShape()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 100, height: 220)

                ScanBrackets()
                    .stroke(Color.white.opacity(0.6), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    .frame(width: 120, height: 240)

                Rectangle()
                    .fill(
                        LinearGradient(colors: [.white.opacity(0), .white.opacity(0.4), .white.opacity(0)], startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: 140, height: 2)
                    .shadow(color: .white.opacity(0.3), radius: 4)
                    .offset(y: scanLineY)

                VStack(spacing: 4) {
                    Text("5.7")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Chadlite")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            .frame(width: 200, height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 30))
        }
        .rotationEffect(.degrees(-2))
    }

    private var logoSection: some View {
        VStack(spacing: 4) {
            ZStack {
                ScanBrackets()
                    .stroke(Color.black.opacity(0.85), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .frame(width: 100, height: 100)

                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 44, weight: .regular))
                    .foregroundStyle(.black)
            }
            .frame(width: 100, height: 100)

            Text("TrainAI")
                .font(.system(size: 38, weight: .bold))
                .foregroundStyle(.black)

            Text("Body scoring made easy")
                .font(.system(size: 16))
                .foregroundStyle(Color(.secondaryLabel))
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
                    .frame(height: 52)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .clipShape(.rect(cornerRadius: 14))
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

    private func startScanLine() {
        Task {
            while true {
                scanLineY = -180
                withAnimation(.linear(duration: 2.5)) {
                    scanLineY = 180
                }
                try? await Task.sleep(for: .seconds(3))
            }
        }
    }
}
