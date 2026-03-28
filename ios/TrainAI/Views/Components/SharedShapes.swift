import SwiftUI

struct ScanBrackets: Shape {
    var cornerSegmentLength: CGFloat = 0.28

    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerLength: CGFloat = rect.width * cornerSegmentLength

        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerLength))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + cornerLength, y: rect.minY))

        path.move(to: CGPoint(x: rect.maxX - cornerLength, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerLength))

        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerLength))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerLength, y: rect.maxY))

        path.move(to: CGPoint(x: rect.minX + cornerLength, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerLength))

        return path
    }
}

struct FrontSilhouetteGuide: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2

        path.addEllipse(in: CGRect(x: cx - 8, y: 0, width: 16, height: 18))
        path.move(to: CGPoint(x: cx, y: 18))
        path.addLine(to: CGPoint(x: cx - w * 0.4, y: h * 0.25))
        path.move(to: CGPoint(x: cx, y: 18))
        path.addLine(to: CGPoint(x: cx + w * 0.4, y: h * 0.25))
        path.move(to: CGPoint(x: cx, y: 18))
        path.addLine(to: CGPoint(x: cx, y: h * 0.55))
        path.move(to: CGPoint(x: cx, y: h * 0.55))
        path.addLine(to: CGPoint(x: cx - w * 0.25, y: h))
        path.move(to: CGPoint(x: cx, y: h * 0.55))
        path.addLine(to: CGPoint(x: cx + w * 0.25, y: h))

        return path
    }
}

struct SideSilhouetteGuide: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w * 0.45

        path.addEllipse(in: CGRect(x: cx - 7, y: 0, width: 14, height: 16))
        path.move(to: CGPoint(x: cx, y: 16))
        path.addQuadCurve(
            to: CGPoint(x: cx + w * 0.15, y: h * 0.55),
            control: CGPoint(x: cx + w * 0.2, y: h * 0.3)
        )
        path.move(to: CGPoint(x: cx + w * 0.15, y: h * 0.55))
        path.addLine(to: CGPoint(x: cx + w * 0.1, y: h))
        path.move(to: CGPoint(x: cx + w * 0.15, y: h * 0.55))
        path.addLine(to: CGPoint(x: cx - w * 0.1, y: h))

        return path
    }
}
