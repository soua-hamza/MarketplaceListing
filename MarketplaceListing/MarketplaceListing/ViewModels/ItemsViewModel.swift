//
//  ItemsViewModel.swift
//  MarketplaceListing
//
//  Created by Hamza on 17/12/2024.
//

import RxSwift

protocol ViewModelErrorPresentation {
    var defaultErrorCoordinator: ErrorCoordinator { get }

    func handleError(error: String)
}

protocol ViewModelProtocol: ViewModelErrorPresentation {}

class ViewModel: ViewModelProtocol {
    var defaultErrorCoordinator: ErrorCoordinator

    init(defaultErrorCoordinator: ErrorCoordinator) {
        self.defaultErrorCoordinator = defaultErrorCoordinator
    }

    func handleError(error: String) {
        defaultErrorCoordinator.presentError(error: error)
    }
}

class ItemsViewModel: ViewModel {
    private let fetchItemsUseCase: FetchItemsUseCaseProtocol
    private let disposeBag = DisposeBag()

    // Outputs
    let items = PublishSubject<ItemsResponse>()
    let errorMessage = PublishSubject<String>()

    init(fetchItemsUseCase: FetchItemsUseCaseProtocol, defaultErrorCoordinator: ErrorCoordinator) {
        self.fetchItemsUseCase = fetchItemsUseCase
        super.init(defaultErrorCoordinator: defaultErrorCoordinator)
    }

    func loadItems(fromBeginning: Bool = false) {
        fetchItemsUseCase.execute(fromBeginning: fromBeginning)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .success(items):
                    self?.items.onNext(items)
                case let .failure(error):
                    self?.errorMessage.onNext(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
}
