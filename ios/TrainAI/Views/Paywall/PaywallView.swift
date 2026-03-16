import SwiftUI

struct PaywallView: View {
    let onComplete: () -> Void
    @State private var currentPage: Int = 0
    @State private var contentVisible: Bool = false
    @State private var selectedPlan: String = "annual"

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
                VStack(spacing: 24) {
                    Text("Unlock TrainAI to reach\nyour goals faster.")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)
                        .blurFadeIn(visible: contentVisible, delay: 0)

                    appPreviewCard
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
                                    .stroke(selectedPlan == "monthly" ? Color.primary : Color(red: 0.8, green: 0.8, blue: 0.8), lineWidth: 2)
                                    .frame(width: 22, height: 22)
                                    .overlay {
                                        if selectedPlan == "monthly" {
                                            Circle()
                                                .fill(Color.primary)
                                                .frame(width: 12, height: 12)
                                        }
                                    }

                                Text("Monthly")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(.primary)

                                Spacer()

                                Text("$14.99/mo")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(.primary)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedPlan == "monthly" ? Color.primary : Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: selectedPlan == "monthly" ? 2 : 1)
                            )
                        }

                        Button {
                            selectedPlan = "annual"
                            HapticManager.selection()
                        } label: {
                            HStack {
                                Circle()
                                    .fill(selectedPlan == "annual" ? Color.white : Color.clear)
                                    .frame(width: 22, height: 22)
                                    .overlay {
                                        Circle()
                                            .stroke(selectedPlan == "annual" ? Color.white : Color(red: 0.8, green: 0.8, blue: 0.8), lineWidth: 2)
                                            .frame(width: 22, height: 22)
                                        if selectedPlan == "annual" {
                                            Circle()
                                                .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                                                .frame(width: 10, height: 10)
                                        }
                                    }

                                Text("Yearly")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(selectedPlan == "annual" ? .white : .primary)

                                Spacer()

                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("$4.17/mo")
                                        .font(.body.weight(.semibold))
                                        .foregroundStyle(selectedPlan == "annual" ? .white : .primary)
                                }
                            }
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
                                    .background(Color.orange)
                                    .clipShape(Capsule())
                                    .offset(x: -12, y: -8)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedPlan == "annual" ? Color.clear : Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 1)
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

    private var appPreviewCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.94, green: 0.94, blue: 0.95))
                .frame(height: 260)

            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(width: 180, height: 160)
                        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)

                    VStack(spacing: 6) {
                        HStack(spacing: 4) {
                            ZStack {
                                ScanBrackets()
                                    .stroke(Color.primary.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                                    .frame(width: 16, height: 16)
                                Image(systemName: "figure.strengthtraining.traditional")
                                    .font(.system(size: 7))
                                    .foregroundStyle(.primary)
                            }
                            Text("TrainAI")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.primary)
                        }

                        Text("1739")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.primary)

                        Text("Calories left")
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)

                        HStack(spacing: 6) {
                            MacroPreviewPill(value: "136g", color: Color(red: 0.9, green: 0.3, blue: 0.3))
                            MacroPreviewPill(value: "206g", color: .orange)
                            MacroPreviewPill(value: "41g", color: Color(red: 0.3, green: 0.5, blue: 0.9))
                        }
                    }
                }

                HStack(spacing: 4) {
                    Circle().fill(Color.primary).frame(width: 6, height: 6)
                    Circle().fill(Color(red: 0.8, green: 0.8, blue: 0.8)).frame(width: 6, height: 6)
                }
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
                    .foregroundStyle(.primary)
            }

            Button {
                action()
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
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
                .foregroundStyle(.primary)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
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
                .foregroundStyle(.primary)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct PlanCard: View {
    let title: String
    let price: String
    let subtitle: String?
    let badge: String?
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            if let badge {
                Text(badge)
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.orange)
                    .clipShape(Capsule())
            }

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(price)
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.94, green: 0.94, blue: 0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.clear : Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 1)
        )
    }
}
