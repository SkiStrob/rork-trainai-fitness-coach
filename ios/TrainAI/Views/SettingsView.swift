import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ThemeManager.self) private var themeManager
    @Query private var profiles: [UserProfile]

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader

                    statsCard

                    settingsSection

                    dangerSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
            .background(Color(red: 0.96, green: 0.96, blue: 0.97))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.93, green: 0.97, blue: 0.95))
                    .frame(width: 72, height: 72)
                Image(systemName: "person.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
            }

            Text(profile?.name ?? "Athlete")
                .font(.system(size: 20, weight: .bold))

            Text("Member since \(profile?.createdAt ?? Date(), format: .dateTime.month(.wide).year())")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private var statsCard: some View {
        HStack(spacing: 0) {
            statItem(label: "Height", value: formatHeight())
            Divider().frame(height: 40)
            statItem(label: "Weight", value: formatWeight())
            Divider().frame(height: 40)
            statItem(label: "Goal", value: shortGoal())
        }
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private func statItem(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(size: 15, weight: .semibold))
        }
        .frame(maxWidth: .infinity)
    }

    private var settingsSection: some View {
        VStack(spacing: 2) {
            settingsRow(icon: "bell.fill", color: .orange, title: "Notifications")
            settingsRow(icon: "ruler", color: .blue, title: "Units")
            settingsRow(icon: "target", color: .green, title: "Goals")
            settingsRow(icon: "crown.fill", color: .purple, title: "Subscription")
        }
        .clipShape(.rect(cornerRadius: 16))
    }

    private func settingsRow(icon: String, color: Color, title: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(color)
                .clipShape(.rect(cornerRadius: 6))

            Text(title)
                .font(.system(size: 16))

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
    }

    private var dangerSection: some View {
        VStack(spacing: 2) {
            Button {
                HapticManager.light()
            } label: {
                HStack {
                    Text("Sign Out")
                        .font(.system(size: 16))
                        .foregroundStyle(.red)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white)
            }

            Button {
                HapticManager.warning()
            } label: {
                HStack {
                    Text("Delete Account")
                        .font(.system(size: 16))
                        .foregroundStyle(.red)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white)
            }
        }
        .clipShape(.rect(cornerRadius: 16))
    }

    private func formatHeight() -> String {
        guard let p = profile else { return "5'10\"" }
        if p.useMetric {
            return "\(Int(Double(p.heightInches) * 2.54)) cm"
        }
        return "\(p.heightInches / 12)'\(p.heightInches % 12)\""
    }

    private func formatWeight() -> String {
        guard let p = profile else { return "170 lbs" }
        if p.useMetric {
            return "\(Int(p.weightLbs / 2.20462)) kg"
        }
        return "\(Int(p.weightLbs)) lbs"
    }

    private func shortGoal() -> String {
        guard let p = profile else { return "—" }
        let goal = p.goal
        if goal.count > 12 {
            return String(goal.prefix(10)) + "..."
        }
        return goal.isEmpty ? "—" : goal
    }
}
