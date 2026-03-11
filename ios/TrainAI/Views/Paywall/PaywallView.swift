import SwiftUI

struct PaywallView: View {
    let onComplete: () -> Void
    @State private var showSubscriptionOptions: Bool = false
    @State private var contentVisible: Bool = false
    @State private var selectedPlan: String = "annual"

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Restore") {}
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                ScrollView {
                    VStack(spacing: 28) {
                        Text("Unlock TrainAI to reach\nyour goals faster.")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .blurFadeIn(visible: contentVisible, delay: 0)

                        appPreviewCard
                            .blurFadeIn(visible: contentVisible, delay: 0.05)

                        featuresList
                            .blurFadeIn(visible: contentVisible, delay: 0.1)

                        planSelector
                            .blurFadeIn(visible: contentVisible, delay: 0.15)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }

                paymentSection
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                contentVisible = true
            }
        }
    }

    private var appPreviewCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
                .frame(height: 280)

            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .frame(width: 200, height: 180)
                        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)

                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            ZStack {
                                ScanBrackets()
                                    .stroke(Color.primary.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                                    .frame(width: 20, height: 20)
                                Image(systemName: "figure.strengthtraining.traditional")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.primary)
                            }
                            Text("TrainAI")
                                .font(.caption.bold())
                                .foregroundStyle(.primary)
                        }

                        HStack(spacing: 2) {
                            Text("Today")
                                .font(.system(size: 9))
                                .foregroundStyle(.primary)
                            Text("Yesterday")
                                .font(.system(size: 9))
                                .foregroundStyle(.secondary)
                        }

                        Text("1739")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.primary)

                        HStack(spacing: 8) {
                            MacroPreviewPill(value: "136g", color: Color(red: 0.9, green: 0.3, blue: 0.3))
                            MacroPreviewPill(value: "206g", color: .orange)
                            MacroPreviewPill(value: "41g", color: Color(red: 0.3, green: 0.5, blue: 0.9))
                        }

                        Text("Recently eaten")
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                    }
                }

                HStack(spacing: 4) {
                    Circle().fill(Color.primary).frame(width: 6, height: 6)
                    Circle().fill(Color(.systemGray4)).frame(width: 6, height: 6)
                }
            }
        }
    }

    private var featuresList: some View {
        VStack(alignment: .leading, spacing: 16) {
            FeatureCheckRow(icon: "camera.viewfinder", text: "Easy body scanning", subtitle: "Track your physique with just a photo")
            FeatureCheckRow(icon: "figure.strengthtraining.traditional", text: "Get your dream body", subtitle: "AI-personalized programs make results easy")
            FeatureCheckRow(icon: "chart.line.uptrend.xyaxis", text: "Track your progress", subtitle: "Stay on track with smart insights")
        }
    }

    private var planSelector: some View {
        HStack(spacing: 12) {
            Button {
                selectedPlan = "monthly"
                HapticManager.selection()
            } label: {
                PlanCard(
                    title: "Monthly",
                    price: "$9.99",
                    subtitle: "/mo",
                    badge: nil,
                    isSelected: selectedPlan == "monthly"
                )
            }

            Button {
                selectedPlan = "annual"
                HapticManager.selection()
            } label: {
                PlanCard(
                    title: "Yearly",
                    price: "$2.49",
                    subtitle: "/mo",
                    badge: "SAVE 75%",
                    isSelected: selectedPlan == "annual"
                )
            }
        }
    }

    private var paymentSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "checkmark")
                    .font(.caption.bold())
                    .foregroundStyle(.primary)
                Text("No Payment Due Now")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
            }

            Button {
                HapticManager.light()
                onComplete()
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundStyle(Color(.systemBackground))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primary)
                    .clipShape(.rect(cornerRadius: 14))
            }
            .padding(.horizontal, 16)

            Text("Just $29.99 per year ($2.49/mo)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 12)
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
                    .foregroundStyle(Color(.systemBackground))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.primary)
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
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.primary : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
        )
        .overlay(alignment: .topTrailing) {
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .padding(8)
            }
        }
    }
}
