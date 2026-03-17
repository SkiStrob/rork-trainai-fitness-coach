import SwiftUI

struct SplashView: View {
    let onComplete: () -> Void

    @State private var iconScale: CGFloat = 0.5
    @State private var iconOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var textOffset: CGFloat = 15
    @State private var splashFadeOut: Double = 1.0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 16) {
                ZStack {
                    ScanBrackets()
                        .stroke(Color.black.opacity(0.85), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .frame(width: 80, height: 80)

                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 38, weight: .regular))
                        .foregroundStyle(.black)
                }
                .frame(width: 80, height: 80)
                .scaleEffect(iconScale)
                .opacity(iconOpacity)

                Text("Fisique")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.black)
                    .opacity(textOpacity)
                    .offset(y: textOffset)
            }
        }
        .opacity(splashFadeOut)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                iconScale = 1.0
                iconOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.3).delay(0.4)) {
                textOpacity = 1.0
                textOffset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    splashFadeOut = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onComplete()
                }
            }
        }
    }
}
