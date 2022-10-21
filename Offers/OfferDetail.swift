//
//  OfferDetail.swift
//  Offers
//
//  Created by Daniel Alvarez on 20/10/22.
//

import SwiftUI

struct OfferDetail: View {
    var offer: Offer
    @State private var scaleAmount = 0.0
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                AsyncImage(url: URL(string: offer.imageUrl),
                           content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                }, placeholder: {
                    Image(systemName: "leaf")
                })
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .scaleEffect(scaleAmount)
                    .animation(.spring(), value: scaleAmount)
            }
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
                    .font(.largeTitle.weight(.medium))
                    .padding(.bottom)
                Text(offer.tags ?? "")
                    .font(.caption)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            Spacer()
            
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                isLiked.toggle()
                guard isLiked else { return }
                scaleAmount = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { scaleAmount = 0 }
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
            }
        }
    }
}
