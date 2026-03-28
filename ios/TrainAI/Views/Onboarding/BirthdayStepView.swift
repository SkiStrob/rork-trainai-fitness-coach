import SwiftUI

struct BirthdayStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var appeared: Bool = false

    private let months = Calendar.current.monthSymbols
    private let years = Array(stride(from: 2010, through: 1950, by: -1))

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("\(viewModel.userName.isEmpty ? "" : viewModel.userName + ", ")when's your birthday?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                HStack(spacing: 0) {
                    Picker("Month", selection: $viewModel.birthMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text(months[month - 1])
                                .tag(month)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)

                    Picker("Year", selection: $viewModel.birthYear) {
                        ForEach(years, id: \.self) { year in
                            Text("\(year)")
                                .tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 180)
                .padding(.horizontal, 16)
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
}
