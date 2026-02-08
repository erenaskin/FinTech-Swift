//
//  DetailBuilder.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit

final class DetailBuilder {
    static func make(with id: String, context: DetailContext) -> UIViewController {
        let networkManager = NetworkManager.shared
        
        let detailRepository = DetailRepository(networkManager: networkManager)
        let portfolioRepository = PortfolioRepository()
        
        let useCase = DetailUseCase(repository: detailRepository, portfolioRepository: portfolioRepository)
        
        let viewModel = DetailViewModel(useCase: useCase, coinId: id, context: context)
                
        let viewController = DetailViewController(viewModel: viewModel)
        return viewController
    }
}
