//
//  DetailSubViewRepresentable.swift
//  MarketplaceListing
//
//  Created by Hamza on 19/12/2024.
//

import SwiftUI
import UIKit

struct DetailSubViewRepresentable: UIViewRepresentable {
    let titre: String
    let description: String
    @Binding var dynamicHeight: CGFloat

    func makeUIView(context _: Context) -> DetailSubView {
        let view = DetailSubView()
        return view
    }

    func updateUIView(_ uiView: DetailSubView, context _: Context) {
        uiView.configure(titre: titre, sousTitre: description)
        DispatchQueue.main.async {
            dynamicHeight = uiView.suggestedHeight()
        }
    }
}

struct AdDetailSubView: View {
    @State private var height: CGFloat = .zero
    let titre: String
    let description: String

    var body: some View {
        DetailSubViewRepresentable(titre: titre, description: description, dynamicHeight: $height)
            .frame(height: height)
    }
}
