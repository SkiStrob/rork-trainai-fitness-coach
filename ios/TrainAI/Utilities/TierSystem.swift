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
            return TierInfo(name: "Starting Out", message: "Everyone starts somewhere. Let's build.", color: Color(.systemGray), hasGlassEffect: false)
        case 2.1..<3.1:
            return TierInfo(name: "Foundation", message: "Your base is set. Time to grow.", color: Color(.systemGray2), hasGlassEffect: false)
        case 3.1..<4.1:
            return TierInfo(name: "Rising", message: "Progress is showing. Keep pushing.", color: Color(white: 0.75), hasGlassEffect: false)
        case 4.1..<5.0:
            return TierInfo(name: "Contender", message: "You're ahead of most. Let's level up.", color: Color(red: 0.85, green: 0.75, blue: 0.45), hasGlassEffect: false)
        case 5.0..<5.5:
            return TierInfo(name: isFemale ? "Stacylite" : "Chadlite", message: "Top 5%. You stand out.", color: Color(red: 0.9, green: 0.8, blue: 0.3), hasGlassEffect: false)
        case 5.5..<6.0:
            return TierInfo(name: isFemale ? "High-Tier Stacylite" : "High-Tier Chadlite", message: "Impressive. Turning heads.", color: Color(red: 1.0, green: 0.85, blue: 0.2), hasGlassEffect: false)
        case 6.0..<6.5:
            return TierInfo(name: isFemale ? "Stacy" : "Chad", message: "1 in 1,000. Elite.", color: Color(red: 0.2, green: 0.8, blue: 0.5), hasGlassEffect: true)
        case 6.5..<7.0:
            return TierInfo(name: isFemale ? "GigaStacy" : "GigaChad", message: "The most attractive in any room.", color: Color(red: 0.0, green: 0.8, blue: 0.7), hasGlassEffect: true)
        case 7.0..<7.5:
            return TierInfo(name: isFemale ? "True Eve" : "True Adam", message: "PSL God tier.", color: Color(red: 0.5, green: 0.8, blue: 1.0), hasGlassEffect: true)
        default:
            return TierInfo(name: "Ascended", message: "Peak human aesthetics.", color: Color(red: 0.8, green: 0.6, blue: 1.0), hasGlassEffect: true)
        }
    }
}
