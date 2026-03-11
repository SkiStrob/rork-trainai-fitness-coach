import SwiftUI

struct PaywallView: View {
    let onComplete: () -> Void
    @State private var showSubscriptionOptions: Bool = false
    @State private var contentVisible: Bool = false
    @State private var currentTestimonialPage: Int = 0

    private let testimonials: [(String, String)] = [
        ("I lost 12 lbs in 2 months thanks to TrainAI. The body scan keeps me motivated every week.", "Mike R."),
        ("The food scanner is insanely accurate. I just point my camera and it gets everything.", "Sarah K."),
        ("Finally an app that combines physique tracking with actual workout programs. Game changer.", "James T."),
        ("I couldn't believe how accurate the body analysis was. It picked up on my weak points immediately.", "Ana M."),
        ("Best fitness app I've ever used. The progressive overload tracking alone is worth it.", "Chris D.")
    ]

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
                        Text("We want you to try\nTrainAI for free.")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .blurFadeIn(visible: contentVisible, delay: 0)

                        appPreviewCard
                            .blurFadeIn(visible: contentVisible, delay: 0.05)

                        testimonialSection
                            .blurFadeIn(visible: contentVisible, delay: 0.1)

                        featuresList
                            .blurFadeIn(visible: contentVisible, delay: 0.15)

                        socialProof
                            .blurFadeIn(visible: contentVisible, delay: 0.2)
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
            startTestimonialRotation()
        }
        .sheet(isPresented: $showSubscriptionOptions) {
            SubscriptionOptionsSheet {
                showSubscriptionOptions = false
                onComplete()
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    private var appPreviewCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemGray6))
                .frame(height: 220)

            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray5))
                        .frame(width: 180, height: 140)

                    VStack(spacing: 6) {
                        ZStack {
                            ScanBrackets()
                                .stroke(Color.primary.opacity(0.4), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                                .frame(width: 40, height: 40)

                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 18))
                                .foregroundStyle(.primary)
                        }

                        Text("TrainAI")
                            .font(.headline.bold())
                            .foregroundStyle(.primary)

                        HStack(spacing: 4) {
                            Text("5.7")
                                .font(.title2.bold())
                                .foregroundStyle(.primary)
                            Text("/10")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    private var testimonialSection: some View {
        VStack(spacing: 12) {
            TabView(selection: $currentTestimonialPage) {
                ForEach(0..<testimonials.count, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\"\(testimonials[i].0)\"")
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("- \(testimonials[i].1)")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 16))
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 130)

            HStack(spacing: 6) {
                ForEach(0..<testimonials.count, id: \.self) { i in
                    Circle()
                        .fill(i == currentTestimonialPage ? Color.primary : Color(.systemGray4))
                        .frame(width: 6, height: 6)
                }
            }
        }
    }

    private var featuresList: some View {
        VStack(alignment: .leading, spacing: 14) {
            FeatureCheckRow(text: "AI-personalized workout programs")
            FeatureCheckRow(text: "Smart food scanning with instant macros")
            FeatureCheckRow(text: "Weekly body scans with score tracking")
            FeatureCheckRow(text: "Progressive overload suggestions")
            FeatureCheckRow(text: "Realistic timeline to your goal")
        }
    }

    private var socialProof: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
                Text("4.8")
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)
                Text("App Store")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Text("50K+ users")
                .font(.subheadline)
                .foregroundStyle(.secondary)
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
                showSubscriptionOptions = true
            } label: {
                Text("Try for $0.00")
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

    private func startTestimonialRotation() {
        Task {
            while true {
                try? await Task.sleep(for: .seconds(4))
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    currentTestimonialPage = (currentTestimonialPage + 1) % testimonials.count
                }
            }
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
                        .fill(Color(.systemGray4))
                        .frame(width: 2, height: 40)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
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
                .foregroundStyle(.primary)
        }
    }
}

struct SubscriptionOptionsSheet: View {
    let onSubscribe: () -> Void
    @State private var selectedPlan: String = "annual"

    var body: some View {
        VStack(spacing: 20) {
            Text("Unlimited access to")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 8)

            HStack(spacing: 8) {
                ZStack {
                    ScanBrackets()
                        .stroke(Color.primary.opacity(0.5), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: 28, height: 28)
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 13))
                        .foregroundStyle(.primary)
                }
                Text("TrainAI")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
            }

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
                        price: "$4.16",
                        subtitle: "/mo",
                        badge: "Save 60%",
                        isSelected: selectedPlan == "annual"
                    )
                }
            }
            .padding(.horizontal, 16)

            Button {
                HapticManager.light()
                onSubscribe()
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

            HStack(spacing: 16) {
                Button("Restore Purchases") {}
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("·").foregroundStyle(.secondary.opacity(0.5))
                Button("Terms") {}
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("·").foregroundStyle(.secondary.opacity(0.5))
                Button("Privacy") {}
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 8)
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
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(.systemGray5))
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
