import SwiftUI
import UIKit

enum ScoreCardRenderer {
    static func renderShareCard(score: Double, tierName: String, tierColor: Color, radarValues: [Double], date: Date, frontPhoto: UIImage? = nil) -> UIImage {
        let size = CGSize(width: 1080, height: 1920)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let context = ctx.cgContext

            // Background
            UIColor.black.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // Card background
            let cardRect = CGRect(x: 60, y: 200, width: size.width - 120, height: 1520)
            let cardPath = UIBezierPath(roundedRect: cardRect, cornerRadius: 48)
            context.setFillColor(UIColor(white: 0.1, alpha: 1.0).cgColor)
            context.addPath(cardPath.cgPath)
            context.fillPath()
            context.setStrokeColor(UIColor.white.withAlphaComponent(0.06).cgColor)
            context.setLineWidth(2)
            context.addPath(cardPath.cgPath)
            context.strokePath()

            let centerX = size.width / 2

            // "Ratings" header
            let headerAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 42, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let headerSize = ("Ratings" as NSString).size(withAttributes: headerAttrs)
            ("Ratings" as NSString).draw(at: CGPoint(x: centerX - headerSize.width / 2, y: 240), withAttributes: headerAttrs)

            // User photo circle
            let photoSize: CGFloat = 280
            let photoY: CGFloat = 320
            let photoRect = CGRect(x: centerX - photoSize / 2, y: photoY, width: photoSize, height: photoSize)

            context.saveGState()
            let circlePath = UIBezierPath(ovalIn: photoRect)
            context.addPath(circlePath.cgPath)
            context.clip()

            if let photo = frontPhoto {
                photo.draw(in: photoRect)
            } else {
                context.setFillColor(UIColor(white: 0.2, alpha: 1.0).cgColor)
                context.fill(photoRect)
                let placeholderAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 80, weight: .ultraLight),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.3)
                ]
                let placeholderText = "?"
                let pSize = (placeholderText as NSString).size(withAttributes: placeholderAttrs)
                (placeholderText as NSString).draw(at: CGPoint(x: centerX - pSize.width / 2, y: photoY + photoSize / 2 - pSize.height / 2), withAttributes: placeholderAttrs)
            }
            context.restoreGState()

            // Photo border
            context.setStrokeColor(UIColor.white.withAlphaComponent(0.15).cgColor)
            context.setLineWidth(3)
            let borderRect = photoRect.insetBy(dx: -2, dy: -2)
            context.addEllipse(in: borderRect)
            context.strokePath()

            // Tier badge pill
            let tierY: CGFloat = photoY + photoSize + 24
            let tierAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 28, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
            let tierSize = (tierName as NSString).size(withAttributes: tierAttrs)
            let tierRect = CGRect(x: centerX - (tierSize.width + 40) / 2, y: tierY, width: tierSize.width + 40, height: 44)
            let tierPath = UIBezierPath(roundedRect: tierRect, cornerRadius: 22)
            context.setFillColor(UIColor.white.withAlphaComponent(0.1).cgColor)
            context.addPath(tierPath.cgPath)
            context.fillPath()
            context.setStrokeColor(UIColor.white.withAlphaComponent(0.2).cgColor)
            context.setLineWidth(1)
            context.addPath(tierPath.cgPath)
            context.strokePath()
            (tierName as NSString).draw(at: CGPoint(x: tierRect.minX + 20, y: tierY + (44 - tierSize.height) / 2), withAttributes: tierAttrs)

            // Build 6 score categories
            let overallVal = Int(min(100, max(0, score * 10)))

            // Potential: estimate headroom from weakest to strongest area
            let scores = radarValues.count >= 6
                ? radarValues
                : [score, score, score, score, score, score]
            let minS = scores.min() ?? 0
            let maxS = scores.max() ?? 10
            let headroom = (maxS - minS) * 0.6
            let potentialVal = Int(min(95, max(Double(overallVal) + 5, (score + headroom) * 10)))

            // Aesthetics: average of symmetry + proportions + vtaper
            let sym = scores.count > 0 ? scores[0] : score
            let prop = scores.count > 3 ? scores[3] : score
            let vtap = scores.count > 4 ? scores[4] : score
            let aestheticsVal = Int(min(100, max(0, ((sym + prop + vtap) / 3.0) * 10)))

            let defVal = Int(min(100, max(0, (scores.count > 1 ? scores[1] : score) * 10)))
            let vtaperVal = Int(min(100, max(0, (scores.count > 4 ? scores[4] : score) * 10)))
            let strengthVal = Int(min(100, max(0, (scores.count > 2 ? scores[2] : score) * 10)))

            let categories: [(String, Int)] = [
                ("Overall", overallVal),
                ("Potential", potentialVal),
                ("Aesthetics", aestheticsVal),
                ("Definition", defVal),
                ("V-Taper", vtaperVal),
                ("Strength", strengthVal)
            ]

            // Draw 2-column grid
            let gridStartY: CGFloat = tierY + 44 + 48
            let colWidth: CGFloat = (cardRect.width - 80) / 2
            let rowHeight: CGFloat = 150
            let leftX: CGFloat = cardRect.minX + 40
            let rightX: CGFloat = leftX + colWidth + 40

            for (index, category) in categories.enumerated() {
                let col = index % 2
                let row = index / 2
                let x = col == 0 ? leftX : rightX
                let y = gridStartY + CGFloat(row) * rowHeight

                // Label
                let labelAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 28, weight: .regular),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.5)
                ]
                (category.0 as NSString).draw(at: CGPoint(x: x, y: y), withAttributes: labelAttrs)

                // Score number
                let numAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 56, weight: .bold),
                    .foregroundColor: UIColor.white
                ]
                let numText = "\(category.1)"
                (numText as NSString).draw(at: CGPoint(x: x, y: y + 32), withAttributes: numAttrs)

                // Progress bar
                let barY = y + 100
                let barHeight: CGFloat = 10
                let trackRect = CGRect(x: x, y: barY, width: colWidth, height: barHeight)
                let trackPath = UIBezierPath(roundedRect: trackRect, cornerRadius: 5)
                context.setFillColor(UIColor(white: 0.25, alpha: 1.0).cgColor)
                context.addPath(trackPath.cgPath)
                context.fillPath()

                // Bar color based on value
                let barColor: UIColor
                switch category.1 {
                case 0..<40:   barColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
                case 40..<60:  barColor = UIColor(red: 0.95, green: 0.6, blue: 0.1, alpha: 1.0)
                case 60..<75:  barColor = UIColor(red: 0.95, green: 0.8, blue: 0.2, alpha: 1.0)
                default:       barColor = UIColor(red: 0.2, green: 0.85, blue: 0.4, alpha: 1.0)
                }

                let fillWidth = colWidth * CGFloat(category.1) / 100.0
                let fillRect = CGRect(x: x, y: barY, width: fillWidth, height: barHeight)
                let fillPath = UIBezierPath(roundedRect: fillRect, cornerRadius: 5)
                context.setFillColor(barColor.cgColor)
                context.addPath(fillPath.cgPath)
                context.fillPath()
            }

            // "Fisique" watermark
            let watermarkAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 30, weight: .medium),
                .foregroundColor: UIColor.white.withAlphaComponent(0.3)
            ]
            let wSize = ("Fisique" as NSString).size(withAttributes: watermarkAttrs)
            ("Fisique" as NSString).draw(at: CGPoint(x: centerX - wSize.width / 2, y: cardRect.maxY - 60), withAttributes: watermarkAttrs)

            // Date
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            let dateStr = formatter.string(from: date)
            let dateAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 22, weight: .regular),
                .foregroundColor: UIColor.white.withAlphaComponent(0.2)
            ]
            let dateSize = (dateStr as NSString).size(withAttributes: dateAttrs)
            (dateStr as NSString).draw(at: CGPoint(x: centerX - dateSize.width / 2, y: cardRect.maxY - 28), withAttributes: dateAttrs)
        }
    }
}