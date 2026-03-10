import SwiftData
import Foundation

@Model
class WeightEntry {
    var date: Date
    var weightLbs: Double

    init(date: Date = Date(), weightLbs: Double = 0) {
        self.date = date
        self.weightLbs = weightLbs
    }
}
