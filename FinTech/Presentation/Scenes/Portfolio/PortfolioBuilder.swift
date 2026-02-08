//
//  PortfolioBuilder.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit

final class PortfolioBuilder {
    static func make(coordinator: HomeViewModelCoordinatorDelegate?) -> UIViewController {
        let networkManager = NetworkManager.shared
        
        let localRepo = PortfolioRepository()
        let remoteRepo = AssetRepository(networkManager: networkManager)
        
        let useCase = PortfolioUseCase(localRepository: localRepo, remoteRepository: remoteRepo)
        let viewModel = PortfolioViewModel(useCase: useCase)
        
        viewModel.coordinatorDelegate = coordinator
        
        // 'vc' -> 'viewController'
        let viewController = PortfolioViewController(viewModel: viewModel)
        return UINavigationController(rootViewController: viewController)
    }
}
