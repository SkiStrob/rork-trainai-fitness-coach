import SwiftUI

struct RealisticTargetStepView: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                let diff = viewModel.weightDifference
                let unit = viewModel.weightUnit
                let action = viewModel.selectedGoal.contains("Lose") ? "Losing" : "Gaining"

                Text("\(action) **\(diff) \(unit)** is a realistic target. It's not hard at all!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            HStack(spacing: 16) {
                Image(systemName: "figure.stand")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)

                Image(systemName: "arrow.right")
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 48))
                    .foregroundStyle(.primary)
            }
            .padding(.vertical, 32)

            Text("90% of users say that the change is obvious after using TrainAI and it is not easy to plateau.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}

struct ProgressSpeedStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    private let speeds: [(Double, String, String)] = [
        (0.25, "Slow & steady", "tortoise.fill"),
        (0.8, "Moderate", "figure.walk"),
        (1.5, "Aggressive", "hare.fill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("How fast do you want to reach your goal?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            VStack(spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", viewModel.selectedProgressSpeed))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText())
                    Text(viewModel.weightUnit)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                Text("per week")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 0) {
                ForEach(speeds, id: \.0) { speed in
                    Button {
                        HapticManager.selection()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                            viewModel.selectedProgressSpeed = speed.0
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: speed.2)
                                .font(.title2)
                                .foregroundStyle(viewModel.selectedProgressSpeed == speed.0 ? .white : .primary)

                            Text(speed.1)
                                .font(.caption.bold())
                                .foregroundStyle(viewModel.selectedProgressSpeed == speed.0 ? .white : .secondary)

                            if speed.0 == 0.8 {
                                Text("Recommended")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundStyle(viewModel.selectedProgressSpeed == speed.0 ? .white.opacity(0.7) : .secondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        Capsule().fill(viewModel.selectedProgressSpeed == speed.0 ? Color.white.opacity(0.15) : Color(red: 0.9, green: 0.9, blue: 0.9))
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(viewModel.selectedProgressSpeed == speed.0 ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.94, green: 0.94, blue: 0.95))
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}

struct DarkComparisonStepView: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("TrainAI makes it easy")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            VStack(spacing: 20) {
                HStack(spacing: 0) {
                    VStack(spacing: 12) {
                        Text("Without TrainAI")
                            .font(.caption.bold())
                            .foregroundStyle(Color.white.opacity(0.5))

                        HStack(spacing: 6) {
                            Image(systemName: "fork.knife")
                            Image(systemName: "figure.run")
                            Image(systemName: "chart.bar.fill")
                        }
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.3))

                        Text("20%")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.4))

                        Text("success rate")
                            .font(.caption)
                            .foregroundStyle(Color.white.opacity(0.3))
                    }
                    .frame(maxWidth: .infinity)

                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 1, height: 140)

                    VStack(spacing: 12) {
                        Text("With TrainAI")
                            .font(.caption.bold())
                            .foregroundStyle(Color.white.opacity(0.7))

                        HStack(spacing: 6) {
                            Image(systemName: "fork.knife")
                            Image(systemName: "figure.run")
                            Image(systemName: "chart.bar.fill")
                        }
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.5))

                        Text("2X")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(.white)

                        Text("more likely to succeed")
                            .font(.caption)
                            .foregroundStyle(Color.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                )

                Text("TrainAI makes it easy and holds you accountable")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}

struct PotentialStepView: View {
    let viewModel: OnboardingViewModel
    @State private var chartProgress: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("You have great potential to crush your goal")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Your physique transition")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "target")
                        .font(.body)
                        .foregroundStyle(.orange)
                }

                ZStack {
                    VStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { _ in
                            Rectangle()
                                .fill(Color(red: 0.9, green: 0.9, blue: 0.91))
                                .frame(height: 0.5)
                            Spacer()
                        }
                    }
                    .frame(height: 120)

                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 100))
                        path.addCurve(
                            to: CGPoint(x: 280, y: 20),
                            control1: CGPoint(x: 100, y: 95),
                            control2: CGPoint(x: 200, y: 30)
                        )
                    }
                    .trim(from: 0, to: chartProgress)
                    .stroke(Color.primary, lineWidth: 2.5)
                    .frame(height: 120)
                }

                HStack {
                    Text("3 Days")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("7 Days")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("30 Days")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text("Results are usually subtle at first, but after 7 days, you can see real changes.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
            )
            .padding(.horizontal, 20)

            Spacer().frame(height: 24)

            HStack(spacing: 10) {
                Image(systemName: "lock.shield.fill")
                    .font(.body)
                    .foregroundStyle(.secondary)
                Text("Your privacy and security matter to us.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).delay(0.3)) {
                chartProgress = 1.0
            }
        }
    }
}

struct ThankYouStepView: View {
    let viewModel: OnboardingViewModel
    @State private var pulse: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color(red: 1, green: 0.9, blue: 0.9))
                        .frame(width: 120, height: 120)

                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color(red: 0.9, green: 0.3, blue: 0.3))
                        .scaleEffect(pulse ? 1.05 : 1.0)
                }

                Text("Thank you for trusting us")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)

                Text("Now let's personalize TrainAI for you...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

struct AppleHealthStepView: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Connect to Apple Health")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)

                Text("Sync your daily activity for the most thorough data.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.red)

                HStack(spacing: 20) {
                    healthItem(icon: "figure.walk", label: "Walking")
                    healthItem(icon: "figure.run", label: "Running")
                    healthItem(icon: "heart.fill", label: "Heart")
                    healthItem(icon: "bed.double.fill", label: "Sleep")
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
            )
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            } label: {
                Text("Not now")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 16)
        }
    }

    private func healthItem(icon: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.secondary)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

struct CaloriesBurnedStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Add calories burned back to your daily goal?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    VStack(spacing: 6) {
                        Text("Today's Goal")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("2500 Cal")
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                    }

                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundStyle(.secondary)

                    VStack(spacing: 6) {
                        HStack(spacing: 4) {
                            Image(systemName: "figure.run")
                                .font(.caption)
                            Text("Running")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)

                        Text("+200 Cal")
                            .font(.title3.bold())
                            .foregroundStyle(.green)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
                )
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 40)

            HStack(spacing: 12) {
                Button {
                    HapticManager.selection()
                    viewModel.wantsCaloriesBurnedBack = false
                } label: {
                    Text("No")
                        .font(.headline)
                        .foregroundStyle(viewModel.wantsCaloriesBurnedBack == false ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(viewModel.wantsCaloriesBurnedBack == false ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.94, green: 0.94, blue: 0.95))
                        )
                }

                Button {
                    HapticManager.selection()
                    viewModel.wantsCaloriesBurnedBack = true
                } label: {
                    Text("Yes")
                        .font(.headline)
                        .foregroundStyle(viewModel.wantsCaloriesBurnedBack == true ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(viewModel.wantsCaloriesBurnedBack == true ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.94, green: 0.94, blue: 0.95))
                        )
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: viewModel.wantsCaloriesBurnedBack != nil) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}

struct RolloverStepView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Rollover extra calories to the next day?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)

                HStack(spacing: 4) {
                    Text("Rollover up to")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("200 cals")
                        .font(.subheadline.bold())
                        .foregroundStyle(.orange)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)

            Spacer()

            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text("Yesterday")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    ZStack {
                        Circle()
                            .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 4)
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                    }
                    .frame(width: 48, height: 48)
                    Text("350/500")
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                    Text("150 left")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
                )

                Image(systemName: "arrow.right")
                    .font(.title3)
                    .foregroundStyle(.orange)

                VStack(spacing: 8) {
                    Text("Today")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    ZStack {
                        Circle()
                            .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 4)
                        Circle()
                            .trim(from: 0, to: 0.54)
                            .stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                    }
                    .frame(width: 48, height: 48)
                    Text("350/650")
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                    Text("+150 rollover")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
                )
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 40)

            HStack(spacing: 12) {
                Button {
                    HapticManager.selection()
                    viewModel.wantsRolloverCalories = false
                } label: {
                    Text("No")
                        .font(.headline)
                        .foregroundStyle(viewModel.wantsRolloverCalories == false ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(viewModel.wantsRolloverCalories == false ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.94, green: 0.94, blue: 0.95))
                        )
                }

                Button {
                    HapticManager.selection()
                    viewModel.wantsRolloverCalories = true
                } label: {
                    Text("Yes")
                        .font(.headline)
                        .foregroundStyle(viewModel.wantsRolloverCalories == true ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(viewModel.wantsRolloverCalories == true ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.94, green: 0.94, blue: 0.95))
                        )
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: viewModel.wantsRolloverCalories != nil) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }
}

struct AllDoneStepView: View {
    let viewModel: OnboardingViewModel
    @State private var checkScale: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.91, green: 0.97, blue: 0.91))
                        .frame(width: 100, height: 100)

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.green)
                        .scaleEffect(checkScale)
                }

                Text("All done!")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)

                Text("Time to generate your\ncustom plan!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }

            Spacer().frame(height: 40)

            VStack(alignment: .leading, spacing: 12) {
                Text("Daily recommendation for:")
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)

                VStack(alignment: .leading, spacing: 8) {
                    planItem("Calories")
                    planItem("Carbs")
                    planItem("Protein")
                    planItem("Fats")
                    planItem("Body Score")
                    planItem("Workout Program")
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
            )
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Continue", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2)) {
                checkScale = 1.0
            }
        }
    }

    private func planItem(_ text: String) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(Color.primary)
                .frame(width: 4, height: 4)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
    }
}

struct CongratulationsStepView: View {
    let viewModel: OnboardingViewModel
    @State private var ringsAnimated: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.primary)
                    .padding(.top, 24)

                Text("Congratulations\nyour custom plan is ready!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)

                Text("You can edit this anytime")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }

            Spacer().frame(height: 32)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                macroTile(icon: "flame.fill", color: .green, label: "Calories", value: "2,583", progress: 0.0)
                macroTile(icon: "c.circle.fill", color: .orange, label: "Carbs", value: "300g", progress: 0.0)
                macroTile(icon: "p.circle.fill", color: Color(red: 0.9, green: 0.3, blue: 0.3), label: "Protein", value: "184g", progress: 0.0)
                macroTile(icon: "f.circle.fill", color: Color(red: 0.3, green: 0.5, blue: 0.9), label: "Fats", value: "71g", progress: 0.0)
            }
            .padding(.horizontal, 20)

            Spacer()

            OnboardingCTAButton(title: "Let's get started!", enabled: true) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    viewModel.nextStep()
                }
            }
        }
    }

    private func macroTile(icon: String, color: Color, label: String, value: String, progress: Double) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 4)
                Circle()
                    .trim(from: 0, to: ringsAnimated ? 0.75 : 0)
                    .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3), value: ringsAnimated)

                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
            }
            .frame(width: 36, height: 36)

            Text(value)
                .font(.title3.bold())
                .foregroundStyle(.primary)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        )
        .onAppear {
            ringsAnimated = true
        }
    }
}
