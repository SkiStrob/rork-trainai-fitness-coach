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

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    weekCalendarStrip
                        .blurFadeIn(visible: cardsAppeared, delay: 0)
                    calorieCard
                        .blurFadeIn(visible: cardsAppeared, delay: 0.05)
                    macroCards
                        .blurFadeIn(visible: cardsAppeared, delay: 0.1)
                    todayWorkoutCard
                        .blurFadeIn(visible: cardsAppeared, delay: 0.15)
                    recentlyLoggedSection
                        .blurFadeIn(visible: cardsAppeared, delay: 0.2)
                    streakCard
                        .blurFadeIn(visible: cardsAppeared, delay: 0.25)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .background(colors.background)
            .refreshable {
                HapticManager.light()
                viewModel.loadData(context: modelContext)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(viewModel.greeting), \(profile?.name ?? "Athlete")")
                            .font(.title3.bold())
                            .foregroundStyle(colors.primaryText)
                    }
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
                        .font(.caption2.bold())
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
        .padding(.horizontal, 8)
    }

    private var calorieCard: some View {
        let remaining = max(0, viewModel.calorieGoal - viewModel.todayCalories)
        let progress = min(Double(viewModel.todayCalories) / Double(viewModel.calorieGoal), 1.0)

        return HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(remaining)")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(colors.primaryText)
                    .contentTransition(.numericText())

                Text("Calories left")
                    .font(.subheadline)
                    .foregroundStyle(colors.secondaryText)
            }

            Spacer()

            ZStack {
                Circle()
                    .stroke(colors.progressTrack, lineWidth: 10)

                Circle()
                    .trim(from: 0, to: ringsAppeared ? progress : 0)
                    .stroke(
                        AngularGradient(
                            colors: [Color(red: 0.13, green: 0.77, blue: 0.37), Color(red: 0.2, green: 0.9, blue: 0.4)],
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3), value: ringsAppeared)

                Image(systemName: "flame.fill")
                    .font(.title3)
                    .foregroundStyle(Color(red: 0.13, green: 0.77, blue: 0.37))
            }
            .frame(width: 72, height: 72)
        }
        .glassCardStyle()
        .pressable()
        .onAppear {
            ringsAppeared = true
        }
    }

    private var macroCards: some View {
        HStack(spacing: 10) {
            MacroMiniCard(
                label: "Protein",
                value: "\(viewModel.todayProtein)g",
                subtitle: "left",
                remaining: max(0, viewModel.proteinGoal - viewModel.todayProtein),
                goal: viewModel.proteinGoal,
                color: Color(red: 0.9, green: 0.3, blue: 0.3),
                icon: "p.circle.fill",
                animated: ringsAppeared
            )

            MacroMiniCard(
                label: "Carbs",
                value: "\(max(0, 300 - Int(todayEntries.reduce(0.0) { $0 + $1.carbsGrams })))g",
                subtitle: "left",
                remaining: max(0, 300 - Int(todayEntries.reduce(0.0) { $0 + $1.carbsGrams })),
                goal: 300,
                color: Color.orange,
                icon: "c.circle.fill",
                animated: ringsAppeared
            )

            MacroMiniCard(
                label: "Fat",
                value: "\(max(0, 80 - Int(todayEntries.reduce(0.0) { $0 + $1.fatGrams })))g",
                subtitle: "left",
                remaining: max(0, 80 - Int(todayEntries.reduce(0.0) { $0 + $1.fatGrams })),
                goal: 80,
                color: Color(red: 0.3, green: 0.5, blue: 0.9),
                icon: "f.circle.fill",
                animated: ringsAppeared
            )
        }
    }

    private var todayWorkoutCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Today's Workout")
                .font(.caption.bold())
                .foregroundStyle(colors.secondaryText)
                .textCase(.uppercase)
                .tracking(0.5)

            if let day = todayWorkout {
                if day.isRestDay {
                    HStack {
                        Image(systemName: "bed.double.fill")
                            .foregroundStyle(.secondary)
                        Text("Rest Day")
                            .font(.headline)
                            .foregroundStyle(colors.primaryText)
                        Spacer()
                    }
                    Text("Recovery is growth")
                        .font(.subheadline)
                        .foregroundStyle(colors.secondaryText)
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
                        Text("~55 min")
                            .font(.caption.bold())
                            .foregroundStyle(colors.secondaryText)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(colors.inputBackground)
                            .clipShape(Capsule())
                    }
                }
            } else {
                Text("No workout scheduled")
                    .font(.subheadline)
                    .foregroundStyle(colors.secondaryText)
            }
        }
        .cardStyle()
        .pressable()
    }

    private var recentlyLoggedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently logged")
                .font(.caption.bold())
                .foregroundStyle(colors.secondaryText)
                .textCase(.uppercase)
                .tracking(0.5)

            if todayEntries.isEmpty {
                HStack {
                    Text("No meals logged today")
                        .font(.subheadline)
                        .foregroundStyle(colors.secondaryText)
                    Spacer()
                }
            } else {
                ForEach(todayEntries.prefix(4)) { entry in
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colors.inputBackground)
                            .frame(width: 44, height: 44)
                            .overlay {
                                Image(systemName: mealIcon(entry.mealType))
                                    .font(.body)
                                    .foregroundStyle(colors.secondaryText)
                            }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.name)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(colors.primaryText)
                                .lineLimit(1)
                            Text(entry.date.formatted(.dateTime.hour().minute()))
                                .font(.caption)
                                .foregroundStyle(colors.secondaryText)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(entry.calories) cal")
                                .font(.subheadline.bold())
                                .foregroundStyle(colors.primaryText)
                            HStack(spacing: 4) {
                                Text("P:\(Int(entry.proteinGrams))g")
                                    .font(.caption2)
                                    .foregroundStyle(Color(red: 0.9, green: 0.3, blue: 0.3))
                            }
                        }
                    }
                }
            }
        }
        .cardStyle()
    }

    private var streakCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Image(systemName: "chart.bar.fill")
                        .font(.caption)
                        .foregroundStyle(.blue)
                    Text("Next scan in 3 days")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(colors.primaryText)
                }
                Text("Track your progress weekly")
                    .font(.caption)
                    .foregroundStyle(colors.secondaryText)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(colors.secondaryText)
        }
        .cardStyle()
        .pressable()
    }

    private func mealIcon(_ mealType: String) -> String {
        switch mealType {
        case "Breakfast": return "sunrise.fill"
        case "Lunch": return "sun.max.fill"
        case "Dinner": return "moon.fill"
        case "Snack": return "leaf.fill"
        default: return "fork.knife"
        }
    }
}

struct MacroMiniCard: View {
    @Environment(\.appColors) private var colors
    let label: String
    let value: String
    let subtitle: String
    let remaining: Int
    let goal: Int
    let color: Color
    let icon: String
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
                    .stroke(colors.progressTrack, lineWidth: 5)

                Circle()
                    .trim(from: 0, to: animated ? progress : 0)
                    .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.4), value: animated)

                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
            }
            .frame(width: 36, height: 36)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 14))
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
