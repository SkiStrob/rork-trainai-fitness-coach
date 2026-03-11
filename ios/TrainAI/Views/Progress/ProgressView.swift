import SwiftUI
import SwiftData
import Charts

struct ProgressTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appColors) private var colors
    @Query(sort: \BodyScan.date) private var scans: [BodyScan]
    @Query(sort: \WeightEntry.date) private var weightEntries: [WeightEntry]
    @Query(sort: \UserProfile.createdAt) private var profiles: [UserProfile]
    @State private var selectedSegment: Int = 0
    @State private var weightTimeRange: Int = 90
    @State private var showLogWeight: Bool = false

    private var profile: UserProfile? { profiles.first }
    private let segments = ["Body Score", "Weight", "Strength"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    segmentedPicker

                    switch selectedSegment {
                    case 0: bodyScoreSection
                    case 1: weightSection
                    case 2: strengthSection
                    default: EmptyView()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(colors.background)
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showLogWeight) {
                LogWeightSheet()
                    .presentationDetents([.height(200)])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var segmentedPicker: some View {
        HStack(spacing: 8) {
            ForEach(0..<segments.count, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                        selectedSegment = i
                    }
                    HapticManager.selection()
                } label: {
                    Text(segments[i])
                        .font(.subheadline.bold())
                        .foregroundStyle(selectedSegment == i ? colors.selectedCardText : colors.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedSegment == i ? colors.selectedCard : colors.inputBackground)
                        .clipShape(Capsule())
                }
            }
            Spacer()
        }
    }

    private var bodyScoreSection: some View {
        VStack(spacing: 20) {
            if let latest = scans.last {
                let tierInfo = TierInfo.tier(for: latest.overallScore, gender: profile?.gender ?? "Male")

                HStack(spacing: 16) {
                    if let photoData = latest.frontPhotoData, !photoData.isEmpty,
                       let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 100)
                            .clipShape(.rect(cornerRadius: 12))
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray5))
                                .frame(width: 80, height: 100)
                            Image(systemName: "figure.stand")
                                .font(.title)
                                .foregroundStyle(.secondary)
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(String(format: "%.1f", latest.overallScore))
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(colors.primaryText)
                            Text("/10")
                                .font(.subheadline)
                                .foregroundStyle(colors.secondaryText)
                        }
                        TierBadgeView(tierInfo: tierInfo)
                        Text(latest.date.formatted(.dateTime.month(.abbreviated).day()))
                            .font(.caption)
                            .foregroundStyle(colors.secondaryText)
                    }

                    Spacer()
                }
                .padding(20)
                .background(colors.cardBackground)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(color: colors.cardShadow, radius: 8, y: 2)

                if scans.count > 1 {
                    photoComparisonCard

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Score Trend")
                            .font(.subheadline.bold())
                            .foregroundStyle(colors.secondaryText)

                        Chart(scans) { scan in
                            LineMark(
                                x: .value("Date", scan.date),
                                y: .value("Score", scan.overallScore)
                            )
                            .foregroundStyle(Color(red: 0.13, green: 0.77, blue: 0.37))
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(lineWidth: 2.5))

                            AreaMark(
                                x: .value("Date", scan.date),
                                y: .value("Score", scan.overallScore)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(red: 0.13, green: 0.77, blue: 0.37).opacity(0.15), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .interpolationMethod(.catmullRom)

                            PointMark(
                                x: .value("Date", scan.date),
                                y: .value("Score", scan.overallScore)
                            )
                            .foregroundStyle(Color(red: 0.13, green: 0.77, blue: 0.37))
                            .symbolSize(30)
                        }
                        .chartYScale(domain: 0...10)
                        .chartYAxis {
                            AxisMarks(values: [0, 5, 10]) { _ in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.3))
                                    .foregroundStyle(colors.separator)
                                AxisValueLabel()
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .chartXAxis {
                            AxisMarks { _ in
                                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(height: 180)
                    }
                    .padding(20)
                    .background(colors.cardBackground)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(color: colors.cardShadow, radius: 8, y: 2)
                }

                RadarChartView(
                    values: [latest.symmetry, latest.definition, latest.mass, latest.proportions, latest.vtaper, latest.core],
                    labels: ["Symmetry", "Definition", "Mass", "Proportions", "V-Taper", "Core"],
                    maxValue: 10
                )
                .frame(height: 240)
                .padding(20)
                .background(colors.cardBackground)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(color: colors.cardShadow, radius: 8, y: 2)

                bodyPartBreakdown(latest)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "figure.stand")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("No scans yet")
                        .font(.headline)
                        .foregroundStyle(colors.primaryText)
                    Text("Take your first body scan to see your progress.")
                        .font(.subheadline)
                        .foregroundStyle(colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            }
        }
    }

    private var photoComparisonCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Photo Comparison")
                    .font(.subheadline.bold())
                    .foregroundStyle(colors.secondaryText)
                Spacer()
                Text("Take daily photos")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                if scans.count >= 2 {
                    let first = scans.first!
                    let last = scans.last!

                    photoTile(scan: first, label: "Start")
                    
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    photoTile(scan: last, label: "Current")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }

    private func photoTile(scan: BodyScan, label: String) -> some View {
        VStack(spacing: 6) {
            if let photoData = scan.frontPhotoData, !photoData.isEmpty,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 130)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        .frame(width: 100, height: 130)
                    Image(systemName: "figure.stand")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }

            Text(label)
                .font(.caption.bold())
                .foregroundStyle(colors.secondaryText)

            Text(String(format: "%.1f/10", scan.overallScore))
                .font(.caption2)
                .foregroundStyle(colors.primaryText)
        }
    }

    private func bodyPartBreakdown(_ scan: BodyScan) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Body Part Scores")
                .font(.subheadline.bold())
                .foregroundStyle(colors.secondaryText)

            BodyPartScoreRow(name: "Chest", score: scan.chestScore)
            BodyPartScoreRow(name: "Back", score: scan.backScore)
            BodyPartScoreRow(name: "Shoulders", score: scan.shoulderScore)
            BodyPartScoreRow(name: "Arms", score: scan.armScore)
            BodyPartScoreRow(name: "Core", score: scan.coreScore)
            BodyPartScoreRow(name: "Legs", score: scan.legScore)
        }
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }

    private var weightSection: some View {
        VStack(spacing: 24) {
            HStack(spacing: 16) {
                SummaryCard(icon: "scalemass.fill", label: "Last weight", value: weightEntries.last.map { "\(Int($0.weightLbs)) lbs" } ?? "--")
                SummaryCard(icon: "apple.logo", label: "Days logged", value: "\(weightEntries.count)")
            }

            HStack {
                Text("Goal Progress")
                    .font(.headline)
                    .foregroundStyle(colors.primaryText)
                Spacer()
                Button {
                    showLogWeight = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
            }

            HStack(spacing: 8) {
                ForEach(["90 Days", "6 Months", "1 Year", "All time"], id: \.self) { label in
                    let days = label == "90 Days" ? 90 : label == "6 Months" ? 180 : label == "1 Year" ? 365 : 0
                    Button {
                        withAnimation { weightTimeRange = days }
                    } label: {
                        Text(label)
                            .font(.caption.bold())
                            .foregroundStyle(weightTimeRange == days ? colors.selectedCardText : colors.primaryText)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(weightTimeRange == days ? colors.selectedCard : colors.inputBackground)
                            .clipShape(Capsule())
                    }
                }
                Spacer()
            }

            if !weightEntries.isEmpty {
                let filtered = filterWeightEntries(days: weightTimeRange)
                if !filtered.isEmpty {
                    Chart(filtered) { entry in
                        LineMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weightLbs)
                        )
                        .foregroundStyle(Color(red: 0.13, green: 0.77, blue: 0.37))
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 2.5))

                        AreaMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weightLbs)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(red: 0.13, green: 0.77, blue: 0.37).opacity(0.15), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weightLbs)
                        )
                        .foregroundStyle(Color(red: 0.13, green: 0.77, blue: 0.37))
                        .symbolSize(30)
                    }
                    .chartYAxis {
                        AxisMarks { _ in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.3))
                                .foregroundStyle(colors.separator)
                            AxisValueLabel()
                                .foregroundStyle(.secondary)
                        }
                    }
                    .chartXAxis {
                        AxisMarks { _ in
                            AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(height: 200)
                    .padding(20)
                    .background(colors.cardBackground)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(color: colors.cardShadow, radius: 8, y: 2)
                }
            } else {
                Text("No weight data yet")
                    .font(.subheadline)
                    .foregroundStyle(colors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            }
        }
    }

    private var strengthSection: some View {
        VStack(spacing: 12) {
            PRRow(exercise: "Bench Press", pr: "185 lbs x 8", date: "Feb 28")
            PRRow(exercise: "Barbell Squats", pr: "245 lbs x 6", date: "Mar 5")
            PRRow(exercise: "Barbell Rows", pr: "155 lbs x 10", date: "Mar 8")
            PRRow(exercise: "Overhead Press", pr: "115 lbs x 8", date: "Mar 1")
        }
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }

    private func filterWeightEntries(days: Int) -> [WeightEntry] {
        guard days > 0 else { return weightEntries }
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return weightEntries.filter { $0.date >= cutoff }
    }
}

struct SummaryCard: View {
    @Environment(\.appColors) private var colors
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(colors.progressTrack, lineWidth: 3)
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            Text(value)
                .font(.headline.bold())
                .foregroundStyle(colors.primaryText)

            Text(label)
                .font(.caption)
                .foregroundStyle(colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }
}

struct PRRow: View {
    @Environment(\.appColors) private var colors
    let exercise: String
    let pr: String
    let date: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise)
                    .font(.subheadline)
                    .foregroundStyle(colors.primaryText)
                Text(date)
                    .font(.caption)
                    .foregroundStyle(colors.secondaryText)
            }
            Spacer()
            Text(pr)
                .font(.subheadline.bold())
                .foregroundStyle(colors.primaryText)
        }
        .padding(.vertical, 4)
    }
}

struct LogWeightSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var weight: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Log Weight")
                .font(.headline)
                .foregroundStyle(.primary)

            HStack(spacing: 8) {
                TextField("Weight", text: $weight)
                    .keyboardType(.decimalPad)
                    .font(.title.bold())
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 10))
                    .frame(width: 150)

                Text("lbs")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            Button {
                if let w = Double(weight) {
                    let entry = WeightEntry(date: Date(), weightLbs: w)
                    modelContext.insert(entry)
                    HapticManager.success()
                    dismiss()
                }
            } label: {
                Text("Save")
                    .font(.headline)
                    .foregroundStyle(Color(.systemBackground))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.primary)
                    .clipShape(.rect(cornerRadius: 14))
            }
            .disabled(weight.isEmpty)
            .padding(.horizontal, 16)
        }
        .padding(.top, 16)
    }
}
