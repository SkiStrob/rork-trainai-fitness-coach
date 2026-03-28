import SwiftUI
import SwiftData

@Observable
@MainActor
class OnboardingViewModel {
    var currentStep: Int = 0
    var userName: String = ""
    var selectedGender: String = ""
    var birthMonth: Int = 6
    var birthYear: Int = 1998
    var heightFeet: Int = 5
    var heightInches: Int = 10
    var weightLbs: Int = 170
    var heightCm: Int = 178
    var weightKg: Int = 77
    var useMetric: Bool = false
    var selectedGoal: String = ""
    var selectedExperience: String = ""
    var frontPhotoData: Data?
    var sidePhotoData: Data?
    var isAnalyzing: Bool = false
    var analysisProgress: Double = 0
    var analysisComplete: Bool = false
    var scanResult: BodyScan?
    var selectedPlan: String = "annual"

    let totalSteps: Int = 18

    var progress: Double {
        guard currentStep >= 2 else { return 0 }
        return Double(currentStep - 1) / Double(totalSteps - 2)
    }

    var showProgressBar: Bool {
        currentStep >= 2 && currentStep <= 16
    }

    var showBackButton: Bool {
        currentStep >= 2 && currentStep <= 16
    }

    var canContinue: Bool {
        switch currentStep {
        case 0: return true
        case 1: return true
        case 2: return !userName.trimmingCharacters(in: .whitespaces).isEmpty
        case 3: return !selectedGender.isEmpty
        case 4: return true
        case 5: return true
        case 6: return true
        case 7: return !selectedGoal.isEmpty
        case 8: return !selectedExperience.isEmpty
        case 9: return true
        case 10: return true
        case 11: return true
        case 12: return frontPhotoData != nil
        case 13: return sidePhotoData != nil
        case 14: return analysisComplete
        case 15: return true
        case 16: return true
        case 17: return true
        default: return true
        }
    }

    var heightInTotalInches: Int {
        if useMetric {
            return Int(Double(heightCm) / 2.54)
        }
        return heightFeet * 12 + heightInches
    }

    var weightInLbs: Double {
        if useMetric {
            return Double(weightKg) * 2.20462
        }
        return Double(weightLbs)
    }

    var weightInKg: Double {
        if useMetric {
            return Double(weightKg)
        }
        return Double(weightLbs) / 2.20462
    }

    var heightInCm: Double {
        if useMetric {
            return Double(heightCm)
        }
        return Double(heightInTotalInches) * 2.54
    }

    var heightDisplayString: String {
        if useMetric {
            return "\(heightCm) cm"
        }
        return "\(heightFeet)'\(heightInches)\""
    }

    var weightDisplayString: String {
        if useMetric {
            return "\(weightKg) kg"
        }
        return "\(weightLbs) lbs"
    }

    var ageYears: Int {
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = birthMonth
        components.year = birthYear
        components.day = 15
        guard let birthday = calendar.date(from: components) else { return 25 }
        return calendar.dateComponents([.year], from: birthday, to: Date()).year ?? 25
    }

    var calculatedBMR: Double {
        let w = weightInKg
        let h = heightInCm
        let a = Double(ageYears)
        if selectedGender.lowercased() == "female" {
            return (10.0 * w) + (6.25 * h) - (5.0 * a) - 161.0
        }
        return (10.0 * w) + (6.25 * h) - (5.0 * a) + 5.0
    }

    var activityMultiplier: Double {
        switch selectedExperience {
        case "Beginner (0-6 months)": return 1.375
        case "Intermediate (6mo - 2yr)": return 1.55
        case "Advanced (2+ years)": return 1.725
        case "Coming back after a break": return 1.375
        default: return 1.55
        }
    }

    var calculatedTDEE: Double {
        calculatedBMR * activityMultiplier
    }

    var goalCalorieAdjustment: Double {
        switch selectedGoal {
        case "Build Muscle": return 300
        case "Lose Fat": return -500
        case "Get Toned": return -200
        case "Competition Prep": return -600
        case "Stay Healthy": return 0
        case "Get Stronger": return 200
        default: return 0
        }
    }

    var calculatedDailyCalories: Int {
        let raw = calculatedTDEE + goalCalorieAdjustment
        return max(1200, min(5000, Int(raw / 25) * 25))
    }

    var calculatedProtein: Int {
        let proteinPerKg: Double
        switch selectedGoal {
        case "Build Muscle", "Competition Prep": proteinPerKg = 2.2
        case "Lose Fat": proteinPerKg = 2.0
        case "Get Stronger": proteinPerKg = 1.8
        default: proteinPerKg = 1.6
        }
        return Int(weightInKg * proteinPerKg)
    }

    var calculatedFat: Int {
        let fatCals = Double(calculatedDailyCalories) * 0.25
        return Int(fatCals / 9)
    }

    var calculatedCarbs: Int {
        let proteinCals = Double(calculatedProtein) * 4
        let fatCals = Double(calculatedFat) * 9
        let remaining = Double(calculatedDailyCalories) - proteinCals - fatCals
        return max(50, Int(remaining / 4))
    }

    func nextStep() {
        if currentStep < totalSteps - 1 {
            currentStep += 1
        }
    }

    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }

    func performAnalysis() {
        isAnalyzing = true
        analysisProgress = 0

        Task {
            for i in 1...180 {
                try? await Task.sleep(for: .milliseconds(100))
                analysisProgress = Double(i) / 180.0
            }
            isAnalyzing = false
            analysisComplete = true

            scanResult = BodyScan(
                date: Date(),
                overallScore: 5.7,
                symmetry: 6.5, definition: 5.3, mass: 5.9,
                proportions: 5.5, vtaper: 5.7, core: 5.2,
                chestScore: 6.0, backScore: 5.5, shoulderScore: 6.4,
                armScore: 5.7, coreScore: 5.2, legScore: 5.3,
                tierName: TierInfo.tier(for: 5.7, gender: selectedGender).name,
                frontPhotoData: frontPhotoData,
                sidePhotoData: sidePhotoData
            )

            nextStep()
        }
    }

    func saveProfile(context: ModelContext) {
        let profile = UserProfile(
            name: userName.isEmpty ? "Athlete" : userName,
            age: "\(ageYears)",
            gender: selectedGender,
            heightInches: heightInTotalInches,
            weightLbs: weightInLbs,
            goal: selectedGoal,
            experience: selectedExperience,
            dailyCalorieGoal: calculatedDailyCalories,
            dailyProteinGoal: calculatedProtein,
            dailyCarbsGoal: calculatedCarbs,
            dailyFatGoal: calculatedFat,
            useMetric: useMetric
        )
        context.insert(profile)

        if let scan = scanResult {
            context.insert(scan)
        }
    }
}
