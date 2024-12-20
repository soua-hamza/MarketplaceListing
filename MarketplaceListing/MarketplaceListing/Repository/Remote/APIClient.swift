//
//  APIClient.swift
//  MarketplaceListing
//
//  Created by Hamza on 17/12/2024.
//

import Alamofire
import Foundation
import RxSwift

// MARK: - APIError

enum APIError: Error {
    case networkError(Error) // Erreur réseau
    case decodingError(Error) // Erreur de décodage
    case unknownError // Erreur inconnue
    case serverError(Int) // Erreur serveur (exemple: 500)

    var localizedDescription: String {
        switch self {
        case let .networkError(error):
            return "Erreur réseau: \(error.localizedDescription)"
        case let .decodingError(error):
            return "Erreur de décodage: \(error.localizedDescription)"
        case .unknownError:
            return "Une erreur inconnue s'est produite."
        case let .serverError(statusCode):
            return "Erreur serveur: code \(statusCode)"
        }
    }
}

// MARK: - APIClient Protocol

protocol APIClientProtocol {
    func fetchItems(fromBeginning: Bool) -> Observable<Result<ItemsResponse, APIError>>
}

// MARK: - APIClient Implementation

class APIClient: APIClientProtocol {
    private let session: Session
    private let urlPath: String
    private var after: String = ""
    init(session: Session = .default, urlPath: String = Constant().url) {
        self.session = session
        self.urlPath = urlPath
    }

    func fetchItems(fromBeginning: Bool = false) -> Observable<Result<ItemsResponse, APIError>> {
        return Observable.create { [weak self] observer in
            if fromBeginning {
                self?.after = ""
            }
            let queryParams: Parameters = [
                "limit": 26,
                "after": self?.after ?? ""
            ]
            guard let urlPath = self?.urlPath, let url = URL(string: urlPath) else {
                observer.onNext(.failure(.decodingError(AFError.parameterEncodingFailed(reason: .missingURL))))
                return Disposables.create()
            }
            guard let encodedURL = try? URLEncoding.default.encode(URLRequest(url: url), with: queryParams) else {
                observer.onNext(.failure(.decodingError(AFError.parameterEncodingFailed(reason: .customEncodingFailed(error: NSError(domain: "Unknown raison", code: -1))))))
                return Disposables.create()
            }

            let parameters: Parameters = [
                "type": ["donation"],
                "distance": "10000",
                "donationState": ["open", "reserved"],
                "latitude": 44.8380691,
                "universe": ["object"],
                "longitude": -0.5777678
            ]

            self?.session.request(encodedURL.url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(of: ItemsResponse.self) { response in
                    switch response.result {
                    case let .success(items):
                        self?.after = items.paging.after
                        observer.onNext(.success(items))
                        observer.onCompleted()
                    case let .failure(error):
                        let statusCode = response.response?.statusCode
                        if let code = statusCode, (400 ..< 600).contains(code) {
                            observer.onNext(.failure(.serverError(code)))
                        } else if let afError = error.asAFError, afError.isResponseSerializationError {
                            observer.onNext(.failure(.decodingError(error)))
                        } else {
                            observer.onNext(.failure(.networkError(error)))
                        }
                        observer.onCompleted()
                    }
                }

            return Disposables.create()
        }
    }
}
