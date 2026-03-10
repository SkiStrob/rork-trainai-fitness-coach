import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appColors) private var colors
    @Environment(ThemeManager.self) private var themeManager
    @Query(sort: \UserProfile.createdAt) private var profiles: [UserProfile]
    @Query(sort: \BodyScan.date, order: .reverse) private var scans: [BodyScan]

    private var profile: UserProfile? { profiles.first }
    private var latestScan: BodyScan? { scans.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    profileHeader
                    statsCard
                    appearanceSection
                    settingsList
                    subscriptionSection
                    shareButton
                    accountActions
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .background(colors.background)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(colors.inputBackground)
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.secondary)
                }

            Text(profile?.name ?? "Athlete")
                .font(.title2.bold())
                .foregroundStyle(colors.primaryText)

            if let created = profile?.createdAt {
                Text("Member since \(created.formatted(.dateTime.month(.wide).year()))")
                    .font(.caption)
                    .foregroundStyle(colors.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private var statsCard: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatItem(label: "Height", value: formatHeight(profile?.heightInches ?? 70))
            StatItem(label: "Weight", value: "\(Int(profile?.weightLbs ?? 170)) lbs")

            if let scan = latestScan {
                StatItem(label: "Body Score", value: String(format: "%.1f", scan.overallScore))
                VStack(spacing: 4) {
                    Text("Tier")
                        .font(.caption)
                        .foregroundStyle(colors.secondaryText)
                    TierBadgeView(tierInfo: TierInfo.tier(for: scan.overallScore, gender: profile?.gender ?? "Male"))
                }
            }
        }
        .cardStyle()
    }

    private var appearanceSection: some View {
        @Bindable var tm = themeManager
        return HStack {
            Image(systemName: "moon.fill")
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            Text("Dark Mode")
                .font(.body)
                .foregroundStyle(colors.primaryText)
            Spacer()
            Toggle("", isOn: $tm.isDarkMode)
                .labelsHidden()
        }
        .cardStyle()
    }

    private var settingsList: some View {
        VStack(spacing: 0) {
            SettingsRow(icon: "bell.fill", title: "Notifications") {}
            Divider().background(colors.separator)
            SettingsRow(icon: "ruler.fill", title: "Units") {}
            Divider().background(colors.separator)
            SettingsRow(icon: "target", title: "Update Goals") {}
            Divider().background(colors.separator)
            SettingsRow(icon: "figure.stand", title: "Update Stats") {}
        }
        .cardStyle()
    }

    private var subscriptionSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Subscription")
                    .font(.headline)
                    .foregroundStyle(colors.primaryText)
                Text("TrainAI Pro · Annual")
                    .font(.subheadline)
                    .foregroundStyle(colors.secondaryText)
            }
            Spacer()
            Text("Active")
                .font(.caption.bold())
                .foregroundStyle(.green)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.12))
                .clipShape(Capsule())
        }
        .cardStyle()
    }

    private var shareButton: some View {
        Button {
            shareScoreCard()
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Share My Score Card")
            }
            .font(.headline)
            .foregroundStyle(colors.ctaForeground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(colors.ctaBackground)
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private var accountActions: some View {
        VStack(spacing: 12) {
            Button {} label: {
                Text("Sign Out")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button {} label: {
                Text("Delete Account")
                    .font(.subheadline)
                    .foregroundStyle(.red.opacity(0.7))
            }
        }
        .padding(.top, 8)
    }

    private func formatHeight(_ inches: Int) -> String {
        let feet = inches / 12
        let rem = inches % 12
        return "\(feet)'\(rem)\""
    }

    private func shareScoreCard() {
        guard let scan = latestScan else { return }
        let tierInfo = TierInfo.tier(for: scan.overallScore, gender: profile?.gender ?? "Male")
        let image = ScoreCardRenderer.renderShareCard(
            score: scan.overallScore,
            tierName: tierInfo.name,
            tierColor: tierInfo.color,
            radarValues: [scan.symmetry, scan.definition, scan.mass, scan.proportions, scan.vtaper, scan.core],
            date: scan.date
        )
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct StatItem: View {
    @Environment(\.appColors) private var colors
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(colors.secondaryText)
            Text(value)
                .font(.headline)
                .foregroundStyle(colors.primaryText)
        }
    }
}

struct SettingsRow: View {
    @Environment(\.appColors) private var colors
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(width: 24)
                Text(title)
                    .font(.body)
                    .foregroundStyle(colors.primaryText)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
        }
    }
}
