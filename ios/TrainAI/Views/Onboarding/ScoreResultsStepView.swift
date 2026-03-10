import SwiftUI

struct ScoreResultsStepView: View {
    let viewModel: OnboardingViewModel
    let onGetPlan: () -> Void

    @State private var displayedScore: Double = 0
    @State private var showTier: Bool = false
    @State private var showRadar: Bool = false
    @State private var showDetails: Bool = false
    @State private var tierPulse: Bool = false

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
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer().frame(height: 20)

                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white.opacity(0.08))
                                .shadow(color: .white.opacity(0.05), radius: 30)

                            VStack(spacing: 16) {
                                Text(String(format: "%.1f", displayedScore))
                                    .font(.system(size: 72, weight: .bold))
                                    .foregroundStyle(.white)
                                    .contentTransition(.numericText(countsDown: false))
                                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: displayedScore)

                                if showTier {
                                    TierBadgeView(tierInfo: tierInfo, large: true)
                                        .scaleEffect(tierPulse ? 1.05 : 1.0)
                                        .transition(.scale.combined(with: .opacity))

                                    Text(tierInfo.message)
                                        .font(.body)
                                        .foregroundStyle(.white.opacity(0.6))
                                        .transition(.opacity)
                                }
                            }
                            .padding(.vertical, 32)
                            .padding(.horizontal, 24)
                        }
                        .padding(.horizontal, 8)

                        if showRadar {
                            RadarChartView(
                                values: [scan.symmetry, scan.definition, scan.mass, scan.proportions, scan.vtaper, scan.core],
                                labels: ["Symmetry", "Definition", "Mass", "Proportions", "V-Taper", "Core"],
                                maxValue: 10
                            )
                            .frame(height: 260)
                            .padding(.horizontal, 8)
                            .transition(.opacity)
                        }

                        if showDetails {
                            VStack(spacing: 12) {
                                BodyPartScoreRow(name: "Chest", score: scan.chestScore)
                                BodyPartScoreRow(name: "Back", score: scan.backScore)
                                BodyPartScoreRow(name: "Shoulders", score: scan.shoulderScore)
                                BodyPartScoreRow(name: "Arms", score: scan.armScore)
                                BodyPartScoreRow(name: "Core", score: scan.coreScore)
                                BodyPartScoreRow(name: "Legs", score: scan.legScore)
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .clipShape(.rect(cornerRadius: 16))
                            .transition(.move(edge: .bottom).combined(with: .opacity))

                            VStack(spacing: 8) {
                                Text("Estimated Timeline")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text("Based on your scan and goals, reaching \(TierInfo.tier(for: min(scan.overallScore + 0.5, 10), gender: viewModel.selectedGender).name) will take approximately 8-12 weeks")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.6))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.08))
                            .clipShape(.rect(cornerRadius: 16))
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }

                        Spacer().frame(height: 100)
                    }
                    .padding(.horizontal, 16)
                }

                if showDetails {
                    VStack(spacing: 8) {
                        Button {
                            shareScoreCard()
                        } label: {
                            Text("Share My Score")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.white.opacity(0.12))
                                .clipShape(.rect(cornerRadius: 14))
                        }
                        .padding(.horizontal, 16)

                        Button {
                            HapticManager.light()
                            onGetPlan()
                        } label: {
                            Text("Get My Plan")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .clipShape(.rect(cornerRadius: 14))
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            animateReveal()
        }
    }

    private func animateReveal() {
        Task {
            let targetScore = scan.overallScore
            let steps = 20
            for i in 1...steps {
                try? await Task.sleep(for: .milliseconds(50))
                let progress = Double(i) / Double(steps)
                let eased = 1 - pow(1 - progress, 3)
                displayedScore = (targetScore * eased * 10).rounded() / 10
            }
            displayedScore = targetScore

            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showTier = true
            }
            HapticManager.success()

            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                tierPulse = true
            }
            try? await Task.sleep(for: .milliseconds(200))
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                tierPulse = false
            }

            try? await Task.sleep(for: .milliseconds(400))
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                showRadar = true
            }

            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                showDetails = true
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
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 80, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.1))
                    RoundedRectangle(cornerRadius: 3)
                        .fill(barColor)
                        .frame(width: geo.size.width * (score / 10.0))
                }
            }
            .frame(height: 6)

            Text(String(format: "%.1f", score))
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .frame(width: 32, alignment: .trailing)
        }
    }
}