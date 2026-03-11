import SwiftUI

nonisolated struct AttributionOption {
    let name: String
    let icon: String
    let brandColor: Color
}

struct AttributionStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let options: [AttributionOption] = [
        AttributionOption(name: "Instagram", icon: "camera.fill", brandColor: Color(red: 0.88, green: 0.19, blue: 0.42)),
        AttributionOption(name: "TikTok", icon: "play.rectangle.fill", brandColor: Color.black),
        AttributionOption(name: "YouTube", icon: "play.rectangle.fill", brandColor: Color(red: 1.0, green: 0.0, blue: 0.0)),
        AttributionOption(name: "Facebook", icon: "person.crop.square.fill", brandColor: Color(red: 0.23, green: 0.35, blue: 0.6)),
        AttributionOption(name: "X (Twitter)", icon: "xmark", brandColor: Color.black),
        AttributionOption(name: "TV", icon: "tv.fill", brandColor: Color(red: 0.4, green: 0.4, blue: 0.4)),
        AttributionOption(name: "Friend or family", icon: "person.2.fill", brandColor: Color(red: 0.3, green: 0.5, blue: 0.9)),
        AttributionOption(name: "App Store", icon: "app.badge.fill", brandColor: Color(red: 0.0, green: 0.48, blue: 1.0)),
        AttributionOption(name: "Other", icon: "ellipsis.circle.fill", brandColor: Color(.secondaryLabel))
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

                    ForEach(options, id: \.name) { option in
                        Button {
                            HapticManager.selection()
                            viewModel.selectedAttribution = option.name
                        } label: {
                            AttributionCard(
                                title: option.name,
                                icon: option.icon,
                                brandColor: option.brandColor,
                                isSelected: viewModel.selectedAttribution == option.name
                            )
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

struct AttributionCard: View {
    let title: String
    let icon: String
    let brandColor: Color
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.white.opacity(0.2) : brandColor.opacity(0.12))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isSelected ? .white : brandColor)
            }

            Text(title)
                .font(.body.weight(.semibold))
                .foregroundStyle(isSelected ? Color(.systemBackground) : .primary)

            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color.primary : Color(.systemGray6))
        )
        .scaleEffect(isSelected ? 1.01 : 1.0)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isSelected)
    }
}
