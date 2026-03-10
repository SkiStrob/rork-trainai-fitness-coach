import SwiftUI

struct RadarChartView: View {
    @Environment(\.appColors) private var colors
    let values: [Double]
    let labels: [String]
    let maxValue: Double
    var animated: Bool = true

    @State private var animationProgress: Double = 0

    private var effectiveValues: [Double] {
        values.map { $0 * animationProgress }
    }

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2 - 30

            ZStack {
                ForEach(0..<5) { ring in
                    RadarGridShape(sides: values.count, scale: Double(ring + 1) / 5.0)
                        .stroke(colors.separator, lineWidth: 0.5)
                        .frame(width: radius * 2, height: radius * 2)
                        .position(center)
                }

                ForEach(0..<values.count, id: \.self) { i in
                    let angle = angleFor(index: i)
                    Path { path in
                        path.move(to: center)
                        path.addLine(to: pointAt(center: center, radius: radius, angle: angle))
                    }
                    .stroke(colors.separator, lineWidth: 0.5)
                }

                RadarDataShape(values: effectiveValues, maxValue: maxValue)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: radius * 2, height: radius * 2)
                    .position(center)

                RadarDataShape(values: effectiveValues, maxValue: maxValue)
                    .stroke(Color.blue.opacity(0.6), lineWidth: 1.5)
                    .frame(width: radius * 2, height: radius * 2)
                    .position(center)

                ForEach(0..<values.count, id: \.self) { i in
                    let angle = angleFor(index: i)
                    let labelRadius = radius + 22
                    let pt = pointAt(center: center, radius: labelRadius, angle: angle)

                    VStack(spacing: 1) {
                        Text(labels[i])
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.secondary)
                        Text(String(format: "%.1f", values[i]))
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(colors.primaryText)
                    }
                    .position(pt)
                }

                ForEach(0..<values.count, id: \.self) { i in
                    let angle = angleFor(index: i)
                    let val = effectiveValues[i] / maxValue
                    let pt = pointAt(center: center, radius: radius * val, angle: angle)

                    Circle()
                        .fill(Color.blue)
                        .frame(width: 5, height: 5)
                        .position(pt)
                }
            }
        }
        .onAppear {
            if animated {
                withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                    animationProgress = 1.0
                }
            } else {
                animationProgress = 1.0
            }
        }
    }

    private func angleFor(index: Int) -> Double {
        let count = values.count
        return (Double(index) / Double(count)) * 2 * .pi - .pi / 2
    }

    private func pointAt(center: CGPoint, radius: Double, angle: Double) -> CGPoint {
        CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
    }
}

struct RadarGridShape: Shape {
    let sides: Int
    let scale: Double

    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 * scale

        for i in 0...sides {
            let angle = (Double(i) / Double(sides)) * 2 * .pi - .pi / 2
            let point = CGPoint(x: center.x + cos(angle) * radius, y: center.y + sin(angle) * radius)
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

struct RadarDataShape: Shape {
    let values: [Double]
    let maxValue: Double

    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let count = values.count
        guard count > 0 else { return path }

        for i in 0...count {
            let idx = i % count
            let angle = (Double(idx) / Double(count)) * 2 * .pi - .pi / 2
            let value = min(values[idx] / maxValue, 1.0)
            let point = CGPoint(
                x: center.x + cos(angle) * radius * value,
                y: center.y + sin(angle) * radius * value
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}
