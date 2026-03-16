import SwiftUI

struct TrustStepView: View {
    let viewModel: OnboardingViewModel
    @State private var currentTestimonial: Int = 0
    @State private var cardAppeared: Bool = false
    @State private var starsAnimated: [Bool] = [false, false, false, false, false]
    @State private var avatarsVisible: [Bool] = [false, false, false]

    private let testimonials: [(String, String, String, Color)] = [
        ("Jake S.", "My body score went from 4.2 to 6.1 in 3 months. The ratio breakdown showed me exactly what to fix.", "J", Color(red: 0.3, green: 0.5, blue: 0.9)),
        ("Sarah M.", "The physique analysis is incredible. Finally understand my proportions.", "S", Color(red: 0.9, green: 0.3, blue: 0.5)),
        ("Chris R.", "Replaced my $200/month trainer. The AI programs are genuinely personalized.", "C", Color(red: 0.3, green: 0.7, blue: 0.4)),
        ("Mike T.", "The food scanner is insanely fast. Takes 3 seconds to log a meal. I actually stick with it now.", "M", Color(red: 0.9, green: 0.5, blue: 0.2)),
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Trusted by athletes\nworldwide")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)

                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Text("4.8")
                                .font(.system(size: 28, weight: .bold))

                            HStack(spacing: 2) {
                                ForEach(0..<5, id: \.self) { i in
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color(red: 1.0, green: 0.58, blue: 0.0))
                                        .scaleEffect(starsAnimated[i] ? 1.0 : 0)
                                }
                            }
                        }

                        Text("100K+ Ratings")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("Fisique was made for\nathletes like you")
                            .font(.system(size: 17, weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)

                        HStack(spacing: -12) {
                            ForEach(0..<3, id: \.self) { i in
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 44, height: 44)
                                    .overlay {
                                        Image(systemName: ["figure.strengthtraining.traditional", "figure.run", "figure.yoga"][i])
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                    }
                                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                    .offset(x: avatarsVisible[i] ? 0 : -20)
                                    .opacity(avatarsVisible[i] ? 1 : 0)
                            }
                        }

                        Text("50K+ Users")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                    }
                    .galaxyCard()
                    .padding(.horizontal, 20)
                    .blur(radius: cardAppeared ? 0 : 8)
                    .scaleEffect(cardAppeared ? 1 : 0.97)
                    .opacity(cardAppeared ? 1 : 0)

                    VStack(spacing: 12) {
                        TabView(selection: $currentTestimonial) {
                            ForEach(0..<testimonials.count, id: \.self) { i in
                                testimonialCard(i)
                                    .tag(i)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 170)

                        HStack(spacing: 8) {
                            ForEach(0..<testimonials.count, id: \.self) { i in
                                Circle()
                                    .fill(i == currentTestimonial ? Color.primary : Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .frame(width: 8, height: 8)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.85), value: currentTestimonial)
                            }
                        }
                    }
                }
            }

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                cardAppeared = true
            }
            for i in 0..<5 {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.3 + Double(i) * 0.1)) {
                    starsAnimated[i] = true
                }
            }
            for i in 0..<3 {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.8 + Double(i) * 0.15)) {
                    avatarsVisible[i] = true
                }
            }
            startRotation()
        }
    }

    private func testimonialCard(_ i: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Circle()
                    .fill(testimonials[i].3.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay {
                        Text(testimonials[i].2)
                            .font(.headline.bold())
                            .foregroundStyle(testimonials[i].3)
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text(testimonials[i].0)
                        .font(.subheadline.bold())
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(Color(red: 1.0, green: 0.58, blue: 0.0))
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
        .padding(.horizontal, 20)
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
