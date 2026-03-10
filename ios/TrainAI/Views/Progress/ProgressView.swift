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
    @State private var weightTimeRange: Int = 30
    @State private var showLogWeight: Bool = false

    private var profile: UserProfile? { profiles.first }
    private let segments = ["Body Score", "Weight", "Strength", "Photos"]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    segmentedPicker

                    switch selectedSegment {
                    case 0: bodyScoreSection
                    case 1: weightSection
                    case 2: strengthSection
                    case 3: photosSection
                    default: EmptyView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
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
        ScrollView(.horizontal) {
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
            }
        }
        .scrollIndicators(.hidden)
        .padding(.top, 4)
    }

    private var bodyScoreSection: some View {
        VStack(spacing: 16) {
            if let latest = scans.last {
                let tierInfo = TierInfo.tier(for: latest.overallScore, gender: profile?.gender ?? "Male")

                VStack(spacing: 8) {
                    Text(String(format: "%.1f", latest.overallScore))
                        .font(.system(size: 56, weight: .bold))
                        .foregroundStyle(colors.primaryText)
                    TierBadgeView(tierInfo: tierInfo)
                }
                .frame(maxWidth: .infinity)
                .cardStyle()

                if scans.count > 1 {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Score Trend")
                            .font(.headline)
                            .foregroundStyle(colors.primaryText)

                        Chart(scans) { scan in
                            LineMark(
                                x: .value("Date", scan.date),
                                y: .value("Score", scan.overallScore)
                            )
                            .foregroundStyle(.blue)
                            .interpolationMethod(.catmullRom)

                            AreaMark(
                                x: .value("Date", scan.date),
                                y: .value("Score", scan.overallScore)
                            )
                            .foregroundStyle(.blue.opacity(0.08))
                            .interpolationMethod(.catmullRom)

                            PointMark(
                                x: .value("Date", scan.date),
                                y: .value("Score", scan.overallScore)
                            )
                            .foregroundStyle(.blue)
                        }
                        .chartYScale(domain: 0...10)
                        .chartYAxis {
                            AxisMarks(values: [0, 2, 4, 6, 8, 10]) { _ in
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
                    }
                    .cardStyle()
                }

                RadarChartView(
                    values: [latest.symmetry, latest.definition, latest.mass, latest.proportions, latest.vtaper, latest.core],
                    labels: ["Symmetry", "Definition", "Mass", "Proportions", "V-Taper", "Core"],
                    maxValue: 10
                )
                .frame(height: 260)
                .cardStyle()

                VStack(spacing: 12) {
                    Text("Body Part Scores")
                        .font(.headline)
                        .foregroundStyle(colors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    BodyPartScoreRow(name: "Chest", score: latest.chestScore)
                    BodyPartScoreRow(name: "Back", score: latest.backScore)
                    BodyPartScoreRow(name: "Shoulders", score: latest.shoulderScore)
                    BodyPartScoreRow(name: "Arms", score: latest.armScore)
                    BodyPartScoreRow(name: "Core", score: latest.coreScore)
                    BodyPartScoreRow(name: "Legs", score: latest.legScore)
                }
                .cardStyle()
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "figure.stand")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("No scans yet")
                        .font(.headline)
                        .foregroundStyle(colors.primaryText)
                    Text("Complete your first body scan to track progress")
                        .font(.subheadline)
                        .foregroundStyle(colors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            }
        }
    }

    private var weightSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Log Weight")
                    .font(.headline)
                    .foregroundStyle(colors.primaryText)
                Spacer()
                Button {
                    showLogWeight = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.blue)
                }
            }
            .cardStyle()

            if !weightEntries.isEmpty {
                HStack(spacing: 8) {
                    ForEach([7, 30, 90, 0], id: \.self) { days in
                        Button {
                            withAnimation { weightTimeRange = days }
                        } label: {
                            Text(days == 0 ? "All" : "\(days)d")
                                .font(.caption.bold())
                                .foregroundStyle(weightTimeRange == days ? colors.selectedCardText : colors.primaryText)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(weightTimeRange == days ? colors.selectedCard : colors.inputBackground)
                                .clipShape(Capsule())
                        }
                    }
                }

                let filtered = filterWeightEntries(days: weightTimeRange)
                if !filtered.isEmpty {
                    Chart(filtered) { entry in
                        LineMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weightLbs)
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.catmullRom)

                        AreaMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weightLbs)
                        )
                        .foregroundStyle(.blue.opacity(0.08))
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weightLbs)
                        )
                        .foregroundStyle(.blue)
                        .symbolSize(20)
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
                    .cardStyle()
                }
            } else {
                VStack(spacing: 8) {
                    Text("No weight data")
                        .font(.subheadline)
                        .foregroundStyle(colors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            }
        }
    }

    private var strengthSection: some View {
        VStack(spacing: 12) {
            Text("Personal Records")
                .font(.headline)
                .foregroundStyle(colors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            PRRow(exercise: "Bench Press", pr: "185 lbs × 8", date: "Feb 28")
            PRRow(exercise: "Barbell Squats", pr: "245 lbs × 6", date: "Mar 5")
            PRRow(exercise: "Barbell Rows", pr: "155 lbs × 10", date: "Mar 8")
            PRRow(exercise: "Overhead Press", pr: "115 lbs × 8", date: "Mar 1")
            PRRow(exercise: "Romanian Deadlifts", pr: "205 lbs × 8", date: "Mar 6")
        }
        .cardStyle()
    }

    private var photosSection: some View {
        VStack(spacing: 12) {
            if scans.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("No scan photos yet")
                        .font(.subheadline)
                        .foregroundStyle(colors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(scans) { scan in
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colors.inputBackground)
                                .frame(height: 160)
                                .overlay {
                                    VStack(spacing: 4) {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 36))
                                            .foregroundStyle(.secondary)
                                        Text(String(format: "%.1f", scan.overallScore))
                                            .font(.caption.bold())
                                            .foregroundStyle(colors.primaryText)
                                    }
                                }

                            Text(scan.date.formatted(.dateTime.month(.abbreviated).day()))
                                .font(.caption)
                                .foregroundStyle(colors.secondaryText)
                        }
                    }
                }
            }
        }
        .cardStyle()
    }

    private func filterWeightEntries(days: Int) -> [WeightEntry] {
        guard days > 0 else { return weightEntries }
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return weightEntries.filter { $0.date >= cutoff }
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
            HStack(spacing: 4) {
                Image(systemName: "trophy.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
                Text(pr)
                    .font(.subheadline.bold())
                    .foregroundStyle(colors.primaryText)
            }
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
                    .clipShape(.rect(cornerRadius: 12))
            }
            .disabled(weight.isEmpty)
            .padding(.horizontal, 16)
        }
        .padding(.top, 16)
    }
}
