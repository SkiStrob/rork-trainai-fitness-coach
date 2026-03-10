import SwiftData
import Foundation

@Model
class WorkoutProgram {
    var name: String
    var totalWeeks: Int
    var currentWeek: Int
    var templateType: String
    var isActive: Bool
    @Relationship(deleteRule: .cascade) var days: [ProgramDay] = []

    init(
        name: String = "",
        totalWeeks: Int = 12,
        currentWeek: Int = 1,
        templateType: String = "PPL",
        isActive: Bool = true
    ) {
        self.name = name
        self.totalWeeks = totalWeeks
        self.currentWeek = currentWeek
        self.templateType = templateType
        self.isActive = isActive
    }
}

@Model
class ProgramDay {
    var dayOfWeek: Int
    var workoutName: String
    var muscleGroups: String
    var isRestDay: Bool
    var exercises: [ProgramExercise] = []
    var program: WorkoutProgram?

    init(
        dayOfWeek: Int = 0,
        workoutName: String = "",
        muscleGroups: String = "",
        isRestDay: Bool = false
    ) {
        self.dayOfWeek = dayOfWeek
        self.workoutName = workoutName
        self.muscleGroups = muscleGroups
        self.isRestDay = isRestDay
    }
}

@Model
class ProgramExercise {
    var name: String
    var muscleGroup: String
    var targetSets: Int
    var targetRepsMin: Int
    var targetRepsMax: Int
    var orderIndex: Int
    var day: ProgramDay?

    init(
        name: String = "",
        muscleGroup: String = "",
        targetSets: Int = 4,
        targetRepsMin: Int = 8,
        targetRepsMax: Int = 12,
        orderIndex: Int = 0
    ) {
        self.name = name
        self.muscleGroup = muscleGroup
        self.targetSets = targetSets
        self.targetRepsMin = targetRepsMin
        self.targetRepsMax = targetRepsMax
        self.orderIndex = orderIndex
    }
}
