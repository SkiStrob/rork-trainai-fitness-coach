import SwiftUI
import SwiftData

struct FoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appColors) private var colors
    @Query(sort: \FoodEntry.date, order: .reverse) private var allEntries: [FoodEntry]
    @Query(sort: \UserProfile.createdAt) private var profiles: [UserProfile]
    @State private var showScanner: Bool = false
    @State private var showManualEntry: Bool = false

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
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 24) {
                        macrosDashboard
                        mealSections
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
                .background(colors.background)

                scanButton
            }
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
            .sheet(isPresented: $showScanner) {
                FoodScannerView()
            }
            .sheet(isPresented: $showManualEntry) {
                ManualFoodEntryView()
            }
        }
    }

    private var macrosDashboard: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            MacroBarView(label: "Calories", current: Double(totalCalories), goal: Double(profile?.dailyCalorieGoal ?? 2400), unit: " cal", color: Color(red: 0.13, green: 0.77, blue: 0.37))
            MacroBarView(label: "Protein", current: totalProtein, goal: Double(profile?.dailyProteinGoal ?? 165), unit: "g", color: Color(red: 0.9, green: 0.3, blue: 0.3))
            MacroBarView(label: "Carbs", current: totalCarbs, goal: Double(profile?.dailyCarbsGoal ?? 300), unit: "g", color: .orange)
            MacroBarView(label: "Fats", current: totalFat, goal: Double(profile?.dailyFatGoal ?? 80), unit: "g", color: Color(red: 0.3, green: 0.5, blue: 0.9))
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
                            showScanner = true
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundStyle(.primary)
                        }
                    }
                } else {
                    ForEach(entries) { entry in
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.name)
                                    .font(.subheadline)
                                    .foregroundStyle(colors.primaryText)
                                Text("\(entry.calories) cal")
                                    .font(.caption)
                                    .foregroundStyle(colors.secondaryText)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .padding(20)
            .background(colors.cardBackground)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(color: colors.cardShadow, radius: 8, y: 2)
        }
    }

    private var scanButton: some View {
        Button {
            HapticManager.light()
            showScanner = true
        } label: {
            Image(systemName: "camera.fill")
                .font(.title2)
                .foregroundStyle(colors.ctaForeground)
                .frame(width: 56, height: 56)
                .background(colors.ctaBackground)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
    }
}
