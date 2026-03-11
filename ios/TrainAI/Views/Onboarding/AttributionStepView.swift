import SwiftUI

struct AttributionStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options: [(String, String)] = [
        ("TikTok", "play.rectangle.fill"),
        ("Instagram", "camera.fill"),
        ("YouTube", "play.tv.fill"),
        ("Through a friend", "person.2.fill"),
        ("App Store", "app.badge.fill"),
        ("Other", "ellipsis.circle.fill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Where did you hear about us?")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)
                        .padding(.top, 24)

                    Text("This helps us improve our reach.")
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

            OnboardingCTAButton(title: "Next", enabled: !viewModel.selectedAttribution.isEmpty) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
