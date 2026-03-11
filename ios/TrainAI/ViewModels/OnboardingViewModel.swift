import SwiftUI
import SwiftData

@Observable
@MainActor
class OnboardingViewModel {
    var currentStep: Int = 0
    var selectedAge: String = ""
    var selectedAttribution: String = ""
    var selectedGoal: String = ""
    var selectedExperience: String = ""
    var selectedBlocker: String = ""
    var heightFeet: Int = 5
    var heightInches: Int = 10
    var weightLbs: String = "170"
    var targetWeightLbs: String = "165"
    var selectedGender: String = "Male"
    var useMetric: Bool = false
    var heightCm: Int = 178
    var weightKg: String = "77"
    var targetWeightKg: String = "75"
    var frontPhotoData: Data?
    var sidePhotoData: Data?
    var isScanning: Bool = false
    var scanProgress: Double = 0
    var scanComplete: Bool = false
    var scanResult: BodyScan?
    var userName: String = ""
    var hasTriedOtherApps: Bool? = nil
    var setupProgress: Double = 0
    var isSettingUp: Bool = false

    let totalSteps: Int = 15

    var progress: Double {
        guard currentStep > 0 else { return 0 }
        return Double(currentStep) / Double(totalSteps - 1)
    }

    var canContinue: Bool {
        switch currentStep {
        case 0: return true
        case 1: return !selectedGender.isEmpty
        case 2: return !selectedAge.isEmpty
        case 3: return !weightLbs.isEmpty || !weightKg.isEmpty
        case 4: return !selectedGoal.isEmpty
        case 5: return !targetWeightLbs.isEmpty || !targetWeightKg.isEmpty
        case 6: return true
        case 7: return !selectedExperience.isEmpty
        case 8: return !selectedBlocker.isEmpty
        case 9: return !selectedAttribution.isEmpty
        case 10: return hasTriedOtherApps != nil
        case 11: return true
        case 12: return true
        case 13: return true
        case 14: return true
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
            return (Double(weightKg) ?? 77) * 2.20462
        }
        return Double(weightLbs) ?? 170
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

    func performScan() {
        isScanning = true
        scanProgress = 0

        Task {
            for i in 1...20 {
                try? await Task.sleep(for: .milliseconds(150))
                scanProgress = Double(i) / 20.0
            }
            isScanning = false
            scanComplete = true

            scanResult = BodyScan(
                date: Date(),
                overallScore: 5.7,
                symmetry: 6.5, definition: 5.3, mass: 5.9,
                proportions: 5.5, vtaper: 5.7, core: 5.2,
                chestScore: 6.0, backScore: 5.5, shoulderScore: 6.4,
                armScore: 5.7, coreScore: 5.2, legScore: 5.3,
                tierName: "High-Tier Chadlite",
                frontPhotoData: frontPhotoData,
                sidePhotoData: sidePhotoData
            )
        }
    }

    func simulateSetup() {
        isSettingUp = true
        setupProgress = 0
        Task {
            for i in 1...100 {
                try? await Task.sleep(for: .milliseconds(40))
                setupProgress = Double(i) / 100.0
            }
            isSettingUp = false
            nextStep()
        }
    }

    func saveProfile(context: ModelContext) {
        let profile = UserProfile(
            name: userName.isEmpty ? "Athlete" : userName,
            age: selectedAge,
            gender: selectedGender,
            heightInches: heightInTotalInches,
            weightLbs: weightInLbs,
            goal: selectedGoal,
            experience: selectedExperience,
            attribution: selectedAttribution
        )
        context.insert(profile)

        if let scan = scanResult {
            context.insert(scan)
        }
    }
}
