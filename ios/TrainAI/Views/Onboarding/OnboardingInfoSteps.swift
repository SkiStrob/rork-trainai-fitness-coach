import SwiftUI

struct RealisticTargetStepView: View {
    let viewModel: OnboardingViewModel
    @State private var cardAppeared: Bool = false
    @State private var figureProgress: [Bool] = [false, false, false]

    private var isFemale: Bool {
        viewModel.selectedGender.lowercased() == "female"
    }

    private var nowIcon: String { "figure.stand" }
    private var midIcon: String {
        isFemale ? "figure.run" : "figure.strengthtraining.traditional"
    }
    private var goalIcon: String {
        isFemale ? "figure.dance" : "figure.strengthtraining.traditional"
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                let diff = viewModel.weightDifference
                let unit = viewModel.weightUnit
                let action = viewModel.selectedGoals.contains("Lose Fat") ? "Losing" : "Gaining"

                (Text("\(action) ") + Text("\(diff) \(unit)").foregroundStyle(Color(red: 1.0, green: 0.58, blue: 0.0)) + Text(" is a realistic target. It's not hard at all!"))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    VStack(spacing: 8) {
                        Image(systemName: nowIcon)
                            .font(.system(size: 60))
                            .foregroundStyle(Color(.systemGray3))
                            .frame(height: 80)
                            .opacity(figureProgress[0] ? 1 : 0)
                            .scaleEffect(figureProgress[0] ? 1 : 0.7)
                        Text("4.2")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                        Text("Now")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(red: 1.0, green: 0.58, blue: 0.0))

                    VStack(spacing: 8) {
                        Image(systemName: midIcon)
                            .font(.system(size: 65))
                            .foregroundStyle(Color(.systemGray))
                            .frame(height: 80)
                            .opacity(figureProgress[1] ? 1 : 0)
                            .scaleEffect(figureProgress[1] ? 1 : 0.7)
                        Text("5.5")
                            .font(.caption.bold())
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray4))
                            .clipShape(Capsule())
                        Text("8 Weeks")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(red: 1.0, green: 0.58, blue: 0.0))

                    VStack(spacing: 8) {
                        Image(systemName: goalIcon)
                            .font(.system(size: 72, weight: .bold))
                            .foregroundStyle(.black)
                            .frame(height: 80)
                            .opacity(figureProgress[2] ? 1 : 0)
                            .scaleEffect(figureProgress[2] ? 1 : 0.7)
                        Text("6.8")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(red: 1.0, green: 0.58, blue: 0.0))
                            .clipShape(Capsule())
                        Text("Goal")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .galaxyCard()
            .padding(.horizontal, 20)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer().frame(height: 20)

            Text("90% of users say the change is obvious after using TrainAI and it is not easy to plateau.")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
            for i in 0..<3 {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.3 + Double(i) * 0.4)) {
                    figureProgress[i] = true
                }
            }
        }
    }
}

struct ProgressSpeedStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var cardAppeared: Bool = false
    @State private var gaugeAnimated: Bool = false

    private let minSpeed: Double = 0.1
    private let maxSpeed: Double = 2.0

    private var normalizedValue: CGFloat {
        CGFloat((viewModel.selectedProgressSpeed - minSpeed) / (maxSpeed - minSpeed))
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("How fast do you want to reach your goal?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(String(format: "%.1f", viewModel.selectedProgressSpeed))
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(.primary)
                            .contentTransition(.numericText())
                        Text(viewModel.weightUnit)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    Text("per week")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                GeometryReader { geo in
                    let trackWidth = geo.size.width
                    let pct = normalizedValue

                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.13, green: 0.77, blue: 0.37),
                                        Color(red: 1.0, green: 0.84, blue: 0.0),
                                        Color(red: 1.0, green: 0.58, blue: 0.0),
                                        Color(red: 0.94, green: 0.27, blue: 0.27)
                                    ],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .frame(height: 8)

                        Circle()
                            .fill(Color.black)
                            .frame(width: 28, height: 28)
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
                            .offset(x: trackWidth * pct - 14)
                    }
                    .frame(height: 28)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let pctVal = max(0, min(1, value.location.x / trackWidth))
                                let raw = minSpeed + pctVal * (maxSpeed - minSpeed)
                                let snapped = (raw * 10).rounded() / 10
                                withAnimation(.interactiveSpring()) {
                                    viewModel.selectedProgressSpeed = max(minSpeed, min(maxSpeed, snapped))
                                }
                                let snapPoints: [Double] = [0.25, 0.8, 1.5]
                                for snap in snapPoints {
                                    if abs(snapped - snap) < 0.1 {
                                        HapticManager.selection()
                                        viewModel.selectedProgressSpeed = snap
                                        break
                                    }
                                }
                            }
                    )
                }
                .frame(height: 28)

                HStack {
                    VStack(spacing: 4) {
                        Image(systemName: "tortoise.fill").font(.caption).foregroundStyle(.secondary)
                        Text("Slow").font(.caption2).foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(spacing: 4) {
                        Image(systemName: "figure.walk").font(.caption).foregroundStyle(.secondary)
                        Text("Moderate").font(.caption2).foregroundStyle(.secondary)
                        Text("Recommended")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(red: 1.0, green: 0.58, blue: 0.0))
                            .clipShape(Capsule())
                    }
                    Spacer()
                    VStack(spacing: 4) {
                        Image(systemName: "hare.fill").font(.caption).foregroundStyle(.secondary)
                        Text("Aggressive").font(.caption2).foregroundStyle(.secondary)
                    }
                }
            }
            .galaxyCard()
            .padding(.horizontal, 20)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
        }
    }
}

struct DarkComparisonStepView: View {
    let viewModel: OnboardingViewModel
    @State private var cardAppeared: Bool = false
    @State private var leftFill: CGFloat = 0
    @State private var rightFill: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Gain twice as much with TrainAI vs on your own")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            HStack(spacing: 10) {
                VStack(spacing: 12) {
                    Text("Without TrainAI")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.primary)

                    Spacer()

                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray5))
                            .frame(height: 140 * leftFill)
                    }
                    .frame(height: 140, alignment: .bottom)

                    Text("20%")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color(.secondaryLabel))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 230)
                .padding(16)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 16))

                VStack(spacing: 12) {
                    Text("With TrainAI")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.primary)

                    Spacer()

                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .frame(height: 140 * rightFill)
                    }
                    .frame(height: 140, alignment: .bottom)

                    Text("2X")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 230)
                .padding(16)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 16))
            }
            .galaxyCard()
            .padding(.horizontal, 20)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer().frame(height: 16)

            (Text("TrainAI makes it easy and holds ").foregroundStyle(.primary) + Text("you accountable.").foregroundStyle(.secondary))
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
                leftFill = 0.2
            }
            withAnimation(.easeOut(duration: 0.8).delay(1.3)) {
                rightFill = 0.75
            }
        }
    }
}

struct PotentialStepView: View {
    let viewModel: OnboardingViewModel
    @State private var chartProgress: CGFloat = 0
    @State private var cardAppeared: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("You have great potential to crush your goal")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Your physique score transition")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "target")
                        .font(.body)
                        .foregroundStyle(Color(red: 1.0, green: 0.58, blue: 0.0))
                }

                ZStack {
                    VStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { _ in
                            Rectangle().fill(Color(.systemGray5)).frame(height: 0.5)
                            Spacer()
                        }
                    }
                    .frame(height: 120)

                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 100))
                        path.addCurve(
                            to: CGPoint(x: 280, y: 20),
                            control1: CGPoint(x: 100, y: 95),
                            control2: CGPoint(x: 200, y: 30)
                        )
                    }
                    .trim(from: 0, to: chartProgress)
                    .stroke(Color.primary, lineWidth: 2.5)
                    .frame(height: 120)

                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 100))
                        path.addCurve(
                            to: CGPoint(x: 280, y: 20),
                            control1: CGPoint(x: 100, y: 95),
                            control2: CGPoint(x: 200, y: 30)
                        )
                        path.addLine(to: CGPoint(x: 280, y: 120))
                        path.addLine(to: CGPoint(x: 0, y: 120))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(colors: [Color(red: 1.0, green: 0.58, blue: 0.0).opacity(0.12), .clear], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(height: 120)
                    .opacity(chartProgress)
                }

                HStack {
                    Text("3 Days").font(.caption).foregroundStyle(.secondary)
                    Spacer()
                    Text("7 Days").font(.caption).foregroundStyle(.secondary)
                    Spacer()
                    Text("30 Days").font(.caption).foregroundStyle(.secondary)
                }

                Text("Based on TrainAI's analysis, physique changes are subtle at first, but after 7 days you can see real differences!")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
            )
            .galaxyCard()
            .padding(.horizontal, 20)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer().frame(height: 20)

            HStack(spacing: 10) {
                Image(systemName: "lock.shield.fill")
                    .font(.body)
                    .foregroundStyle(.secondary)
                Text("Your privacy and security matter to us.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
            withAnimation(.easeInOut(duration: 1.5).delay(0.4)) {
                chartProgress = 1.0
            }
        }
    }
}

struct ThankYouStepView: View {
    let viewModel: OnboardingViewModel
    @State private var cardAppeared: Bool = false
    @State private var bracketPulse: Bool = false
    @State private var scanLineY: CGFloat = -60
    @State private var shieldScale: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                ZStack {
                    ScanBrackets()
                        .stroke(Color.black.opacity(0.7), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .frame(width: 120, height: 120)
                        .scaleEffect(bracketPulse ? 1.04 : 1.0)

                    Image(systemName: "shield.checkmark.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(.black)
                        .scaleEffect(shieldScale)

                    Rectangle()
                        .fill(
                            LinearGradient(colors: [.clear, Color.black.opacity(0.15), .clear], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: 100, height: 2)
                        .blur(radius: 1)
                        .offset(y: scanLineY)
                }
                .frame(width: 120, height: 120)
            }
            .galaxyCard()
            .padding(.horizontal, 40)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer().frame(height: 24)

            Text("Thank you for trusting us")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            Text("Now let's personalize TrainAI for you...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 4)

            Spacer().frame(height: 20)

            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.91, green: 0.97, blue: 0.91))
                        .frame(width: 36, height: 36)
                    Image(systemName: "lock.shield.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Your data stays on your device.")
                        .font(.caption.bold())
                        .foregroundStyle(.primary)
                    Text("We never share your body scan photos.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(14)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 14))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.5)) {
                shieldScale = 1.0
            }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.8)) {
                bracketPulse = true
            }
            startScanLoop()
        }
    }

    private func startScanLoop() {
        Task {
            try? await Task.sleep(for: .milliseconds(800))
            while true {
                scanLineY = -60
                withAnimation(.linear(duration: 2.5)) {
                    scanLineY = 60
                }
                try? await Task.sleep(for: .seconds(3))
            }
        }
    }
}

struct AppleHealthStepView: View {
    let viewModel: OnboardingViewModel
    @State private var cardAppeared: Bool = false
    @State private var nodesVisible: [Bool] = [false, false, false]
    @State private var linesDrawn: CGFloat = 0
    @State private var healthIconVisible: Bool = false

    private let nodeIcons = ["scalemass.fill", "dumbbell.fill", "bed.double.fill"]
    private let nodeLabels = ["Body Metrics", "Workouts", "Recovery"]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 0) {
                ZStack {
                    let centerX: CGFloat = 150
                    let centerY: CGFloat = 170

                    Path { path in
                        path.move(to: CGPoint(x: centerX - 110, y: centerY - 30))
                        path.addLine(to: CGPoint(x: centerX, y: centerY))
                    }
                    .trim(from: 0, to: linesDrawn)
                    .stroke(Color(.systemGray3), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    Path { path in
                        path.move(to: CGPoint(x: centerX - 80, y: centerY + 100))
                        path.addLine(to: CGPoint(x: centerX, y: centerY))
                    }
                    .trim(from: 0, to: linesDrawn)
                    .stroke(Color(.systemGray3), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    Path { path in
                        path.move(to: CGPoint(x: centerX + 80, y: centerY + 100))
                        path.addLine(to: CGPoint(x: centerX, y: centerY))
                    }
                    .trim(from: 0, to: linesDrawn)
                    .stroke(Color(.systemGray3), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    Path { path in
                        path.move(to: CGPoint(x: centerX, y: centerY - 70))
                        path.addLine(to: CGPoint(x: centerX, y: centerY - 30))
                    }
                    .trim(from: 0, to: linesDrawn)
                    .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))

                    VStack(spacing: 6) {
                        Image(systemName: nodeIcons[0])
                            .font(.system(size: 18))
                            .foregroundStyle(Color(.secondaryLabel))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                        Text(nodeLabels[0])
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.secondary)
                    }
                    .position(x: centerX - 110, y: centerY - 30)
                    .opacity(nodesVisible[0] ? 1 : 0)
                    .scaleEffect(nodesVisible[0] ? 1 : 0.5)

                    VStack(spacing: 6) {
                        Image(systemName: nodeIcons[1])
                            .font(.system(size: 18))
                            .foregroundStyle(Color(.secondaryLabel))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                        Text(nodeLabels[1])
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.secondary)
                    }
                    .position(x: centerX - 80, y: centerY + 100)
                    .opacity(nodesVisible[1] ? 1 : 0)
                    .scaleEffect(nodesVisible[1] ? 1 : 0.5)

                    VStack(spacing: 6) {
                        Image(systemName: nodeIcons[2])
                            .font(.system(size: 18))
                            .foregroundStyle(Color(.secondaryLabel))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                        Text(nodeLabels[2])
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.secondary)
                    }
                    .position(x: centerX + 80, y: centerY + 100)
                    .opacity(nodesVisible[2] ? 1 : 0)
                    .scaleEffect(nodesVisible[2] ? 1 : 0.5)

                    Image(systemName: "apple.logo")
                        .font(.system(size: 24))
                        .foregroundStyle(.black)
                        .frame(width: 44, height: 44)
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                        .position(x: centerX, y: centerY - 70)
                        .opacity(healthIconVisible ? 1 : 0)
                        .scaleEffect(healthIconVisible ? 1 : 0.5)

                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                            .shadow(color: .black.opacity(0.08), radius: 8, y: 2)

                        ZStack {
                            ScanBrackets()
                                .stroke(Color.black.opacity(0.7), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                                .frame(width: 32, height: 32)
                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.black)
                        }
                    }
                    .position(x: centerX, y: centerY)
                }
                .frame(width: 300, height: 340)
            }
            .galaxyCard()
            .padding(.horizontal, 20)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer().frame(height: 24)

            Text("Connect to Apple Health")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            Text("Sync your workouts, body metrics, and recovery data for the most accurate physique analysis.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 8)

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
                Text("Not now")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 16)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.3)) {
                healthIconVisible = true
            }
            for i in 0..<3 {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4 + Double(i) * 0.3)) {
                    nodesVisible[i] = true
                }
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
                linesDrawn = 1.0
            }
        }
    }
}

struct CaloriesBurnedStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var cardAppeared: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Add calories burned back to your daily goal?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            VStack(spacing: 16) {
                ZStack {
                    Image(systemName: "figure.run")
                        .font(.system(size: 80))
                        .foregroundStyle(.black.opacity(0.08))
                        .offset(x: -12)

                    Image(systemName: "figure.run")
                        .font(.system(size: 80))
                        .foregroundStyle(.black.opacity(0.15))
                        .offset(x: -6)

                    Image(systemName: "figure.run")
                        .font(.system(size: 80))
                        .foregroundStyle(.black)
                }
                .frame(height: 100)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Goal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill")
                            .font(.body)
                            .foregroundStyle(.primary)
                        Text("500 Cals")
                            .font(.system(size: 22, weight: .bold))
                    }
                    HStack(spacing: 6) {
                        Image(systemName: "figure.run")
                            .font(.caption)
                        Text("Running")
                            .font(.caption)
                        Text("+100 cals")
                            .font(.caption.bold())
                            .foregroundStyle(.green)
                    }
                    .foregroundStyle(.secondary)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 14))
                .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
            }
            .galaxyCard()
            .padding(.horizontal, 20)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer().frame(height: 32)

            HStack(spacing: 12) {
                yesNoButton("No", selected: viewModel.wantsCaloriesBurnedBack == false) {
                    viewModel.wantsCaloriesBurnedBack = false
                }
                yesNoButton("Yes", selected: viewModel.wantsCaloriesBurnedBack == true) {
                    viewModel.wantsCaloriesBurnedBack = true
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: viewModel.wantsCaloriesBurnedBack != nil) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
        }
    }

    private func yesNoButton(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            HapticManager.selection()
            action()
        } label: {
            Text(title)
                .font(.headline)
                .foregroundStyle(selected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(selected ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.94, green: 0.94, blue: 0.95))
                )
        }
    }
}

struct RolloverStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var cardAppeared: Bool = false
    @State private var arrowDrawn: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Rollover extra calories to the next day?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)

                HStack(spacing: 4) {
                    Text("Rollover up to")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("200 cals")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color(red: 1.0, green: 0.58, blue: 0.0))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            ZStack {
                HStack(spacing: 24) {
                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill").font(.caption).foregroundStyle(Color(red: 1, green: 0.42, blue: 0.42))
                            Text("Yesterday").font(.caption.bold()).foregroundStyle(.secondary)
                        }
                        ZStack {
                            Circle().stroke(Color(.systemGray5), lineWidth: 4)
                            Circle().trim(from: 0, to: 0.7).stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round)).rotationEffect(.degrees(-90))
                            Image(systemName: "flame.fill").font(.system(size: 10)).foregroundStyle(.primary)
                        }
                        .frame(width: 48, height: 48)
                        Text("350/500").font(.subheadline.bold())
                        Text("150 left")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.black)
                            .clipShape(Capsule())
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                    .rotationEffect(.degrees(-3))
                    .offset(x: -10, y: -15)

                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill").font(.caption).foregroundStyle(.primary)
                            Text("Today").font(.caption.bold()).foregroundStyle(.primary)
                        }
                        ZStack {
                            Circle().stroke(Color(.systemGray5), lineWidth: 4)
                            Circle().trim(from: 0, to: 0.54).stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round)).rotationEffect(.degrees(-90))
                            Image(systemName: "flame.fill").font(.system(size: 10)).foregroundStyle(.primary)
                        }
                        .frame(width: 48, height: 48)
                        Text("350/650").font(.subheadline.bold())
                        HStack(spacing: 2) {
                            Image(systemName: "arrow.counterclockwise").font(.system(size: 8))
                            Text("+150")
                        }
                        .font(.caption2.bold())
                        .foregroundStyle(Color(red: 1.0, green: 0.58, blue: 0.0))
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                    .rotationEffect(.degrees(2))
                    .offset(x: 10, y: 15)
                }

                Image(systemName: "arrow.right")
                    .font(.title3.bold())
                    .foregroundStyle(Color(red: 1.0, green: 0.58, blue: 0.0))
                    .opacity(arrowDrawn)
            }
            .galaxyCard()
            .padding(.horizontal, 20)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer().frame(height: 32)

            HStack(spacing: 12) {
                yesNoButton("No", selected: viewModel.wantsRolloverCalories == false) {
                    viewModel.wantsRolloverCalories = false
                }
                yesNoButton("Yes", selected: viewModel.wantsRolloverCalories == true) {
                    viewModel.wantsRolloverCalories = true
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: viewModel.wantsRolloverCalories != nil) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.8)) {
                arrowDrawn = 1.0
            }
        }
    }

    private func yesNoButton(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            HapticManager.selection()
            action()
        } label: {
            Text(title)
                .font(.headline)
                .foregroundStyle(selected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(selected ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.94, green: 0.94, blue: 0.95))
                )
        }
    }
}

struct AllDoneStepView: View {
    let viewModel: OnboardingViewModel
    @State private var checkScale: CGFloat = 0
    @State private var cardAppeared: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.91, green: 0.97, blue: 0.91))
                        .frame(width: 100, height: 100)
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.green)
                        .scaleEffect(checkScale)
                }

                Text("All done!")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)

                Text("Time to generate your\ncustom plan!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
            .galaxyCard()
            .padding(.horizontal, 32)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer().frame(height: 32)

            VStack(alignment: .leading, spacing: 12) {
                Text("Daily recommendation for:")
                    .font(.subheadline.bold())

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(["Calories", "Carbs", "Protein", "Fats", "Body Score", "Workout Program"], id: \.self) { item in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark")
                                .font(.caption.bold())
                                .foregroundStyle(.green)
                            Text(item)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
            )
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2)) {
                checkScale = 1.0
            }
        }
    }
}

struct CongratulationsStepView: View {
    let viewModel: OnboardingViewModel
    @State private var ringsAnimated: Bool = false
    @State private var cardAppeared: Bool = false
    @State private var completionProgress: CGFloat = 0
    @State private var checkmarkScale: CGFloat = 0

    private var formattedCalories: String {
        let num = viewModel.calculatedDailyCalories
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.primary)
                    .scaleEffect(checkmarkScale)
                    .padding(.top, 24)

                Text("Congratulations\nyour custom plan is ready!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)

                Text("You can edit this anytime")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }

            Spacer().frame(height: 24)

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: completionProgress)
                        .stroke(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.58, blue: 0.0), Color.black],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.primary)
                }
                .frame(width: 80, height: 80)

                Text("Your plan is ready")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    macroTile(icon: "flame.fill", color: Color.black, label: "Calories", value: formattedCalories)
                    macroTile(icon: "p.circle.fill", color: Color(red: 1.0, green: 0.23, blue: 0.19), label: "Protein", value: "\(viewModel.calculatedProtein)g")
                    macroTile(icon: "c.circle.fill", color: Color(red: 1.0, green: 0.58, blue: 0.0), label: "Carbs", value: "\(viewModel.calculatedCarbs)g")
                    macroTile(icon: "f.circle.fill", color: Color(red: 0.0, green: 0.48, blue: 1.0), label: "Fats", value: "\(viewModel.calculatedFat)g")
                }

                Text("Complete your first body scan to get your physique score")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)

                Text("Weekly scan day: Sunday")
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
            }
            .galaxyCard()
            .padding(.horizontal, 20)
            .blur(radius: cardAppeared ? 0 : 8)
            .scaleEffect(cardAppeared ? 1 : 0.97)
            .opacity(cardAppeared ? 1 : 0)

            Spacer()

            OnboardingCTAButton(title: "Let's get started!", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.85).delay(0.3)) {
                cardAppeared = true
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2)) {
                checkmarkScale = 1.0
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
                completionProgress = 1.0
            }
            ringsAnimated = true
        }
    }

    private func macroTile(icon: String, color: Color, label: String, value: String) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle().stroke(Color(.systemGray5), lineWidth: 4)
                Circle()
                    .trim(from: 0, to: ringsAnimated ? 0.75 : 0)
                    .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.8), value: ringsAnimated)
                Image(systemName: icon).font(.caption).foregroundStyle(color)
            }
            .frame(width: 36, height: 36)

            Text(value).font(.title3.bold())
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }
}
