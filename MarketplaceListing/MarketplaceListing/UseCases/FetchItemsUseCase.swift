//
//  FetchItemsUseCase.swift
//  MarketplaceListing
//
//  Created by Hamza on 17/12/2024.
//

import RxSwift

protocol FetchItemsUseCaseProtocol {
    func execute(fromBeginning: Bool) -> Observable<Result<ItemsResponse, APIError>>
}

class FetchItemsUseCase: FetchItemsUseCaseProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func execute(fromBeginning: Bool = false) -> Observable<Result<ItemsResponse, APIError>> {
        return apiClient.fetchItems(fromBeginning: fromBeginning)
    }
}
