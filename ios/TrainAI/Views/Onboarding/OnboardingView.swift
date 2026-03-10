import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = OnboardingViewModel()
    let onComplete: (BodyScan?) -> Void

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                if viewModel.currentStep > 0 {
                    VStack(spacing: 12) {
                        HStack {
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    viewModel.previousStep()
                                }
                                HapticManager.light()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title3.bold())
                                    .foregroundStyle(.primary)
                                    .frame(width: 44, height: 44)
                            }

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color(.systemGray5))
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.primary)
                                        .frame(width: geo.size.width * viewModel.progress)
                                        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: viewModel.progress)
                                }
                            }
                            .frame(height: 3)

                            Spacer().frame(width: 44)
                        }
                    }
                    .padding(.horizontal, 16)
                }

                TabView(selection: $viewModel.currentStep) {
                    WelcomeStepView(viewModel: viewModel)
                        .tag(0)
                    AgeStepView(viewModel: viewModel)
                        .tag(1)
                    AttributionStepView(viewModel: viewModel)
                        .tag(2)
                    GoalStepView(viewModel: viewModel)
                        .tag(3)
                    ExperienceStepView(viewModel: viewModel)
                        .tag(4)
                    StatsStepView(viewModel: viewModel)
                        .tag(5)
                    NotificationStepView(viewModel: viewModel)
                        .tag(6)
                    ScanStepView(viewModel: viewModel)
                        .tag(7)
                    ScoreResultsStepView(viewModel: viewModel) {
                        viewModel.saveProfile(context: modelContext)
                        onComplete(viewModel.scanResult)
                    }
                        .tag(8)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.4, dampingFraction: 0.85), value: viewModel.currentStep)
            }
        }
    }
}

struct OnboardingOptionCard: View {
    let title: String
    let isSelected: Bool
    var emoji: String? = nil
    var subtitle: String? = nil
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 14) {
            if let icon {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .frame(width: 28)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isSelected ? .white : .primary)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(isSelected ? .white.opacity(0.7) : .secondary)
                }
            }

            Spacer()

            if let emoji {
                Text(emoji)
                    .font(.title3)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color.primary : Color(.systemGray6))
        )
        .scaleEffect(isSelected ? 1.01 : 1.0)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isSelected)
    }
}

struct OnboardingCTAButton: View {
    let title: String
    let enabled: Bool
    let action: () -> Void

    var body: some View {
        Button {
            HapticManager.light()
            action()
        } label: {
            Text(title)
                .font(.headline)
                .foregroundStyle(enabled ? Color(.systemBackground) : Color(.systemBackground).opacity(0.5))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(enabled ? Color.primary : Color.primary.opacity(0.3))
                .clipShape(.rect(cornerRadius: 14))
        }
        .disabled(!enabled)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}
