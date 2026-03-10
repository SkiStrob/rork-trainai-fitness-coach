import SwiftData
import Foundation

@Model
class WorkoutSession {
    var date: Date
    var programName: String
    var workoutName: String
    var duration: TimeInterval
    var isCompleted: Bool
    @Relationship(deleteRule: .cascade) var exercises: [ExerciseLog] = []

    init(
        date: Date = Date(),
        programName: String = "",
        workoutName: String = "",
        duration: TimeInterval = 0,
        isCompleted: Bool = false
    ) {
        self.date = date
        self.programName = programName
        self.workoutName = workoutName
        self.duration = duration
        self.isCompleted = isCompleted
    }
}

@Model
class ExerciseLog {
    var exerciseName: String
    var muscleGroup: String
    var targetSets: Int
    var targetRepsMin: Int
    var targetRepsMax: Int
    @Relationship(deleteRule: .cascade) var sets: [SetLog] = []
    var session: WorkoutSession?

    init(
        exerciseName: String = "",
        muscleGroup: String = "",
        targetSets: Int = 4,
        targetRepsMin: Int = 8,
        targetRepsMax: Int = 12
    ) {
        self.exerciseName = exerciseName
        self.muscleGroup = muscleGroup
        self.targetSets = targetSets
        self.targetRepsMin = targetRepsMin
        self.targetRepsMax = targetRepsMax
    }
}

@Model
class SetLog {
    var setNumber: Int
    var weight: Double
    var reps: Int
    var isCompleted: Bool
    var isPR: Bool
    var exercise: ExerciseLog?

    init(
        setNumber: Int = 1,
        weight: Double = 0,
        reps: Int = 0,
        isCompleted: Bool = false,
        isPR: Bool = false
    ) {
        self.setNumber = setNumber
        self.weight = weight
        self.reps = reps
        self.isCompleted = isCompleted
        self.isPR = isPR
    }
}
