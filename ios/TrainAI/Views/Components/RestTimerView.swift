import SwiftUI

struct RestTimerView: View {
    @Bindable var viewModel: WorkoutViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Rest Timer")
                .font(.headline)
                .foregroundStyle(.secondary)

            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 8)
                    .frame(width: 160, height: 160)

                Circle()
                    .trim(from: 0, to: Double(viewModel.restTimerRemaining) / Double(viewModel.restTimerSeconds))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: viewModel.restTimerRemaining)

                Text("\(viewModel.restTimerRemaining)s")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
            }

            HStack(spacing: 24) {
                Button {
                    viewModel.restTimerSeconds = max(15, viewModel.restTimerSeconds - 15)
                    viewModel.restTimerRemaining = min(viewModel.restTimerRemaining, viewModel.restTimerSeconds)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }

                Text("\(viewModel.restTimerSeconds)s default")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button {
                    viewModel.restTimerSeconds = min(300, viewModel.restTimerSeconds + 15)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                viewModel.stopRestTimer()
            } label: {
                Text("Skip")
                    .font(.headline)
                    .foregroundStyle(Color(.systemBackground))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.primary)
                    .clipShape(.rect(cornerRadius: 12))
            }
        }
        .padding(24)
    }
}
