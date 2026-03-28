import SwiftUI

struct NameStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @FocusState private var isFocused: Bool
    @State private var appeared: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                Text("What's Your Name?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .multilineTextAlignment(.center)

                TextField("Enter your name", text: $viewModel.userName)
                    .font(.system(size: 17))
                    .padding(.horizontal, 18)
                    .frame(height: 56)
                    .background(Color(red: 0.93, green: 0.97, blue: 0.95))
                    .clipShape(.rect(cornerRadius: 16))
                    .padding(.horizontal, 16)
                    .focused($isFocused)
                    .textContentType(.givenName)
                    .submitLabel(.done)
                    .onSubmit {
                        if viewModel.canContinue {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                                viewModel.nextStep()
                            }
                        }
                    }
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: viewModel.canContinue) {
                isFocused = false
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82).delay(0.1)) {
                appeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
    }
}
