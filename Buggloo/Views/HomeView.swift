import SwiftUI

struct WelcomeView: View {
    @State private var currentFact: String = Facts.all.randomElement()!

    var body: some View {
        VStack(alignment: .leading) {
            
            Text(
                "Snap or select a photo of an insect to identify its species and discover fascinating facts!"
            )
            .font(.title2)

            (
                Text("Did you know? ")
                    .font(.title3)
                    .fontWeight(.semibold)
                + Text(currentFact)
                    .font(.callout)
                    .italic()
            )
            .multilineTextAlignment(.leading)
            .lineSpacing(4)
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(.top)
            
            Image(systemName: "ladybug.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 15)
                .symbolRenderingMode(.monochrome)
                .foregroundColor(.green)

            
        }
        .navigationTitle(Text("Welcome"))
        .onAppear {
            currentFact = Facts.all.randomElement()!
        }
    }
}

struct HomeView: View {
    @ObservedObject var viewModel: InsectViewModel
    @State private var showLibraryPicker = false
    @State private var showCameraPicker = false
    @State private var navigateToInfo: Bool = false
    @State private var navigateToError: Bool = false
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
                
                Group {
                    WelcomeView()
                }
                .padding()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                
                VStack(spacing: 16) {
                    Button {
                        showCameraPicker = false
                        showLibraryPicker = true
                    } label: {
                        Image(systemName: "photo")
                            .font(.title.weight(.semibold))
                            .frame(width: 70, height: 70)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }

                    Button {
                        showLibraryPicker = false
                        showCameraPicker = true

                    } label: {
                        Image(systemName: "camera")
                            .font(.title.weight(.semibold))
                            .frame(width: 70, height: 70)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                }
                .padding(.trailing)
                .padding(.bottom, 50)
            }
            .navigationDestination(isPresented: $navigateToInfo) {
                if let insect = viewModel.selectedInsect {
                    InsectInfoView(insect: insect)
                }
            }
            .overlay(alignment: .center) {
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .navigationDestination(isPresented: $navigateToError) {
                if let message = viewModel.errorMessage {
                    ErrorView(message: message)
                }
            }
            .sheet(isPresented: $showLibraryPicker) {
                ImagePicker(
                    image: $viewModel.selectedImage,
                    sourceType: .photoLibrary,
                    onComplete: {
                        showLibraryPicker = false
                        Task {
                            await viewModel.identify()
                            if viewModel.errorMessage != nil {
                                navigateToError = true
                            } else {
                                navigateToInfo = true
                            }
                        }
                    }
                )
            }
            .fullScreenCover(isPresented: $showCameraPicker) {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    ImagePicker(
                        image: $viewModel.selectedImage,
                        sourceType: .camera,
                        onComplete: {
                            showCameraPicker = false
                            Task {
                                await viewModel.identify()
                                if viewModel.errorMessage != nil {
                                    navigateToError = true
                                } else {
                                    navigateToInfo = true
                                }
                            }
                        }
                    )
                }
            }
        }
    }
}
