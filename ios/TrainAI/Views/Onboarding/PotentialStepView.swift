import SwiftUI

struct PotentialStepView: View {
    let viewModel: OnboardingViewModel
    @State private var appeared: Bool = false
    @State private var displayedScore: Double = 5.7
    @State private var selectedTab: Int = 0
    @State private var showAttributes: Bool = false

    private var currentScore: Double {
        viewModel.scanResult?.overallScore ?? 5.7
    }

    private let timelineTabs = ["Today", "Next Week", "Next Month", "Next Year"]
    private let scoreDeltas: [Double] = [0, 0.3, 1.2, 2.5]

    private var projectedScore: Double {
        min(10.0, currentScore + scoreDeltas[selectedTab])
    }

    private var projectedTier: TierInfo {
        TierInfo.tier(for: projectedScore, gender: viewModel.selectedGender)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Text("Your Potential")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.top, 32)

                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 80, weight: .regular))
                        .foregroundStyle(.white.opacity(0.2))
                        .frame(height: 120)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(String(format: "%.1f", displayedScore))
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                        Text("/10")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.gray)
                    }

                    TierBadgeView(tierInfo: projectedTier, large: true)

                    if selectedTab > 0 {
                        Text("+\(String(format: "%.1f", scoreDeltas[selectedTab]))")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(red: 0.0, green: 0.75, blue: 0.72))
                    }

                    timelineSelector

                    if showAttributes {
                        improvementGrid
                            .transition(.opacity)
                    }

                    (Text("\(viewModel.userName.isEmpty ? "Based on your profile" : viewModel.userName + ", based on your profile"), users similar to you improved by ") + Text("187%").foregroundStyle(Color(red: 0.0, green: 0.75, blue: 0.72)).fontWeight(.bold) + Text(" within 3 months of using Trainity"))
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 20)
            }

            VStack {
                Spacer()
                OnboardingCTAButton(title: "Continue", enabled: true) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                        viewModel.nextStep()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                appeared = true
            }
            animateToScore(projectedScore)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    showAttributes = true
                }
            }
        }
    }

    private var timelineSelector: some View {
        HStack(spacing: 4) {
            ForEach(0..<timelineTabs.count, id: \.self) { index in
                Button {
                    HapticManager.selection()
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                        selectedTab = index
                    }
                    animateToScore(min(10.0, currentScore + scoreDeltas[index]))
                } label: {
                    Text(timelineTabs[index])
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(selectedTab == index ? .black : .gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedTab == index ? Color.white : Color.white.opacity(0.08))
                        .clipShape(Capsule())
                }
            }
        }
    }

    private var improvementGrid: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                improvementCell("Body Fat", value: selectedTab > 0 ? "11%" : "~15%", delta: selectedTab > 0 ? "↓" : nil)
                improvementCell("Muscle Mass", value: selectedTab > 1 ? "High" : "Med", delta: selectedTab > 1 ? "↑" : nil)
                improvementCell("Symmetry", value: selectedTab > 0 ? "V. High" : "High", delta: selectedTab > 0 ? "↑" : nil)
            }
            HStack(spacing: 2) {
                improvementCell("Definition", value: selectedTab > 1 ? "High" : "Med", delta: selectedTab > 1 ? "↑" : nil)
                improvementCell("Posture", value: "Good", delta: nil)
                improvementCell("Core", value: selectedTab > 0 ? "6.0" : "5.2", delta: selectedTab > 0 ? "↑" : nil)
            }
        }
        .clipShape(.rect(cornerRadius: 16))
    }

    private func improvementCell(_ title: String, value: String, delta: String?) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.gray)
            HStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                if let delta {
                    Text(delta)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color(red: 0.0, green: 0.75, blue: 0.72))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.06))
    }

    private func animateToScore(_ target: Double) {
        Task {
            let start = displayedScore
            let steps = 15
            for i in 1...steps {
                try? await Task.sleep(for: .milliseconds(30))
                let progress = Double(i) / Double(steps)
                let eased = 1 - pow(1 - progress, 3)
                displayedScore = (((target - start) * eased + start) * 10).rounded() / 10
            }
            displayedScore = target
        }
    }
}
