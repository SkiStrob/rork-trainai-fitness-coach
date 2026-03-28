import SwiftUI

struct FrontPhotoStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var appeared: Bool = false
    @State private var checkScale: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("Upload a front photo of your physique")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Button {
                    HapticManager.light()
                    viewModel.frontPhotoData = Data()
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        checkScale = 1.0
                    }
                } label: {
                    photoArea
                }
                .padding(.horizontal, 32)

                Text("Tip: ensure muscles are visible and well lit")
                    .font(.system(size: 14))
                    .foregroundStyle(Color(.secondaryLabel))
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: viewModel.frontPhotoData != nil) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82).delay(0.1)) {
                appeared = true
            }
        }
    }

    private var photoArea: some View {
        ZStack {
            if viewModel.frontPhotoData != nil {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.93, green: 0.97, blue: 0.95))
                    .frame(height: 280)
                    .overlay {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(Color(red: 0.2, green: 0.78, blue: 0.35))
                            .scaleEffect(checkScale)
                    }
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.96, green: 0.96, blue: 0.97))
                    .frame(height: 280)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color(.systemGray4), style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                    }
                    .overlay {
                        VStack(spacing: 12) {
                            FrontSilhouetteGuide()
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1.5)
                                .frame(width: 65, height: 120)

                            Image(systemName: "camera.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(Color(.secondaryLabel))

                            Text("Tap to upload")
                                .font(.caption)
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                    }
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color(.secondaryLabel))
                        .padding(12)
                }
            }
            .frame(height: 280)
        }
    }
}
