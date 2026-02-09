import SwiftUI

struct RootView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
            } else {
                NavigationStack {
                    TasksHomeView()
                }
            }
        }
        .onAppear {
            // Show splash briefly for milestone demo
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeInOut) { showSplash = false }
            }
        }
    }
}
