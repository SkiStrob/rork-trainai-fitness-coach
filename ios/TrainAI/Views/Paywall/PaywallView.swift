import SwiftUI

struct PaywallView: View {
    let onComplete: () -> Void
    @State private var showSubscriptionOptions: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 32) {
                        Spacer().frame(height: 20)

                        Text("How Your Free Trial Works")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)

                        VStack(alignment: .leading, spacing: 0) {
                            TimelineStep(icon: "checkmark.circle.fill", iconColor: .green, title: "Today", subtitle: "Full body analysis + personalized program", isLast: false)
                            TimelineStep(icon: "bell.fill", iconColor: .blue, title: "Day 5", subtitle: "We'll send you a reminder", isLast: false)
                            TimelineStep(icon: "lock.open.fill", iconColor: .white.opacity(0.6), title: "Day 7", subtitle: "Trial ends. Cancel anytime.", isLast: true)
                        }
                        .padding(.horizontal, 8)

                        VStack(alignment: .leading, spacing: 14) {
                            FeatureCheckRow(text: "AI-personalized workout programs")
                            FeatureCheckRow(text: "Smart food scanning with instant macros")
                            FeatureCheckRow(text: "Weekly body scans with score tracking")
                            FeatureCheckRow(text: "Progressive overload suggestions")
                            FeatureCheckRow(text: "Realistic timeline to your goal")
                        }

                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Text("⭐")
                                Text("4.8")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.white)
                                Text("· App Store")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.5))
                            }

                            Text("·")
                                .foregroundStyle(.white.opacity(0.3))

                            Text("50K+ users")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                    .padding(.horizontal, 16)
                }

                Button {
                    HapticManager.light()
                    showSubscriptionOptions = true
                } label: {
                    Text("Start Free Week")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 14))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showSubscriptionOptions) {
            SubscriptionOptionsSheet {
                showSubscriptionOptions = false
                onComplete()
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
}

struct TimelineStep: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(iconColor)
                    .frame(width: 32, height: 32)

                if !isLast {
                    Rectangle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 2, height: 40)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.bottom, isLast ? 0 : 16)

            Spacer()
        }
    }
}

struct FeatureCheckRow: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark")
                .font(.subheadline.bold())
                .foregroundStyle(.green)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white)
        }
    }
}

struct SubscriptionOptionsSheet: View {
    let onSubscribe: () -> Void
    @State private var selectedPlan: String = "annual"

    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Your Plan")
                .font(.title2.bold())
                .foregroundStyle(.white)
                .padding(.top, 8)

            VStack(spacing: 12) {
                Button {
                    selectedPlan = "annual"
                    HapticManager.selection()
                } label: {
                    PlanCard(
                        title: "Annual",
                        price: "$29.99/year",
                        subtitle: "$2.49/mo",
                        badge: "BEST VALUE",
                        isSelected: selectedPlan == "annual"
                    )
                }

                Button {
                    selectedPlan = "monthly"
                    HapticManager.selection()
                } label: {
                    PlanCard(
                        title: "Monthly",
                        price: "$9.99/month",
                        subtitle: nil,
                        badge: nil,
                        isSelected: selectedPlan == "monthly"
                    )
                }
            }
            .padding(.horizontal, 16)

            Button {
                HapticManager.light()
                onSubscribe()
            } label: {
                Text("Start Free Trial")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 14))
            }
            .padding(.horizontal, 16)

            HStack(spacing: 16) {
                Button("Restore Purchases") {}
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.4))
                Text("·").foregroundStyle(.white.opacity(0.3))
                Button("Terms") {}
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.4))
                Text("·").foregroundStyle(.white.opacity(0.3))
                Button("Privacy") {}
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(.bottom, 8)
        }
        .background(Color(white: 0.1))
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
                    .foregroundStyle(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }

            Text(title)
                .font(.headline)
                .foregroundStyle(.white)

            Text(price)
                .font(.title3.bold())
                .foregroundStyle(.white)

            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.white.opacity(0.4) : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
        )
    }
}