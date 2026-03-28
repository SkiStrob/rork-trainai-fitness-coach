import SwiftUI

struct HeightStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var appeared: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("\(displayName), what's your height?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                unitToggle

                Text(viewModel.heightDisplayString)
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.heightDisplayString)

                if viewModel.useMetric {
                    Picker("Height", selection: $viewModel.heightCm) {
                        ForEach(120...220, id: \.self) { cm in
                            Text("\(cm) cm").tag(cm)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                    .padding(.horizontal, 40)
                    .onChange(of: viewModel.heightCm) { _, _ in
                        HapticManager.selection()
                    }
                } else {
                    HStack(spacing: 0) {
                        Picker("Feet", selection: $viewModel.heightFeet) {
                            ForEach(4...7, id: \.self) { ft in
                                Text("\(ft) ft").tag(ft)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        .onChange(of: viewModel.heightFeet) { _, _ in
                            HapticManager.selection()
                        }

                        Picker("Inches", selection: $viewModel.heightInches) {
                            ForEach(0...11, id: \.self) { inch in
                                Text("\(inch) in").tag(inch)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        .onChange(of: viewModel.heightInches) { _, _ in
                            HapticManager.selection()
                        }
                    }
                    .frame(height: 150)
                    .padding(.horizontal, 20)
                }
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82).delay(0.1)) {
                appeared = true
            }
        }
    }

    private var displayName: String {
        viewModel.userName.isEmpty ? "" : viewModel.userName + ","
    }

    private var unitToggle: some View {
        HStack(spacing: 0) {
            unitButton("Imperial", isSelected: !viewModel.useMetric) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.useMetric = false
                }
            }
            unitButton("Metric", isSelected: viewModel.useMetric) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.useMetric = true
                }
            }
        }
        .background(Color(red: 0.93, green: 0.93, blue: 0.94))
        .clipShape(Capsule())
    }

    private func unitButton(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(isSelected ? .white : Color(red: 0.1, green: 0.1, blue: 0.1))
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(isSelected ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color.clear)
                .clipShape(Capsule())
        }
    }
}
