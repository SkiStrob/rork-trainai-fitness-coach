import SwiftUI

struct SplashView: View {
    let onComplete: () -> Void

    @State private var contentScale: CGFloat = 0.7
    @State private var contentOpacity: Double = 0
    @State private var splashFadeOut: Double = 1.0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            HStack(spacing: 16) {
                ZStack {
                    ScanBrackets()
                        .stroke(Color.black.opacity(0.85), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                        .frame(width: 50, height: 50)

                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(.black)
                }
                .frame(width: 50, height: 50)

                Text("Trainity")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.black)
            }
            .scaleEffect(contentScale)
            .opacity(contentOpacity)
        }
        .opacity(splashFadeOut)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                contentScale = 1.0
                contentOpacity = 1.0
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
