import SwiftUI

struct PaywallView: View {
    let onComplete: () -> Void
    @State private var currentPage: Int = 0
    @State private var contentVisible: Bool = false
    @State private var selectedPlan: String = "annual"
    @State private var phoneFloat: Bool = false
    @State private var calCountUp: Int = 0
    @State private var ringProgress: CGFloat = 0

    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97).ignoresSafeArea()

            if currentPage == 0 {
                trustPage
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                planPage
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                contentVisible = true
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                phoneFloat = true
            }
            animatePhone()
        }
    }

    private var trustPage: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button("Restore") {}
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            ScrollView {
                VStack(spacing: 20) {
                    Text("Unlock TrainAI to reach\nyour goals faster.")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)
                        .blurFadeIn(visible: contentVisible, delay: 0)

                    phonePreview
                        .blurFadeIn(visible: contentVisible, delay: 0.05)

                    VStack(alignment: .leading, spacing: 16) {
                        FeatureCheckRow(text: "AI Body Scanning & Scoring", subtitle: "Track your physique with just a photo")
                        FeatureCheckRow(text: "Personalized Workout Programs", subtitle: "AI-personalized programs make results easy")
                        FeatureCheckRow(text: "Smart Food Tracking with AI", subtitle: "Stay on track with smart insights")
                    }
                    .padding(.horizontal, 4)
                    .blurFadeIn(visible: contentVisible, delay: 0.1)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }

            paywallBottom {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    currentPage = 1
                }
            }
        }
    }

    private var phonePreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color(.systemGray3), lineWidth: 3)
                .frame(width: 240, height: 460)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
                )
                .shadow(color: .black.opacity(0.08), radius: 16, y: 8)

            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 80, height: 24)
                .offset(y: -218)

            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    ZStack {
                        ScanBrackets()
                            .stroke(Color.primary.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                            .frame(width: 14, height: 14)
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 6))
                            .foregroundStyle(.primary)
                    }
                    Text("TrainAI")
                        .font(.system(size: 9, weight: .bold))
                }

                Text("\(calCountUp)")
                    .font(.system(size: 26, weight: .bold))
                    .contentTransition(.numericText())

                Text("Calories left")
                    .font(.system(size: 8))
                    .foregroundStyle(.secondary)

                ZStack {
                    Circle().stroke(Color(.systemGray5), lineWidth: 4)
                    Circle()
                        .trim(from: 0, to: ringProgress)
                        .stroke(Color.black, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 40, height: 40)

                HStack(spacing: 6) {
                    MacroPreviewPill(value: "136g", color: Color(red: 1.0, green: 0.23, blue: 0.19))
                    MacroPreviewPill(value: "206g", color: Color(red: 1.0, green: 0.58, blue: 0.0))
                    MacroPreviewPill(value: "41g", color: Color(red: 0.0, green: 0.48, blue: 1.0))
                }

                HStack(spacing: 4) {
                    Text("5.7")
                        .font(.system(size: 14, weight: .bold))
                    Text("High-Tier Chadlite")
                        .font(.system(size: 7, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green)
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
            }
            .frame(width: 200, height: 380)
        }
        .galaxyCard()
        .offset(y: phoneFloat ? -2 : 2)
    }

    private var planPage: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        currentPage = 0
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                        .frame(width: 44, height: 44)
                }
                Spacer()
                Button("Restore") {}
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)

            ScrollView {
                VStack(spacing: 20) {
                    Text("Choose your plan")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 14) {
                        featureCheck("AI Body Scanning & Scoring")
                        featureCheck("Personalized Workout Programs")
                        featureCheck("Smart Food Tracking with AI")
                        featureCheck("Weekly Progress Reports")
                        featureCheck("Ratio & Proportion Analysis")
                        featureCheck("Progressive Overload Tracking")
                    }

                    VStack(spacing: 12) {
                        Button {
                            selectedPlan = "monthly"
                            HapticManager.selection()
                        } label: {
                            HStack {
                                Circle()
                                    .stroke(selectedPlan == "monthly" ? Color.primary : Color(.systemGray4), lineWidth: 2)
                                    .frame(width: 22, height: 22)
                                    .overlay {
                                        if selectedPlan == "monthly" {
                                            Circle().fill(Color.primary).frame(width: 12, height: 12)
                                        }
                                    }
                                Text("Monthly").font(.body.weight(.semibold))
                                Spacer()
                                Text("$14.99/mo").font(.body.weight(.semibold))
                            }
                            .foregroundStyle(.primary)
                            .padding(16)
                            .background(Color.white)
                            .clipShape(.rect(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedPlan == "monthly" ? Color.primary : Color(.systemGray4), lineWidth: selectedPlan == "monthly" ? 2 : 1)
                            )
                        }

                        Button {
                            selectedPlan = "annual"
                            HapticManager.selection()
                        } label: {
                            HStack {
                                Circle()
                                    .fill(selectedPlan == "annual" ? .white : .clear)
                                    .frame(width: 22, height: 22)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedPlan == "annual" ? .white : Color(.systemGray4), lineWidth: 2)
                                    )
                                    .overlay {
                                        if selectedPlan == "annual" {
                                            Circle().fill(Color(red: 0.11, green: 0.11, blue: 0.12)).frame(width: 10, height: 10)
                                        }
                                    }
                                Text("Yearly").font(.body.weight(.semibold))
                                Spacer()
                                Text("$4.17/mo").font(.body.weight(.semibold))
                            }
                            .foregroundStyle(selectedPlan == "annual" ? .white : .primary)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selectedPlan == "annual" ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color.white)
                            )
                            .overlay(alignment: .topTrailing) {
                                Text("SAVE 72%")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color(red: 1.0, green: 0.58, blue: 0.0))
                                    .clipShape(Capsule())
                                    .offset(x: -12, y: -8)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedPlan == "annual" ? Color.clear : Color(.systemGray4), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }

            paywallBottom {
                HapticManager.light()
                onComplete()
            }
        }
    }

    private func paywallBottom(action: @escaping () -> Void) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.green)
                Text("No Payment Due Now")
                    .font(.subheadline.weight(.medium))
            }

            Button(action: action) {
                Text("Continue")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .clipShape(.rect(cornerRadius: 14))
            }
            .padding(.horizontal, 20)

            Text(selectedPlan == "annual" ? "Just $49.99 per year ($4.17/mo)" : "$14.99 per month")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 12)
        }
    }

    private func featureCheck(_ text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark")
                .font(.subheadline.bold())
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
        }
    }

    private func animatePhone() {
        Task {
            let steps = 20
            for i in 1...steps {
                try? await Task.sleep(for: .milliseconds(80))
                withAnimation(.easeOut(duration: 0.05)) {
                    calCountUp = Int(Double(1739) * Double(i) / Double(steps))
                }
            }
            calCountUp = 1739
            withAnimation(.easeOut(duration: 0.8)) {
                ringProgress = 0.68
            }
        }
    }
}

struct MacroPreviewPill: View {
    let value: String
    let color: Color

    var body: some View {
        Text(value)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(color.opacity(0.1))
            .clipShape(.rect(cornerRadius: 4))
    }
}

struct FeatureCheckRow: View {
    var icon: String = "checkmark"
    let text: String
    var subtitle: String? = nil

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "checkmark")
                .font(.subheadline.bold())
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .font(.subheadline.bold())
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
