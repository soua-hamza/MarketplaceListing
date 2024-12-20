//
//  ErrorCoordinator.swift
//  MarketplaceListing
//
//  Created by Hamza on 19/12/2024.
//

import UIKit

protocol ErrorCoordinator {
    func presentError(error: String)
}

class DefaultErrorCoordinator: ErrorCoordinator {
    func presentError(error: String) {
        guard let rootViewController = getRootViewController() else {
            print("Error: Root ViewController not found")
            return
        }
        presentError(from: rootViewController, error: error)
    }

    func presentError(from viewController: UIViewController, error: String) {
        let alert = UIAlertController(
            title: "Error",
            message: error,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else {
            return nil
        }
        return rootViewController
    }
}
