//
//  DetailUseCaseProtocol.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

protocol DetailUseCaseProtocol {
    func execute(id: String) async throws -> CoinDetailEntity
    func buyAsset(id: String, symbol: String, amount: Double)
    func sellAsset(id: String, amount: Double) throws
    func getCurrentHoldings(id: String) -> Double
}

final class DetailUseCase: DetailUseCaseProtocol {
    private let repository: DetailRepositoryProtocol
    private let portfolioRepository: PortfolioRepositoryProtocol
    
    init(repository: DetailRepositoryProtocol, portfolioRepository: PortfolioRepositoryProtocol) {
        self.repository = repository
        self.portfolioRepository = portfolioRepository
    }
    
    func execute(id: String) async throws -> CoinDetailEntity {
        return try await repository.fetchCoinDetail(id: id)
    }
    
    func buyAsset(id: String, symbol: String, amount: Double) {
            portfolioRepository.addAsset(id: id, symbol: symbol, amount: amount)
    }
    func sellAsset(id: String, amount: Double) throws {
            try portfolioRepository.sellAsset(id: id, amount: amount)
    }
    func getCurrentHoldings(id: String) -> Double {
            do {
                let items = try portfolioRepository.fetchPortfolio()
                if let item = items.first(where: { $0.id == id }) {
                    return item.amount
                }
            } catch {
                print("Holding fetch error: \(error)")
            }
            return 0.0
        }
}
