import SwiftUI

@main
struct BugglooApp: App {
    var body: some Scene {
         WindowGroup {
             MainView(viewModel: InsectViewModel(
                 imageService: ImageService()
             ))
         }
     }
}
