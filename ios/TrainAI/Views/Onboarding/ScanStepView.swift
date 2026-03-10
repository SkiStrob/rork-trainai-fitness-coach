import SwiftUI

struct ScanStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Let's see where you stand")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.primary)
                            .padding(.top, 24)

                        Text("Take two photos so our AI can analyze your physique.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if viewModel.isScanning {
                        VStack(spacing: 20) {
                            ProgressView(value: viewModel.scanProgress)
                                .tint(.primary)
                                .scaleEffect(y: 2)
                                .padding(.horizontal, 40)

                            Text("Analyzing your physique...")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 60)
                    } else if !viewModel.scanComplete {
                        VStack(spacing: 20) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)

                            Text("Front photo + side photo")
                                .font(.headline)
                                .foregroundStyle(.primary)
                        }
                        .padding(.top, 12)

                        HStack(spacing: 16) {
                            PhotoCaptureBox(
                                label: "Front",
                                hasPhoto: viewModel.frontPhotoData != nil
                            ) {
                                viewModel.frontPhotoData = Data()
                            }

                            PhotoCaptureBox(
                                label: "Side",
                                hasPhoto: viewModel.sidePhotoData != nil
                            ) {
                                viewModel.sidePhotoData = Data()
                            }
                        }
                        .padding(.horizontal, 16)
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

struct PhotoCaptureBox: View {
    let label: String
    let hasPhoto: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                if hasPhoto {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.green)
                } else {
                    Image(systemName: "camera")
                        .font(.system(size: 28))
                        .foregroundStyle(.secondary)
                }
                Text(label)
                    .font(.caption.bold())
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
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
