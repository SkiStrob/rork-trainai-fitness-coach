import SwiftUI

nonisolated struct TierInfo: Sendable {
    let name: String
    let message: String
    let color: Color
    let hasGlassEffect: Bool

    static func tier(for score: Double, gender: String) -> TierInfo {
        let isFemale = gender.lowercased() == "female"
        switch score {
        case 0..<2.1:
            return TierInfo(name: "Starting Out", message: "Everyone starts somewhere. Let's build.", color: Color(red: 0.6, green: 0.6, blue: 0.6), hasGlassEffect: false)
        case 2.1..<3.1:
            return TierInfo(name: "Foundation", message: "Your base is set. Time to grow.", color: Color(red: 0.5, green: 0.5, blue: 0.55), hasGlassEffect: false)
        case 3.1..<4.1:
            return TierInfo(name: "Rising", message: "Progress is showing. Keep pushing.", color: Color(red: 0.96, green: 0.62, blue: 0.04), hasGlassEffect: false)
        case 4.1..<5.0:
            return TierInfo(name: "Contender", message: "You're ahead of most. Let's level up.", color: Color(red: 0.96, green: 0.62, blue: 0.04), hasGlassEffect: false)
        case 5.0..<5.5:
            return TierInfo(name: isFemale ? "Stacylite" : "Chadlite", message: "Top 5%. You stand out.", color: Color(red: 0.13, green: 0.77, blue: 0.37), hasGlassEffect: false)
        case 5.5..<6.0:
            return TierInfo(name: isFemale ? "High-Tier Stacylite" : "High-Tier Chadlite", message: "Impressive. Turning heads.", color: Color(red: 0.13, green: 0.77, blue: 0.37), hasGlassEffect: false)
        case 6.0..<6.5:
            return TierInfo(name: isFemale ? "Stacy" : "Chad", message: "1 in 1,000. Elite.", color: Color(red: 0.0, green: 0.7, blue: 0.4), hasGlassEffect: true)
        case 6.5..<7.0:
            return TierInfo(name: isFemale ? "GigaStacy" : "GigaChad", message: "The most attractive in any room.", color: Color(red: 0.0, green: 0.65, blue: 0.85), hasGlassEffect: true)
        case 7.0..<7.5:
            return TierInfo(name: isFemale ? "True Eve" : "True Adam", message: "PSL God tier.", color: Color(red: 0.3, green: 0.5, blue: 1.0), hasGlassEffect: true)
        default:
            return TierInfo(name: "Ascended", message: "Peak human aesthetics.", color: Color(red: 0.6, green: 0.4, blue: 1.0), hasGlassEffect: true)
        }
    }
}
