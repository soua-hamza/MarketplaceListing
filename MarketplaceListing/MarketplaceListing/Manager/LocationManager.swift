//
//  LocationManager.swift
//  MarketplaceListing
//
//  Created by Hamza on 19/12/2024.
//

import CoreLocation
import RxSwift

protocol LocationManagerProtocol {
    var location: PublishSubject<CLLocation> { get }
    var authorizationStatus: PublishSubject<CLAuthorizationStatus> { get }

    func requestLocation()
    func requestWhenInUseAuthorization()
}

class LocationManager: NSObject, LocationManagerProtocol, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    private let disposeBag = DisposeBag()

    // Outputs
    var location = PublishSubject<CLLocation>()
    var authorizationStatus = PublishSubject<CLAuthorizationStatus>()

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    // CLLocationManagerDelegate
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location.onNext(location)
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        location.onError(error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        authorizationStatus.onNext(status)
    }
}
