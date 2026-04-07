import SwiftUI

struct ScanStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var frontCheckScale: Double = 0
    @State private var sideCheckScale: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Let's see where you stand")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.primary)
                            .padding(.top, 24)

                        Text("Take two photos so our AI can analyze your physique.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if viewModel.isScanning {
                        VStack(spacing: 24) {
                            ZStack {
                                Circle()
                                    .stroke(Color(.systemGray5), lineWidth: 6)
                                    .frame(width: 100, height: 100)

                                Circle()
                                    .trim(from: 0, to: viewModel.scanProgress)
                                    .stroke(Color.primary, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                    .frame(width: 100, height: 100)
                                    .rotationEffect(.degrees(-90))
                                    .animation(.linear(duration: 0.15), value: viewModel.scanProgress)

                                Text("\(Int(viewModel.scanProgress * 100))%")
                                    .font(.title3.bold())
                                    .foregroundStyle(.primary)
                                    .contentTransition(.numericText())
                            }

                            Text("Analyzing your physique...")
                                .font(.headline)
                                .foregroundStyle(.secondary)

                            VStack(alignment: .leading, spacing: 8) {
                                SetupLineItem(text: "Measuring proportions", done: viewModel.scanProgress > 0.3)
                                SetupLineItem(text: "Calculating ratios", done: viewModel.scanProgress > 0.6)
                                SetupLineItem(text: "Generating score", done: viewModel.scanProgress > 0.9)
                            }
                            .padding(.horizontal, 32)
                        }
                        .padding(.top, 40)
                    } else if !viewModel.scanComplete {
                        // Daily tracking tip - moved ABOVE the photo boxes
                        HStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.title3)
                                .foregroundStyle(.primary)
                                .frame(width: 36, height: 36)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Take photos daily for best tracking")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.primary)
                                Text("Consistent photos help our AI track your progress")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(14)
                        .background(Color(.systemGray6))
                        .clipShape(.rect(cornerRadius: 16))

                        // Photo capture boxes
                        HStack(spacing: 16) {
                            ScanPhotoCaptureBox(
                                label: "Front",
                                hasPhoto: viewModel.frontPhotoData != nil,
                                checkScale: frontCheckScale,
                                isFront: true
                            ) {
                                viewModel.frontPhotoData = Data()
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    frontCheckScale = 1.0
                                }
                            }

                            ScanPhotoCaptureBox(
                                label: "Side",
                                hasPhoto: viewModel.sidePhotoData != nil,
                                checkScale: sideCheckScale,
                                isFront: false
                            ) {
                                viewModel.sidePhotoData = Data()
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    sideCheckScale = 1.0
                                }
                            }
                        }

                        // Tips section - more compact
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tips for best results")
                                .font(.subheadline.bold())
                                .foregroundStyle(.primary)

                            HStack(spacing: 10) {
                                Image(systemName: "light.max")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 20)
                                Text("Good lighting, plain background")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            HStack(spacing: 10) {
                                Image(systemName: "tshirt.fill")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 20)
                                Text("Wear fitted clothes or activewear")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            HStack(spacing: 10) {
                                Image(systemName: "figure.stand")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 20)
                                Text("Stand upright, arms slightly away")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            HStack(spacing: 10) {
                                Image(systemName: "iphone.gen3")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 20)
                                Text("Place phone at waist height, 6ft away")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(16)
                        .background(Color(.systemGray6))
                        .clipShape(.rect(cornerRadius: 16))
                    }
                }
                .padding(.horizontal, 16)
            }

            if !viewModel.isScanning && !viewModel.scanComplete {
                VStack(spacing: 8) {
                    OnboardingCTAButton(title: "Scan My Physique", enabled: true) {
                        viewModel.performScan()
                    }

                    Button {
                        HapticManager.light()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            viewModel.scanComplete = true
                            viewModel.scanResult = BodyScan(
                                date: Date(),
                                overallScore: 5.7,
                                symmetry: 6.5, definition: 5.3, mass: 5.9,
                                proportions: 5.5, vtaper: 5.7, core: 5.2,
                                chestScore: 6.0, backScore: 5.5, shoulderScore: 6.4,
                                armScore: 5.7, coreScore: 5.2, legScore: 5.3,
                                tierName: "High-Tier Chadlite"
                            )
                            viewModel.nextStep()
                        }
                    } label: {
                        Text("Skip for now")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 8)
                }
            }

            if viewModel.scanComplete {
                OnboardingCTAButton(title: "See My Score", enabled: true) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        viewModel.nextStep()
                    }
                }
            }
        }
    }
}

struct SetupLineItem: View {
    let text: String
    let done: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .font(.body)
                .foregroundStyle(done ? .green : .secondary)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(done ? .primary : .secondary)
            Spacer()
        }
    }
}

struct ScanPhotoCaptureBox: View {
    let label: String
    let hasPhoto: Bool
    let checkScale: Double
    let isFront: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if hasPhoto {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.green)
                        .scaleEffect(checkScale)
                } else {
                    VStack(spacing: 8) {
                        ZStack {
                            if isFront {
                                FrontSilhouetteGuide()
                                    .stroke(Color.primary.opacity(0.12), lineWidth: 1.5)
                                    .frame(width: 65, height: 105)
                            } else {
                                SideSilhouetteGuide()
                                    .stroke(Color.primary.opacity(0.12), lineWidth: 1.5)
                                    .frame(width: 45, height: 105)
                            }
                        }

                        Image(systemName: "camera")
                            .font(.system(size: 22))
                            .foregroundStyle(.secondary)
                    }
                }

                VStack {
                    Spacer()
                    Text(label)
                        .font(.caption.bold())
                        .foregroundStyle(.primary)
                        .padding(.bottom, 12)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        hasPhoto ? Color.green.opacity(0.5) : Color(.systemGray4),
                        style: StrokeStyle(lineWidth: 2, dash: hasPhoto ? [] : [8])
                    )
            )
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(hasPhoto ? Color.green.opacity(0.05) : Color(.systemGray6))
            )
        }
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