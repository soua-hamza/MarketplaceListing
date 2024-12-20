//
//  DetailCoordinator.swift
//  MarketplaceListing
//
//  Created by Hamza on 19/12/2024.
//

import SwiftUI

class DetailCoordinator: ObservableObject {
    @Published var selectedItem: Item?

    @ViewBuilder
    func detailView() -> some View {
        if let selectedItem = selectedItem {
            DetailView(item: selectedItem)
                .onDisappear {
                    self.selectedItem = nil
                }
        } else {
            EmptyView()
        }
    }
}
