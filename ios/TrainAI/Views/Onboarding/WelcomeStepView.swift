import SwiftUI

struct ScanBrackets: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerLength: CGFloat = rect.width * 0.25

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
    @State private var contentVisible: Bool = false

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    ZStack {
                        ScanBrackets()
                            .stroke(Color.primary.opacity(0.6), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .frame(width: 110, height: 110)

                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 50, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                    .blur(radius: contentVisible ? 0 : 3)
                    .opacity(contentVisible ? 1 : 0)

                    Text("TrainAI")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.primary)
                        .blur(radius: contentVisible ? 0 : 3)
                        .opacity(contentVisible ? 1 : 0)

                    Text("Your AI Physique Coach")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .blur(radius: contentVisible ? 0 : 3)
                        .opacity(contentVisible ? 1 : 0)
                }

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        HapticManager.light()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            viewModel.nextStep()
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "apple.logo")
                                .font(.title3)
                            Text("Continue with Apple")
                                .font(.headline)
                        }
                        .foregroundStyle(Color(.systemBackground))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primary)
                        .clipShape(.rect(cornerRadius: 14))
                    }

                    Button {
                        HapticManager.light()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            viewModel.nextStep()
                        }
                    } label: {
                        Text("Other sign-in options")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
                .blur(radius: contentVisible ? 0 : 3)
                .opacity(contentVisible ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.1)) {
                contentVisible = true
            }
        }
    }
}
