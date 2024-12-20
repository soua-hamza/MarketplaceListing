//
//  LocationViewModel.swift
//  MarketplaceListing
//
//  Created by Hamza on 19/12/2024.
//

import CoreLocation
import RxSwift

class LocationViewModel: ViewModel {
    private let locationManager: LocationManagerProtocol
    private let disposeBag = DisposeBag()

    // Outputs
    let currentLocation = PublishSubject<CLLocation?>()
    let authorizationStatus = PublishSubject<CLAuthorizationStatus>()
    let errorMessage = PublishSubject<String>()

    init(locationManager: LocationManagerProtocol, defaultErrorCoordinator: ErrorCoordinator) {
        self.locationManager = locationManager
        super.init(defaultErrorCoordinator: defaultErrorCoordinator)

        // Observe location updates
        locationManager.location
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] location in
                self?.currentLocation.onNext(location)
            }, onError: { [weak self] error in
                self?.errorMessage.onNext("Failed to get location: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)

        // Observe authorization status
        locationManager.authorizationStatus
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                self?.authorizationStatus.onNext(status)
            })
            .disposed(by: disposeBag)
    }

    func requestLocation() {
        requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}
