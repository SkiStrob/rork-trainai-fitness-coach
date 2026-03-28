import SwiftUI

struct CredibilitySplashStepView: View {
    let viewModel: OnboardingViewModel
    @State private var laurelScale: CGFloat = 0.5
    @State private var laurelOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var photoOpacity: Double = 0
    @State private var photoOffset: CGFloat = 40
    @State private var logosOpacity: Double = 0
    @State private var buttonOpacity: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Spacer().frame(height: 24)

                    laurelBadge
                        .scaleEffect(laurelScale)
                        .opacity(laurelOpacity)

                    titleSection
                        .opacity(titleOpacity)

                    transformationArea
                        .opacity(photoOpacity)
                        .offset(y: photoOffset)

                    sourcesBar
                        .opacity(logosOpacity)

                    citationRow
                        .opacity(logosOpacity)
                }
                .padding(.horizontal, 20)
            }

            bottomSection
                .opacity(buttonOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                laurelScale = 1.0
                laurelOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.3)) {
                titleOpacity = 1.0
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.5)) {
                photoOpacity = 1.0
                photoOffset = 0
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.7)) {
                logosOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.9)) {
                buttonOpacity = 1.0
            }
        }
    }

    private var laurelBadge: some View {
        VStack(spacing: 6) {
            HStack(spacing: 2) {
                Image(systemName: "laurel.leading")
                    .font(.system(size: 28))
                    .foregroundStyle(Color(red: 0.78, green: 0.66, blue: 0.32))

                HStack(spacing: 3) {
                    ForEach(0..<5, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(red: 0.78, green: 0.66, blue: 0.32))
                    }
                }

                Image(systemName: "laurel.trailing")
                    .font(.system(size: 28))
                    .foregroundStyle(Color(red: 0.78, green: 0.66, blue: 0.32))
            }
        }
    }

    private var titleSection: some View {
        VStack(spacing: 4) {
            (Text("The ") + Text("#1 Science Based").fontWeight(.heavy) + Text("\nPhysique Coach"))
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
    }

    private var transformationArea: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.92, green: 0.92, blue: 0.94),
                            Color(red: 0.88, green: 0.88, blue: 0.90)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 320)

            HStack(spacing: 0) {
                VStack(spacing: 12) {
                    Image(systemName: "figure.stand")
                        .font(.system(size: 80, weight: .ultraLight))
                        .foregroundStyle(Color(.systemGray3))
                    Text("Before")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(Color(.separator))
                    .frame(width: 1, height: 200)

                VStack(spacing: 12) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 80, weight: .regular))
                        .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    Text("After")
                        .font(.caption.bold())
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
        }
    }

    private var sourcesBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                ForEach(["NSCA", "ACSM", "Sports Medicine", "J. Strength & Cond."], id: \.self) { source in
                    Text(source)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color(.tertiaryLabel))
                        .textCase(.uppercase)
                        .tracking(0.5)
                }
            }
            .padding(.horizontal, 8)
        }
        .contentMargins(.horizontal, 16)
    }

    private var citationRow: some View {
        HStack(spacing: 8) {
            Image(systemName: "doc.text")
                .font(.caption)
                .foregroundStyle(.tertiary)
            Text("U. Walker et al. (2024). Exercise Physiology...")
                .font(.system(size: 11))
                .foregroundStyle(.tertiary)
                .lineLimit(1)
            Spacer()
            Text("+180")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 4)
    }

    private var bottomSection: some View {
        VStack(spacing: 12) {
            OnboardingCTAButton(title: "Get Started", enabled: true) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.nextStep()
                }
            }

            Button {
                HapticManager.light()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.nextStep()
                }
            } label: {
                Text("Or Login")
                    .font(.subheadline)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            .padding(.bottom, 8)
        }
    }
}
