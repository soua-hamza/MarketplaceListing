//
//  MarketplaceListingApp.swift
//  MarketplaceListing
//
//  Created by Hamza on 17/12/2024.
//

import Alamofire
import SwiftUI

@main
struct MarketplaceListingApp: App {
    let session = Session(eventMonitors: [NetworkLogger()])
    let defaultErrorCoordinator = DefaultErrorCoordinator()
    let detailCoordinator = DetailCoordinator()
    var body: some Scene {
        WindowGroup {
            AdListing(viewModel: ItemsViewModel(fetchItemsUseCase: FetchItemsUseCase(apiClient: APIClient(session: session)),
                                                defaultErrorCoordinator: defaultErrorCoordinator),
                      locationViewModel: LocationViewModel(locationManager: LocationManager(),
                                                           defaultErrorCoordinator: defaultErrorCoordinator),
                      detailCoordinator: detailCoordinator)
        }
    }
}
