//
//  NetworkLogger.swift
//  MarketplaceListing
//
//  Created by Hamza on 18/12/2024.
//

import Alamofire

final class NetworkLogger: EventMonitor {
    func requestDidResume(_ request: Request) {
        guard let method = request.request?.method?.rawValue,
              let url = request.request?.url else { return }
        print("Request Started: \(method) \(url)")
    }

    func requestDidFinish(_ request: Request) {
        guard let method = request.request?.method?.rawValue,
              let url = request.request?.url else { return }
        print("Request Finished: \(method) \(url)")
    }
}
