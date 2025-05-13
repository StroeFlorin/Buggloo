import SwiftUI

struct ChatView: View {
    var body: some View {
        VStack {
            Text("Chat with an expert")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Button("Hello") {
                // Action for hello button
            }
     
            .padding()
        }
        .navigationTitle("Chat")
    }
}
