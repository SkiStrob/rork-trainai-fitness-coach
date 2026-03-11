import SwiftUI
import SwiftData

nonisolated struct FoodDatabaseItem: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let serving: String
}

private let foodDatabase: [FoodDatabaseItem] = [
    FoodDatabaseItem(name: "Chicken Breast (grilled)", calories: 165, protein: 31, carbs: 0, fat: 3.6, serving: "100g"),
    FoodDatabaseItem(name: "Brown Rice", calories: 216, protein: 5, carbs: 45, fat: 1.8, serving: "1 cup"),
    FoodDatabaseItem(name: "Salmon Fillet", calories: 208, protein: 20, carbs: 0, fat: 13, serving: "100g"),
    FoodDatabaseItem(name: "Sweet Potato", calories: 103, protein: 2.3, carbs: 24, fat: 0.1, serving: "1 medium"),
    FoodDatabaseItem(name: "Greek Yogurt", calories: 100, protein: 17, carbs: 6, fat: 0.7, serving: "170g"),
    FoodDatabaseItem(name: "Eggs (whole)", calories: 155, protein: 13, carbs: 1.1, fat: 11, serving: "2 large"),
    FoodDatabaseItem(name: "Oatmeal", calories: 154, protein: 5, carbs: 27, fat: 2.6, serving: "1 cup cooked"),
    FoodDatabaseItem(name: "Banana", calories: 105, protein: 1.3, carbs: 27, fat: 0.4, serving: "1 medium"),
    FoodDatabaseItem(name: "Avocado", calories: 240, protein: 3, carbs: 13, fat: 22, serving: "1 whole"),
    FoodDatabaseItem(name: "Protein Shake", calories: 280, protein: 35, carbs: 12, fat: 8, serving: "1 scoop + milk"),
    FoodDatabaseItem(name: "Almonds", calories: 164, protein: 6, carbs: 6, fat: 14, serving: "1 oz"),
    FoodDatabaseItem(name: "Broccoli", calories: 55, protein: 3.7, carbs: 11, fat: 0.6, serving: "1 cup"),
    FoodDatabaseItem(name: "Steak (sirloin)", calories: 271, protein: 26, carbs: 0, fat: 18, serving: "6 oz"),
    FoodDatabaseItem(name: "Tuna (canned)", calories: 132, protein: 29, carbs: 0, fat: 1, serving: "1 can"),
    FoodDatabaseItem(name: "Peanut Butter", calories: 188, protein: 8, carbs: 6, fat: 16, serving: "2 tbsp"),
    FoodDatabaseItem(name: "White Rice", calories: 206, protein: 4.3, carbs: 45, fat: 0.4, serving: "1 cup"),
    FoodDatabaseItem(name: "Pasta (cooked)", calories: 220, protein: 8, carbs: 43, fat: 1.3, serving: "1 cup"),
    FoodDatabaseItem(name: "Turkey Breast", calories: 135, protein: 30, carbs: 0, fat: 1, serving: "100g"),
    FoodDatabaseItem(name: "Cottage Cheese", calories: 206, protein: 28, carbs: 6, fat: 9, serving: "1 cup"),
    FoodDatabaseItem(name: "Apple", calories: 95, protein: 0.5, carbs: 25, fat: 0.3, serving: "1 medium"),
]

struct FoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appColors) private var colors
    @Query(sort: \FoodEntry.date, order: .reverse) private var allEntries: [FoodEntry]
    @Query(sort: \UserProfile.createdAt) private var profiles: [UserProfile]
    @State private var showManualEntry: Bool = false
    @State private var selectedEntry: FoodEntry? = nil
    @State private var searchText: String = ""
    @State private var showSearchResults: Bool = false
    @State private var selectedMealTypeForQuickAdd: String = "Lunch"

    private var profile: UserProfile? { profiles.first }

    private var todayEntries: [FoodEntry] {
        let today = Calendar.current.startOfDay(for: Date())
        return allEntries.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }

    private var totalCalories: Int { todayEntries.reduce(0) { $0 + $1.calories } }
    private var totalProtein: Double { todayEntries.reduce(0) { $0 + $1.proteinGrams } }
    private var totalCarbs: Double { todayEntries.reduce(0) { $0 + $1.carbsGrams } }
    private var totalFat: Double { todayEntries.reduce(0) { $0 + $1.fatGrams } }

    private var filteredFoodItems: [FoodDatabaseItem] {
        guard !searchText.isEmpty else { return [] }
        return foodDatabase.filter { $0.name.localizedStandardContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    foodSearchBar

                    if !searchText.isEmpty {
                        searchResultsList
                    } else {
                        macrosDashboard
                        mealSections
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(colors.background)
            .navigationTitle("Food")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showManualEntry = true
                    } label: {
                        Image(systemName: "pencil.line")
                            .foregroundStyle(.primary)
                    }
                }
            }
            .sheet(isPresented: $showManualEntry) {
                ManualFoodEntryView()
            }
            .sheet(item: $selectedEntry) { entry in
                FoodDetailSheet(entry: entry)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var foodSearchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.body)
                .foregroundStyle(.secondary)

            TextField("Search food database...", text: $searchText)
                .font(.body)
                .foregroundStyle(colors.primaryText)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(colors.inputBackground)
        .clipShape(.rect(cornerRadius: 12))
    }

    private var searchResultsList: some View {
        VStack(spacing: 8) {
            if filteredFoodItems.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    Text("No results for \"\(searchText)\"")
                        .font(.subheadline)
                        .foregroundStyle(colors.secondaryText)
                    Button {
                        showManualEntry = true
                    } label: {
                        Text("Log manually")
                            .font(.subheadline.bold())
                            .foregroundStyle(colors.ctaForeground)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(colors.ctaBackground)
                            .clipShape(.rect(cornerRadius: 10))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ForEach(filteredFoodItems) { item in
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(item.name)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(colors.primaryText)
                                .lineLimit(1)
                            HStack(spacing: 8) {
                                HStack(spacing: 3) {
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 9))
                                        .foregroundStyle(.primary)
                                    Text("\(item.calories) cal")
                                        .font(.caption)
                                        .foregroundStyle(colors.secondaryText)
                                }
                                Text(item.serving)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        HStack(spacing: 4) {
                            Text("P:\(Int(item.protein))")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Color(red: 0.9, green: 0.3, blue: 0.3))
                            Text("C:\(Int(item.carbs))")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.orange)
                            Text("F:\(Int(item.fat))")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Color(red: 0.3, green: 0.5, blue: 0.9))
                        }

                        Button {
                            quickAddFood(item)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.primary)
                        }
                    }
                    .padding(14)
                    .background(colors.cardBackground)
                    .clipShape(.rect(cornerRadius: 14))
                    .shadow(color: colors.cardShadow, radius: 6, y: 2)
                }
            }
        }
    }

    private func quickAddFood(_ item: FoodDatabaseItem) {
        let hour = Calendar.current.component(.hour, from: Date())
        let mealType: String
        if hour < 11 { mealType = "Breakfast" }
        else if hour < 15 { mealType = "Lunch" }
        else if hour < 20 { mealType = "Dinner" }
        else { mealType = "Snack" }

        let entry = FoodEntry(
            date: Date(),
            mealType: mealType,
            name: item.name,
            calories: item.calories,
            proteinGrams: item.protein,
            carbsGrams: item.carbs,
            fatGrams: item.fat,
            healthScore: 7
        )
        modelContext.insert(entry)
        HapticManager.success()
        searchText = ""
    }

    private var macrosDashboard: some View {
        VStack(spacing: 12) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                MacroProgressBar(
                    label: "Calories",
                    current: Double(totalCalories),
                    goal: Double(profile?.dailyCalorieGoal ?? 2400),
                    unit: " cal",
                    color: Color(red: 0.13, green: 0.77, blue: 0.37)
                )
                MacroProgressBar(
                    label: "Protein",
                    current: totalProtein,
                    goal: Double(profile?.dailyProteinGoal ?? 165),
                    unit: "g",
                    color: Color(red: 0.9, green: 0.3, blue: 0.3)
                )
                MacroProgressBar(
                    label: "Carbs",
                    current: totalCarbs,
                    goal: Double(profile?.dailyCarbsGoal ?? 300),
                    unit: "g",
                    color: .orange
                )
                MacroProgressBar(
                    label: "Fats",
                    current: totalFat,
                    goal: Double(profile?.dailyFatGoal ?? 80),
                    unit: "g",
                    color: Color(red: 0.3, green: 0.5, blue: 0.9)
                )
            }
        }
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }

    private var mealSections: some View {
        ForEach(["Breakfast", "Lunch", "Dinner", "Snack"], id: \.self) { mealType in
            let entries = todayEntries.filter { $0.mealType == mealType }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(mealType)
                        .font(.headline)
                        .foregroundStyle(colors.primaryText)
                    Spacer()
                    if !entries.isEmpty {
                        Text("\(entries.reduce(0) { $0 + $1.calories }) cal")
                            .font(.caption)
                            .foregroundStyle(colors.secondaryText)
                    }
                }

                if entries.isEmpty {
                    HStack {
                        Text("No items logged")
                            .font(.subheadline)
                            .foregroundStyle(colors.secondaryText)
                        Spacer()
                        Button {
                            showManualEntry = true
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundStyle(.primary)
                        }
                    }
                } else {
                    ForEach(entries) { entry in
                        Button {
                            selectedEntry = entry
                        } label: {
                            FoodEntryRow(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
            .background(colors.cardBackground)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(color: colors.cardShadow, radius: 8, y: 2)
        }
    }
}

struct FoodEntryRow: View {
    @Environment(\.appColors) private var colors
    let entry: FoodEntry

    var body: some View {
        HStack(spacing: 12) {
            if let photoData = entry.photoData, !photoData.isEmpty,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(.rect(cornerRadius: 10))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                        .frame(width: 48, height: 48)
                    Image(systemName: "fork.knife")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(colors.primaryText)
                    .lineLimit(1)
                Text("\(entry.calories) cal")
                    .font(.caption)
                    .foregroundStyle(colors.secondaryText)
            }

            Spacer()

            HStack(spacing: 4) {
                MacroPill(label: "P", value: Int(entry.proteinGrams), color: Color(red: 0.9, green: 0.3, blue: 0.3))
                MacroPill(label: "C", value: Int(entry.carbsGrams), color: .orange)
                MacroPill(label: "F", value: Int(entry.fatGrams), color: Color(red: 0.3, green: 0.5, blue: 0.9))
            }
        }
    }
}

struct MacroPill: View {
    let label: String
    let value: Int
    let color: Color

    var body: some View {
        Text("\(label):\(value)g")
            .font(.system(size: 9, weight: .bold))
            .foregroundStyle(color)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(color.opacity(0.1))
            .clipShape(.rect(cornerRadius: 4))
    }
}

struct MacroProgressBar: View {
    @Environment(\.appColors) private var colors
    let label: String
    let current: Double
    let goal: Double
    let unit: String
    let color: Color

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(current / goal, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(colors.secondaryText)
                Spacer()
                Text("\(Int(current))\(unit) / \(Int(goal))\(unit)")
                    .font(.caption.bold())
                    .foregroundStyle(colors.primaryText)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colors.progressTrack)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 6)
        }
    }
}

struct FoodDetailSheet: View {
    let entry: FoodEntry

    var body: some View {
        VStack(spacing: 20) {
            if let photoData = entry.photoData, !photoData.isEmpty,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipShape(.rect(cornerRadius: 16))
            }

            Text(entry.name)
                .font(.title3.bold())
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                DetailMacroTile(icon: "flame.fill", color: .green, label: "Calories", value: "\(entry.calories)")
                DetailMacroTile(icon: "p.circle.fill", color: Color(red: 0.9, green: 0.3, blue: 0.3), label: "Protein", value: "\(Int(entry.proteinGrams))g")
                DetailMacroTile(icon: "c.circle.fill", color: .orange, label: "Carbs", value: "\(Int(entry.carbsGrams))g")
                DetailMacroTile(icon: "f.circle.fill", color: Color(red: 0.3, green: 0.5, blue: 0.9), label: "Fat", value: "\(Int(entry.fatGrams))g")
            }
            .padding(.horizontal, 16)

            HStack(spacing: 8) {
                Image(systemName: "heart.fill")
                    .font(.caption)
                    .foregroundStyle(.pink)
                Text("Health Score: \(entry.healthScore)/10")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }

            Spacer()
        }
        .padding(.top, 20)
    }
}

struct DetailMacroTile: View {
    let icon: String
    let color: Color
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)
            }

            Spacer()
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 12))
    }
}

struct ManualFoodEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var name: String = ""
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var carbs: String = ""
    @State private var fat: String = ""
    @State private var mealType: String = "Lunch"

    var body: some View {
        NavigationStack {
            Form {
                Section("Meal Info") {
                    TextField("Food name", text: $name)
                    Picker("Meal", selection: $mealType) {
                        Text("Breakfast").tag("Breakfast")
                        Text("Lunch").tag("Lunch")
                        Text("Dinner").tag("Dinner")
                        Text("Snack").tag("Snack")
                    }
                }
                Section("Macros") {
                    TextField("Calories", text: $calories)
                        .keyboardType(.numberPad)
                    TextField("Protein (g)", text: $protein)
                        .keyboardType(.decimalPad)
                    TextField("Carbs (g)", text: $carbs)
                        .keyboardType(.decimalPad)
                    TextField("Fat (g)", text: $fat)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = FoodEntry(
                            date: Date(),
                            mealType: mealType,
                            name: name,
                            calories: Int(calories) ?? 0,
                            proteinGrams: Double(protein) ?? 0,
                            carbsGrams: Double(carbs) ?? 0,
                            fatGrams: Double(fat) ?? 0,
                            healthScore: 5
                        )
                        modelContext.insert(entry)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
