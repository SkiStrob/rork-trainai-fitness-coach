import SwiftUI
import SwiftData

struct FoodScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appColors) private var colors
    @State private var hasScanned: Bool = false
    @State private var isScanning: Bool = false
    @State private var scanLineOffset: CGFloat = -150
    @State private var visibleLabels: Set<Int> = []
    @State private var showSheet: Bool = false

    private let mockFoods: [(String, Int, CGPoint)] = [
        ("Grilled Chicken\n280 cal", 280, CGPoint(x: 0.3, y: 0.35)),
        ("Brown Rice\n215 cal", 215, CGPoint(x: 0.65, y: 0.4)),
        ("Broccoli\n55 cal", 55, CGPoint(x: 0.5, y: 0.6))
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if !hasScanned {
                cameraPlaceholder
            } else {
                scannedResultView
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showSheet) {
            FoodResultSheet(dismiss: { dismiss() }, modelContext: modelContext)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationContentInteraction(.scrolls)
        }
    }

    private var cameraPlaceholder: some View {
        ZStack {
            Color(white: 0.05).ignoresSafeArea()

            VStack {
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 280, height: 280)
                        .mask(
                            CameraBracketMask()
                        )

                    if isScanning {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [.clear, .white.opacity(0.5), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 260, height: 4)
                            .offset(y: scanLineOffset)
                    }
                }

                Spacer()

                VStack(spacing: 16) {
                    HStack(spacing: 0) {
                        Button {
                            startScan()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "camera.fill")
                                    .font(.caption)
                                Text("Scan Food")
                                    .font(.subheadline.weight(.semibold))
                            }
                            .foregroundStyle(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .clipShape(Capsule())
                        }

                        Spacer().frame(width: 12)

                        Button {} label: {
                            Image(systemName: "barcode.viewfinder")
                                .font(.body)
                                .foregroundStyle(.white.opacity(0.8))
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Circle())
                        }

                        Spacer().frame(width: 8)

                        Button {} label: {
                            Image(systemName: "photo.on.rectangle")
                                .font(.body)
                                .foregroundStyle(.white.opacity(0.8))
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Circle())
                        }

                        Spacer().frame(width: 8)

                        Button {} label: {
                            Image(systemName: "pencil")
                                .font(.body)
                                .foregroundStyle(.white.opacity(0.8))
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 24)

                    HStack {
                        Button {} label: {
                            Image(systemName: "bolt.fill")
                                .font(.title3)
                                .foregroundStyle(.white.opacity(0.6))
                                .frame(width: 44, height: 44)
                        }

                        Spacer()

                        Button {
                            startScan()
                        } label: {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 68, height: 68)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 4)
                                        .frame(width: 76, height: 76)
                                )
                        }

                        Spacer()

                        Spacer().frame(width: 44)
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 32)
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.bold())
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }

    private var scannedResultView: some View {
        GeometryReader { geo in
            ZStack {
                Color(white: 0.08).ignoresSafeArea()

                ForEach(0..<mockFoods.count, id: \.self) { i in
                    let food = mockFoods[i]
                    if visibleLabels.contains(i) {
                        FoodLabelPill(text: food.0)
                            .position(
                                x: geo.size.width * food.2.x,
                                y: geo.size.height * food.2.y
                            )
                            .transition(.scale(scale: 0.5).combined(with: .opacity))
                    }
                }
            }
        }
    }

    private func startScan() {
        isScanning = true
        withAnimation(.linear(duration: 1.5).repeatCount(2, autoreverses: true)) {
            scanLineOffset = 150
        }

        Task {
            try? await Task.sleep(for: .seconds(3))
            isScanning = false
            hasScanned = true

            for i in 0..<mockFoods.count {
                try? await Task.sleep(for: .milliseconds(400))
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    visibleLabels.insert(i)
                }
            }

            try? await Task.sleep(for: .milliseconds(500))
            showSheet = true
        }
    }
}

struct FoodLabelPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.bold())
            .foregroundStyle(.black)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .background(Color.white.opacity(0.85))
            .clipShape(.rect(cornerRadius: 12))
            .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
    }
}

struct CameraBracketMask: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerLength: CGFloat = 40

        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerLength))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + cornerLength, y: rect.minY))

        path.move(to: CGPoint(x: rect.maxX - cornerLength, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerLength))

        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerLength))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerLength, y: rect.maxY))

        path.move(to: CGPoint(x: rect.minX + cornerLength, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerLength))

        return path.strokedPath(StrokeStyle(lineWidth: 3, lineCap: .round))
    }
}

struct FoodResultSheet: View {
    let dismiss: () -> Void
    let modelContext: ModelContext
    @State private var servings: Int = 1
    @State private var mealName: String = "Chicken breast with rice and broccoli"

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("2:10 PM")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(mealName)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 16)

                HStack {
                    Spacer()
                    HStack(spacing: 16) {
                        Button {
                            if servings > 1 {
                                withAnimation { servings -= 1 }
                            }
                        } label: {
                            Image(systemName: "minus")
                                .font(.body.bold())
                                .foregroundStyle(.primary)
                                .frame(width: 32, height: 32)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                        Text("\(servings)")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                            .frame(width: 30)
                            .contentTransition(.numericText())
                        Button {
                            withAnimation { servings += 1 }
                        } label: {
                            Image(systemName: "plus")
                                .font(.body.bold())
                                .foregroundStyle(.primary)
                                .frame(width: 32, height: 32)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                    }
                    Spacer()
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    MacroTile(icon: "flame.fill", color: Color(red: 0.13, green: 0.77, blue: 0.37), label: "Calories", value: "\(550 * servings)")
                    MacroTile(icon: "c.circle.fill", color: .orange, label: "Carbs", value: "\(52 * servings)g")
                    MacroTile(icon: "p.circle.fill", color: Color(red: 0.9, green: 0.3, blue: 0.3), label: "Protein", value: "\(38 * servings)g")
                    MacroTile(icon: "f.circle.fill", color: Color(red: 0.3, green: 0.5, blue: 0.9), label: "Fat", value: "\(14 * servings)g")
                }
                .padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundStyle(.pink.opacity(0.6))
                        Text("Health Score")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("8/10")
                            .font(.subheadline.bold())
                            .foregroundStyle(.primary)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [.green, .green.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * 0.8)
                        }
                    }
                    .frame(height: 8)
                }
                .padding(.horizontal, 16)

                HStack(spacing: 10) {
                    Button {} label: {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.caption)
                            Text("Fix Results")
                                .font(.subheadline.bold())
                        }
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(.systemGray5))
                        .clipShape(.rect(cornerRadius: 12))
                    }

                    Button {
                        let entry = FoodEntry(
                            date: Date(),
                            mealType: "Lunch",
                            name: mealName,
                            calories: 550 * servings,
                            proteinGrams: Double(38 * servings),
                            carbsGrams: Double(52 * servings),
                            fatGrams: Double(14 * servings),
                            healthScore: 8
                        )
                        modelContext.insert(entry)
                        HapticManager.success()
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.headline)
                            .foregroundStyle(Color(.systemBackground))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.primary)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
}

struct MacroTile: View {
    let icon: String
    let color: Color
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
            }

            Spacer()
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 12))
    }
}
