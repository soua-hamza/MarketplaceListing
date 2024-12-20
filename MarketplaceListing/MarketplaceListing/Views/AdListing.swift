//
//  AdListing.swift
//  MarketplaceListing
//
//  Created by Hamza on 17/12/2024.
//

import CoreLocation
import RxSwift
import SwiftUI

struct AdListing: View {
    var viewModel: ItemsViewModel
    var locationViewModel: LocationViewModel
    @StateObject var detailCoordinator: DetailCoordinator

    @State private var location: CLLocation?
    @State private var items: [Item] = []
    @State private var isLoadingMore = false
    private let disposeBag = DisposeBag()
    private let flexibleColumn = [
        GridItem(.flexible(minimum: 150, maximum: 250), spacing: 20),
        GridItem(.flexible(minimum: 150, maximum: 250), spacing: 20)
    ]
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: flexibleColumn, spacing: 20) {
                    ForEach(items) { item in
                        AdView(item: item, location: location)
                            .onTapGesture {
                                detailCoordinator.selectedItem = item
                            }
                            .onAppear {
                                loadMoreIfNeeded(currentItem: item)
                            }
                    }
                }.background(
                    NavigationLink(destination: detailCoordinator.detailView(), isActive: .constant(detailCoordinator.selectedItem != nil), label: { EmptyView() }).hidden()
                )
                .padding(.trailing, 10)
                .padding(.leading, 10)

                if isLoadingMore {
                    ProgressView("Loading")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.vertical)
                }
            }.refreshable {
                isLoadingMore = false
                viewModel.loadItems(fromBeginning: true)
            }
        }.background(.gray)
            .onAppear {
                locationViewModel.requestLocation()
                locationViewModel.currentLocation.subscribe(
                    onNext: { location in
                        print(items)
                        self.location = location
                    }
                ).disposed(by: disposeBag)
                locationViewModel.errorMessage.subscribe(
                    onNext: { errorMessage in
                        print(errorMessage)
                        locationViewModel.handleError(error: errorMessage)
                    }
                ).disposed(by: disposeBag)

                viewModel.loadItems()
                viewModel.items.subscribe(
                    onNext: { items in
                        print(items)
                        if !isLoadingMore {
                            self.items = items.data
                        } else {
                            self.items.append(contentsOf: items.data)
                        }
                        isLoadingMore = false
                    }
                ).disposed(by: disposeBag)
                viewModel.errorMessage.subscribe(
                    onNext: { errorMessage in
                        print(errorMessage)
                        viewModel.handleError(error: errorMessage)
                    }
                ).disposed(by: disposeBag)
            }
    }

    private func loadMoreIfNeeded(currentItem: Item) {
        guard !isLoadingMore, currentItem == items.last else { return }
        isLoadingMore = true
        viewModel.loadItems()
    }
}
