import SwiftUI

struct TargetWeightStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("What is your\ndesired weight?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)

            Spacer()

            VStack(spacing: 8) {
                Text(viewModel.selectedGoal.contains("Lose") ? "Lose weight" : viewModel.selectedGoal.contains("Gain") ? "Gain weight" : viewModel.selectedGoal)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if viewModel.useMetric {
                    HStack(spacing: 4) {
                        Text(viewModel.targetWeightKg)
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(.primary)
                        Text("kg")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }

                    Picker("Target", selection: Binding(
                        get: { Int(viewModel.targetWeightKg) ?? 75 },
                        set: { viewModel.targetWeightKg = "\($0)" }
                    )) {
                        ForEach(40...180, id: \.self) { kg in
                            Text("\(kg) kg").tag(kg)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                } else {
                    HStack(spacing: 4) {
                        Text(viewModel.targetWeightLbs)
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(.primary)
                        Text("lbs")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }

                    Picker("Target", selection: Binding(
                        get: { Int(viewModel.targetWeightLbs) ?? 165 },
                        set: { viewModel.targetWeightLbs = "\($0)" }
                    )) {
                        ForEach(80...350, id: \.self) { lb in
                            Text("\(lb) lb").tag(lb)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                }
            }
            .padding(.horizontal, 16)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
