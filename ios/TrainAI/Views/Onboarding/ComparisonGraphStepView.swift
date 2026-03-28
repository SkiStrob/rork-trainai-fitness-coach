import SwiftUI

struct ComparisonGraphStepView: View {
    let viewModel: OnboardingViewModel
    @State private var appeared: Bool = false
    @State private var barHeights: [CGFloat] = Array(repeating: 0, count: 10)

    private let tealColor = Color(red: 0.0, green: 0.75, blue: 0.72)

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("Trainity is the most effective way to transform your physique")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                laurelBadge

                barChart
                    .padding(.horizontal, 20)

                legend

                (Text("The average Trainity user improved ") + Text("3.2x").foregroundStyle(tealColor).fontWeight(.bold) + Text(" faster than training alone"))
                    .font(.system(size: 14))
                    .foregroundStyle(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .opacity(appeared ? 1 : 0)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                appeared = true
            }
            animateBars()
        }
    }

    private var laurelBadge: some View {
        HStack(spacing: 2) {
            Image(systemName: "laurel.leading")
                .font(.system(size: 20))
                .foregroundStyle(Color(red: 0.78, green: 0.66, blue: 0.32))
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(Color(red: 0.78, green: 0.66, blue: 0.32))
                }
            }
            Image(systemName: "laurel.trailing")
                .font(.system(size: 20))
                .foregroundStyle(Color(red: 0.78, green: 0.66, blue: 0.32))
        }
    }

    private var barChart: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(0..<5, id: \.self) { week in
                HStack(alignment: .bottom, spacing: 3) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(tealColor)
                        .frame(width: 20, height: barHeights[week * 2])

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.88, green: 0.88, blue: 0.9))
                        .frame(width: 20, height: barHeights[week * 2 + 1])
                }
            }
        }
        .frame(height: 160)
    }

    private var legend: some View {
        HStack(spacing: 24) {
            HStack(spacing: 6) {
                Circle().fill(tealColor).frame(width: 8, height: 8)
                Text("Trainity").font(.caption).foregroundStyle(.secondary)
            }
            HStack(spacing: 6) {
                Circle().fill(Color(red: 0.88, green: 0.88, blue: 0.9)).frame(width: 8, height: 8)
                Text("Conventional Methods").font(.caption).foregroundStyle(.secondary)
            }
        }
    }

    private func animateBars() {
        let trainityTargets: [CGFloat] = [40, 65, 90, 120, 150]
        let conventionalTargets: [CGFloat] = [25, 35, 40, 42, 38]

        for i in 0..<5 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.3 + Double(i) * 0.12)) {
                barHeights[i * 2] = trainityTargets[i]
                barHeights[i * 2 + 1] = conventionalTargets[i]
            }
        }
    }
}
