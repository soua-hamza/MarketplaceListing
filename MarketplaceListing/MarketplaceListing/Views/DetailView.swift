//
//  DetailView.swift
//  MarketplaceListing
//
//  Created by Hamza on 19/12/2024.
//

import SwiftUI

struct DetailView: View {
    let item: Item

    var body: some View {
        ScrollView {
            if let imageUrl = item.pictures.first?.resizes1000 {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                }
                placeholder: {
                    Image("")
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            ProgressView()
                        }
                }
                .overlay(alignment: .topTrailing) {
                    VStack {
                        HStack {
                            Text("beFirst")
                            Image(systemName: "person.2")
                        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    }.background(.white)
                        .cornerRadius(5)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            } else {
                Image(systemName: "photo.artframe")
                    .resizable()
                    .scaledToFit()
            }
            VStack {
                AdDetailSubView(titre: item.title, description: item.description)
            }
        }
    }
}
