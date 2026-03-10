import SwiftUI
import Charts

struct BodyRatio: Identifiable {
    let id = UUID()
    let name: String
    let value: String
    let score: Double
    let ideal: String
    let description: String
    let focusArea: CGRect
    let measurementType: MeasurementType

    enum MeasurementType {
        case shoulders, chest, waist, hips, arms, legs, vtaper, torso, armSymmetry, overall
    }
}

struct BodyAnalysisView: View {
    let scan: BodyScan
    let gender: String

    @State private var lineProgress: Double = 0
    @State private var dotsVisible: Bool = false
    @State private var labelsVisible: Bool = false
    @State private var selectedRatioID: UUID? = nil
    @State private var focusBlurRadius: Double = 0

    private let silhouetteHeight: CGFloat = 340
    private let silhouetteWidth: CGFloat = 160

    private var ratios: [BodyRatio] {
        [
            BodyRatio(name: "Shoulder to Waist Ratio", value: "1.62x", score: 9.2, ideal: "1.618", description: "Compares shoulder width to waist width. The golden ratio 1.618 is the ideal aesthetic proportion.", focusArea: CGRect(x: 0.15, y: 0.18, width: 0.7, height: 0.12), measurementType: .shoulders),
            BodyRatio(name: "V-Taper Angle", value: "83.4\u{00B0}", score: 8.1, ideal: "80-85\u{00B0}", description: "The angle formed by your shoulder-to-waist taper. A sharper angle indicates a more dramatic V-shape.", focusArea: CGRect(x: 0.15, y: 0.18, width: 0.7, height: 0.25), measurementType: .vtaper),
            BodyRatio(name: "Waist to Hip Ratio", value: "0.82x", score: 8.5, ideal: "0.80", description: "Lower ratios indicate a more defined waist relative to hips.", focusArea: CGRect(x: 0.2, y: 0.38, width: 0.6, height: 0.14), measurementType: .waist),
            BodyRatio(name: "Chest to Waist Ratio", value: "1.38x", score: 7.2, ideal: "1.4", description: "Measures chest circumference relative to waist. Higher values indicate greater upper body development.", focusArea: CGRect(x: 0.18, y: 0.22, width: 0.64, height: 0.12), measurementType: .chest),
            BodyRatio(name: "Arm Symmetry", value: "96.2%", score: 8.8, ideal: ">95%", description: "Measures how evenly developed your left and right arms are.", focusArea: CGRect(x: 0.05, y: 0.22, width: 0.9, height: 0.18), measurementType: .armSymmetry),
            BodyRatio(name: "Leg to Torso Ratio", value: "1.05x", score: 6.9, ideal: "1.0-1.1", description: "Compares leg length to torso length for overall proportions.", focusArea: CGRect(x: 0.2, y: 0.5, width: 0.6, height: 0.45), measurementType: .legs),
            BodyRatio(name: "Upper to Lower Body Ratio", value: "1.12x", score: 6.5, ideal: "1.0", description: "Balance between upper and lower body muscle development.", focusArea: CGRect(x: 0.1, y: 0.15, width: 0.8, height: 0.8), measurementType: .torso),
            BodyRatio(name: "Core Definition Index", value: "72%", score: 5.2, ideal: ">80%", description: "Estimated core muscle visibility and definition.", focusArea: CGRect(x: 0.25, y: 0.35, width: 0.5, height: 0.15), measurementType: .hips),
            BodyRatio(name: "Shoulder Width Index", value: "88.4%", score: 7.8, ideal: ">85%", description: "Shoulder width relative to overall frame.", focusArea: CGRect(x: 0.1, y: 0.15, width: 0.8, height: 0.1), measurementType: .shoulders),
            BodyRatio(name: "Overall Proportions Score", value: "78.3%", score: 7.4, ideal: ">75%", description: "Composite score of all body ratios and symmetry.", focusArea: CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.85), measurementType: .overall),
        ]
    }

    private var selectedRatio: BodyRatio? {
        guard let id = selectedRatioID else { return nil }
        return ratios.first(where: { $0.id == id })
    }

    var body: some View {
        VStack(spacing: 20) {
            silhouetteSection
                .frame(height: silhouetteHeight + 40)
                .padding(.horizontal, 16)

            ratiosList
        }
        .onAppear {
            animateIn()
        }
    }

    private var silhouetteSection: some View {
        GeometryReader { geo in
            let centerX = geo.size.width / 2
            let originY: CGFloat = 20

            ZStack {
                Color.black
                    .clipShape(.rect(cornerRadius: 20))

                ZStack {
                    BodySilhouetteShape()
                        .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                        .frame(width: silhouetteWidth, height: silhouetteHeight)
                        .position(x: centerX, y: originY + silhouetteHeight / 2)
                        .blur(radius: selectedRatio != nil ? 12 : 0)

                    if selectedRatio != nil {
                        BodySilhouetteShape()
                            .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                            .frame(width: silhouetteWidth, height: silhouetteHeight)
                            .position(x: centerX, y: originY + silhouetteHeight / 2)
                            .mask(
                                focusMask(in: geo.size, originY: originY)
                            )
                    }

                    measurementOverlays(centerX: centerX, originY: originY)
                }
            }
        }
    }

    private func focusMask(in size: CGSize, originY: CGFloat) -> some View {
        Canvas { context, canvasSize in
            guard let ratio = selectedRatio else { return }
            let silX = (size.width - silhouetteWidth) / 2
            let focusRect = CGRect(
                x: silX + ratio.focusArea.origin.x * silhouetteWidth,
                y: originY + ratio.focusArea.origin.y * silhouetteHeight,
                width: ratio.focusArea.width * silhouetteWidth,
                height: ratio.focusArea.height * silhouetteHeight
            )
            let rounded = Path(roundedRect: focusRect, cornerRadius: 16)
            context.fill(rounded, with: .color(.white))
        }
    }

    @ViewBuilder
    private func measurementOverlays(centerX: CGFloat, originY: CGFloat) -> some View {
        let sW = silhouetteWidth
        let sH = silhouetteHeight
        let leftX = centerX - sW / 2
        let rightX = centerX + sW / 2

        let shoulderY = originY + sH * 0.2
        let chestY = originY + sH * 0.27
        let waistY = originY + sH * 0.42
        let hipY = originY + sH * 0.5
        let shoulderLeft = leftX + sW * 0.05
        let shoulderRight = rightX - sW * 0.05
        let waistLeft = leftX + sW * 0.22
        let waistRight = rightX - sW * 0.22

        let isShoulderFocused = selectedRatio?.measurementType == .shoulders || selectedRatio?.measurementType == .vtaper || selectedRatio == nil
        let isChestFocused = selectedRatio?.measurementType == .chest || selectedRatio == nil
        let isWaistFocused = selectedRatio?.measurementType == .waist || selectedRatio?.measurementType == .vtaper || selectedRatio == nil
        let isHipFocused = selectedRatio?.measurementType == .hips || selectedRatio == nil
        let isArmFocused = selectedRatio?.measurementType == .armSymmetry || selectedRatio?.measurementType == .arms || selectedRatio == nil
        let isLegFocused = selectedRatio?.measurementType == .legs || selectedRatio == nil
        let isOverall = selectedRatio?.measurementType == .overall || selectedRatio == nil

        Group {
            MeasurementLine(
                from: CGPoint(x: shoulderLeft, y: shoulderY),
                to: CGPoint(x: shoulderRight, y: shoulderY),
                label: "1.62x",
                labelOffset: -14,
                progress: lineProgress,
                dotsVisible: dotsVisible,
                labelVisible: labelsVisible,
                highlighted: isShoulderFocused || isOverall,
                dimmed: selectedRatio != nil && !isShoulderFocused && !isOverall
            )

            MeasurementLine(
                from: CGPoint(x: shoulderLeft + 12, y: chestY),
                to: CGPoint(x: shoulderRight - 12, y: chestY),
                label: "1.38x",
                labelOffset: -14,
                progress: lineProgress,
                dotsVisible: dotsVisible,
                labelVisible: labelsVisible,
                highlighted: isChestFocused || isOverall,
                dimmed: selectedRatio != nil && !isChestFocused && !isOverall
            )

            MeasurementLine(
                from: CGPoint(x: waistLeft, y: waistY),
                to: CGPoint(x: waistRight, y: waistY),
                label: "0.82x",
                labelOffset: -14,
                progress: lineProgress,
                dotsVisible: dotsVisible,
                labelVisible: labelsVisible,
                highlighted: isWaistFocused || isOverall,
                dimmed: selectedRatio != nil && !isWaistFocused && !isOverall
            )

            MeasurementLine(
                from: CGPoint(x: waistLeft - 6, y: hipY),
                to: CGPoint(x: waistRight + 6, y: hipY),
                label: "72%",
                labelOffset: -14,
                progress: lineProgress,
                dotsVisible: dotsVisible,
                labelVisible: labelsVisible,
                highlighted: isHipFocused || isOverall,
                dimmed: selectedRatio != nil && !isHipFocused && !isOverall
            )

            MeasurementLine(
                from: CGPoint(x: leftX - 8, y: originY + sH * 0.3),
                to: CGPoint(x: leftX + 8, y: originY + sH * 0.3),
                label: "2.26x",
                labelOffset: -14,
                progress: lineProgress,
                dotsVisible: dotsVisible,
                labelVisible: labelsVisible,
                highlighted: isArmFocused || isOverall,
                dimmed: selectedRatio != nil && !isArmFocused && !isOverall
            )

            MeasurementLine(
                from: CGPoint(x: rightX - 8, y: originY + sH * 0.3),
                to: CGPoint(x: rightX + 8, y: originY + sH * 0.3),
                label: "2.44x",
                labelOffset: -14,
                progress: lineProgress,
                dotsVisible: dotsVisible,
                labelVisible: labelsVisible,
                highlighted: isArmFocused || isOverall,
                dimmed: selectedRatio != nil && !isArmFocused && !isOverall
            )

            MeasurementLine(
                from: CGPoint(x: centerX - 14, y: originY + sH * 0.58),
                to: CGPoint(x: centerX - 14, y: originY + sH * 0.82),
                label: "1.05x",
                labelOffset: 0,
                progress: lineProgress,
                dotsVisible: dotsVisible,
                labelVisible: labelsVisible,
                highlighted: isLegFocused || isOverall,
                dimmed: selectedRatio != nil && !isLegFocused && !isOverall,
                isVertical: true
            )

            if labelsVisible && (isShoulderFocused || isWaistFocused || isOverall) {
                Path { path in
                    path.move(to: CGPoint(x: shoulderLeft, y: shoulderY))
                    path.addLine(to: CGPoint(x: waistLeft, y: waistY))
                }
                .stroke(Color.white.opacity(selectedRatio != nil && !isShoulderFocused && !isWaistFocused && !isOverall ? 0.1 : 0.4), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))

                Path { path in
                    path.move(to: CGPoint(x: shoulderRight, y: shoulderY))
                    path.addLine(to: CGPoint(x: waistRight, y: waistY))
                }
                .stroke(Color.white.opacity(selectedRatio != nil && !isShoulderFocused && !isWaistFocused && !isOverall ? 0.1 : 0.4), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))

                Text("83.4\u{00B0}")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.white.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 6))
                    .position(x: waistRight + 24, y: waistY - 8)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: selectedRatioID)
    }

    private var ratiosList: some View {
        VStack(spacing: 8) {
            ForEach(ratios) { ratio in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                        if selectedRatioID == ratio.id {
                            selectedRatioID = nil
                        } else {
                            selectedRatioID = ratio.id
                        }
                    }
                } label: {
                    VStack(spacing: 0) {
                        ratioRow(ratio)

                        if selectedRatioID == ratio.id {
                            ratioDetail(ratio)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(selectedRatioID == ratio.id ? Color.white.opacity(0.08) : Color(white: 0.11))
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }

    private func ratioRow(_ ratio: BodyRatio) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(ratio.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)

                HStack(spacing: 6) {
                    scoreBar(score: ratio.score)
                    Text(String(format: "%.1f/10", ratio.score))
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.5))
                }
            }

            Spacer()

            Text(ratio.value)
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.white.opacity(0.12))
                .clipShape(.rect(cornerRadius: 8))

            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.3))
                .rotationEffect(.degrees(selectedRatioID == ratio.id ? 90 : 0))
        }
    }

    private func ratioDetail(_ ratio: BodyRatio) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider().background(Color.white.opacity(0.1))
                .padding(.top, 10)

            Text(ratio.description)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                Text("Ideal:")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
                Text(ratio.ideal)
                    .font(.caption2.bold())
                    .foregroundStyle(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.green.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 6))
            }

            bellCurveChart(score: ratio.score, value: ratio.value)
                .frame(height: 110)
        }
    }

    private func bellCurveChart(score: Double, value: String) -> some View {
        let points: [BellCurvePoint] = (0...100).map { i in
            let x = Double(i) / 100.0 * 10.0
            let mean = 5.0
            let sd = 2.0
            let y = exp(-pow(x - mean, 2) / (2 * sd * sd))
            return BellCurvePoint(x: x, y: y * 10)
        }

        return Chart {
            ForEach(points) { point in
                AreaMark(
                    x: .value("Value", point.x),
                    y: .value("Score", point.y)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.green.opacity(0.2), Color.green.opacity(0.02)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)

                LineMark(
                    x: .value("Value", point.x),
                    y: .value("Score", point.y)
                )
                .foregroundStyle(Color.green.opacity(0.6))
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 1.5))
            }

            RuleMark(x: .value("You", score))
                .foregroundStyle(.white.opacity(0.6))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                .annotation(position: .top, alignment: .center) {
                    Text("You: \(value)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.15))
                        .clipShape(.rect(cornerRadius: 4))
                }
        }
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(values: [0, 2, 4, 6, 8, 10]) { _ in
                AxisValueLabel()
                    .foregroundStyle(.white.opacity(0.4))
            }
        }
        .chartXScale(domain: 0...10)
        .chartPlotStyle { plot in
            plot.background(Color.clear)
        }
    }

    private func scoreBar(score: Double) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.08))
                RoundedRectangle(cornerRadius: 2)
                    .fill(scoreColor(score))
                    .frame(width: geo.size.width * min(score / 10.0, 1.0))
            }
        }
        .frame(width: 60, height: 4)
    }

    private func scoreColor(_ score: Double) -> Color {
        if score < 5 { return Color(red: 0.94, green: 0.27, blue: 0.27) }
        if score < 7 { return Color(red: 0.96, green: 0.62, blue: 0.04) }
        return Color(red: 0.13, green: 0.77, blue: 0.37)
    }

    private func animateIn() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.85).delay(0.1)) {
            lineProgress = 1.0
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85).delay(0.3)) {
            dotsVisible = true
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85).delay(0.5)) {
            labelsVisible = true
        }
    }
}

nonisolated struct BellCurvePoint: Identifiable {
    let id = UUID()
    let x: Double
    let y: Double
}

struct MeasurementLine: View {
    let from: CGPoint
    let to: CGPoint
    let label: String
    let labelOffset: CGFloat
    let progress: Double
    let dotsVisible: Bool
    let labelVisible: Bool
    var highlighted: Bool = true
    var dimmed: Bool = false
    var isVertical: Bool = false

    private var opacity: Double {
        if dimmed { return 0.1 }
        if highlighted { return 0.7 }
        return 0.4
    }

    private var lineWidth: CGFloat {
        highlighted && !dimmed ? 1.5 : 1
    }

    var body: some View {
        ZStack {
            Path { path in
                let mid = CGPoint(x: (from.x + to.x) / 2, y: (from.y + to.y) / 2)
                let startX = mid.x + (from.x - mid.x) * progress
                let startY = mid.y + (from.y - mid.y) * progress
                let endX = mid.x + (to.x - mid.x) * progress
                let endY = mid.y + (to.y - mid.y) * progress
                path.move(to: CGPoint(x: startX, y: startY))
                path.addLine(to: CGPoint(x: endX, y: endY))
            }
            .stroke(Color.white.opacity(opacity), lineWidth: lineWidth)

            if dotsVisible {
                Circle()
                    .fill(Color.white.opacity(opacity + 0.1))
                    .frame(width: 4, height: 4)
                    .position(from)

                Circle()
                    .fill(Color.white.opacity(opacity + 0.1))
                    .frame(width: 4, height: 4)
                    .position(to)
            }

            if labelVisible {
                let midX = (from.x + to.x) / 2
                let midY = (from.y + to.y) / 2
                Text(label)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white.opacity(dimmed ? 0.2 : 0.9))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.white.opacity(dimmed ? 0.05 : 0.15))
                    .clipShape(.rect(cornerRadius: 6))
                    .position(
                        x: isVertical ? midX + 24 : midX,
                        y: isVertical ? midY : midY + labelOffset
                    )
            }
        }
    }
}

struct BodySilhouetteShape: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2

        path.move(to: CGPoint(x: cx, y: h * 0.02))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.08, y: h * 0.08), control: CGPoint(x: cx + w * 0.1, y: h * 0.02))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.04, y: h * 0.14), control: CGPoint(x: cx + w * 0.1, y: h * 0.12))
        path.addLine(to: CGPoint(x: cx + w * 0.06, y: h * 0.16))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.42, y: h * 0.2), control: CGPoint(x: cx + w * 0.35, y: h * 0.16))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.48, y: h * 0.28), control: CGPoint(x: cx + w * 0.5, y: h * 0.22))
        path.addLine(to: CGPoint(x: cx + w * 0.38, y: h * 0.35))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.32, y: h * 0.2), control: CGPoint(x: cx + w * 0.36, y: h * 0.26))
        path.addLine(to: CGPoint(x: cx + w * 0.22, y: h * 0.22))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.24, y: h * 0.38), control: CGPoint(x: cx + w * 0.26, y: h * 0.3))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.2, y: h * 0.44), control: CGPoint(x: cx + w * 0.24, y: h * 0.42))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.22, y: h * 0.5), control: CGPoint(x: cx + w * 0.18, y: h * 0.47))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.18, y: h * 0.54), control: CGPoint(x: cx + w * 0.24, y: h * 0.52))
        path.addLine(to: CGPoint(x: cx + w * 0.22, y: h * 0.58))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.24, y: h * 0.78), control: CGPoint(x: cx + w * 0.28, y: h * 0.68))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.2, y: h * 0.84), control: CGPoint(x: cx + w * 0.26, y: h * 0.82))
        path.addLine(to: CGPoint(x: cx + w * 0.22, y: h * 0.92))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.28, y: h * 0.98), control: CGPoint(x: cx + w * 0.22, y: h * 0.96))
        path.addLine(to: CGPoint(x: cx + w * 0.08, y: h * 0.98))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.06, y: h * 0.92), control: CGPoint(x: cx + w * 0.06, y: h * 0.96))
        path.addLine(to: CGPoint(x: cx + w * 0.08, y: h * 0.84))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.04, y: h * 0.78), control: CGPoint(x: cx + w * 0.04, y: h * 0.82))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.06, y: h * 0.58), control: CGPoint(x: cx + w * 0.06, y: h * 0.68))
        path.addLine(to: CGPoint(x: cx + w * 0.02, y: h * 0.54))

        path.addLine(to: CGPoint(x: cx - w * 0.02, y: h * 0.54))
        path.addLine(to: CGPoint(x: cx - w * 0.06, y: h * 0.58))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.04, y: h * 0.78), control: CGPoint(x: cx - w * 0.06, y: h * 0.68))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.08, y: h * 0.84), control: CGPoint(x: cx - w * 0.04, y: h * 0.82))
        path.addLine(to: CGPoint(x: cx - w * 0.06, y: h * 0.92))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.08, y: h * 0.98), control: CGPoint(x: cx - w * 0.06, y: h * 0.96))
        path.addLine(to: CGPoint(x: cx - w * 0.28, y: h * 0.98))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.22, y: h * 0.92), control: CGPoint(x: cx - w * 0.22, y: h * 0.96))
        path.addLine(to: CGPoint(x: cx - w * 0.2, y: h * 0.84))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.24, y: h * 0.78), control: CGPoint(x: cx - w * 0.26, y: h * 0.82))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.22, y: h * 0.58), control: CGPoint(x: cx - w * 0.28, y: h * 0.68))
        path.addLine(to: CGPoint(x: cx - w * 0.18, y: h * 0.54))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.22, y: h * 0.5), control: CGPoint(x: cx - w * 0.24, y: h * 0.52))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.2, y: h * 0.44), control: CGPoint(x: cx - w * 0.18, y: h * 0.47))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.24, y: h * 0.38), control: CGPoint(x: cx - w * 0.24, y: h * 0.42))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.22, y: h * 0.22), control: CGPoint(x: cx - w * 0.26, y: h * 0.3))
        path.addLine(to: CGPoint(x: cx - w * 0.32, y: h * 0.2))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.38, y: h * 0.35), control: CGPoint(x: cx - w * 0.36, y: h * 0.26))
        path.addLine(to: CGPoint(x: cx - w * 0.48, y: h * 0.28))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.42, y: h * 0.2), control: CGPoint(x: cx - w * 0.5, y: h * 0.22))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.06, y: h * 0.16), control: CGPoint(x: cx - w * 0.35, y: h * 0.16))
        path.addLine(to: CGPoint(x: cx - w * 0.04, y: h * 0.14))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.08, y: h * 0.08), control: CGPoint(x: cx - w * 0.1, y: h * 0.12))
        path.addQuadCurve(to: CGPoint(x: cx, y: h * 0.02), control: CGPoint(x: cx - w * 0.1, y: h * 0.02))

        path.closeSubpath()
        return path
    }
}
