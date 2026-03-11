import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appColors) private var colors
    @Query(sort: \BodyScan.date, order: .reverse) private var scans: [BodyScan]
    @Query(sort: \WorkoutProgram.name) private var programs: [WorkoutProgram]
    @Query(sort: \UserProfile.createdAt) private var profiles: [UserProfile]
    @Query(sort: \FoodEntry.date, order: .reverse) private var allFoodEntries: [FoodEntry]
    @State private var viewModel = HomeViewModel()
    @State private var ringsAppeared: Bool = false
    @State private var cardsAppeared: Bool = false
    @Binding var showSettings: Bool

    private var profile: UserProfile? { profiles.first }
    private var latestScan: BodyScan? { scans.first }

    private var todayEntries: [FoodEntry] {
        let today = Calendar.current.startOfDay(for: Date())
        return allFoodEntries.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }

    private var todayWorkout: ProgramDay? {
        let weekday = Calendar.current.component(.weekday, from: Date())
        let adjustedDay = weekday == 1 ? 7 : weekday - 1
        return programs.first(where: { $0.isActive })?.days.first(where: { $0.dayOfWeek == adjustedDay })
    }

    private var workoutDuration: String {
        guard let day = todayWorkout, !day.isRestDay else { return "" }
        let exerciseCount = day.exercises.count
        let totalSets = day.exercises.reduce(0) { $0 + $1.targetSets }
        let minutes = totalSets * 2 + exerciseCount * 3
        if minutes < 10 { return "~5 min" }
        return "~\(Int((Double(minutes) / 5).rounded()) * 5) min"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    weekCalendarStrip
                        .blurFadeIn(visible: cardsAppeared, delay: 0)

                    calorieCard
                        .blurFadeIn(visible: cardsAppeared, delay: 0.05)

                    macroCards
                        .blurFadeIn(visible: cardsAppeared, delay: 0.1)

                    if let scan = latestScan {
                        bodyScoreCard(scan)
                            .blurFadeIn(visible: cardsAppeared, delay: 0.12)
                    }

                    if todayWorkout != nil {
                        todayWorkoutCard
                            .blurFadeIn(visible: cardsAppeared, delay: 0.15)
                    }

                    if !todayEntries.isEmpty {
                        recentlyLoggedSection
                            .blurFadeIn(visible: cardsAppeared, delay: 0.2)
                    }

                    recentlyUploadedSection
                        .blurFadeIn(visible: cardsAppeared, delay: 0.25)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(colors.background)
            .refreshable {
                HapticManager.light()
                viewModel.loadData(context: modelContext)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 6) {
                        ZStack {
                            ScanBrackets()
                                .stroke(Color.primary.opacity(0.5), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                                .frame(width: 24, height: 24)

                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.primary)
                        }

                        Text("TrainAI")
                            .font(.subheadline.bold())
                            .foregroundStyle(colors.primaryText)
                    }
                    .padding(.leading, -4)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        if let streak = profile?.currentStreak, streak > 0 {
                            HStack(spacing: 3) {
                                Image(systemName: "flame.fill")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                                Text("\(streak)")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(colors.primaryText)
                            }
                        }

                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.body)
                                .foregroundStyle(colors.primaryText)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.loadData(context: modelContext)
                withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.1)) {
                    cardsAppeared = true
                }
            }
        }
    }

    private var weekCalendarStrip: some View {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today) ?? today
        let dayLabels = ["S", "M", "T", "W", "T", "F", "S"]

        return HStack(spacing: 0) {
            ForEach(0..<7, id: \.self) { i in
                let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) ?? today
                let dayNum = calendar.component(.day, from: day)
                let isToday = calendar.isDateInToday(day)

                VStack(spacing: 6) {
                    Text(dayLabels[i])
                        .font(.caption2)
                        .foregroundStyle(colors.secondaryText)

                    Text("\(dayNum)")
                        .font(.subheadline.weight(isToday ? .bold : .regular))
                        .foregroundStyle(isToday ? colors.selectedCardText : colors.primaryText)
                        .frame(width: 32, height: 32)
                        .background(isToday ? colors.selectedCard : Color.clear)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 12)
    }

    private var calorieCard: some View {
        let remaining = max(0, viewModel.calorieGoal - viewModel.todayCalories)
        let progress = min(Double(viewModel.todayCalories) / Double(viewModel.calorieGoal), 1.0)

        return HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(remaining)")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(colors.primaryText)
                    .contentTransition(.numericText())

                Text("Calories left")
                    .font(.subheadline)
                    .foregroundStyle(colors.secondaryText)
            }

            Spacer()

            ZStack {
                Circle()
                    .stroke(colors.progressTrack, lineWidth: 8)

                Circle()
                    .trim(from: 0, to: ringsAppeared ? progress : 0)
                    .stroke(
                        Color.black.opacity(0.8),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3), value: ringsAppeared)

                Image(systemName: "flame.fill")
                    .font(.body)
                    .foregroundStyle(colors.primaryText)
            }
            .frame(width: 64, height: 64)
        }
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
        .onAppear {
            ringsAppeared = true
        }
    }

    private var macroCards: some View {
        HStack(spacing: 12) {
            MacroMiniCard(
                label: "Protein",
                remaining: max(0, viewModel.proteinGoal - viewModel.todayProtein),
                goal: viewModel.proteinGoal,
                color: Color(red: 0.9, green: 0.3, blue: 0.3),
                animated: ringsAppeared
            )

            MacroMiniCard(
                label: "Carbs",
                remaining: max(0, 300 - Int(todayEntries.reduce(0.0) { $0 + $1.carbsGrams })),
                goal: 300,
                color: Color.orange,
                animated: ringsAppeared
            )

            MacroMiniCard(
                label: "Fat",
                remaining: max(0, 80 - Int(todayEntries.reduce(0.0) { $0 + $1.fatGrams })),
                goal: 80,
                color: Color(red: 0.3, green: 0.5, blue: 0.9),
                animated: ringsAppeared
            )
        }
    }

    private func bodyScoreCard(_ scan: BodyScan) -> some View {
        let tierInfo = TierInfo.tier(for: scan.overallScore, gender: profile?.gender ?? "Male")

        return VStack(spacing: 12) {
            HStack {
                Text("Body Score")
                    .font(.subheadline.bold())
                    .foregroundStyle(colors.secondaryText)
                Spacer()
                Text("View Analysis")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 16) {
                if let photoData = scan.frontPhotoData, !photoData.isEmpty,
                   let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 80)
                        .clipShape(.rect(cornerRadius: 10))
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray5))
                            .frame(width: 60, height: 80)
                        Image(systemName: "figure.stand")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(String(format: "%.1f", scan.overallScore))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(colors.primaryText)
                        Text("/10")
                            .font(.subheadline)
                            .foregroundStyle(colors.secondaryText)
                    }

                    TierBadgeView(tierInfo: tierInfo)
                }

                Spacer()

                VStack(spacing: 4) {
                    Text("Take daily")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Image(systemName: "camera.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }

    private var todayWorkoutCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let day = todayWorkout {
                if day.isRestDay {
                    HStack(spacing: 8) {
                        Image(systemName: "bed.double.fill")
                            .foregroundStyle(.secondary)
                        Text("Rest Day")
                            .font(.headline)
                            .foregroundStyle(colors.primaryText)
                    }
                } else {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(day.workoutName)
                                .font(.headline)
                                .foregroundStyle(colors.primaryText)
                            Text(day.muscleGroups)
                                .font(.subheadline)
                                .foregroundStyle(colors.secondaryText)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.caption2)
                                    .foregroundStyle(colors.secondaryText)
                                Text(workoutDuration)
                                    .font(.caption.bold())
                                    .foregroundStyle(colors.primaryText)
                            }
                            Text("\(day.exercises.count) exercises")
                                .font(.caption)
                                .foregroundStyle(colors.secondaryText)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }

    private var recentlyLoggedSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Recently logged")
                .font(.subheadline.bold())
                .foregroundStyle(colors.secondaryText)

            ForEach(todayEntries.prefix(3)) { entry in
                HStack(spacing: 12) {
                    if let photoData = entry.photoData, !photoData.isEmpty,
                       let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .clipShape(.rect(cornerRadius: 8))
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                                .frame(width: 44, height: 44)
                            Image(systemName: "fork.knife")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.name)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(colors.primaryText)
                            .lineLimit(1)
                        Text("\(entry.calories) cal")
                            .font(.caption)
                            .foregroundStyle(colors.secondaryText)
                    }

                    Spacer()

                    HStack(spacing: 6) {
                        Text("P:\(Int(entry.proteinGrams))g")
                            .font(.caption2.bold())
                            .foregroundStyle(Color(red: 0.9, green: 0.3, blue: 0.3))
                        Text("C:\(Int(entry.carbsGrams))g")
                            .font(.caption2.bold())
                            .foregroundStyle(.orange)
                        Text("F:\(Int(entry.fatGrams))g")
                            .font(.caption2.bold())
                            .foregroundStyle(Color(red: 0.3, green: 0.5, blue: 0.9))
                    }
                }
            }
        }
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }

    private var recentlyUploadedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently uploaded")
                .font(.subheadline.bold())
                .foregroundStyle(colors.secondaryText)

            HStack(spacing: 12) {
                Image(systemName: "info.circle")
                    .font(.body)
                    .foregroundStyle(.secondary)

                Text("You can switch apps or turn off your phone. We'll notify you when the analysis is done.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {} label: {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(.rect(cornerRadius: 12))
        }
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }
}

struct MacroMiniCard: View {
    @Environment(\.appColors) private var colors
    let label: String
    let remaining: Int
    let goal: Int
    let color: Color
    var animated: Bool = false

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(Double(goal - remaining) / Double(goal), 1.0)
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("\(remaining)g")
                .font(.title3.bold())
                .foregroundStyle(colors.primaryText)
                .contentTransition(.numericText())

            Text("\(label) left")
                .font(.caption)
                .foregroundStyle(colors.secondaryText)

            ZStack {
                Circle()
                    .stroke(colors.progressTrack, lineWidth: 4)

                Circle()
                    .trim(from: 0, to: animated ? progress : 0)
                    .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.4), value: animated)
            }
            .frame(width: 32, height: 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: colors.cardShadow, radius: 6, y: 2)
    }
}

struct BlurFadeModifier: ViewModifier {
    let visible: Bool
    let delay: Double

    func body(content: Content) -> some View {
        content
            .blur(radius: visible ? 0 : 6)
            .opacity(visible ? 1 : 0)
            .animation(.spring(response: 0.4, dampingFraction: 0.85).delay(delay), value: visible)
    }
}

extension View {
    func blurFadeIn(visible: Bool, delay: Double = 0) -> some View {
        modifier(BlurFadeModifier(visible: visible, delay: delay))
    }
}
