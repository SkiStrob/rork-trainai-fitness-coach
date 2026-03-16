import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = OnboardingViewModel()
    let onComplete: (BodyScan?) -> Void

    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97).ignoresSafeArea()

            VStack(spacing: 0) {
                if viewModel.showProgressBar {
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
                                    RoundedRectangle(cornerRadius: 1.5)
                                        .fill(Color(red: 0.9, green: 0.9, blue: 0.91))
                                        .frame(height: 3)
                                    RoundedRectangle(cornerRadius: 1.5)
                                        .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                                        .frame(width: geo.size.width * viewModel.progress, height: 3)
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
                    WelcomeStepView(viewModel: viewModel).tag(0)
                    AppIntroStepView(viewModel: viewModel).tag(1)
                    GenderStepView(viewModel: viewModel).tag(2)
                    ExperienceStepView(viewModel: viewModel).tag(3)
                    AttributionStepView(viewModel: viewModel).tag(4)
                    OtherAppsStepView(viewModel: viewModel).tag(5)
                    ComparisonStepView(viewModel: viewModel).tag(6)
                    StatsStepView(viewModel: viewModel).tag(7)
                    AgeStepView(viewModel: viewModel).tag(8)
                    GoalStepView(viewModel: viewModel).tag(9)
                    TargetWeightStepView(viewModel: viewModel).tag(10)
                    RealisticTargetStepView(viewModel: viewModel).tag(11)
                    ProgressSpeedStepView(viewModel: viewModel).tag(12)
                    DarkComparisonStepView(viewModel: viewModel).tag(13)
                    BlockerStepView(viewModel: viewModel).tag(14)
                    PotentialStepView(viewModel: viewModel).tag(15)
                    ThankYouStepView(viewModel: viewModel).tag(16)
                    AppleHealthStepView(viewModel: viewModel).tag(17)
                    CaloriesBurnedStepView(viewModel: viewModel).tag(18)
                    RolloverStepView(viewModel: viewModel).tag(19)
                    TrustStepView(viewModel: viewModel).tag(20)
                    NotificationStepView(viewModel: viewModel).tag(21)
                    SignInStepView(viewModel: viewModel).tag(22)
                    ReferralStepView(viewModel: viewModel).tag(23)
                    AllDoneStepView(viewModel: viewModel).tag(24)
                    LoadingStepView(viewModel: viewModel).tag(25)
                    CongratulationsStepView(viewModel: viewModel).tag(26)
                    ScanStepView(viewModel: viewModel).tag(27)
                    ScoreResultsStepView(viewModel: viewModel) {
                        viewModel.saveProfile(context: modelContext)
                        onComplete(viewModel.scanResult)
                    }.tag(28)
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
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.94, green: 0.94, blue: 0.95))
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
                .foregroundStyle(enabled ? .white : Color(red: 0.6, green: 0.6, blue: 0.62))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(enabled ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.88, green: 0.88, blue: 0.89))
                .clipShape(.rect(cornerRadius: 14))
        }
        .disabled(!enabled)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}
