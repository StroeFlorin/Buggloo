import SwiftUI
import SwiftData

@main
struct BugglooApp: App {
    let container: ModelContainer
    
    var body: some Scene {
         WindowGroup {
             MainView(viewModel: InsectViewModel(
                imageService: ImageService(), modelContext: container.mainContext
             ))
         }
         .modelContainer(container)
     }
    
    init() {
           do {
               container = try ModelContainer(for: InsectHistory.self)
           } catch {
               fatalError("Failed to create ModelContainer for Movie.")
           }
       }
}
