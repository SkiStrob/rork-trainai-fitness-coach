import SwiftUI
import SwiftData

struct FoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appColors) private var colors
    @Query(sort: \FoodEntry.date, order: .reverse) private var allEntries: [FoodEntry]
    @Query(sort: \UserProfile.createdAt) private var profiles: [UserProfile]
    @State private var showManualEntry: Bool = false
    @State private var selectedEntry: FoodEntry? = nil

    private var profile: UserProfile? { profiles.first }

    private var todayEntries: [FoodEntry] {
        let today = Calendar.current.startOfDay(for: Date())
        return allEntries.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }

    private var totalCalories: Int { todayEntries.reduce(0) { $0 + $1.calories } }
    private var totalProtein: Double { todayEntries.reduce(0) { $0 + $1.proteinGrams } }
    private var totalCarbs: Double { todayEntries.reduce(0) { $0 + $1.carbsGrams } }
    private var totalFat: Double { todayEntries.reduce(0) { $0 + $1.fatGrams } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    macrosDashboard
                    mealSections
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
