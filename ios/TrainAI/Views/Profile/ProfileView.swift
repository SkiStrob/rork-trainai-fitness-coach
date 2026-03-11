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
        ScrollView {
            VStack(spacing: 24) {
                profileHeader
                statsCard
                settingsList
                shareButton
                accountActions
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 32)
        }
        .background(colors.background)
        .navigationTitle("Settings")
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(colors.inputBackground)
                .frame(width: 72, height: 72)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.secondary)
                }

            Text(profile?.name ?? "Athlete")
                .font(.title3.bold())
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
        HStack(spacing: 0) {
            StatItem(label: "Height", value: formatHeight(profile?.heightInches ?? 70))
            StatItem(label: "Weight", value: "\(Int(profile?.weightLbs ?? 170)) lbs")

            if let scan = latestScan {
                StatItem(label: "Score", value: String(format: "%.1f/10", scan.overallScore))
            }
        }
        .padding(20)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }

    private var settingsList: some View {
        VStack(spacing: 0) {
            @Bindable var tm = themeManager
            HStack {
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
            .padding(.vertical, 12)

            Divider().background(colors.separator)

            SettingsRow(icon: "bell.fill", title: "Notifications") {}
            Divider().background(colors.separator)
            SettingsRow(icon: "ruler.fill", title: "Units") {}
            Divider().background(colors.separator)
            SettingsRow(icon: "target", title: "Update Goals") {}
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(colors.cardBackground)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: colors.cardShadow, radius: 8, y: 2)
    }

    private var shareButton: some View {
        Button {
            shareScoreCard()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.up")
                Text("Share My Score")
            }
            .font(.headline)
            .foregroundStyle(colors.ctaForeground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
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
        .frame(maxWidth: .infinity)
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
