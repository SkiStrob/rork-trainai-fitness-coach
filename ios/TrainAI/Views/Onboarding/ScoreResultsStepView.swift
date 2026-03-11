import SwiftUI

struct ScoreResultsStepView: View {
    let viewModel: OnboardingViewModel
    let onGetPlan: () -> Void

    @State private var displayedScore: Double = 0
    @State private var showContent: Bool = false
    @State private var showButtons: Bool = false
    @State private var contentBlur: Double = 8
    @State private var contentOpacity: Double = 0

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
                    VStack(spacing: 24) {
                        scoreHeader
                            .blur(radius: contentBlur)
                            .opacity(contentOpacity)
                            .padding(.top, 32)

                        if showContent {
                            VStack(spacing: 24) {
                                dailyRecommendation

                                bodyAnalysisPreview

                                radarSection

                                bodyPartScores

                                timelineCard
                            }
                            .transition(.opacity)
                        }

                        Spacer().frame(height: 120)
                    }
                    .padding(.horizontal, 20)
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
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("All done!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("Your physique score")
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
            }

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(String(format: "%.1f", displayedScore))
                    .font(.system(size: 64, weight: .bold))
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
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 20))
    }

    private var dailyRecommendation: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily recommendation")
                .font(.headline)
                .foregroundStyle(.primary)

            Text("You can edit this anytime.")
                .font(.caption)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                RecommendationTile(icon: "flame.fill", color: .green, label: "Calories", value: "2,583")
                RecommendationTile(icon: "c.circle.fill", color: .orange, label: "Carbs", value: "300g")
                RecommendationTile(icon: "p.circle.fill", color: Color(red: 0.9, green: 0.3, blue: 0.3), label: "Protein", value: "184g")
                RecommendationTile(icon: "f.circle.fill", color: Color(red: 0.3, green: 0.5, blue: 0.9), label: "Fats", value: "71g")
            }
        }
        .padding(20)
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(.rect(cornerRadius: 20))
    }

    private var bodyAnalysisPreview: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Body Analysis")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Text("View Detail")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            ZStack {
                Color.black
                    .clipShape(.rect(cornerRadius: 16))

                BodyAnalysisView(scan: scan, gender: viewModel.selectedGender)
                    .frame(height: 500)
            }
            .frame(height: 500)
        }
    }

    private var radarSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Attribute Scores")
                .font(.headline)
                .foregroundStyle(.primary)

            RadarChartView(
                values: [scan.symmetry, scan.definition, scan.mass, scan.proportions, scan.vtaper, scan.core],
                labels: ["Symmetry", "Definition", "Mass", "Proportions", "V-Taper", "Core"],
                maxValue: 10
            )
            .frame(height: 220)
        }
        .padding(20)
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(.rect(cornerRadius: 20))
    }

    private var bodyPartScores: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Body Part Scores")
                .font(.headline)
                .foregroundStyle(.primary)

            BodyPartScoreRow(name: "Chest", score: scan.chestScore)
            BodyPartScoreRow(name: "Back", score: scan.backScore)
            BodyPartScoreRow(name: "Shoulders", score: scan.shoulderScore)
            BodyPartScoreRow(name: "Arms", score: scan.armScore)
            BodyPartScoreRow(name: "Core", score: scan.coreScore)
            BodyPartScoreRow(name: "Legs", score: scan.legScore)
        }
        .padding(20)
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(.rect(cornerRadius: 20))
    }

    private var timelineCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your Timeline")
                .font(.headline)
                .foregroundStyle(.primary)

            TimelineStep(icon: "calendar", iconColor: .blue, title: "Week 1-2", subtitle: "Build foundation, learn movements", isLast: false)
            TimelineStep(icon: "flame.fill", iconColor: .orange, title: "Week 3-6", subtitle: "Progressive overload begins", isLast: false)
            TimelineStep(icon: "chart.line.uptrend.xyaxis", iconColor: .green, title: "Week 7-12", subtitle: "Visible physique changes", isLast: true)
        }
        .padding(20)
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(.rect(cornerRadius: 20))
    }

    private var bottomButtons: some View {
        VStack(spacing: 8) {
            Button {
                HapticManager.light()
                onGetPlan()
            } label: {
                Text("Let's get started!")
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
            withAnimation(.easeOut(duration: 0.6)) {
                contentBlur = 0
                contentOpacity = 1
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

struct RecommendationTile: View {
    let icon: String
    let color: Color
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)
            }

            Spacer()
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(.rect(cornerRadius: 12))
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

struct TimelineStep: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(iconColor)
                    .frame(width: 32, height: 32)

                if !isLast {
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(width: 2, height: 40)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, isLast ? 0 : 16)

            Spacer()
        }
    }
}
