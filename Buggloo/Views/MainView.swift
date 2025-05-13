import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: InsectViewModel

    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            HistoryView(viewModel: viewModel)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            ChatView()
                .tabItem {
                    Label("AI Chat", systemImage: "ellipsis.message")
                }
        }
        .accentColor(.green)
    }
}


 
