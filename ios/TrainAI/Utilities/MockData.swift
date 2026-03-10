import Foundation
import SwiftData

enum MockData {
    static func populateMockData(context: ModelContext) {
        let profile = UserProfile(
            name: "Alex",
            age: "25-34",
            gender: "Male",
            heightInches: 71,
            weightLbs: 178,
            goal: "Build Muscle",
            experience: "Intermediate (6mo-2yr)",
            attribution: "Instagram",
            createdAt: Calendar.current.date(byAdding: .day, value: -45, to: Date()) ?? Date(),
            currentStreak: 12
        )
        context.insert(profile)

        let scan1 = BodyScan(
            date: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
            overallScore: 5.2,
            symmetry: 6.0, definition: 4.8, mass: 5.5, proportions: 5.0, vtaper: 5.3, core: 4.6,
            chestScore: 5.5, backScore: 5.0, shoulderScore: 6.0, armScore: 5.2, coreScore: 4.6, legScore: 4.8,
            tierName: "Chadlite"
        )
        let scan2 = BodyScan(
            date: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date(),
            overallScore: 5.5,
            symmetry: 6.2, definition: 5.1, mass: 5.7, proportions: 5.3, vtaper: 5.5, core: 5.0,
            chestScore: 5.8, backScore: 5.3, shoulderScore: 6.2, armScore: 5.5, coreScore: 5.0, legScore: 5.1,
            tierName: "High-Tier Chadlite"
        )
        let scan3 = BodyScan(
            date: Date(),
            overallScore: 5.7,
            symmetry: 6.5, definition: 5.3, mass: 5.9, proportions: 5.5, vtaper: 5.7, core: 5.2,
            chestScore: 6.0, backScore: 5.5, shoulderScore: 6.4, armScore: 5.7, coreScore: 5.2, legScore: 5.3,
            tierName: "High-Tier Chadlite"
        )
        context.insert(scan1)
        context.insert(scan2)
        context.insert(scan3)

        let program = WorkoutProgram(name: "Push Pull Legs", totalWeeks: 12, currentWeek: 3, templateType: "PPL", isActive: true)

        let pushDay = ProgramDay(dayOfWeek: 1, workoutName: "Push Day", muscleGroups: "Chest, Shoulders, Triceps", isRestDay: false)
        let pullDay = ProgramDay(dayOfWeek: 2, workoutName: "Pull Day", muscleGroups: "Back, Biceps", isRestDay: false)
        let legDay = ProgramDay(dayOfWeek: 3, workoutName: "Leg Day", muscleGroups: "Quads, Hamstrings, Glutes", isRestDay: false)
        let restDay1 = ProgramDay(dayOfWeek: 4, workoutName: "Rest Day", muscleGroups: "", isRestDay: true)
        let pushDay2 = ProgramDay(dayOfWeek: 5, workoutName: "Push Day", muscleGroups: "Chest, Shoulders, Triceps", isRestDay: false)
        let pullDay2 = ProgramDay(dayOfWeek: 6, workoutName: "Pull Day", muscleGroups: "Back, Biceps", isRestDay: false)
        let restDay2 = ProgramDay(dayOfWeek: 7, workoutName: "Rest Day", muscleGroups: "", isRestDay: true)

        let pushExercises = [
            ProgramExercise(name: "Bench Press", muscleGroup: "Chest", targetSets: 4, targetRepsMin: 8, targetRepsMax: 12, orderIndex: 0),
            ProgramExercise(name: "Overhead Press", muscleGroup: "Shoulders", targetSets: 4, targetRepsMin: 8, targetRepsMax: 10, orderIndex: 1),
            ProgramExercise(name: "Incline Dumbbell Press", muscleGroup: "Chest", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12, orderIndex: 2),
            ProgramExercise(name: "Lateral Raises", muscleGroup: "Shoulders", targetSets: 4, targetRepsMin: 12, targetRepsMax: 15, orderIndex: 3),
            ProgramExercise(name: "Tricep Pushdowns", muscleGroup: "Triceps", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12, orderIndex: 4),
            ProgramExercise(name: "Overhead Tricep Extension", muscleGroup: "Triceps", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12, orderIndex: 5)
        ]

        let pullExercises = [
            ProgramExercise(name: "Barbell Rows", muscleGroup: "Back", targetSets: 4, targetRepsMin: 8, targetRepsMax: 10, orderIndex: 0),
            ProgramExercise(name: "Pull-ups", muscleGroup: "Back", targetSets: 4, targetRepsMin: 6, targetRepsMax: 10, orderIndex: 1),
            ProgramExercise(name: "Seated Cable Rows", muscleGroup: "Back", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12, orderIndex: 2),
            ProgramExercise(name: "Face Pulls", muscleGroup: "Rear Delts", targetSets: 3, targetRepsMin: 15, targetRepsMax: 20, orderIndex: 3),
            ProgramExercise(name: "Barbell Curls", muscleGroup: "Biceps", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12, orderIndex: 4),
            ProgramExercise(name: "Hammer Curls", muscleGroup: "Biceps", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12, orderIndex: 5)
        ]

        let legExercises = [
            ProgramExercise(name: "Barbell Squats", muscleGroup: "Quads", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8, orderIndex: 0),
            ProgramExercise(name: "Romanian Deadlifts", muscleGroup: "Hamstrings", targetSets: 4, targetRepsMin: 8, targetRepsMax: 10, orderIndex: 1),
            ProgramExercise(name: "Leg Press", muscleGroup: "Quads", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12, orderIndex: 2),
            ProgramExercise(name: "Leg Curls", muscleGroup: "Hamstrings", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12, orderIndex: 3),
            ProgramExercise(name: "Calf Raises", muscleGroup: "Calves", targetSets: 4, targetRepsMin: 12, targetRepsMax: 15, orderIndex: 4),
            ProgramExercise(name: "Walking Lunges", muscleGroup: "Glutes", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12, orderIndex: 5)
        ]

        for ex in pushExercises { pushDay.exercises.append(ex); pushDay2.exercises.append(ex) }
        for ex in pullExercises { pullDay.exercises.append(ex); pullDay2.exercises.append(ex) }
        for ex in legExercises { legDay.exercises.append(ex) }

        program.days = [pushDay, pullDay, legDay, restDay1, pushDay2, pullDay2, restDay2]
        context.insert(program)

        let today = Date()
        let mealData: [(String, String, Int, Double, Double, Double, Int)] = [
            ("Breakfast", "Oatmeal with Banana & Almonds", 420, 15, 62, 14, 7),
            ("Breakfast", "Protein Shake", 280, 35, 12, 8, 8),
            ("Lunch", "Grilled Chicken Rice Bowl", 650, 45, 72, 18, 8),
            ("Snack", "Greek Yogurt with Berries", 180, 18, 20, 4, 7),
        ]
        for (mealType, name, cal, protein, carbs, fat, health) in mealData {
            let entry = FoodEntry(date: today, mealType: mealType, name: name, calories: cal, proteinGrams: protein, carbsGrams: carbs, fatGrams: fat, healthScore: health)
            context.insert(entry)
        }

        let weightData: [(Int, Double)] = [(-30, 182), (-25, 181), (-20, 180), (-15, 179.5), (-10, 179), (-5, 178.5), (0, 178)]
        for (daysAgo, weight) in weightData {
            let date = Calendar.current.date(byAdding: .day, value: daysAgo, to: today) ?? today
            let entry = WeightEntry(date: date, weightLbs: weight)
            context.insert(entry)
        }

        let pastWorkout = WorkoutSession(
            date: Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today,
            programName: "Push Pull Legs",
            workoutName: "Pull Day",
            duration: 3240,
            isCompleted: true
        )
        let ex1 = ExerciseLog(exerciseName: "Barbell Rows", muscleGroup: "Back", targetSets: 4, targetRepsMin: 8, targetRepsMax: 10)
        ex1.sets = [
            SetLog(setNumber: 1, weight: 135, reps: 10, isCompleted: true),
            SetLog(setNumber: 2, weight: 135, reps: 10, isCompleted: true),
            SetLog(setNumber: 3, weight: 135, reps: 9, isCompleted: true),
            SetLog(setNumber: 4, weight: 135, reps: 8, isCompleted: true)
        ]
        pastWorkout.exercises = [ex1]
        context.insert(pastWorkout)
    }
}
