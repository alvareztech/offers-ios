//
//  Offer.swift
//  Offers
//
//  Created by Daniel Alvarez on 20/10/22.
//

import Foundation

struct Offer: Codable {
    var title: String
    var tags: String?
    var brand: String
    var favoriteCount: Int
    var detailUrl: String
    var imageUrl: String
}

struct Response: Codable {
    var title: String
    var sections: [Section]
    
    struct Section: Codable {
        var title: String
        var items: [Offer]
    }
}

extension Offer {
    private static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    var formattedFavoriteCount: String {
        if favoriteCount >= 1000 {
            let number = NSNumber(value: Float(favoriteCount) / 1000)
            let formattedValue = Self.formatter.string(from: number)!
            return "\(formattedValue)K"
        }
        return String(favoriteCount)
    }
}

extension Response.Section {
    
    func filteredItems(_ text: String = "") -> [Offer] {
        guard !text.isEmpty else { return items }
        return items.filter { $0.title.localizedCaseInsensitiveContains(text) }
    }
}
