//
//  MockLocationManager.swift
//  MarketplaceListing
//
//  Created by Hamza on 19/12/2024.
//

import CoreLocation
import RxSwift

@testable import MarketplaceListing

class MockLocationManager: LocationManagerProtocol {
    var location = PublishSubject<CLLocation>()
    var authorizationStatus = PublishSubject<CLAuthorizationStatus>()

    func requestLocation() {
        // Simulate a location update
        location.onNext(CLLocation(latitude: 37.7749, longitude: -122.4194)) // San Francisco
    }

    func requestWhenInUseAuthorization() {
        // Simulate a status update
        authorizationStatus.onNext(.authorizedWhenInUse)
    }
}
