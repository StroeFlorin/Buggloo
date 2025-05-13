import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.red, Color.white]),
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
              
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.orange)
                Text("Oops!")
                    .font(.title)
                    .fontWeight(.bold)
                Text(message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(
            message: "Error!",

        )
    }
}
