//
//  ItemsViewModelTests.swift
//  MarketplaceListing
//
//  Created by Hamza on 17/12/2024.
//

@testable import MarketplaceListing
import RxSwift
import RxTest
import XCTest

class ItemsViewModelTests: XCTestCase {
    var viewModel: ItemsViewModel!
    var mockUseCase: MockFetchItemsUseCase!
    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchItemsUseCase()
        viewModel = ItemsViewModel(fetchItemsUseCase: mockUseCase, defaultErrorCoordinator: DefaultErrorCoordinator())
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    func testLoadItemsSuccess() {
        // When
        let data = [Item(id: "id1", title: "Post 1", description: "description", location: Location(city: "Paris", country: "France", department: "Paris", latitude: 44.83823600264997, longitude: -0.6492326369416734, obfuscated: false), pictures: [])]
        let paging = Paging(after: "67630ece04a9fc67ded78d8a", before: "67631adce4b57b2511fcb2cf", pageLength: 26)
        let mockItems = ItemsResponse(paging: paging, data: data)
        mockUseCase.result = .just(.success(mockItems))

        let itemsObserver = testScheduler.createObserver(ItemsResponse.self)
        let errorObserver = testScheduler.createObserver(String.self)

        viewModel.items
            .subscribe(itemsObserver)
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .subscribe(errorObserver)
            .disposed(by: disposeBag)

        // Given
        testScheduler.scheduleAt(10) {
            self.viewModel.loadItems()
        }
        testScheduler.start()

        // Then
        XCTAssertEqual(itemsObserver.events, [
            .next(10, mockItems)
        ])
        XCTAssertTrue(errorObserver.events.isEmpty)
    }

    func testLoadItemsFailure() {
        // When
        let networkError = APIError.networkError(NSError(domain: "Test", code: -1, userInfo: nil))
        mockUseCase.result = .just(.failure(networkError))

        let itemsObserver = testScheduler.createObserver(ItemsResponse.self)
        let errorObserver = testScheduler.createObserver(String.self)

        viewModel.items
            .subscribe(itemsObserver)
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .subscribe(errorObserver)
            .disposed(by: disposeBag)

        // Given
        testScheduler.scheduleAt(10) {
            self.viewModel.loadItems()
        }
        testScheduler.start()

        // Then
        XCTAssertTrue(itemsObserver.events.isEmpty)
        XCTAssertEqual(errorObserver.events, [
            .next(10, networkError.localizedDescription)
        ])
    }
}
