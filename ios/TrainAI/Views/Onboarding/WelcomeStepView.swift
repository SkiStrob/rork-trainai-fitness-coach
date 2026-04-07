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

struct WelcomeStepView: View {
    let viewModel: OnboardingViewModel
    @State private var phoneOpacity: Double = 0
    @State private var phoneOffset: CGFloat = -30
    @State private var textOpacity: Double = 0
    @State private var buttonOpacity: Double = 0
    @State private var currentScene: Int = 0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 40)

                phoneMockup
                    .opacity(phoneOpacity)
                    .offset(y: phoneOffset)

                Spacer()
                    .frame(height: 24)

                VStack(spacing: 4) {
                    Text("Your personal AI")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.black)
                    Text("training assistant")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.black)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(textOpacity)

                Spacer()

                bottomSection
                    .opacity(buttonOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                phoneOpacity = 1
                phoneOffset = 0
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                textOpacity = 1
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.3)) {
                buttonOpacity = 1
            }
            startSceneCycle()
        }
    }

    private func startSceneCycle() {
        Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(4))
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentScene = (currentScene + 1) % 3
                }
            }
        }
    }

    private var phoneMockup: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.black)
                .frame(width: 260, height: 500)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.black, lineWidth: 6)
                )
                .overlay(alignment: .top) {
                    RoundedRectangle(cornerRadius: 13)
                        .fill(.black)
                        .frame(width: 90, height: 26)
                        .offset(y: 11)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 34)
                        .fill(.black)
                        .padding(3)
                        .overlay {
                            phoneInnerContent
                                .padding(3)
                                .clipShape(RoundedRectangle(cornerRadius: 34))
                        }
                }
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
        }
    }

    private var phoneInnerContent: some View {
        ZStack {
            Color.black

            switch currentScene {
            case 0:
                BodyScanScene()
                    .transition(.opacity)
            case 1:
                FoodScanScene()
                    .transition(.opacity)
            case 2:
                WorkoutScene()
                    .transition(.opacity)
            default:
                BodyScanScene()
                    .transition(.opacity)
            }
        }
    }

    private var bottomSection: some View {
        VStack(spacing: 12) {
            Button {
                HapticManager.light()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            } label: {
                Text("Get Started")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .clipShape(.rect(cornerRadius: 16))
            }
            .padding(.horizontal, 20)

            Button {
                HapticManager.light()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            } label: {
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundStyle(Color(.secondaryLabel))
                    Text("Sign In")
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }
                .font(.subheadline)
            }
            .padding(.bottom, 16)
        }
    }
}

private struct BodyScanScene: View {
    @State private var scanLineY: CGFloat = 0
    @State private var showScore: Bool = false
    @State private var showBadge: Bool = false
    @State private var bracketOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.black

            ZStack {
                ScanBrackets(cornerSegmentLength: 0.22)
                    .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    .frame(width: 160, height: 220)
                    .opacity(bracketOpacity)

                Image(systemName: "figure.stand")
                    .font(.system(size: 90, weight: .thin))
                    .foregroundStyle(.white.opacity(0.3))

                RoundedRectangle(cornerRadius: 1)
                    .fill(.white.opacity(0.6))
                    .frame(width: 140, height: 1.5)
                    .shadow(color: .white.opacity(0.4), radius: 6)
                    .offset(y: -110 + scanLineY * 220)

                if showScore {
                    VStack(spacing: 6) {
                        Text("5.6")
                            .font(.system(size: 44, weight: .bold, design: .default))
                            .foregroundStyle(.white)
                            .shadow(color: .white.opacity(0.15), radius: 10)

                        if showBadge {
                            Text("Chadlite")
                                .font(.caption.bold())
                                .foregroundStyle(Color(red: 0.9, green: 0.8, blue: 0.3))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color(red: 0.9, green: 0.8, blue: 0.3).opacity(0.15))
                                )
                        }
                    }
                }
            }
        }
        .onAppear { startAnimations() }
    }

    private func startAnimations() {
        bracketOpacity = 0
        showScore = false
        showBadge = false
        scanLineY = 0

        withAnimation(.easeOut(duration: 0.4)) {
            bracketOpacity = 1
        }

        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            scanLineY = 1
        }

        withAnimation(.easeOut(duration: 0.4).delay(1.5)) {
            showScore = true
        }
        withAnimation(.easeOut(duration: 0.3).delay(2.0)) {
            showBadge = true
        }
    }
}

private struct FoodScanScene: View {
    @State private var showPill1: Bool = false
    @State private var showPill2: Bool = false
    @State private var showPill3: Bool = false
    @State private var showCalories: Bool = false
    @State private var bracketOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.black

            LinearGradient(
                colors: [
                    Color(red: 0.35, green: 0.25, blue: 0.15).opacity(0.5),
                    Color(red: 0.25, green: 0.35, blue: 0.15).opacity(0.4),
                    Color(red: 0.4, green: 0.3, blue: 0.15).opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 0) {
                ZStack {
                    ScanBrackets(cornerSegmentLength: 0.22)
                        .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                        .frame(width: 180, height: 180)
                        .opacity(bracketOpacity)

                    ZStack {
                        Circle()
                            .fill(Color(red: 0.85, green: 0.78, blue: 0.65).opacity(0.4))
                            .frame(width: 120, height: 120)

                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(red: 0.72, green: 0.55, blue: 0.35).opacity(0.5))
                            .frame(width: 55, height: 35)
                            .offset(x: -15, y: -5)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 0.92, green: 0.88, blue: 0.82).opacity(0.4))
                            .frame(width: 45, height: 28)
                            .offset(x: 20, y: 5)

                        Circle()
                            .fill(Color(red: 0.45, green: 0.65, blue: 0.25).opacity(0.5))
                            .frame(width: 22, height: 22)
                            .offset(x: 5, y: -30)
                    }

                    if showPill1 {
                        foodPill("Chicken  285")
                            .offset(x: -40, y: -65)
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                    }
                    if showPill2 {
                        foodPill("Rice  206")
                            .offset(x: 45, y: -25)
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                    }
                    if showPill3 {
                        foodPill("Broccoli  34")
                            .offset(x: -10, y: 65)
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                    }
                }
                .frame(height: 260)

                Spacer()

                if showCalories {
                    VStack(spacing: 4) {
                        Text("525 cal")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)

                        HStack(spacing: 16) {
                            macroLabel("P: 42g", color: Color(red: 1, green: 0.23, blue: 0.19))
                            macroLabel("C: 58g", color: Color(red: 1, green: 0.58, blue: 0))
                            macroLabel("F: 12g", color: Color(red: 0, green: 0.48, blue: 1))
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer()
                    .frame(height: 40)
            }
            .padding(.top, 50)
        }
        .onAppear { startAnimations() }
    }

    private func foodPill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.black)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(.white.opacity(0.9))
            )
    }

    private func macroLabel(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(color)
    }

    private func startAnimations() {
        showPill1 = false
        showPill2 = false
        showPill3 = false
        showCalories = false
        bracketOpacity = 0

        withAnimation(.easeOut(duration: 0.4)) {
            bracketOpacity = 1
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.6)) {
            showPill1 = true
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(1.0)) {
            showPill2 = true
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(1.4)) {
            showPill3 = true
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(2.0)) {
            showCalories = true
        }
    }
}

private struct WorkoutScene: View {
    @State private var showTitle: Bool = false
    @State private var showRows: [Bool] = [false, false, false]
    @State private var ringProgress: CGFloat = 0
    @State private var showWeek: Bool = false

    private let exercises: [(String, String)] = [
        ("Bench Press", "4 × 8-12"),
        ("Shoulder Press", "3 × 10-12"),
        ("Tricep Dips", "3 × 12-15")
    ]

    var body: some View {
        ZStack {
            Color.black

            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                    .frame(height: 60)

                if showTitle {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Push Day")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                        Text("Chest, Shoulders, Triceps")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal, 20)
                    .transition(.opacity)
                }

                Spacer()
                    .frame(height: 28)

                VStack(spacing: 0) {
                    ForEach(0..<exercises.count, id: \.self) { index in
                        if showRows[index] {
                            VStack(spacing: 0) {
                                HStack {
                                    Text(exercises[index].0)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text(exercises[index].1)
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                }
                                .padding(.vertical, 14)
                                .padding(.horizontal, 20)

                                if index < exercises.count - 1 {
                                    Rectangle()
                                        .fill(.white.opacity(0.08))
                                        .frame(height: 0.5)
                                        .padding(.horizontal, 20)
                                }
                            }
                            .transition(.opacity.combined(with: .move(edge: .leading)))
                        }
                    }
                }

                Spacer()

                HStack(alignment: .bottom) {
                    if showWeek {
                        Text("Week 3 of 12")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .stroke(.white.opacity(0.1), lineWidth: 4)
                            .frame(width: 40, height: 40)

                        Circle()
                            .trim(from: 0, to: ringProgress)
                            .stroke(Color(red: 0.2, green: 0.78, blue: 0.35), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .frame(width: 40, height: 40)
                            .rotationEffect(.degrees(-90))

                        Text("65%")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
                    .frame(height: 40)
            }
        }
        .onAppear { startAnimations() }
    }

    private func startAnimations() {
        showTitle = false
        showRows = [false, false, false]
        ringProgress = 0
        showWeek = false

        withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
            showTitle = true
        }
        for i in 0..<3 {
            withAnimation(.easeOut(duration: 0.35).delay(0.6 + Double(i) * 0.25)) {
                showRows[i] = true
            }
        }
        withAnimation(.easeOut(duration: 0.8).delay(1.5)) {
            ringProgress = 0.65
        }
        withAnimation(.easeOut(duration: 0.3).delay(1.8)) {
            showWeek = true
        }
    }
}
