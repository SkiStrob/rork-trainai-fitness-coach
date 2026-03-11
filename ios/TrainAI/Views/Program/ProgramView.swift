import SwiftUI
import SwiftData

nonisolated struct ExerciseDatabaseItem: Identifiable {
    let id = UUID()
    let name: String
    let muscleGroup: String
    let equipment: String
    let effectiveness: Double
    let difficulty: String
}

private let exerciseDatabase: [ExerciseDatabaseItem] = [
    ExerciseDatabaseItem(name: "Barbell Bench Press", muscleGroup: "Chest", equipment: "Barbell", effectiveness: 9.5, difficulty: "Intermediate"),
    ExerciseDatabaseItem(name: "Incline Dumbbell Press", muscleGroup: "Upper Chest", equipment: "Dumbbells", effectiveness: 8.8, difficulty: "Intermediate"),
    ExerciseDatabaseItem(name: "Barbell Squats", muscleGroup: "Quads, Glutes", equipment: "Barbell", effectiveness: 9.8, difficulty: "Intermediate"),
    ExerciseDatabaseItem(name: "Romanian Deadlifts", muscleGroup: "Hamstrings", equipment: "Barbell", effectiveness: 9.2, difficulty: "Intermediate"),
    ExerciseDatabaseItem(name: "Pull-ups", muscleGroup: "Back, Biceps", equipment: "Bodyweight", effectiveness: 9.4, difficulty: "Intermediate"),
    ExerciseDatabaseItem(name: "Barbell Rows", muscleGroup: "Back", equipment: "Barbell", effectiveness: 9.0, difficulty: "Intermediate"),
    ExerciseDatabaseItem(name: "Overhead Press", muscleGroup: "Shoulders", equipment: "Barbell", effectiveness: 9.1, difficulty: "Intermediate"),
    ExerciseDatabaseItem(name: "Lateral Raises", muscleGroup: "Side Delts", equipment: "Dumbbells", effectiveness: 8.2, difficulty: "Beginner"),
    ExerciseDatabaseItem(name: "Barbell Curls", muscleGroup: "Biceps", equipment: "Barbell", effectiveness: 8.5, difficulty: "Beginner"),
    ExerciseDatabaseItem(name: "Tricep Pushdowns", muscleGroup: "Triceps", equipment: "Cable", effectiveness: 8.3, difficulty: "Beginner"),
    ExerciseDatabaseItem(name: "Leg Press", muscleGroup: "Quads, Glutes", equipment: "Machine", effectiveness: 8.7, difficulty: "Beginner"),
    ExerciseDatabaseItem(name: "Deadlifts", muscleGroup: "Full Body", equipment: "Barbell", effectiveness: 9.9, difficulty: "Advanced"),
    ExerciseDatabaseItem(name: "Cable Flyes", muscleGroup: "Chest", equipment: "Cable", effectiveness: 7.8, difficulty: "Beginner"),
    ExerciseDatabaseItem(name: "Face Pulls", muscleGroup: "Rear Delts", equipment: "Cable", effectiveness: 8.6, difficulty: "Beginner"),
    ExerciseDatabaseItem(name: "Leg Curls", muscleGroup: "Hamstrings", equipment: "Machine", effectiveness: 7.9, difficulty: "Beginner"),
    ExerciseDatabaseItem(name: "Calf Raises", muscleGroup: "Calves", equipment: "Machine", effectiveness: 7.5, difficulty: "Beginner"),
    ExerciseDatabaseItem(name: "Dips", muscleGroup: "Chest, Triceps", equipment: "Bodyweight", effectiveness: 9.0, difficulty: "Intermediate"),
    ExerciseDatabaseItem(name: "Hack Squats", muscleGroup: "Quads", equipment: "Machine", effectiveness: 8.4, difficulty: "Beginner"),
    ExerciseDatabaseItem(name: "Hammer Curls", muscleGroup: "Biceps", equipment: "Dumbbells", effectiveness: 8.0, difficulty: "Beginner"),
    ExerciseDatabaseItem(name: "Skull Crushers", muscleGroup: "Triceps", equipment: "Barbell", effectiveness: 8.4, difficulty: "Intermediate"),
]

struct ProgramView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appColors) private var colors
    @Query(sort: \WorkoutProgram.name) private var programs: [WorkoutProgram]
    @State private var workoutVM = WorkoutViewModel()
    @State private var showProgramOptions: Bool = false
    @State private var exerciseSearchText: String = ""
    @State private var showExerciseSearch: Bool = false

    private var activeProgram: WorkoutProgram? {
        programs.first(where: { $0.isActive })
    }

    private var selectedDay: ProgramDay? {
        activeProgram?.days.first(where: { $0.dayOfWeek == workoutVM.selectedDayIndex + 1 })
    }

    private let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]

    private var filteredExercises: [ExerciseDatabaseItem] {
        guard !exerciseSearchText.isEmpty else { return exerciseDatabase }
        return exerciseDatabase.filter {
            $0.name.localizedStandardContains(exerciseSearchText) ||
            $0.muscleGroup.localizedStandardContains(exerciseSearchText)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let program = activeProgram {
                        programHeader(program)
                        weekCalendarStrip(program)
                        dayContent
                    } else {
                        emptyProgramView
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(colors.background)
            .navigationTitle("Program")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                showExerciseSearch.toggle()
                                if !showExerciseSearch { exerciseSearchText = "" }
                            }
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.primary)
                        }
                        Button {
                            showProgramOptions = true
                        } label: {
                            Image(systemName: "pencil.circle")
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
            .confirmationDialog("Edit Program", isPresented: $showProgramOptions, titleVisibility: .visible) {
                Button("AI-Generated") { }
                Button("Choose Template") { }
                Button("Create Custom") { }
                Button("Cancel", role: .cancel) { }
            }
            .sheet(isPresented: $workoutVM.showRestTimer) {
                RestTimerView(viewModel: workoutVM)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private func programHeader(_ program: WorkoutProgram) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(program.name)
                    .font(.title3.bold())
                    .foregroundStyle(colors.primaryText)
                Text("Week \(program.currentWeek) of \(program.totalWeeks)")
                    .font(.subheadline)
                    .foregroundStyle(colors.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if showExerciseSearch {
                exerciseSearchSection
            }
        }
    }

    private var exerciseSearchSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.body)
                    .foregroundStyle(.secondary)
                TextField("Search exercises...", text: $exerciseSearchText)
                    .font(.body)
                    .foregroundStyle(colors.primaryText)
                if !exerciseSearchText.isEmpty {
                    Button {
                        exerciseSearchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(12)
            .background(colors.inputBackground)
            .clipShape(.rect(cornerRadius: 12))

            ForEach(filteredExercises.prefix(8)) { exercise in
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(exercise.name)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(colors.primaryText)
                        HStack(spacing: 6) {
                            Text(exercise.muscleGroup)
                                .font(.caption)
                                .foregroundStyle(colors.secondaryText)
                            Text(exercise.equipment)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(colors.inputBackground)
                                .clipShape(.rect(cornerRadius: 4))
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 9))
                                .foregroundStyle(.orange)
                            Text(String(format: "%.1f", exercise.effectiveness))
                                .font(.caption.bold())
                                .foregroundStyle(colors.primaryText)
                        }
                        Text(exercise.difficulty)
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(14)
                .background(colors.cardBackground)
                .clipShape(.rect(cornerRadius: 14))
                .shadow(color: colors.cardShadow, radius: 6, y: 2)
            }
        }
    }

    private func weekCalendarStrip(_ program: WorkoutProgram) -> some View {
        let todayIndex = {
            let wd = Calendar.current.component(.weekday, from: Date())
            return wd == 1 ? 6 : wd - 2
        }()

        return HStack(spacing: 8) {
            ForEach(0..<7, id: \.self) { i in
                let day = program.days.first(where: { $0.dayOfWeek == i + 1 })
                let isToday = i == todayIndex
                let isSelected = i == workoutVM.selectedDayIndex
                let isWorkout = !(day?.isRestDay ?? true)

                Button {
                    HapticManager.selection()
                    workoutVM.selectedDayIndex = i
                } label: {
                    VStack(spacing: 6) {
                        Text(dayLabels[i])
                            .font(.caption2)
                            .foregroundStyle(isSelected ? colors.selectedCardText : colors.secondaryText)

                        Circle()
                            .fill(isWorkout ? Color.blue.opacity(0.5) : colors.progressTrack)
                            .frame(width: 5, height: 5)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isSelected ? colors.selectedCard : (isToday ? colors.inputBackground : Color.clear))
                    )
                }
            }
        }
        .padding(16)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }

    @ViewBuilder
    private var dayContent: some View {
        if let day = selectedDay {
            if day.isRestDay {
                VStack(spacing: 8) {
                    Image(systemName: "bed.double.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    Text("Rest Day")
                        .font(.title3.bold())
                        .foregroundStyle(colors.primaryText)
                    Text("Recovery is growth")
                        .font(.subheadline)
                        .foregroundStyle(colors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(colors.cardBackground)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(color: colors.cardShadow, radius: 8, y: 2)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(day.workoutName)
                        .font(.headline)
                        .foregroundStyle(colors.primaryText)
                    Text(day.muscleGroups)
                        .font(.subheadline)
                        .foregroundStyle(colors.secondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(colors.cardBackground)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(color: colors.cardShadow, radius: 8, y: 2)

                ForEach(day.exercises.sorted(by: { $0.orderIndex < $1.orderIndex })) { exercise in
                    ExerciseCard(exercise: exercise, workoutVM: workoutVM)
                }
            }
        } else {
            Text("No workout for this day")
                .font(.subheadline)
                .foregroundStyle(colors.secondaryText)
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(colors.cardBackground)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(color: colors.cardShadow, radius: 8, y: 2)
        }
    }

    private var emptyProgramView: some View {
        VStack(spacing: 16) {
            Image(systemName: "dumbbell")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("No Active Program")
                .font(.headline)
                .foregroundStyle(colors.primaryText)
            Text("Create or select a workout program.")
                .font(.subheadline)
                .foregroundStyle(colors.secondaryText)
            Button {
                showProgramOptions = true
            } label: {
                Text("Choose Program")
                    .font(.headline)
                    .foregroundStyle(colors.ctaForeground)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(colors.ctaBackground)
                    .clipShape(.rect(cornerRadius: 14))
            }
        }
        .padding(.top, 60)
    }
}

struct ExerciseCard: View {
    @Environment(\.appColors) private var colors
    let exercise: ProgramExercise
    let workoutVM: WorkoutViewModel

    @State private var completedSets: Set<Int> = []
    @State private var flashingSet: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(exercise.name)
                        .font(.headline)
                        .foregroundStyle(colors.primaryText)
                    Text(exercise.muscleGroup)
                        .font(.caption)
                        .foregroundStyle(colors.secondaryText)
                }
                Spacer()
                Text("\(exercise.targetSets) x \(exercise.targetRepsMin)-\(exercise.targetRepsMax)")
                    .font(.subheadline.bold())
                    .foregroundStyle(.blue)
            }

            ForEach(1...exercise.targetSets, id: \.self) { setNum in
                HStack {
                    Text("Set \(setNum)")
                        .font(.subheadline)
                        .foregroundStyle(colors.secondaryText)
                        .frame(width: 44, alignment: .leading)

                    Spacer()

                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            completedSets.insert(setNum)
                            flashingSet = setNum
                        }
                        workoutVM.completeSet()

                        Task {
                            try? await Task.sleep(for: .milliseconds(600))
                            withAnimation { flashingSet = nil }
                        }
                    } label: {
                        Image(systemName: completedSets.contains(setNum) ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundStyle(completedSets.contains(setNum) ? .green : .secondary)
                            .symbolEffect(.bounce, value: completedSets.contains(setNum))
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(flashingSet == setNum ? Color.green.opacity(0.1) : Color.clear)
                )
            }
        }
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }
}
