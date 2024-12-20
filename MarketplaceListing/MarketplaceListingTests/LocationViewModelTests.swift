//
//  LocationViewModelTests.swift
//  MarketplaceListing
//
//  Created by Hamza on 19/12/2024.
//

import CoreLocation
import RxSwift
import RxTest
import XCTest

@testable import MarketplaceListing

class LocationViewModelTests: XCTestCase {
    var viewModel: LocationViewModel!
    var mockLocationManager: MockLocationManager!
    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockLocationManager = MockLocationManager()
        viewModel = LocationViewModel(locationManager: mockLocationManager, defaultErrorCoordinator: DefaultErrorCoordinator())
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    func testRequestLocation() {
        // Given
        let locationObserver = testScheduler.createObserver(CLLocation?.self)
        viewModel.currentLocation
            .subscribe(locationObserver)
            .disposed(by: disposeBag)

        // When
        testScheduler.scheduleAt(10) {
            self.viewModel.requestLocation()
        }
        testScheduler.start()

        // Then
        let expectedLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        guard let recordedEvent = locationObserver.events.first?.value.element else {
            XCTFail("No event recorded")
            return
        }
        XCTAssertEqual(expectedLocation.coordinate.latitude, recordedEvent!.coordinate.latitude)
        XCTAssertEqual(expectedLocation.coordinate.longitude, recordedEvent!.coordinate.longitude)
    }

    func testAuthorizationStatus() {
        // Given
        let statusObserver = testScheduler.createObserver(CLAuthorizationStatus.self)
        viewModel.authorizationStatus
            .subscribe(statusObserver)
            .disposed(by: disposeBag)

        // When
        testScheduler.scheduleAt(10) {
            self.viewModel.requestWhenInUseAuthorization()
        }
        testScheduler.start()

        // Then
        XCTAssertEqual(statusObserver.events, [
            .next(10, .authorizedWhenInUse)
        ])
    }
}
