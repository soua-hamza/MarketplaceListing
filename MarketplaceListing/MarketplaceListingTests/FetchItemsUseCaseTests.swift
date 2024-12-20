//
//  FetchItemsUseCaseTests.swift
//  MarketplaceListing
//
//  Created by Hamza on 17/12/2024.
//

@testable import MarketplaceListing
import RxSwift
import XCTest

class FetchItemsUseCaseTests: XCTestCase {
    var mockAPIClient: MockAPIClient!
    var fetchItemsUseCase: FetchItemsUseCase!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        fetchItemsUseCase = FetchItemsUseCase(apiClient: mockAPIClient)
        disposeBag = DisposeBag()
    }

    func testFetchItemsSuccess() {
        // When
        let data = [Item(id: "id1", title: "Post 1", description: "description", location: Location(city: "Paris", country: "France", department: "Paris", latitude: 44.83823600264997, longitude: -0.6492326369416734, obfuscated: false), pictures: [])]
        let paging = Paging(after: "67630ece04a9fc67ded78d8a", before: "67631adce4b57b2511fcb2cf", pageLength: 26)
        let mockItems = ItemsResponse(paging: paging, data: data)

        mockAPIClient.result = .success(mockItems)

        // Given & Then
        fetchItemsUseCase.execute()
            .subscribe(onNext: { result in
                switch result {
                case let .success(result):
                    XCTAssertEqual(result.data.count, 1)
                    XCTAssertEqual(result.data.first?.title, "Post 1")
                case .failure:
                    XCTFail("Expected success but got failure")
                }
            })
            .disposed(by: disposeBag)
    }

    func testFetchItemsFailure() {
        // When
        let networkError = APIError.networkError(NSError(domain: "Test", code: -1, userInfo: nil))

        mockAPIClient.result = .failure(networkError)

        // Given & Then
        fetchItemsUseCase.execute()
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case let .failure(error):
                    XCTAssertEqual(error.localizedDescription, networkError.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
}
