import Foundation
import SwiftUI
import UIKit

struct Insect: Decodable {
    let common_name: String?
    let scientific_name: String?
    let alternative_names: [String]?
    let domain: String?
    let kingdom: String?
    let phylum: String?
    let order: String?
    let family: String?
    let genus: String?
    let species: String?
    let geographic_range: String?
    let habitat_type: String?
    let seasonal_appearance: String?
    let size: String?
    let colors: [String]?
    let has_wings: Bool?
    let leg_count: Int?
    let distinctive_markings: String?
    let diet: String?
    let activity_time: String?
    let lifespan: String?
    let predators: [String]?
    let defense_mechanisms: [String]?
    let role_in_ecosystem: String?
    let interesting_facts: [String]?
    let similar_species: [String]?
    let conservation_status: String?
    let url_wikipedia: String?
    let `class`: String?
    var thumbnail: UIImage? = nil

    enum CodingKeys: String, CodingKey {
        case common_name, scientific_name, alternative_names, domain, kingdom, phylum, order, family, genus, species, geographic_range, habitat_type, seasonal_appearance, size, colors, has_wings, leg_count, distinctive_markings, diet, activity_time, lifespan, predators, defense_mechanisms, role_in_ecosystem, interesting_facts, similar_species, conservation_status, url_wikipedia, `class`
    }
}
