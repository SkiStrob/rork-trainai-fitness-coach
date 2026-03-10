import SwiftUI
import SwiftData

@Observable
@MainActor
class AppViewModel {
    var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") }
        set { UserDefaults.standard.set(newValue, forKey: "hasCompletedOnboarding") }
    }

    var hasSeenPaywall: Bool {
        get { UserDefaults.standard.bool(forKey: "hasSeenPaywall") }
        set { UserDefaults.standard.set(newValue, forKey: "hasSeenPaywall") }
    }

    var isSubscribed: Bool {
        get { UserDefaults.standard.bool(forKey: "isSubscribed") }
        set { UserDefaults.standard.set(newValue, forKey: "isSubscribed") }
    }

    var selectedTab: Int = 0
    var showScoreReveal: Bool = false
    var latestScanScore: Double = 0
}
