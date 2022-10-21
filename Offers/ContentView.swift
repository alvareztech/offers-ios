//
//  ContentView.swift
//  Offers
//
//  Created by Daniel Alvarez on 20/10/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sections = [Response.Section]()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            OfferList(sections: sections, searchText: searchText)
                .searchable(text: $searchText, prompt: "Search")
                .navigationTitle("Offers")
                .listStyle(.inset)
        }.task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://my-json-server.typicode.com/mluksenberg/lucky-test/test") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response2 = try? JSONDecoder().decode(Response.self, from: data) {
                sections = response2.sections
            }
        } catch {
            print("Invalid data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct OfferList: View {
    var sections: [Response.Section]
    var searchText: String
    
    var body: some View {
        List {
            ForEach(sections, id: \.title) { section in
                Section(header: SectionHeader(title: section.title)) {
                    ForEach(section.filteredItems(searchText), id: \.title) { item in
                        NavigationLink {
                            OfferDetail(offer: item)
                        } label: {
                            OfferRow(offer: item)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
            }
        }
    }
}

struct SectionHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title.weight(.medium))
            .foregroundColor(.primary)
    }
}

struct OfferRow: View {
    var offer: Offer
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: offer.imageUrl),
                       content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            }, placeholder: {
                Image(systemName: "leaf")
            })
            .frame(maxWidth: 120, maxHeight: 80)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading) {
                HStack {
                    Text(offer.brand)
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(.secondary)
                    Spacer()
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.secondary)
                    Text(offer.formattedFavoriteCount)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(offer.title)
                    .font(.headline)
                    .padding(.bottom, 2)
                Text(offer.tags ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
