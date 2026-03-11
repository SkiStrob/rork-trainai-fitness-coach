import SwiftUI

struct AgeStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    @State private var selectedMonth: Int = 1
    @State private var selectedDay: Int = 15
    @State private var selectedYear: Int = 1995

    private let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("When were you born?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)

                Text("This will be used to calibrate your custom plan.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)

            Spacer()

            HStack(spacing: 0) {
                Picker("Month", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { m in
                        Text(months[m - 1]).tag(m)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .clipped()

                Picker("Day", selection: $selectedDay) {
                    ForEach(1...31, id: \.self) { d in
                        Text("\(d)").tag(d)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80)
                .clipped()

                Picker("Year", selection: $selectedYear) {
                    ForEach(1950...2010, id: \.self) { y in
                        Text("\(y)").tag(y)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                .clipped()
            }
            .padding(.horizontal, 16)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                let age = Calendar.current.dateComponents([.year], from: DateComponents(calendar: Calendar.current, year: selectedYear).date ?? Date(), to: Date()).year ?? 25
                if age < 18 { viewModel.selectedAge = "Under 18" }
                else if age < 25 { viewModel.selectedAge = "18-24" }
                else if age < 35 { viewModel.selectedAge = "25-34" }
                else if age < 45 { viewModel.selectedAge = "35-44" }
                else if age < 55 { viewModel.selectedAge = "45-54" }
                else { viewModel.selectedAge = "55+" }
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}
