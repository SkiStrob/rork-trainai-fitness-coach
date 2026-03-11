import SwiftUI

struct TrustStepView: View {
    let viewModel: OnboardingViewModel
    @State private var currentTestimonial: Int = 0

    private let testimonials: [(String, String, String)] = [
        ("Jake Sullivan", "I lost 15 lbs in 2 months! I was about to go on Ozempic but decided to give this app a shot and it worked.", "star.fill"),
        ("Maria Chen", "The body scan feature is incredible. Seeing my ratios improve week over week keeps me so motivated.", "star.fill"),
        ("David Park", "Best fitness app I've ever used. The AI programs are perfectly tailored to my goals.", "star.fill"),
        ("Sarah Kim", "Finally an app that tracks both physique AND strength. The progress photos are a game changer.", "star.fill"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 28) {
                    VStack(spacing: 16) {
                        Text("Give us a rating")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.primary)
                            .padding(.top, 24)

                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray6))
                                    .frame(width: 48, height: 48)
                                Image(systemName: "star.fill")
                                    .font(.title3)
                                    .foregroundStyle(.yellow)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 2) {
                                    Text("4.8")
                                        .font(.headline.bold())
                                        .foregroundStyle(.primary)
                                    ForEach(0..<5, id: \.self) { _ in
                                        Image(systemName: "star.fill")
                                            .font(.caption2)
                                            .foregroundStyle(.yellow)
                                    }
                                }
                                Text("100K+ App Ratings")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(.rect(cornerRadius: 16))
                        .padding(.horizontal, 16)
                    }

                    VStack(spacing: 12) {
                        Text("TrainAI was made for\npeople like you")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)

                        HStack(spacing: -12) {
                            ForEach(0..<3, id: \.self) { i in
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 44, height: 44)
                                    .overlay {
                                        Image(systemName: ["person.fill", "figure.run", "figure.strengthtraining.traditional"][i])
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                    }
                                    .overlay(
                                        Circle()
                                            .stroke(Color(.systemBackground), lineWidth: 2)
                                    )
                            }
                        }
                    }

                    TabView(selection: $currentTestimonial) {
                        ForEach(0..<testimonials.count, id: \.self) { i in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 10) {
                                    Circle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 40, height: 40)
                                        .overlay {
                                            Text(String(testimonials[i].0.prefix(1)))
                                                .font(.headline)
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
                                                    .foregroundStyle(.yellow)
                                            }
                                        }
                                    }
                                }

                                Text(testimonials[i].1)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(16)
                            .background(Color(.systemGray6))
                            .clipShape(.rect(cornerRadius: 16))
                            .padding(.horizontal, 16)
                            .tag(i)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                    .frame(height: 180)
                }
            }

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
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
