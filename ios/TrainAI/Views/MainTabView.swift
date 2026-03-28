import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @State private var showScanner: Bool = false
    @State private var showSettings: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(showSettings: $showSettings)
                    .tag(0)

                ProgressTabView()
                    .tag(1)

                Color.clear
                    .tag(2)

                SettingsView()
                    .tag(3)
            }
            .onChange(of: selectedTab) { _, newValue in
                if newValue == 2 {
                    selectedTab = 0
                    showScanner = true
                } else {
                    HapticManager.selection()
                }
            }

            customTabBar
        }
        .sheet(isPresented: $showScanner) {
            FoodScannerView()
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                ProfileView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") { showSettings = false }
                                .font(.headline)
                                .foregroundStyle(.primary)
                        }
                    }
            }
        }
    }

    private var customTabBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.separator).opacity(0.3))
                .frame(height: 0.5)

            HStack(spacing: 0) {
                tabItem(icon: "house", filledIcon: "house.fill", label: "Home", tag: 0)

                tabItem(icon: "chart.line.uptrend.xyaxis", filledIcon: "chart.line.uptrend.xyaxis", label: "Progress", tag: 1)

                Button {
                    HapticManager.light()
                    showScanner = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                            .frame(width: 52, height: 52)
                            .shadow(color: .black.opacity(0.10), radius: 6, y: 3)

                        Image(systemName: "plus")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                    .offset(y: -8)
                }
                .frame(maxWidth: .infinity)

                tabItem(icon: "gearshape", filledIcon: "gearshape.fill", label: "Settings", tag: 3)

                Spacer().frame(width: 1).frame(maxWidth: .infinity)
            }
            .padding(.top, 6)
            .padding(.bottom, 4)
        }
        .background(
            Color.white
                .ignoresSafeArea(.all, edges: .bottom)
        )
    }

    private func tabItem(icon: String, filledIcon: String, label: String, tag: Int) -> some View {
        Button {
            HapticManager.selection()
            selectedTab = tag
        } label: {
            VStack(spacing: 4) {
                Image(systemName: selectedTab == tag ? filledIcon : icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.system(size: 10))
            }
            .foregroundStyle(selectedTab == tag ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(.secondaryLabel))
            .frame(maxWidth: .infinity)
        }
    }
}
