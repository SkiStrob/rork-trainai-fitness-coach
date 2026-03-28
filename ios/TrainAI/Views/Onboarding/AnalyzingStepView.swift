import SwiftUI

struct AnalyzingStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var statusIndex: Int = 0
    @State private var appeared: Bool = false

    private let statusMessages = [
        "Measuring shoulder-to-waist ratio...",
        "Analyzing muscle symmetry...",
        "Evaluating body composition...",
        "Scoring proportions...",
        "Calculating V-taper angle...",
        "Generating your results..."
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                Text("Analyzing Your Photos")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))

                Text(statusMessages[statusIndex])
                    .font(.system(size: 15))
                    .foregroundStyle(Color(.secondaryLabel))
                    .contentTransition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: statusIndex)
                    .id(statusIndex)

                ZStack {
                    Circle()
                        .stroke(Color(red: 0.9, green: 0.9, blue: 0.91), lineWidth: 8)
                        .frame(width: 160, height: 160)

                    Circle()
                        .trim(from: 0, to: viewModel.analysisProgress)
                        .stroke(
                            Color(red: 0.1, green: 0.1, blue: 0.1),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 160, height: 160)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.1), value: viewModel.analysisProgress)

                    Text("\(Int(viewModel.analysisProgress * 100))%")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                        .contentTransition(.numericText())
                }

                HStack(spacing: -8) {
                    ForEach(0..<3, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.93, green: 0.93, blue: 0.94))
                            .frame(width: 40, height: 50)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.caption)
                                    .foregroundStyle(Color(.tertiaryLabel))
                            )
                            .rotationEffect(.degrees(Double(i - 1) * 5))
                    }
                }
            }
            .opacity(appeared ? 1 : 0)

            Spacer()

            Text("This may take 1-2 minutes")
                .font(.caption)
                .foregroundStyle(Color(.tertiaryLabel))
                .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                appeared = true
            }
            startStatusCycle()
        }
    }

    private func startStatusCycle() {
        Task {
            while !Task.isCancelled && !viewModel.analysisComplete {
                try? await Task.sleep(for: .seconds(2.5))
                withAnimation {
                    statusIndex = (statusIndex + 1) % statusMessages.count
                }
            }
        }
    }
}
