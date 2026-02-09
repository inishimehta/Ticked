import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.10, green: 0.45, blue: 0.95),
                                    Color(red: 0.13, green: 0.34, blue: 0.90)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()

            VStack(spacing: 14) {
                Image(systemName: "checklist")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(22)
                    .background(.white.opacity(0.20), in: RoundedRectangle(cornerRadius: 18))

                Text("Ticked.")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)

                Text("Deadlines, ticked off.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
    }
}
