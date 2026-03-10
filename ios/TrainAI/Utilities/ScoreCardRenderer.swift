import SwiftUI
import UIKit

enum ScoreCardRenderer {
    static func renderShareCard(score: Double, tierName: String, tierColor: Color, radarValues: [Double], date: Date) -> UIImage {
        let size = CGSize(width: 1080, height: 1920)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let context = ctx.cgContext

            UIColor.black.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            let watermark = "TrainAI"
            let watermarkAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36, weight: .bold),
                .foregroundColor: UIColor.white.withAlphaComponent(0.5)
            ]
            let watermarkSize = (watermark as NSString).size(withAttributes: watermarkAttrs)
            (watermark as NSString).draw(at: CGPoint(x: (size.width - watermarkSize.width) / 2, y: 80), withAttributes: watermarkAttrs)

            let scoreText = String(format: "%.1f", score)
            let scoreAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 180, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let scoreSize = (scoreText as NSString).size(withAttributes: scoreAttrs)
            (scoreText as NSString).draw(at: CGPoint(x: (size.width - scoreSize.width) / 2, y: 300), withAttributes: scoreAttrs)

            let tierAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 48, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
            let tierSize = (tierName as NSString).size(withAttributes: tierAttrs)
            let tierRect = CGRect(x: (size.width - tierSize.width - 60) / 2, y: 520, width: tierSize.width + 60, height: tierSize.height + 24)
            context.setFillColor(UIColor.white.withAlphaComponent(0.15).cgColor)
            let tierPath = UIBezierPath(roundedRect: tierRect, cornerRadius: tierRect.height / 2)
            context.addPath(tierPath.cgPath)
            context.fillPath()
            (tierName as NSString).draw(at: CGPoint(x: tierRect.minX + 30, y: tierRect.minY + 12), withAttributes: tierAttrs)

            let centerX = size.width / 2
            let centerY: CGFloat = 900
            let radius: CGFloat = 200
            let labels = ["SYM", "DEF", "MASS", "PROP", "V-TAP", "CORE"]
            let count = radarValues.count
            for i in 0..<count {
                let angle = CGFloat(i) * (2 * .pi / CGFloat(count)) - .pi / 2
                let value = CGFloat(radarValues[i] / 10.0)
                let x = centerX + cos(angle) * radius * value
                let y = centerY + sin(angle) * radius * value

                if i == 0 {
                    context.move(to: CGPoint(x: x, y: y))
                } else {
                    context.addLine(to: CGPoint(x: x, y: y))
                }

                let labelX = centerX + cos(angle) * (radius + 40)
                let labelY = centerY + sin(angle) * (radius + 40)
                let labelAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 24, weight: .medium),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.7)
                ]
                let lSize = (labels[i] as NSString).size(withAttributes: labelAttrs)
                (labels[i] as NSString).draw(at: CGPoint(x: labelX - lSize.width / 2, y: labelY - lSize.height / 2), withAttributes: labelAttrs)
            }
            context.closePath()
            context.setFillColor(UIColor.white.withAlphaComponent(0.1).cgColor)
            context.fillPath()

            let formatter = DateFormatter()
            formatter.dateStyle = .long
            let dateStr = formatter.string(from: date)
            let dateAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 32, weight: .regular),
                .foregroundColor: UIColor.white.withAlphaComponent(0.5)
            ]
            let dateSize = (dateStr as NSString).size(withAttributes: dateAttrs)
            (dateStr as NSString).draw(at: CGPoint(x: (size.width - dateSize.width) / 2, y: 1750), withAttributes: dateAttrs)
        }
    }
}
