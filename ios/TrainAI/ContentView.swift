import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appColors) private var colors
    @State private var appViewModel = AppViewModel()
    @State private var showPaywall: Bool = false
    @State private var hasPopulatedMockData: Bool = UserDefaults.standard.bool(forKey: "hasPopulatedMockData")

    var body: some View {
        Group {
            if !appViewModel.hasCompletedOnboarding {
                OnboardingView { scan in
                    appViewModel.hasCompletedOnboarding = true
                    showPaywall = true
                    populateMockDataIfNeeded()
                    NotificationService.requestPermission()
                }
            } else if showPaywall && !appViewModel.hasSeenPaywall {
                PaywallView {
                    appViewModel.hasSeenPaywall = true
                    appViewModel.isSubscribed = true
                    showPaywall = false
                    scheduleNotifications()
                }
            } else {
                MainTabView()
                    .onAppear {
                        populateMockDataIfNeeded()
                    }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: appViewModel.hasCompletedOnboarding)
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: showPaywall)
    }

    private func populateMockDataIfNeeded() {
        guard !hasPopulatedMockData else { return }
        MockData.populateMockData(context: modelContext)
        hasPopulatedMockData = true
        UserDefaults.standard.set(true, forKey: "hasPopulatedMockData")
    }

    private func scheduleNotifications() {
        NotificationService.requestPermission()
        Task {
            try? await Task.sleep(for: .seconds(1))
            NotificationService.setupAllNotifications(workoutName: "Push Day")
        }
    }
}
