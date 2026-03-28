import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var appViewModel = AppViewModel()
    @State private var showSplash: Bool = true

    var body: some View {
        Group {
            if showSplash {
                SplashView {
                    showSplash = false
                }
            } else if !appViewModel.hasCompletedOnboarding {
                OnboardingView { scan in
                    appViewModel.hasCompletedOnboarding = true
                    NotificationService.requestPermission()
                }
            } else {
                MainTabView()
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: appViewModel.hasCompletedOnboarding)
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: showSplash)
    }
}
