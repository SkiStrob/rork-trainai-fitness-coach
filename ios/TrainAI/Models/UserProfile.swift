import SwiftData
import Foundation

@Model
class UserProfile {
    var name: String
    var age: String
    var gender: String
    var heightInches: Int
    var weightLbs: Double
    var goal: String
    var experience: String
    var attribution: String
    var createdAt: Date
    var currentStreak: Int
    var dailyCalorieGoal: Int
    var dailyProteinGoal: Int
    var dailyCarbsGoal: Int
    var dailyFatGoal: Int
    var dailyWaterGoal: Int
    var useMetric: Bool

    init(
        name: String = "",
        age: String = "",
        gender: String = "Male",
        heightInches: Int = 70,
        weightLbs: Double = 170,
        goal: String = "",
        experience: String = "",
        attribution: String = "",
        createdAt: Date = Date(),
        currentStreak: Int = 0,
        dailyCalorieGoal: Int = 2400,
        dailyProteinGoal: Int = 165,
        dailyCarbsGoal: Int = 300,
        dailyFatGoal: Int = 80,
        dailyWaterGoal: Int = 8,
        useMetric: Bool = false
    ) {
        self.name = name
        self.age = age
        self.gender = gender
        self.heightInches = heightInches
        self.weightLbs = weightLbs
        self.goal = goal
        self.experience = experience
        self.attribution = attribution
        self.createdAt = createdAt
        self.currentStreak = currentStreak
        self.dailyCalorieGoal = dailyCalorieGoal
        self.dailyProteinGoal = dailyProteinGoal
        self.dailyCarbsGoal = dailyCarbsGoal
        self.dailyFatGoal = dailyFatGoal
        self.dailyWaterGoal = dailyWaterGoal
        self.useMetric = useMetric
    }
}
