import SwiftUI
import SwiftData

struct ProgramView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appColors) private var colors
    @Query(sort: \WorkoutProgram.name) private var programs: [WorkoutProgram]
    @State private var workoutVM = WorkoutViewModel()
    @State private var showProgramOptions: Bool = false

    private var activeProgram: WorkoutProgram? {
        programs.first(where: { $0.isActive })
    }

    private var selectedDay: ProgramDay? {
        activeProgram?.days.first(where: { $0.dayOfWeek == workoutVM.selectedDayIndex + 1 })
    }

    private let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if let program = activeProgram {
                        programHeader(program)
                        weekCalendarStrip(program)
                        dayContent
                    } else {
                        emptyProgramView
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .background(colors.background)
            .navigationTitle("Program")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showProgramOptions = true
                    } label: {
                        Image(systemName: "pencil.circle")
                            .foregroundStyle(.primary)
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
        VStack(alignment: .leading, spacing: 4) {
            Text(program.name)
                .font(.title3.bold())
                .foregroundStyle(colors.primaryText)
            Text("Week \(program.currentWeek) of \(program.totalWeeks)")
                .font(.subheadline)
                .foregroundStyle(colors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
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
                    VStack(spacing: 4) {
                        Text(dayLabels[i])
                            .font(.caption2.bold())
                            .foregroundStyle(isSelected ? colors.selectedCardText : isToday ? colors.primaryText : colors.secondaryText)

                        Circle()
                            .fill(isWorkout ? Color.blue.opacity(0.6) : colors.progressTrack)
                            .frame(width: 6, height: 6)
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
        .cardStyle()
    }

    @ViewBuilder
    private var dayContent: some View {
        if let day = selectedDay {
            if day.isRestDay {
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "bed.double.fill")
                            .foregroundStyle(.secondary)
                        Text("Rest Day")
                            .font(.title3.bold())
                            .foregroundStyle(colors.primaryText)
                    }
                    Text("Recovery is growth. Your muscles rebuild during rest.")
                        .font(.subheadline)
                        .foregroundStyle(colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .cardStyle()
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(day.workoutName)
                        .font(.headline)
                        .foregroundStyle(colors.primaryText)
                    Text(day.muscleGroups)
                        .font(.caption)
                        .foregroundStyle(colors.secondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardStyle()

                ForEach(day.exercises.sorted(by: { $0.orderIndex < $1.orderIndex })) { exercise in
                    ExerciseCard(exercise: exercise, workoutVM: workoutVM)
                }
            }
        } else {
            Text("No workout for this day")
                .font(.subheadline)
                .foregroundStyle(colors.secondaryText)
                .frame(maxWidth: .infinity)
                .cardStyle()
        }
    }

    private var emptyProgramView: some View {
        VStack(spacing: 16) {
            Image(systemName: "dumbbell")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Active Program")
                .font(.headline)
                .foregroundStyle(colors.primaryText)
            Text("Create or select a workout program to get started.")
                .font(.subheadline)
                .foregroundStyle(colors.secondaryText)
                .multilineTextAlignment(.center)
            Button {
                showProgramOptions = true
            } label: {
                Text("Choose Program")
                    .font(.headline)
                    .foregroundStyle(colors.ctaForeground)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(colors.ctaBackground)
                    .clipShape(.rect(cornerRadius: 12))
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
        VStack(alignment: .leading, spacing: 12) {
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

                    Text("-- lbs x -- reps")
                        .font(.subheadline)
                        .foregroundStyle(colors.primaryText.opacity(0.5))

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
                        .fill(flashingSet == setNum ? Color.green.opacity(0.12) : Color.clear)
                )
            }

            Button {} label: {
                Text("Swap Exercise")
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
        }
        .cardStyle()
        .pressable()
    }
}
