import SwiftUI

struct ResultsStepView: View {
    let viewModel: OnboardingViewModel
    @State private var displayedScore: Double = 0
    @State private var showMeasurements: Bool = false
    @State private var showTier: Bool = false
    @State private var showGrid: Bool = false
    @State private var scoreBlur: Double = 4
    @State private var scoreOpacity: Double = 0

    private var scan: BodyScan {
        viewModel.scanResult ?? BodyScan(
            date: Date(), overallScore: 5.7,
            symmetry: 6.5, definition: 5.3, mass: 5.9,
            proportions: 5.5, vtaper: 5.7, core: 5.2,
            chestScore: 6.0, backScore: 5.5, shoulderScore: 6.4,
            armScore: 5.7, coreScore: 5.2, legScore: 5.3,
            tierName: TierInfo.tier(for: 5.7, gender: viewModel.selectedGender).name
        )
    }

    private var tierInfo: TierInfo {
        TierInfo.tier(for: scan.overallScore, gender: viewModel.selectedGender)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Text("Your Results")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.top, 32)

                    bodyWithMeasurements

                    scoreSection
                        .blur(radius: scoreBlur)
                        .opacity(scoreOpacity)

                    if showTier {
                        TierBadgeView(tierInfo: tierInfo, large: true)
                            .transition(.scale.combined(with: .opacity))
                    }

                    if showGrid {
                        attributeGrid
                            .transition(.opacity)
                    }

                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 20)
            }

            VStack {
                Spacer()
                OnboardingCTAButton(title: "Continue", enabled: true) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                        viewModel.nextStep()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear { animateReveal() }
    }

    private var bodyWithMeasurements: some View {
        ZStack {
            Image(systemName: "figure.stand")
                .font(.system(size: 140, weight: .ultraLight))
                .foregroundStyle(.white.opacity(0.15))

            if showMeasurements {
                VStack(spacing: 40) {
                    measurementLine(label: "6.4", width: 120)
                    measurementLine(label: "5.7", width: 80)
                    measurementLine(label: "5.2", width: 100)
                }
                .transition(.opacity)
            }
        }
        .frame(height: 260)
    }

    private func measurementLine(label: String, width: CGFloat) -> some View {
        HStack(spacing: 8) {
            Circle().fill(.white).frame(width: 4, height: 4)
            Rectangle().fill(.white.opacity(0.4)).frame(width: width, height: 1)
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(.white.opacity(0.15))
                .clipShape(Capsule())
            Rectangle().fill(.white.opacity(0.4)).frame(width: width, height: 1)
            Circle().fill(.white).frame(width: 4, height: 4)
        }
    }

    private var scoreSection: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(String(format: "%.1f", displayedScore))
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .contentTransition(.numericText(countsDown: false))
                .shadow(color: .white.opacity(0.08), radius: 20)

            Text("/10")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.gray)
        }
    }

    private var attributeGrid: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                attributeCell("Body Fat", value: "~15%", locked: false)
                attributeCell("Muscle Mass", value: "Med", locked: false)
                attributeCell("Symmetry", value: "High", locked: false)
            }
            HStack(spacing: 2) {
                attributeCell("Shoulder-Waist", value: "1.42", locked: true)
                attributeCell("V-Taper", value: "Good", locked: true)
                attributeCell("Proportions", value: "5.5", locked: true)
            }
            HStack(spacing: 2) {
                attributeCell("Definition", value: "Med", locked: true)
                attributeCell("Posture", value: "Good", locked: true)
                attributeCell("Core", value: "5.2", locked: true)
            }
        }
        .clipShape(.rect(cornerRadius: 16))
    }

    private func attributeCell(_ title: String, value: String, locked: Bool) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.gray)
            if locked {
                ZStack {
                    Text(value)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .blur(radius: 6)
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                }
            } else {
                Text(value)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.06))
    }

    private func animateReveal() {
        Task {
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                showMeasurements = true
            }

            withAnimation(.easeOut(duration: 0.5).delay(0.8)) {
                scoreBlur = 0
                scoreOpacity = 1
            }

            try? await Task.sleep(for: .seconds(1))

            let targetScore = scan.overallScore
            let steps = 25
            for i in 1...steps {
                try? await Task.sleep(for: .milliseconds(60))
                let progress = Double(i) / Double(steps)
                let eased = 1 - pow(1 - progress, 3)
                displayedScore = (targetScore * eased * 10).rounded() / 10
                if i % 5 == 0 { HapticManager.light() }
            }
            displayedScore = targetScore
            HapticManager.success()

            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showTier = true
            }

            try? await Task.sleep(for: .milliseconds(400))
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                showGrid = true
            }
        }
    }
}

