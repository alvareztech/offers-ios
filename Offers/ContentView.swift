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
        guard let url = URL(string: kOffersApiUrl) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(Response.self, from: data) {
                sections = response.sections
            }
        } catch { }
    }
}
