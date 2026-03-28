import SwiftUI

struct BodyPartScoreRow: View {
    let name: String
    let score: Double

    private var barColor: Color {
        if score < 4 { return Color(red: 0.94, green: 0.27, blue: 0.27) }
        if score < 6 { return Color(red: 0.96, green: 0.62, blue: 0.04) }
        return Color(red: 0.13, green: 0.77, blue: 0.37)
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(name)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(.systemGray5))
                    RoundedRectangle(cornerRadius: 3)
                        .fill(barColor)
                        .frame(width: geo.size.width * (score / 10.0))
                }
            }
            .frame(height: 6)

            Text(String(format: "%.1f", score))
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
                .frame(width: 32, alignment: .trailing)
        }
    }
}
