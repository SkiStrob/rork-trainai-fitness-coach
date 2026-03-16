import Foundation

nonisolated enum NutritionCalculator {

    static func calculateBMR(gender: String, weightLbs: Double, heightInches: Int, ageYears: Int) -> Double {
        let weightKg = weightLbs * 0.453592
        let heightCm = Double(heightInches) * 2.54

        if gender.lowercased() == "female" {
            return (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * Double(ageYears)) - 161.0
        } else {
            return (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * Double(ageYears)) + 5.0
        }
    }

    static func calculateTDEE(bmr: Double, workoutsPerWeek: String) -> Double {
        let multiplier: Double
        switch workoutsPerWeek {
        case "0-2":
            multiplier = 1.375
        case "3-5":
            multiplier = 1.55
        case "6+":
            multiplier = 1.725
        default:
            multiplier = 1.55
        }
        return bmr * multiplier
    }

    static func calculateDailyCalories(tdee: Double, goals: [String]) -> Int {
        var adjustments: [Double] = []

        for goal in goals {
            switch goal {
            case "Build Muscle":
                adjustments.append(300)
            case "Lose Fat":
                adjustments.append(-500)
            case "Get Toned":
                adjustments.append(-200)
            case "Competition Prep":
                adjustments.append(-600)
            case "Stay Healthy":
                adjustments.append(0)
            case "Get Stronger":
                adjustments.append(200)
            default:
                adjustments.append(0)
            }
        }

        var adjustment: Double = 0
        if !adjustments.isEmpty {
            adjustment = adjustments.reduce(0, +) / Double(adjustments.count)
        }

        let target = tdee + adjustment
        return Int(max(1200, min(5000, target)))
    }

    nonisolated struct MacroTargets: Sendable {
        let calories: Int
        let proteinGrams: Int
        let carbsGrams: Int
        let fatsGrams: Int
    }

    static func calculateMacros(dailyCalories: Int, goals: [String], weightLbs: Double) -> MacroTargets {
        var proteinRatio: Double = 0.30
        var carbsRatio: Double = 0.40
        var fatsRatio: Double = 0.30

        let primaryGoal = goals.first ?? "Stay Healthy"

        switch primaryGoal {
        case "Build Muscle":
            proteinRatio = 0.35
            carbsRatio = 0.40
            fatsRatio = 0.25
        case "Lose Fat":
            proteinRatio = 0.40
            carbsRatio = 0.30
            fatsRatio = 0.30
        case "Get Toned":
            proteinRatio = 0.35
            carbsRatio = 0.35
            fatsRatio = 0.30
        case "Competition Prep":
            proteinRatio = 0.45
            carbsRatio = 0.35
            fatsRatio = 0.20
        case "Get Stronger":
            proteinRatio = 0.30
            carbsRatio = 0.45
            fatsRatio = 0.25
        default:
            proteinRatio = 0.30
            carbsRatio = 0.40
            fatsRatio = 0.30
        }

        var proteinGrams = Int(Double(dailyCalories) * proteinRatio / 4.0)
        let carbsGrams = Int(Double(dailyCalories) * carbsRatio / 4.0)
        let fatsGrams = Int(Double(dailyCalories) * fatsRatio / 9.0)

        let minProtein = Int(weightLbs * 0.7)
        proteinGrams = max(proteinGrams, minProtein)

        return MacroTargets(
            calories: dailyCalories,
            proteinGrams: proteinGrams,
            carbsGrams: carbsGrams,
            fatsGrams: fatsGrams
        )
    }

    static func estimateWeeksToGoal(currentWeightLbs: Double, targetWeightLbs: Double, speedPerWeek: Double) -> Int {
        let weightDiff = abs(targetWeightLbs - currentWeightLbs)
        let speedLbs = speedPerWeek * 2.20462
        guard speedLbs > 0 else { return 52 }
        return max(1, Int(ceil(weightDiff / speedLbs)))
    }

    static func estimateGoalDate(weeksToGoal: Int) -> Date {
        Calendar.current.date(byAdding: .weekOfYear, value: weeksToGoal, to: Date()) ?? Date()
    }

    static func calculateWaterGoal(weightLbs: Double) -> Int {
        return Int(weightLbs / 2.0)
    }

    static func ageFromBirthday(month: Int, day: Int, year: Int) -> Int {
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = month
        components.day = day
        components.year = year
        guard let birthday = calendar.date(from: components) else { return 25 }
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        return ageComponents.year ?? 25
    }

    static func calculateFromOnboarding(
        gender: String,
        weightLbs: Double,
        heightInches: Int,
        ageYears: Int,
        workoutsPerWeek: String,
        goals: [String]
    ) -> MacroTargets {
        let bmr = calculateBMR(gender: gender, weightLbs: weightLbs, heightInches: heightInches, ageYears: ageYears)
        let tdee = calculateTDEE(bmr: bmr, workoutsPerWeek: workoutsPerWeek)
        let dailyCalories = calculateDailyCalories(tdee: tdee, goals: goals)
        return calculateMacros(dailyCalories: dailyCalories, goals: goals, weightLbs: weightLbs)
    }
}
