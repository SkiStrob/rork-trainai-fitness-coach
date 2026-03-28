import SwiftUI

struct PaywallStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    let onComplete: () -> Void
    @State private var appeared: Bool = false
    @State private var showWinback: Bool = false

    var body: some View {
        if showWinback {
            winbackView
        } else {
            mainPaywall
        }
    }

    private var mainPaywall: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                                showWinback = true
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(.secondaryLabel))
                                .frame(width: 32, height: 32)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    (Text("Ready to ") + Text("transform").fontWeight(.heavy) + Text(" your physique?"))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    transformationPreview

                    laurelBadge

                    testimonialCard

                    sourcesSection

                    planToggle

                    Spacer().frame(height: 80)
                }
            }

            VStack {
                Spacer()
                VStack(spacing: 8) {
                    Button {
                        HapticManager.medium()
                        onComplete()
                    } label: {
                        Text("Start My Transformation")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                            .clipShape(.rect(cornerRadius: 16))
                    }
                    .padding(.horizontal, 16)

                    Button {
                        HapticManager.light()
                    } label: {
                        Text("Restore purchases")
                            .font(.caption)
                            .foregroundStyle(Color(.tertiaryLabel))
                    }
                    .padding(.bottom, 16)
                }
                .background(
                    LinearGradient(colors: [Color(red: 0.96, green: 0.96, blue: 0.97).opacity(0), Color(red: 0.96, green: 0.96, blue: 0.97)], startPoint: .top, endPoint: .center)
                        .frame(height: 120)
                        .allowsHitTesting(false),
                    alignment: .top
                )
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                appeared = true
            }
        }
    }

    private var transformationPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.92, green: 0.92, blue: 0.94), Color(red: 0.88, green: 0.88, blue: 0.90)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(height: 200)

            HStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "figure.stand")
                        .font(.system(size: 60, weight: .ultraLight))
                        .foregroundStyle(Color(.systemGray3))
                    Text("Before")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }

                Image(systemName: "arrow.right")
                    .font(.title3.bold())
                    .foregroundStyle(Color(.systemGray2))

                VStack(spacing: 8) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 60, weight: .regular))
                        .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    Text("After")
                        .font(.caption.bold())
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private var laurelBadge: some View {
        HStack(spacing: 2) {
            Image(systemName: "laurel.leading")
                .font(.system(size: 18))
                .foregroundStyle(Color(red: 0.78, green: 0.66, blue: 0.32))
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(Color(red: 0.78, green: 0.66, blue: 0.32))
                }
            }
            Image(systemName: "laurel.trailing")
                .font(.system(size: 18))
                .foregroundStyle(Color(red: 0.78, green: 0.66, blue: 0.32))
        }
    }

    private var testimonialCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Circle()
                    .fill(Color(red: 0.3, green: 0.5, blue: 0.9))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("B")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("Bryan, 29M")
                        .font(.system(size: 14, weight: .semibold))
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(Color(red: 0.78, green: 0.66, blue: 0.32))
                        }
                    }
                }
            }

            Text("\"I replaced my $200/month trainer and got better results in 3 months\"")
                .font(.system(size: 14))
                .foregroundStyle(Color(.secondaryLabel))
                .italic()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        .padding(.horizontal, 20)
    }

    private var sourcesSection: some View {
        VStack(spacing: 8) {
            Text("Backed by research from")
                .font(.caption)
                .foregroundStyle(Color(.tertiaryLabel))

            HStack(spacing: 20) {
                ForEach(["NSCA", "ACSM", "Sports Med."], id: \.self) { source in
                    Text(source)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color(.tertiaryLabel))
                        .textCase(.uppercase)
                }
            }
        }
    }

    private var planToggle: some View {
        VStack(spacing: 12) {
            Button {
                HapticManager.selection()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.selectedPlan = "annual"
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text("Annual")
                                .font(.system(size: 17, weight: .bold))
                            Text("Save 72%")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color(red: 0.2, green: 0.78, blue: 0.35))
                                .clipShape(Capsule())
                        }
                        Text("$4.17/mo, billed annually")
                            .font(.caption)
                    }
                    Spacer()
                    Image(systemName: viewModel.selectedPlan == "annual" ? "circle.inset.filled" : "circle")
                        .font(.title3)
                }
                .foregroundStyle(viewModel.selectedPlan == "annual" ? .white : Color(red: 0.1, green: 0.1, blue: 0.1))
                .padding(16)
                .background(viewModel.selectedPlan == "annual" ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color.white)
                .clipShape(.rect(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(viewModel.selectedPlan == "annual" ? Color.clear : Color(.separator), lineWidth: 1)
                )
            }

            Button {
                HapticManager.selection()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                    viewModel.selectedPlan = "monthly"
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Monthly")
                            .font(.system(size: 17, weight: .bold))
                        Text("$14.99/mo")
                            .font(.caption)
                    }
                    Spacer()
                    Image(systemName: viewModel.selectedPlan == "monthly" ? "circle.inset.filled" : "circle")
                        .font(.title3)
                }
                .foregroundStyle(viewModel.selectedPlan == "monthly" ? .white : Color(red: 0.1, green: 0.1, blue: 0.1))
                .padding(16)
                .background(viewModel.selectedPlan == "monthly" ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color.white)
                .clipShape(.rect(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(viewModel.selectedPlan == "monthly" ? Color.clear : Color(.separator), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 20)
    }

    private var winbackView: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97).ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                (Text("Wait — ") + Text("Try Trainity Free").fontWeight(.heavy) + Text(" for 7 Days"))
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Text("& Unlock 72% off")
                    .font(.system(size: 16))
                    .foregroundStyle(Color(.secondaryLabel))

                ZStack {
                    ScanBrackets(cornerSegmentLength: 0.22)
                        .stroke(Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.3), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                        .frame(width: 120, height: 160)

                    Image(systemName: "figure.stand")
                        .font(.system(size: 80, weight: .ultraLight))
                        .foregroundStyle(Color(.systemGray3))
                }
                .frame(height: 180)

                Text("One-time Offer")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color(red: 1.0, green: 0.58, blue: 0.0))
                    .textCase(.uppercase)
                    .tracking(1)

                HStack(spacing: 8) {
                    Text("$14.99/mo")
                        .font(.system(size: 16))
                        .foregroundStyle(Color(.tertiaryLabel))
                        .strikethrough()
                    Text("$4.49/week")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                }

                Spacer()

                Button {
                    HapticManager.medium()
                    onComplete()
                } label: {
                    Text("Start Free Trial")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                        .clipShape(.rect(cornerRadius: 16))
                }
                .padding(.horizontal, 16)

                Button {
                    HapticManager.light()
                    onComplete()
                } label: {
                    Text("No thanks")
                        .font(.subheadline)
                        .foregroundStyle(Color(.secondaryLabel))
                }
                .padding(.bottom, 32)
            }
        }
    }
}
