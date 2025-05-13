import SwiftData
import SwiftUI
import UIKit

@MainActor
class InsectViewModel: ObservableObject {
    private let imageService: ImageService
    var modelContext: ModelContext

    @Published var selectedImage: UIImage?
    @Published var selectedInsect: Insect?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var history = [Insect]()

    init(imageService: ImageService, modelContext: ModelContext) {
        self.imageService = imageService
        self.modelContext = modelContext
        fetchHistory()
    }
    
    func saveCurrentInsectToHistory() async {
        guard let insect = selectedInsect else { return }

        let record = InsectHistory()
        record.id = UUID()
        if let data = try? JSONEncoder().encode(insect) {
            record.insectData = data
        }

        modelContext.insert(record)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save insect history: \(error)")
        }
    }

    func fetchHistory() {
        do {
            let descriptor = FetchDescriptor<InsectHistory>(sortBy: [SortDescriptor(\.dateIdentified, order: .reverse)])
            let records = try modelContext.fetch(descriptor)
            history = records.compactMap { entry in
                guard let data = entry.insectData else { return nil }
                return try? JSONDecoder().decode(Insect.self, from: data)
            }
        } catch {
            print("Failed to load insect history: \(error)")
        }
    }

    func identify() async {
        guard let image = selectedImage else { return }
        isLoading = true
        selectedInsect = nil
        errorMessage = nil

        do {
            let result = try await imageService.identify(insectImage: image)
            selectedInsect = result
            selectedInsect?.thumbnail = selectedImage
            await saveCurrentInsectToHistory()
        } catch ImageServiceError.invalidImage {
            errorMessage =
                "Could not convert image to OpenAI's imageURL format."
        } catch {
            errorMessage = error.localizedDescription
        }

        fetchHistory()
        isLoading = false
    }
}
