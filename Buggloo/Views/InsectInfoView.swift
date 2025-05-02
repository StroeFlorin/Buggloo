import SwiftUI


struct DetailRow: View {
    let title: String
    let value: String?

    var body: some View {
        ViewThatFits(in: .horizontal) {
            // 1) Try this first: HStack with value on the right
            HStack {
                Text(title)
                    .fontWeight(.semibold)
                Text(value ?? "Unknown")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }

            // 2) If that doesn't fit, stack them vertically
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .fontWeight(.semibold)
                Text(value ?? "Unknown")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(.vertical, 3)
    }
}

struct InsectInfoView: View {
    let insect: Insect
    let thumbnail: UIImage?
    @State private var isFullscreenImage = false

    var body: some View {
        List {
            Section(header: Text("Picture of the insect")) {
                Button {
                    isFullscreenImage = true
                } label: {
                    Image(uiImage: thumbnail ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                }
                .buttonStyle(PlainButtonStyle())
            }

            Section(header: Text("Basic Info")) {
                DetailRow(title: "Common name:", value: insect.common_name)
                DetailRow(
                    title: "Scientific name:",
                    value: insect.scientific_name
                )
                if let alt = insect.alternative_names, !alt.isEmpty {
                    DetailRow(
                        title: "Alternative names:",
                        value: alt.joined(separator: ", ")
                    )
                }
            }
            Section(header: Text("Classification")) {
                DetailRow(title: "Domain:", value: insect.domain)
                DetailRow(title: "Kingdom:", value: insect.kingdom)
                DetailRow(title: "Phylum:", value: insect.phylum)
                DetailRow(title: "Class:", value: insect.`class`)
                DetailRow(title: "Order:", value: insect.order)
                DetailRow(title: "Family:", value: insect.family)
                DetailRow(title: "Genus:", value: insect.genus)
                DetailRow(title: "Species:", value: insect.species)
            }

            Section(header: Text("Habitat & Range")) {
                DetailRow(
                    title: "Geographic range:",
                    value: insect.geographic_range
                )
                DetailRow(title: "Habitat type:", value: insect.habitat_type)
                DetailRow(
                    title: "Seasonal appearance:",
                    value: insect.seasonal_appearance
                )
            }

            Section(header: Text("Physical Characteristics")) {
                DetailRow(title: "Size:", value: insect.size)
                if let colors = insect.colors, !colors.isEmpty {
                    DetailRow(
                        title: "Colors:",
                        value: colors.joined(separator: ", ")
                    )
                }
                if let wings = insect.has_wings {
                    DetailRow(title: "Has wings:", value: wings ? "Yes" : "No")
                }
                if let legs = insect.leg_count {
                    DetailRow(title: "Leg count:", value: "\(legs)")
                }
                DetailRow(
                    title: "Distinctive markings:",
                    value: insect.distinctive_markings
                )
            }

            Section(header: Text("Ecology & Behavior")) {
                DetailRow(title: "Diet:", value: insect.diet)
                DetailRow(title: "Activity time:", value: insect.activity_time)
                DetailRow(title: "Lifespan:", value: insect.lifespan)
                if let preds = insect.predators, !preds.isEmpty {
                    DetailRow(
                        title: "Predators:",
                        value: preds.joined(separator: ", ")
                    )
                }
                if let defs = insect.defense_mechanisms, !defs.isEmpty {
                    DetailRow(
                        title: "Defense mechanisms",
                        value: defs.joined(separator: ", ")
                    )
                }
                DetailRow(
                    title: "Role in ecosystem:",
                    value: insect.role_in_ecosystem
                )
                if let facts = insect.interesting_facts, !facts.isEmpty {
                    DetailRow(
                        title: "Interesting facts:",
                        value: facts.joined(separator: "\n")
                    )
                }
                if let sims = insect.similar_species, !sims.isEmpty {
                    DetailRow(
                        title: "Similar species:",
                        value: sims.joined(separator: ", ")
                    )
                }
            }

            Section(header: Text("Additional Info")) {
                DetailRow(
                    title: "Conservation status:",
                    value: insect.conservation_status
                )
                if let wiki = insect.url_wikipedia, let url = URL(string: wiki),
                    !wiki.isEmpty
                {
                    Link("View on Wikipedia", destination: url)
                        .font(.body).foregroundColor(.blue)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .fullScreenCover(isPresented: $isFullscreenImage) {
            ZStack {
                Color.black.ignoresSafeArea()
                if let img = thumbnail {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture { isFullscreenImage = false }
                }
            }
        }
    }
}





