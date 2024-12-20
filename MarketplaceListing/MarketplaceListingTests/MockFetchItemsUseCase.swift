//
//  MockFetchItemsUseCase.swift
//  MarketplaceListing
//
//  Created by Hamza on 17/12/2024.
//

@testable import MarketplaceListing
import RxSwift

class MockFetchItemsUseCase: FetchItemsUseCaseProtocol {
    var result: Observable<Result<ItemsResponse, APIError>> = .empty()

    func execute(fromBeginning _: Bool) -> Observable<Result<ItemsResponse, APIError>> {
        return result
    }
}
