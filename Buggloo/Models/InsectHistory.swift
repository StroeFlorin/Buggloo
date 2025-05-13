import SwiftData
import Foundation

@Model
class InsectHistory {
    var id = UUID()
    var dateIdentified: Date
    var insectData: Data?
    
    init() {
        self.dateIdentified = Date()
    }
}
