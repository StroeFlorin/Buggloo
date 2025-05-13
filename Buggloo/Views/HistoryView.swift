import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: InsectViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.green, colorScheme == .dark ? Color.black : Color.white]),
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()
                
                List(viewModel.history) { insect in
                    NavigationLink(destination: InsectInfoView(insect: insect)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(insect.common_name ?? "Unknown")
                                    .font(.title3)
                                Text(insect.scientific_name ?? "Unknown")
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            if let thumbnail = insect.thumbnail {
                                Image(uiImage: thumbnail)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle(Text("History"))
        }
    }
}
