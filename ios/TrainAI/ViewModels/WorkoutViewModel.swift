import SwiftUI
import SwiftData

@Observable
@MainActor
class WorkoutViewModel {
    var isWorkoutActive: Bool = false
    var restTimerSeconds: Int = 90
    var restTimerRemaining: Int = 0
    var isRestTimerRunning: Bool = false
    var workoutStartTime: Date?
    var selectedDayIndex: Int = Calendar.current.component(.weekday, from: Date()) - 1
    var showProgramOptions: Bool = false
    var showRestTimer: Bool = false

    func startRestTimer() {
        restTimerRemaining = restTimerSeconds
        isRestTimerRunning = true
        showRestTimer = true
        Task {
            while restTimerRemaining > 0 && isRestTimerRunning {
                try? await Task.sleep(for: .seconds(1))
                if isRestTimerRunning {
                    restTimerRemaining -= 1
                }
            }
            isRestTimerRunning = false
            if restTimerRemaining <= 0 {
                HapticManager.medium()
            }
        }
    }

    func stopRestTimer() {
        isRestTimerRunning = false
        showRestTimer = false
    }

    func completeSet() {
        HapticManager.medium()
        startRestTimer()
    }
}
