import SwiftUI
import UIKit

@MainActor
class InsectViewModel: ObservableObject {
    private let imageService: ImageService

    @Published var selectedImage: UIImage?
    @Published var insect: Insect?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var analysis: String?

    init(imageService: ImageService) {
        self.imageService = imageService
    }

    func identify() async {
        guard let image = selectedImage else { return }
        isLoading = true
        insect = nil
        errorMessage = nil
        analysis = nil

        do {
            let result = try await imageService.identify(insectImage: image)
            insect = result
        } catch ImageServiceError.invalidImage {
            errorMessage = "Could not convert image to OpenAI's imageURL format."
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

