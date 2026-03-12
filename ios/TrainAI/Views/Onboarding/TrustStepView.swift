import SwiftUI

struct TrustStepView: View {
    let viewModel: OnboardingViewModel
    @State private var currentTestimonial: Int = 0
    @State private var contentVisible: Bool = false

    private let testimonials: [(String, String, String)] = [
        ("Jake S.", "I was about to go on Ozempic but decided to give this app a shot. Down 15 lbs in 2 months and my body score went from 3.8 to 5.2.", "J"),
        ("Maria C.", "The body scan feature is incredible. Seeing my ratios improve week over week keeps me so motivated.", "M"),
        ("David P.", "Best fitness app I've ever used. The AI programs are perfectly tailored to my weak points.", "D"),
        ("Sarah K.", "Finally an app that tracks both physique AND strength. The progress photos are a game changer.", "S"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    // Header - social proof, NOT asking for a rating
                    VStack(spacing: 16) {
                        Text("Trusted by athletes\nworldwide")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 24)
                            .blur(radius: contentVisible ? 0 : 3)
                            .opacity(contentVisible ? 1 : 0)

                        // Rating badge
                        HStack(spacing: 10) {
                            VStack(spacing: 2) {
                                HStack(spacing: 4) {
                                    Text("4.8")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundStyle(.primary)
                                }
                                HStack(spacing: 2) {
                                    ForEach(0..<5, id: \.self) { _ in
                                        Image(systemName: "star.fill")
                                            .font(.caption)
                                            .foregroundStyle(.orange)
                                    }
                                }
                                Text("100K+ Ratings")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemGray6))
                        )
                        .padding(.horizontal, 16)
                        .blur(radius: contentVisible ? 0 : 3)
                        .opacity(contentVisible ? 1 : 0)
                    }

                    // User avatars + count
                    VStack(spacing: 12) {
                        Text("TrainAI was made for\npeople like you")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)

                        HStack(spacing: -12) {
                            ForEach(0..<3, id: \.self) { i in
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 48, height: 48)
                                    .overlay {
                                        Image(systemName: ["person.fill", "figure.run", "figure.strengthtraining.traditional"][i])
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                    }
                                    .overlay(
                                        Circle()
                                            .stroke(Color(.systemBackground), lineWidth: 3)
                                    )
                            }
                        }

                        Text("50K+ Users")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                    }
                    .blur(radius: contentVisible ? 0 : 3)
                    .opacity(contentVisible ? 1 : 0)

                    // Testimonials carousel
                    VStack(spacing: 12) {
                        TabView(selection: $currentTestimonial) {
                            ForEach(0..<testimonials.count, id: \.self) { i in
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(spacing: 10) {
                                        Circle()
                                            .fill(Color(.systemGray4))
                                            .frame(width: 44, height: 44)
                                            .overlay {
                                                Text(testimonials[i].2)
                                                    .font(.headline.bold())
                                                    .foregroundStyle(.primary)
                                            }

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(testimonials[i].0)
                                                .font(.subheadline.bold())
                                                .foregroundStyle(.primary)
                                            HStack(spacing: 2) {
                                                ForEach(0..<5, id: \.self) { _ in
                                                    Image(systemName: "star.fill")
                                                        .font(.system(size: 10))
                                                        .foregroundStyle(.orange)
                                                }
                                            }
                                        }
                                    }

                                    Text(testimonials[i].1)
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                        .lineSpacing(3)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemGray6))
                                )
                                .padding(.horizontal, 16)
                                .tag(i)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 180)

                        // Custom page indicator - darker dots, positioned below reviews
                        HStack(spacing: 8) {
                            ForEach(0..<testimonials.count, id: \.self) { i in
                                Circle()
                                    .fill(i == currentTestimonial ? Color.primary : Color(.systemGray3))
                                    .frame(width: 7, height: 7)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.85), value: currentTestimonial)
                            }
                        }
                        .padding(.top, 4)
                    }

                    Spacer().frame(height: 8)
                }
            }

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.1)) {
                contentVisible = true
            }
            startRotation()
        }
    }

    private func startRotation() {
        Task {
            while true {
                try? await Task.sleep(for: .seconds(4))
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    currentTestimonial = (currentTestimonial + 1) % testimonials.count
                }
            }
        }
    }
}