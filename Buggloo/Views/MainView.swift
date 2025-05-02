import SwiftUI
import UIKit

struct BeforeIdentifyingView: View {
    @Binding var showPicker: Bool
    var body: some View {
        VStack {
            Button {
                showPicker = true
            } label: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 250)
                    .overlay(Text("Tap to select image"))
            }
            Spacer()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView("Identifying...")
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(2.5)
            .padding()
    }
}

struct MainView: View {
    @StateObject var viewModel: InsectViewModel
    @State private var showPicker = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    LoadingView()
                } else if let insect = viewModel.insect {
                    InsectInfoView(
                        insect: insect,
                        thumbnail: viewModel.insect?.thumbnail
                    )
                } else if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                } else {
                    BeforeIdentifyingView(showPicker: $showPicker)
                }

            }
            .navigationTitle(viewModel.insect?.scientific_name ?? "Buggloo")
            .sheet(isPresented: $showPicker) {
                ImagePicker(image: $viewModel.selectedImage) {
                    Task { await viewModel.identify() }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.insect != nil || viewModel.errorMessage != nil {
                        Button("Back") {
                            // reset to initial state
                            viewModel.insect = nil
                            viewModel.errorMessage = nil
                            viewModel.selectedImage = nil
                            showPicker = false
                        }
                    }
                }
            }
        }
    }
}
