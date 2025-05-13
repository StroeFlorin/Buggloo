import SwiftUI

struct DetailRowView: View {
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

struct TitleView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title2)
            .padding(.bottom, 2)
    }
}

//main
struct InsectInfoView: View {
    let insect: Insect
    @State private var isFullscreenImage = false

    var body: some View {
        ScrollView {
            NamePhotoAndTaxonomyView(
                insect: insect,
                isFullscreenImage: $isFullscreenImage
            )

            VStack(alignment: .leading) {
                TitleView(title: "Habitat & Range")

                DetailRowView(
                    title: "Geographic range:",
                    value: insect.geographic_range
                )
                DetailRowView(
                    title: "Habitat type:",
                    value: insect.habitat_type
                )
                DetailRowView(
                    title: "Seasonal appearance:",
                    value: insect.seasonal_appearance
                )

                Divider()

                TitleView(title: "Physical characteristics")

                DetailRowView(title: "Size:", value: insect.size)
                if let colors = insect.colors, !colors.isEmpty {
                    DetailRowView(
                        title: "Colors:",
                        value: colors.joined(separator: ", ")
                    )
                }

                if let wings = insect.has_wings {
                    DetailRowView(
                        title: "Has wings:",
                        value: wings ? "Yes" : "No"
                    )
                }

                if let legs = insect.leg_count {
                    DetailRowView(title: "Leg count:", value: "\(legs)")
                }

                DetailRowView(
                    title: "Distinctive markings:",
                    value: insect.distinctive_markings
                )

                Divider()

                TitleView(title: "Ecology & Behaviour")

                DetailRowView(title: "Diet:", value: insect.diet)

                DetailRowView(
                    title: "Activity time:",
                    value: insect.activity_time
                )

                DetailRowView(title: "Lifespan:", value: insect.lifespan)

                if let preds = insect.predators, !preds.isEmpty {
                    DetailRowView(
                        title: "Predators:",
                        value: preds.joined(separator: ", ")
                    )
                }

                if let defs = insect.defense_mechanisms, !defs.isEmpty {
                    DetailRowView(
                        title: "Defense mechanisms:",
                        value: defs.joined(separator: ", ")
                    )
                }

                DetailRowView(
                    title: "Role in ecosystem:",
                    value: insect.role_in_ecosystem
                )

                if let facts = insect.interesting_facts, !facts.isEmpty {
                    DetailRowView(
                        title: "Interesting facts:",
                        value: facts.joined(separator: "\n")
                    )
                }

                if let sims = insect.similar_species, !sims.isEmpty {
                    DetailRowView(
                        title: "Similar species:",
                        value: sims.joined(separator: ", ")
                    )
                }

            }
            .padding(.horizontal, 30)
            .listStyle(InsetGroupedListStyle())

        }
        .navigationTitle(Text(insect.common_name ?? "Unknown insect"))
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isFullscreenImage) {
            ZStack {
                Color.black.ignoresSafeArea()

                if let img = insect.thumbnail {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                        .onTapGesture {
                            isFullscreenImage = false
                        }
                }
            }
        }
    }
}

struct NamePhotoAndTaxonomyView: View {
    let insect: Insect
    @Binding var isFullscreenImage: Bool

    var body: some View {
        HStack {
            TaxonomyView(insect: insect)

            VStack(alignment: .leading, spacing: 0) {
                Button {
                    isFullscreenImage = true
                } label: {
                    Image(uiImage: insect.thumbnail!)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.green, lineWidth: 2)
                        )
                }
                .buttonStyle(PlainButtonStyle())

                DetailRowView(title: "Common name:", value: insect.common_name)
                
                DetailRowView(
                    title: "Scientific name:",
                    value: insect.scientific_name
                )
                
                if let alt = insect.alternative_names, !alt.isEmpty {
                    DetailRowView(
                        title: "Alternative names:",
                        value: alt.joined(separator: ", ")
                    )
                }

                DetailRowView(
                    title: "Conservation status:",
                    value: insect.conservation_status
                )
                
                if let wiki = insect.url_wikipedia, let url = URL(string: wiki),
                    !wiki.isEmpty
                {
                    Link("View on Wikipedia", destination: url)
                        .font(.body).foregroundColor(.blue)
                }

                Spacer()
            }
        }
    }
}

struct TaxonomyView: View {
    let insect: Insect

    var body: some View {
        let taxonomy = getTaxonomy(from: insect)
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<taxonomy.count, id: \.self) { index in
                HStack(alignment: .top) {
                    VStack(spacing: 0) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 17, height: 17)
                        if index < taxonomy.count - 1 {
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 2, height: 50)
                                .offset(y: 1)
                        }
                    }
                    .frame(width: 16)
                    .padding(.top, 2)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(taxonomy[index].level)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(taxonomy[index].name)
                            .font(.body)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.bottom, 8)
                }
            }
        }
        .padding()
    }
}

func getTaxonomy(from insect: Insect) -> [(level: String, name: String)] {
    return [
        ("Domain", insect.domain ?? "Unknown"),
        ("Kingdom", insect.kingdom ?? "Unknown"),
        ("Phylum", insect.phylum ?? "Unknown"),
        ("Class", insect.class ?? "Unknown"),
        ("Order", insect.order ?? "Unknown"),
        ("Family", insect.family ?? "Unknown"),
        ("Genus", insect.genus ?? "Unknown"),
        ("Species", insect.species ?? "Unknown"),
    ]
}
