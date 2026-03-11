import SwiftUI

struct StatsStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Height & weight")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)

                Text("This will be used to calibrate your custom plan.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)

            HStack(spacing: 0) {
                Button {
                    withAnimation { viewModel.useMetric = false }
                    HapticManager.selection()
                } label: {
                    Text("Imperial")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(!viewModel.useMetric ? Color(.systemBackground) : .primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(!viewModel.useMetric ? Color.primary : Color(.systemGray6))
                        .clipShape(Capsule())
                }

                Button {
                    withAnimation { viewModel.useMetric = true }
                    HapticManager.selection()
                } label: {
                    Text("Metric")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(viewModel.useMetric ? Color(.systemBackground) : .primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(viewModel.useMetric ? Color.primary : Color(.systemGray6))
                        .clipShape(Capsule())
                }
            }
            .padding(.top, 24)

            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text("Height")
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)

                    if viewModel.useMetric {
                        Picker("cm", selection: $viewModel.heightCm) {
                            ForEach(140...220, id: \.self) { cm in
                                Text("\(cm) cm").tag(cm)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 150)
                    } else {
                        HStack(spacing: 4) {
                            Picker("Feet", selection: $viewModel.heightFeet) {
                                ForEach(4...7, id: \.self) { ft in
                                    Text("\(ft) ft").tag(ft)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 150)

                            Picker("Inches", selection: $viewModel.heightInches) {
                                ForEach(0...11, id: \.self) { inch in
                                    Text("\(inch) in").tag(inch)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 150)
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 4) {
                    Text("Weight")
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)

                    if viewModel.useMetric {
                        Picker("kg", selection: Binding(
                            get: { Int(viewModel.weightKg) ?? 77 },
                            set: { viewModel.weightKg = "\($0)" }
                        )) {
                            ForEach(40...180, id: \.self) { kg in
                                Text("\(kg) kg").tag(kg)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 150)
                    } else {
                        Picker("lbs", selection: Binding(
                            get: { Int(viewModel.weightLbs) ?? 170 },
                            set: { viewModel.weightLbs = "\($0)" }
                        )) {
                            ForEach(80...350, id: \.self) { lb in
                                Text("\(lb) lb").tag(lb)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 150)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: viewModel.canContinue) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
