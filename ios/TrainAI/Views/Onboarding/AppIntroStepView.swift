import SwiftUI

struct AppIntroStepView: View {
    let viewModel: OnboardingViewModel
    @State private var currentPhase: Int = 0
    @State private var phoneAppeared: Bool = false
    @State private var phoneFloat: Bool = false

    @State private var bodySilhouetteDraw: CGFloat = 0
    @State private var scanBracketsScale: CGFloat = 0.5
    @State private var scanLineY: CGFloat = -110
    @State private var measureLinesProgress: CGFloat = 0
    @State private var scoreCountUp: Double = 0
    @State private var showScoreLabel: Bool = false

    @State private var foodPhotoOffset: CGFloat = -60
    @State private var foodPhotoOpacity: Double = 0
    @State private var foodBracketsOpacity: Double = 0
    @State private var foodScanX: CGFloat = -100
    @State private var foodPill1: Bool = false
    @State private var foodPill2: Bool = false
    @State private var foodPill3: Bool = false
    @State private var foodSheetOffset: CGFloat = 100

    @State private var dashCalDots: Bool = false
    @State private var dashCalNumber: Int = 0
    @State private var dashRingProgress: CGFloat = 0
    @State private var dashMacros: Bool = false
    @State private var dashChartDraw: CGFloat = 0

    @State private var phaseOpacity: [Double] = [1, 0, 0]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 36)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 220, height: 440)
                    .background(
                        RoundedRectangle(cornerRadius: 36)
                            .fill(currentPhase == 0 ? Color.black : Color.white)
                            .animation(.easeInOut(duration: 0.4), value: currentPhase)
                    )
                    .shadow(color: .black.opacity(0.12), radius: 24, y: 12)

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .frame(width: 70, height: 22)
                    .offset(y: -209)

                ZStack {
                    bodyScanPhase
                        .opacity(phaseOpacity[0])

                    foodScanPhase
                        .opacity(phaseOpacity[1])

                    dashboardPhase
                        .opacity(phaseOpacity[2])
                }
                .frame(width: 200, height: 400)
                .clipShape(.rect(cornerRadius: 30))
            }
            .offset(y: phoneAppeared ? (phoneFloat ? -3 : 0) : 60)
            .opacity(phoneAppeared ? 1 : 0)

            HStack(spacing: 12) {
                featurePill(icon: "chart.bar.fill", text: "Body Scoring")
                featurePill(icon: "fork.knife", text: "Food Tracking")
                featurePill(icon: "dumbbell.fill", text: "AI Programs")
            }
            .padding(.top, 20)
            .opacity(phoneAppeared ? 1 : 0)

            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(i == currentPhase ? Color.black : Color(red: 0.8, green: 0.8, blue: 0.8))
                        .frame(width: 8, height: 8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: currentPhase)
                }
            }
            .padding(.top, 12)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            } label: {
                Text("Skip intro")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 16)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                phoneAppeared = true
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true).delay(0.6)) {
                phoneFloat = true
            }
            startContinuousLoop()
        }
    }

    private var bodyScanPhase: some View {
        ZStack {
            Color.black

            RealisticSilhouetteShape()
                .fill(Color.white.opacity(0.12))
                .frame(width: 120, height: 260)
                .mask(
                    Rectangle()
                        .frame(height: 260 * bodySilhouetteDraw)
                        .frame(maxHeight: .infinity, alignment: .top)
                )

            ScanBrackets()
                .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .frame(width: 140, height: 280)
                .scaleEffect(scanBracketsScale)
                .opacity(scanBracketsScale > 0.6 ? 1 : 0)

            Rectangle()
                .fill(
                    LinearGradient(colors: [.white.opacity(0), .white.opacity(0.5), .white.opacity(0)], startPoint: .leading, endPoint: .trailing)
                )
                .frame(width: 160, height: 2)
                .shadow(color: .white.opacity(0.4), radius: 6)
                .offset(y: scanLineY)

            if measureLinesProgress > 0.3 {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 110 * min(measureLinesProgress * 2, 1), height: 2)
                        .clipShape(.capsule)

                    Spacer().frame(height: 30)

                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 70 * min(measureLinesProgress * 2, 1), height: 2)
                        .clipShape(.capsule)
                }
                .offset(y: -20)
            }

            if showScoreLabel {
                VStack(spacing: 4) {
                    Text(String(format: "%.1f", scoreCountUp))
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText(countsDown: false))

                    Text("Chadlite")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
        }
    }

    private var foodScanPhase: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97)

            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(colors: [Color(red: 0.75, green: 0.85, blue: 0.65), Color(red: 0.85, green: 0.75, blue: 0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(height: 140)
                    .padding(12)
                    .offset(y: foodPhotoOffset)
                    .opacity(foodPhotoOpacity)
                    .overlay {
                        ScanBrackets()
                            .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                            .frame(width: 120, height: 100)
                            .offset(y: -20)
                            .opacity(foodBracketsOpacity)
                    }
                    .overlay {
                        Rectangle()
                            .fill(
                                LinearGradient(colors: [.white.opacity(0), .white.opacity(0.3), .white.opacity(0)], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(width: 2, height: 100)
                            .offset(x: foodScanX, y: -20)
                    }

                if foodPill1 || foodPill2 || foodPill3 {
                    HStack(spacing: 6) {
                        if foodPill1 { foodPill("Chicken 284") }
                        if foodPill2 { foodPill("Rice 206") }
                        if foodPill3 { foodPill("Broccoli 34") }
                    }
                    .padding(.horizontal, 12)
                    .transition(.opacity)
                }

                Spacer()

                VStack(spacing: 6) {
                    Text("524")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.black)
                    Text("calories")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 16) {
                        miniLabel("P: 42g", .red)
                        miniLabel("C: 58g", .orange)
                        miniLabel("F: 12g", .blue)
                    }
                    .padding(.top, 4)
                }
                .padding(.bottom, 16)
                .offset(y: foodSheetOffset)
            }
        }
    }

    private var dashboardPhase: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97)

            VStack(spacing: 8) {
                if dashCalDots {
                    HStack(spacing: 3) {
                        ForEach(0..<7, id: \.self) { i in
                            Circle()
                                .fill(i == 3 ? Color.black : Color.clear)
                                .frame(width: 14, height: 14)
                                .overlay {
                                    if i != 3 {
                                        Text("\(10 + i)")
                                            .font(.system(size: 7))
                                            .foregroundStyle(.primary)
                                    } else {
                                        Text("13")
                                            .font(.system(size: 7, weight: .bold))
                                            .foregroundStyle(.white)
                                    }
                                }
                        }
                    }
                    .padding(.top, 16)
                    .transition(.opacity)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .frame(height: 70)

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(dashCalNumber)")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(.black)
                                .contentTransition(.numericText())
                            Text("Calories left")
                                .font(.system(size: 8))
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        ZStack {
                            Circle()
                                .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 4)
                            Circle()
                                .trim(from: 0, to: dashRingProgress)
                                .stroke(Color.black, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                        }
                        .frame(width: 36, height: 36)
                    }
                    .padding(.horizontal, 12)
                }
                .padding(.horizontal, 10)

                if dashMacros {
                    HStack(spacing: 6) {
                        miniMacro("184g", Color.red.opacity(0.8))
                        miniMacro("300g", Color.orange)
                        miniMacro("71g", Color.blue)
                    }
                    .padding(.horizontal, 10)
                    .transition(.opacity)
                }

                Path { path in
                    path.move(to: CGPoint(x: 20, y: 50))
                    path.addCurve(
                        to: CGPoint(x: 160, y: 15),
                        control1: CGPoint(x: 60, y: 40),
                        control2: CGPoint(x: 120, y: 20)
                    )
                }
                .trim(from: 0, to: dashChartDraw)
                .stroke(Color.green, lineWidth: 2)
                .frame(height: 60)
                .padding(.horizontal, 10)

                Spacer()
            }
        }
    }

    private func featurePill(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(text)
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(red: 0.94, green: 0.94, blue: 0.95))
        .clipShape(Capsule())
    }

    private func foodPill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .bold))
            .foregroundStyle(.black)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }

    private func miniLabel(_ text: String, _ color: Color) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .bold))
            .foregroundStyle(color)
    }

    private func miniMacro(_ value: String, _ color: Color) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.white)
            .frame(height: 36)
            .overlay {
                Text(value)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(color)
            }
    }

    private func startContinuousLoop() {
        Task {
            try? await Task.sleep(for: .milliseconds(600))
            while true {
                await runPhase1()
                try? await Task.sleep(for: .milliseconds(500))

                await crossfadeTo(phase: 1)
                await runPhase2()
                try? await Task.sleep(for: .milliseconds(500))

                await crossfadeTo(phase: 2)
                await runPhase3()
                try? await Task.sleep(for: .milliseconds(800))

                await crossfadeTo(phase: 0)
                resetAllStates()
            }
        }
    }

    private func crossfadeTo(phase: Int) async {
        withAnimation(.easeInOut(duration: 0.4)) {
            for i in 0..<3 {
                phaseOpacity[i] = i == phase ? 1 : 0
            }
            currentPhase = phase
        }
        try? await Task.sleep(for: .milliseconds(400))
    }

    private func resetAllStates() {
        bodySilhouetteDraw = 0
        scanBracketsScale = 0.5
        scanLineY = -110
        measureLinesProgress = 0
        scoreCountUp = 0
        showScoreLabel = false
        foodPhotoOffset = -60
        foodPhotoOpacity = 0
        foodBracketsOpacity = 0
        foodScanX = -100
        foodPill1 = false
        foodPill2 = false
        foodPill3 = false
        foodSheetOffset = 100
        dashCalDots = false
        dashCalNumber = 0
        dashRingProgress = 0
        dashMacros = false
        dashChartDraw = 0
    }

    private func runPhase1() async {
        withAnimation(.easeInOut(duration: 0.8)) {
            bodySilhouetteDraw = 1.0
        }
        try? await Task.sleep(for: .milliseconds(400))

        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            scanBracketsScale = 1.0
        }
        try? await Task.sleep(for: .milliseconds(300))

        withAnimation(.linear(duration: 1.0)) {
            scanLineY = 110
        }
        try? await Task.sleep(for: .milliseconds(600))

        withAnimation(.easeOut(duration: 0.5)) {
            measureLinesProgress = 1.0
        }
        try? await Task.sleep(for: .milliseconds(300))

        showScoreLabel = true
        let steps = 12
        for i in 1...steps {
            try? await Task.sleep(for: .milliseconds(40))
            let progress = Double(i) / Double(steps)
            withAnimation(.easeOut(duration: 0.05)) {
                scoreCountUp = (5.7 * progress * 10).rounded() / 10
            }
        }
        withAnimation(.none) { scoreCountUp = 5.7 }
    }

    private func runPhase2() async {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            foodPhotoOffset = 0
            foodPhotoOpacity = 1
        }
        try? await Task.sleep(for: .milliseconds(300))

        withAnimation(.easeOut(duration: 0.3)) {
            foodBracketsOpacity = 1
        }
        try? await Task.sleep(for: .milliseconds(200))

        withAnimation(.linear(duration: 0.6)) {
            foodScanX = 100
        }
        try? await Task.sleep(for: .milliseconds(400))

        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
            foodPill1 = true
        }
        try? await Task.sleep(for: .milliseconds(300))

        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
            foodPill2 = true
        }
        try? await Task.sleep(for: .milliseconds(300))

        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
            foodPill3 = true
        }
        try? await Task.sleep(for: .milliseconds(200))

        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            foodSheetOffset = 0
        }
    }

    private func runPhase3() async {
        withAnimation(.easeOut(duration: 0.3)) {
            dashCalDots = true
        }
        try? await Task.sleep(for: .milliseconds(300))

        let calSteps = 15
        for i in 1...calSteps {
            try? await Task.sleep(for: .milliseconds(50))
            withAnimation(.easeOut(duration: 0.05)) {
                dashCalNumber = Int(Double(2583) * Double(i) / Double(calSteps))
            }
        }
        dashCalNumber = 2583

        withAnimation(.easeOut(duration: 0.8)) {
            dashRingProgress = 0.72
        }
        try? await Task.sleep(for: .milliseconds(400))

        withAnimation(.easeOut(duration: 0.3)) {
            dashMacros = true
        }
        try? await Task.sleep(for: .milliseconds(300))

        withAnimation(.easeOut(duration: 1.0)) {
            dashChartDraw = 1.0
        }
    }
}

struct RealisticSilhouetteShape: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2

        path.addEllipse(in: CGRect(x: cx - w * 0.1, y: h * 0.01, width: w * 0.2, height: h * 0.1))

        path.move(to: CGPoint(x: cx - w * 0.06, y: h * 0.1))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.44, y: h * 0.2), control: CGPoint(x: cx - w * 0.35, y: h * 0.13))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.48, y: h * 0.3), control: CGPoint(x: cx - w * 0.5, y: h * 0.24))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.3, y: h * 0.2), control: CGPoint(x: cx - w * 0.42, y: h * 0.26))
        path.addLine(to: CGPoint(x: cx - w * 0.2, y: h * 0.22))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.22, y: h * 0.4), control: CGPoint(x: cx - w * 0.24, y: h * 0.32))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.2, y: h * 0.46), control: CGPoint(x: cx - w * 0.22, y: h * 0.44))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.22, y: h * 0.52), control: CGPoint(x: cx - w * 0.18, y: h * 0.49))
        path.addLine(to: CGPoint(x: cx - w * 0.24, y: h * 0.56))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.26, y: h * 0.78), control: CGPoint(x: cx - w * 0.3, y: h * 0.68))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.22, y: h * 0.84), control: CGPoint(x: cx - w * 0.26, y: h * 0.82))
        path.addLine(to: CGPoint(x: cx - w * 0.24, y: h * 0.94))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.3, y: h * 0.99), control: CGPoint(x: cx - w * 0.24, y: h * 0.98))
        path.addLine(to: CGPoint(x: cx - w * 0.1, y: h * 0.99))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.08, y: h * 0.94), control: CGPoint(x: cx - w * 0.08, y: h * 0.98))
        path.addLine(to: CGPoint(x: cx - w * 0.06, y: h * 0.84))
        path.addQuadCurve(to: CGPoint(x: cx - w * 0.04, y: h * 0.56), control: CGPoint(x: cx - w * 0.04, y: h * 0.7))

        path.addLine(to: CGPoint(x: cx + w * 0.04, y: h * 0.56))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.06, y: h * 0.84), control: CGPoint(x: cx + w * 0.04, y: h * 0.7))
        path.addLine(to: CGPoint(x: cx + w * 0.08, y: h * 0.94))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.1, y: h * 0.99), control: CGPoint(x: cx + w * 0.08, y: h * 0.98))
        path.addLine(to: CGPoint(x: cx + w * 0.3, y: h * 0.99))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.24, y: h * 0.94), control: CGPoint(x: cx + w * 0.24, y: h * 0.98))
        path.addLine(to: CGPoint(x: cx + w * 0.22, y: h * 0.84))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.26, y: h * 0.78), control: CGPoint(x: cx + w * 0.26, y: h * 0.82))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.24, y: h * 0.56), control: CGPoint(x: cx + w * 0.3, y: h * 0.68))
        path.addLine(to: CGPoint(x: cx + w * 0.22, y: h * 0.52))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.2, y: h * 0.46), control: CGPoint(x: cx + w * 0.18, y: h * 0.49))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.22, y: h * 0.4), control: CGPoint(x: cx + w * 0.22, y: h * 0.44))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.2, y: h * 0.22), control: CGPoint(x: cx + w * 0.24, y: h * 0.32))
        path.addLine(to: CGPoint(x: cx + w * 0.3, y: h * 0.2))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.48, y: h * 0.3), control: CGPoint(x: cx + w * 0.42, y: h * 0.26))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.44, y: h * 0.2), control: CGPoint(x: cx + w * 0.5, y: h * 0.24))
        path.addQuadCurve(to: CGPoint(x: cx + w * 0.06, y: h * 0.1), control: CGPoint(x: cx + w * 0.35, y: h * 0.13))

        path.closeSubpath()
        return path
    }
}
