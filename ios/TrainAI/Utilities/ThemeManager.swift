import SwiftUI

@Observable
@MainActor
class ThemeManager {
    static let shared = ThemeManager()

    var isDarkMode: Bool {
        get { UserDefaults.standard.object(forKey: "isDarkMode") as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: "isDarkMode") }
    }

    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }
}

struct AppColors {
    let colorScheme: ColorScheme

    var background: Color {
        colorScheme == .dark ? Color.black : Color(red: 0.96, green: 0.96, blue: 0.97)
    }

    var cardBackground: Color {
        colorScheme == .dark ? Color(white: 0.11) : Color.white
    }

    var cardShadow: Color {
        colorScheme == .dark ? Color.clear : Color.black.opacity(0.06)
    }

    var primaryText: Color {
        colorScheme == .dark ? .white : .black
    }

    var secondaryText: Color {
        colorScheme == .dark ? Color(.secondaryLabel) : Color(.secondaryLabel)
    }

    var separator: Color {
        colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.06)
    }

    var inputBackground: Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : Color(white: 0.95)
    }

    var ctaBackground: Color {
        colorScheme == .dark ? Color.white : Color.black
    }

    var ctaForeground: Color {
        colorScheme == .dark ? Color.black : Color.white
    }

    var secondaryButton: Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.06)
    }

    var selectedCard: Color {
        colorScheme == .dark ? Color.white : Color.black
    }

    var selectedCardText: Color {
        colorScheme == .dark ? Color.black : Color.white
    }

    var unselectedCard: Color {
        colorScheme == .dark ? Color(white: 0.11) : Color(white: 0.95)
    }

    var unselectedCardText: Color {
        colorScheme == .dark ? Color.white : Color.black
    }

    var tabBarTint: Color {
        colorScheme == .dark ? .white : .black
    }

    var progressTrack: Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06)
    }
}

struct AppColorsKey: EnvironmentKey {
    static let defaultValue = AppColors(colorScheme: .dark)
}

extension EnvironmentValues {
    var appColors: AppColors {
        get { self[AppColorsKey.self] }
        set { self[AppColorsKey.self] = newValue }
    }
}
