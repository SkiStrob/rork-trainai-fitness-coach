import SwiftUI
import SwiftData

@Observable
@MainActor
class HomeViewModel {
    var isRefreshing: Bool = false
    var todayCalories: Int = 1530
    var todayProtein: Int = 113
    var todayWater: Int = 5
    var calorieGoal: Int = 2400
    var proteinGoal: Int = 165
    var carbsGoal: Int = 300
    var fatGoal: Int = 80
    var waterGoal: Int = 8

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }

    var todayDateString: String {
        Date().formatted(.dateTime.weekday(.wide).month(.wide).day())
    }

    func refresh() async {
        isRefreshing = true
        try? await Task.sleep(for: .seconds(1))
        isRefreshing = false
    }

    func loadData(context: ModelContext) {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today
        var descriptor = FetchDescriptor<FoodEntry>(
            predicate: #Predicate { $0.date >= today && $0.date < tomorrow }
        )
        descriptor.fetchLimit = 100
        if let entries = try? context.fetch(descriptor) {
            todayCalories = entries.reduce(0) { $0 + $1.calories }
            todayProtein = Int(entries.reduce(0.0) { $0 + $1.proteinGrams })
        }

        if let profile = try? context.fetch(FetchDescriptor<UserProfile>()).first {
            calorieGoal = profile.dailyCalorieGoal
            proteinGoal = profile.dailyProteinGoal
            carbsGoal = profile.dailyCarbsGoal
            fatGoal = profile.dailyFatGoal
            waterGoal = profile.dailyWaterGoal
        }
    }
}
