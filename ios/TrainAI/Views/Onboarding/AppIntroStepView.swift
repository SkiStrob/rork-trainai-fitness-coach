import SwiftUI
import Combine

struct AppIntroStepView: View {
    let viewModel: OnboardingViewModel
    @State private var currentDemo: Int = 0
    @State private var phoneAppeared: Bool = false
    @State private var scanLineY: CGFloat = 0
    @State private var showLabels: Bool = false
    @State private var ringProgress: CGFloat = 0
    @State private var chartDraw: CGFloat = 0

    private let timer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 36)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 220, height: 440)
                    .background(
                        RoundedRectangle(cornerRadius: 36)
                            .fill(currentDemo == 0 ? Color.black : Color.white)
                    )
                    .shadow(color: .black.opacity(0.12), radius: 24, y: 12)

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .frame(width: 70, height: 22)
                    .offset(y: -209)

                Group {
                    switch currentDemo {
                    case 0: bodyScanDemo
                    case 1: foodScanDemo
                    default: dashboardDemo
                    }
                }
                .frame(width: 200, height: 400)
                .clipShape(.rect(cornerRadius: 30))
                .transition(.opacity)
            }
            .offset(y: phoneAppeared ? 0 : 60)
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
                        .fill(i == currentDemo ? Color.black : Color(red: 0.8, green: 0.8, blue: 0.8))
                        .frame(width: 6, height: 6)
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
            startDemoAnimations()
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentDemo = (currentDemo + 1) % 3
            }
            startDemoAnimations()
        }
    }

    private var bodyScanDemo: some View {
        ZStack {
            Color.black

            BodySilhouetteShape()
                .stroke(Color.white.opacity(0.2), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .frame(width: 100, height: 220)

            Rectangle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 160, height: 2)
                .offset(y: scanLineY)
                .shadow(color: .white.opacity(0.3), radius: 4)

            if showLabels {
                VStack(spacing: 0) {
                    Text("5.7")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
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

    private var foodScanDemo: some View {
        ZStack {
            Color(red: 0.95, green: 0.95, blue: 0.95)

            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.85, green: 0.9, blue: 0.8))
                    .frame(height: 120)

                if showLabels {
                    HStack(spacing: 6) {
                        foodPill("Chicken 284")
                        foodPill("Rice 206")
                    }

                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .frame(height: 80)
                        .overlay {
                            VStack(spacing: 4) {
                                Text("524")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.black)
                                Text("calories")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                }

                Spacer()
            }
            .padding(12)
        }
    }

    private var dashboardDemo: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97)

            VStack(spacing: 8) {
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
                                }
                            }
                    }
                }
                .padding(.top, 16)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .frame(height: 70)

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("2583")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(.black)
                            Text("Calories left")
                                .font(.system(size: 8))
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        ZStack {
                            Circle()
                                .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 4)
                            Circle()
                                .trim(from: 0, to: ringProgress)
                                .stroke(Color.black, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                        }
                        .frame(width: 36, height: 36)
                    }
                    .padding(.horizontal, 12)
                }
                .padding(.horizontal, 10)

                HStack(spacing: 6) {
                    miniMacro("136g", Color.red.opacity(0.8))
                    miniMacro("206g", Color.orange)
                    miniMacro("41g", Color.blue)
                }
                .padding(.horizontal, 10)

                Path { path in
                    path.move(to: CGPoint(x: 20, y: 50))
                    path.addCurve(
                        to: CGPoint(x: 160, y: 15),
                        control1: CGPoint(x: 60, y: 40),
                        control2: CGPoint(x: 120, y: 20)
                    )
                }
                .trim(from: 0, to: chartDraw)
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

    private func startDemoAnimations() {
        scanLineY = -100
        showLabels = false
        ringProgress = 0
        chartDraw = 0

        switch currentDemo {
        case 0:
            withAnimation(.linear(duration: 1.5)) {
                scanLineY = 100
            }
            withAnimation(.easeOut(duration: 0.3).delay(1.8)) {
                showLabels = true
            }
        case 1:
            withAnimation(.easeOut(duration: 0.4).delay(0.5)) {
                showLabels = true
            }
        default:
            withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
                ringProgress = 0.72
            }
            withAnimation(.easeOut(duration: 1.2).delay(0.5)) {
                chartDraw = 1.0
            }
        }
    }
}
