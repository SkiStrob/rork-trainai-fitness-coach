import SwiftUI

struct StatsStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your stats")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.primary)
                            .padding(.top, 24)

                        Text("This will be used to calibrate your custom plan.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        TextField("Your name", text: $viewModel.userName)
                            .font(.title3)
                            .foregroundStyle(.primary)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(.rect(cornerRadius: 12))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gender")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        HStack(spacing: 10) {
                            ForEach(["Male", "Female", "Other"], id: \.self) { gender in
                                Button {
                                    HapticManager.selection()
                                    viewModel.selectedGender = gender
                                } label: {
                                    Text(gender)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(viewModel.selectedGender == gender ? Color(.systemBackground) : .primary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(viewModel.selectedGender == gender ? Color.primary : Color(.systemGray6))
                                        .clipShape(.rect(cornerRadius: 12))
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Height")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Button(viewModel.useMetric ? "Switch to ft/in" : "Switch to cm") {
                                viewModel.useMetric.toggle()
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        if viewModel.useMetric {
                            HStack {
                                Picker("cm", selection: $viewModel.heightCm) {
                                    ForEach(120...220, id: \.self) { cm in
                                        Text("\(cm) cm").tag(cm)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                            }
                        } else {
                            HStack(spacing: 16) {
                                Picker("Feet", selection: $viewModel.heightFeet) {
                                    ForEach(4...7, id: \.self) { ft in
                                        Text("\(ft) ft").tag(ft)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)

                                Picker("Inches", selection: $viewModel.heightInches) {
                                    ForEach(0...11, id: \.self) { inch in
                                        Text("\(inch) in").tag(inch)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weight")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        HStack(spacing: 8) {
                            if viewModel.useMetric {
                                TextField("Weight", text: $viewModel.weightKg)
                                    .keyboardType(.decimalPad)
                                    .font(.title2.bold())
                                    .foregroundStyle(.primary)
                                    .padding(14)
                                    .background(Color(.systemGray6))
                                    .clipShape(.rect(cornerRadius: 12))
                                Text("kg")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                            } else {
                                TextField("Weight", text: $viewModel.weightLbs)
                                    .keyboardType(.decimalPad)
                                    .font(.title2.bold())
                                    .foregroundStyle(.primary)
                                    .padding(14)
                                    .background(Color(.systemGray6))
                                    .clipShape(.rect(cornerRadius: 12))
                                Text("lbs")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)

            OnboardingCTAButton(title: "Next", enabled: viewModel.canContinue) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
