import SwiftUI
import SwiftData

@main
struct TrainAIApp: App {
    @State private var themeManager = ThemeManager.shared

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            BodyScan.self,
            WorkoutSession.self,
            ExerciseLog.self,
            SetLog.self,
            FoodEntry.self,
            WeightEntry.self,
            WorkoutProgram.self,
            ProgramDay.self,
            ProgramExercise.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
                .environment(\.appColors, AppColors(colorScheme: themeManager.isDarkMode ? .dark : .light))
                .environment(themeManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
