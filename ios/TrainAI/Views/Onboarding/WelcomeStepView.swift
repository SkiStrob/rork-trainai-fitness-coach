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


    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

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
        }
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

            Text("Fisique")
                .font(.system(size: 38, weight: .bold))
                .foregroundStyle(.black)

            Text("Body Score & AI Coach")
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

}
