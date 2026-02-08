//
//  HomeBuilder.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit

final class HomeBuilder {
    static func make(coordinator: HomeViewModelCoordinatorDelegate?) -> UIViewController {
        let networkManager = NetworkManager.shared
        let repository = AssetRepository(networkManager: networkManager)
        let useCase = AssetUseCase(repository: repository)
        let viewModel = HomeViewModel(useCase: useCase)
        
        viewModel.coordinatorDelegate = coordinator
                
        let viewController = HomeViewController(viewModel: viewModel)
        return viewController
    }
}
