import SwiftUI

struct AttributionStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options: [(String, String)] = [
        ("Instagram", "camera.fill"),
        ("TikTok", "play.rectangle.fill"),
        ("TV", "tv.fill"),
        ("Friend or family", "person.2.fill"),
        ("Facebook", "person.crop.square.fill"),
        ("YouTube", "play.tv.fill"),
        ("App Store", "app.badge.fill"),
        ("Other", "ellipsis.circle.fill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Where did you hear about us?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .padding(.top, 24)

                    Text("This will be used to calibrate your custom plan.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 16)

                    ForEach(options, id: \.0) { option in
                        Button {
                            HapticManager.selection()
                            viewModel.selectedAttribution = option.0
                        } label: {
                            OnboardingOptionCard(title: option.0, isSelected: viewModel.selectedAttribution == option.0, icon: option.1)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            OnboardingCTAButton(title: "Continue", enabled: !viewModel.selectedAttribution.isEmpty) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
