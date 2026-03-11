import SwiftUI

struct ScoreResultsStepView: View {
    let viewModel: OnboardingViewModel
    let onGetPlan: () -> Void

    @State private var displayedScore: Double = 0
    @State private var showContent: Bool = false
    @State private var showButtons: Bool = false
    @State private var cardBlur: Double = 20
    @State private var cardOpacity: Double = 0

    private var scan: BodyScan {
        viewModel.scanResult ?? BodyScan(
            date: Date(), overallScore: 5.7,
            symmetry: 6.5, definition: 5.3, mass: 5.9,
            proportions: 5.5, vtaper: 5.7, core: 5.2,
            chestScore: 6.0, backScore: 5.5, shoulderScore: 6.4,
            armScore: 5.7, coreScore: 5.2, legScore: 5.3,
            tierName: "High-Tier Chadlite"
        )
    }

    private var tierInfo: TierInfo {
        TierInfo.tier(for: scan.overallScore, gender: viewModel.selectedGender)
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        scoreHeader
                            .blur(radius: cardBlur)
                            .opacity(cardOpacity)
                            .padding(.top, 24)
                            .padding(.horizontal, 20)

                        if showContent {
                            bodyAnalysisSection
                                .padding(.top, 16)
                                .transition(.opacity)
                        }

                        Spacer().frame(height: 120)
                    }
                }

                if showButtons {
                    bottomButtons
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            animateReveal()
        }
    }

    private var scoreHeader: some View {
        VStack(spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(String(format: "%.1f", displayedScore))
                    .font(.system(size: 56, weight: .bold))
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText(countsDown: false))
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: displayedScore)

                Text("/10")
                    .font(.title2.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            TierBadgeView(tierInfo: tierInfo, large: false)

            Text(tierInfo.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
    }

    private var bodyAnalysisSection: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.black
                    .clipShape(.rect(cornerRadius: 20))

                BodyAnalysisView(scan: scan, gender: viewModel.selectedGender)
            }
            .padding(.horizontal, 16)
        }
    }

    private var bottomButtons: some View {
        VStack(spacing: 8) {
            Button {
                shareScoreCard()
            } label: {
                Text("Share My Score")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 14))
            }

            Button {
                HapticManager.light()
                onGetPlan()
            } label: {
                Text("Get My Plan")
                    .font(.headline)
                    .foregroundStyle(Color(.systemBackground))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primary)
                    .clipShape(.rect(cornerRadius: 14))
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    private func animateReveal() {
        Task {
            withAnimation(.easeOut(duration: 0.8)) {
                cardBlur = 0
                cardOpacity = 1
            }

            try? await Task.sleep(for: .milliseconds(400))

            let targetScore = scan.overallScore
            let steps = 20
            for i in 1...steps {
                try? await Task.sleep(for: .milliseconds(50))
                let progress = Double(i) / Double(steps)
                let eased = 1 - pow(1 - progress, 3)
                displayedScore = (targetScore * eased * 10).rounded() / 10
            }
            displayedScore = targetScore
            HapticManager.success()

            try? await Task.sleep(for: .milliseconds(400))
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                showContent = true
            }

            try? await Task.sleep(for: .milliseconds(600))
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                showButtons = true
            }
        }
    }

    private func shareScoreCard() {
        let image = ScoreCardRenderer.renderShareCard(
            score: scan.overallScore,
            tierName: tierInfo.name,
            tierColor: tierInfo.color,
            radarValues: [scan.symmetry, scan.definition, scan.mass, scan.proportions, scan.vtaper, scan.core],
            date: scan.date
        )
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct BodyPartScoreRow: View {
    let name: String
    let score: Double

    private var barColor: Color {
        if score < 4 { return Color(red: 0.94, green: 0.27, blue: 0.27) }
        if score < 6 { return Color(red: 0.96, green: 0.62, blue: 0.04) }
        return Color(red: 0.13, green: 0.77, blue: 0.37)
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(name)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(.systemGray5))
                    RoundedRectangle(cornerRadius: 3)
                        .fill(barColor)
                        .frame(width: geo.size.width * (score / 10.0))
                }
            }
            .frame(height: 6)

            Text(String(format: "%.1f", score))
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
                .frame(width: 32, alignment: .trailing)
        }
    }
}
