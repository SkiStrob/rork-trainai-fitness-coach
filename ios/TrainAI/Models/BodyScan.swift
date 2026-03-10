import SwiftData
import Foundation

@Model
class BodyScan {
    var date: Date
    var overallScore: Double
    var symmetry: Double
    var definition: Double
    var mass: Double
    var proportions: Double
    var vtaper: Double
    var core: Double
    var chestScore: Double
    var backScore: Double
    var shoulderScore: Double
    var armScore: Double
    var coreScore: Double
    var legScore: Double
    var tierName: String
    @Attribute(.externalStorage) var frontPhotoData: Data?
    @Attribute(.externalStorage) var sidePhotoData: Data?

    init(
        date: Date = Date(),
        overallScore: Double = 0,
        symmetry: Double = 0,
        definition: Double = 0,
        mass: Double = 0,
        proportions: Double = 0,
        vtaper: Double = 0,
        core: Double = 0,
        chestScore: Double = 0,
        backScore: Double = 0,
        shoulderScore: Double = 0,
        armScore: Double = 0,
        coreScore: Double = 0,
        legScore: Double = 0,
        tierName: String = "",
        frontPhotoData: Data? = nil,
        sidePhotoData: Data? = nil
    ) {
        self.date = date
        self.overallScore = overallScore
        self.symmetry = symmetry
        self.definition = definition
        self.mass = mass
        self.proportions = proportions
        self.vtaper = vtaper
        self.core = core
        self.chestScore = chestScore
        self.backScore = backScore
        self.shoulderScore = shoulderScore
        self.armScore = armScore
        self.coreScore = coreScore
        self.legScore = legScore
        self.tierName = tierName
        self.frontPhotoData = frontPhotoData
        self.sidePhotoData = sidePhotoData
    }
}
