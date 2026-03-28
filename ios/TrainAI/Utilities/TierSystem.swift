import SwiftUI

nonisolated struct TierInfo: Sendable {
    let name: String
    let message: String
    let color: Color
    let hasGlassEffect: Bool

    static func tier(for score: Double, gender: String) -> TierInfo {
        let isFemale = gender.lowercased() == "female"
        let clampedScore = max(1.0, min(10.0, score))

        switch clampedScore {
        case 1.0..<2.0:
            return TierInfo(name: "Starting Out", message: "Everyone starts somewhere. Let's build.", color: Color(.systemGray), hasGlassEffect: false)
        case 2.0..<3.0:
            return TierInfo(name: "Foundation", message: "Building your base. Keep going.", color: Color(.systemGray), hasGlassEffect: false)
        case 3.0..<4.0:
            return TierInfo(name: "Rising", message: "Solid foundation. Time to level up.", color: Color(.systemGray), hasGlassEffect: false)
        case 4.0..<5.0:
            return TierInfo(name: "Contender", message: "You're ahead of most. Let's push further.", color: Color(red: 0.85, green: 0.75, blue: 0.45), hasGlassEffect: false)
        case 5.0..<5.5:
            return TierInfo(name: isFemale ? "Stacylite" : "Chadlite", message: "Top 20%. Standing out.", color: Color(red: 0.9, green: 0.8, blue: 0.3), hasGlassEffect: true)
        case 5.5..<6.0:
            return TierInfo(name: isFemale ? "High-Tier Stacylite" : "High-Tier Chadlite", message: "Top 10%. Turning heads.", color: Color(red: 0.9, green: 0.8, blue: 0.3), hasGlassEffect: true)
        case 6.0..<6.5:
            return TierInfo(name: isFemale ? "Stacy" : "Chad", message: "Top 5%. Impressive physique.", color: Color(red: 0.2, green: 0.8, blue: 0.5), hasGlassEffect: true)
        case 6.5..<7.0:
            return TierInfo(name: isFemale ? "GigaStacy" : "GigaChad", message: "Elite. One in a thousand.", color: Color(red: 0.0, green: 0.8, blue: 0.7), hasGlassEffect: true)
        case 7.0..<7.5:
            return TierInfo(name: isFemale ? "True Eve" : "True Adam", message: "Near-perfect aesthetics.", color: Color(red: 0.5, green: 0.8, blue: 1.0), hasGlassEffect: true)
        case 7.5...10.0:
            return TierInfo(name: "Ascended", message: "Peak human physique. Legendary.", color: Color(red: 0.8, green: 0.6, blue: 1.0), hasGlassEffect: true)
        default:
            return TierInfo(name: "Starting Out", message: "Everyone starts somewhere. Let's build.", color: Color(.systemGray), hasGlassEffect: false)
        }
    }
}
