import SwiftUI

struct MainTabView: View {
    @Environment(\.appColors) private var colors
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: selectedTab == 0 ? "house.fill" : "house", value: 0) {
                HomeView()
            }

            Tab("Program", systemImage: selectedTab == 1 ? "dumbbell.fill" : "dumbbell", value: 1) {
                ProgramView()
            }

            Tab("Food", systemImage: "fork.knife", value: 2) {
                FoodView()
            }

            Tab("Progress", systemImage: selectedTab == 3 ? "chart.line.uptrend.xyaxis" : "chart.line.uptrend.xyaxis", value: 3) {
                ProgressTabView()
            }

            Tab("Profile", systemImage: selectedTab == 4 ? "person.fill" : "person", value: 4) {
                ProfileView()
            }
        }
        .tint(colors.tabBarTint)
        .onChange(of: selectedTab) { _, _ in
            HapticManager.selection()
        }
    }
}
