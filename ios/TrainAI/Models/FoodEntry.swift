import SwiftData
import Foundation

@Model
class FoodEntry {
    var date: Date
    var mealType: String
    var name: String
    var calories: Int
    var proteinGrams: Double
    var carbsGrams: Double
    var fatGrams: Double
    var healthScore: Int
    @Attribute(.externalStorage) var photoData: Data?

    init(
        date: Date = Date(),
        mealType: String = "Lunch",
        name: String = "",
        calories: Int = 0,
        proteinGrams: Double = 0,
        carbsGrams: Double = 0,
        fatGrams: Double = 0,
        healthScore: Int = 5,
        photoData: Data? = nil
    ) {
        self.date = date
        self.mealType = mealType
        self.name = name
        self.calories = calories
        self.proteinGrams = proteinGrams
        self.carbsGrams = carbsGrams
        self.fatGrams = fatGrams
        self.healthScore = healthScore
        self.photoData = photoData
    }
}
