//
//  MockAPIClient.swift
//  MarketplaceListing
//
//  Created by Hamza on 17/12/2024.
//

@testable import MarketplaceListing
import RxSwift

class MockAPIClient: APIClientProtocol {
    var result: Result<ItemsResponse, APIError>?

    func fetchItems(fromBeginning _: Bool) -> Observable<Result<ItemsResponse, APIError>> {
        guard let result = result else {
            return Observable.error(APIError.unknownError)
        }
        return Observable.just(result)
    }
}
