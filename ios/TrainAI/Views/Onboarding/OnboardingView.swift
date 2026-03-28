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
                    HStack(spacing: 12) {
                        if viewModel.showBackButton {
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                                    viewModel.previousStep()
                                }
                                HapticManager.light()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                                    .frame(width: 44, height: 44)
                            }
                        }

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(red: 0.9, green: 0.9, blue: 0.91))
                                    .frame(height: 4)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                                    .frame(width: max(0, geo.size.width * viewModel.progress), height: 4)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.82), value: viewModel.progress)
                            }
                        }
                        .frame(height: 4)

                        Spacer().frame(width: viewModel.showBackButton ? 44 : 0)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }

                TabView(selection: $viewModel.currentStep) {
                    CredibilitySplashStepView(viewModel: viewModel).tag(0)
                    SignInStepView(viewModel: viewModel).tag(1)
                    NameStepView(viewModel: viewModel).tag(2)
                    GenderStepView(viewModel: viewModel).tag(3)
                    BirthdayStepView(viewModel: viewModel).tag(4)
                    HeightStepView(viewModel: viewModel).tag(5)
                    WeightStepView(viewModel: viewModel).tag(6)
                    GoalStepView(viewModel: viewModel).tag(7)
                    ExperienceStepView(viewModel: viewModel).tag(8)
                    ComparisonGraphStepView(viewModel: viewModel).tag(9)
                    NotificationStepView(viewModel: viewModel).tag(10)
                    ScanIntroStepView(viewModel: viewModel).tag(11)
                    FrontPhotoStepView(viewModel: viewModel).tag(12)
                    SidePhotoStepView(viewModel: viewModel).tag(13)
                    AnalyzingStepView(viewModel: viewModel).tag(14)
                    ResultsStepView(viewModel: viewModel).tag(15)
                    PotentialStepView(viewModel: viewModel).tag(16)
                    PaywallStepView(viewModel: viewModel) {
                        viewModel.saveProfile(context: modelContext)
                        onComplete(viewModel.scanResult)
                    }.tag(17)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.4, dampingFraction: 0.82), value: viewModel.currentStep)
            }
        }
    }
}

struct OnboardingOptionCard: View {
    let title: String
    let isSelected: Bool
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 14) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(isSelected ? .white : Color(red: 0.1, green: 0.1, blue: 0.1))
                    .frame(width: 24)
            }

            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(isSelected ? .white : Color(red: 0.1, green: 0.1, blue: 0.1))

            Spacer()

            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(red: 0.93, green: 0.97, blue: 0.95))
        )
        .scaleEffect(isSelected ? 1.0 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.82), value: isSelected)
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
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(enabled ? .white : Color(red: 0.6, green: 0.6, blue: 0.62))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(enabled ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(red: 0.9, green: 0.9, blue: 0.91))
                )
        }
        .disabled(!enabled)
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
        .animation(.spring(response: 0.4, dampingFraction: 0.82), value: enabled)
    }
}
