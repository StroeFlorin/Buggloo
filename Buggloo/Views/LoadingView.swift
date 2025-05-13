import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                Text("Identifying in progress...")
                
                Image(systemName: "ladybug.circle.fill")
                    .font(.system(size: 70))
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear { isAnimating = true }
            }
            .padding(20)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}
