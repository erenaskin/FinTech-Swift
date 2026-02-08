//
//  PortfolioUseCaseProtocol.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

protocol PortfolioUseCaseProtocol {
    func execute() async throws -> [PortfolioDisplayEntity]
}

final class PortfolioUseCase: PortfolioUseCaseProtocol {
    private let localRepository: PortfolioRepositoryProtocol
    private let remoteRepository: AssetRepositoryProtocol
    
    init(localRepository: PortfolioRepositoryProtocol, remoteRepository: AssetRepositoryProtocol) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
    }
    
    func execute() async throws -> [PortfolioDisplayEntity] {
        // 1. Core Data'dan cüzdanı çek (Örn: {id: "bitcoin", amount: 1.5})
        let portfolioItems = try localRepository.fetchPortfolio()
        
        guard !portfolioItems.isEmpty else { return [] }
        
        // 2. Elimizdeki coinlerin ID'lerini topla (örn: ["bitcoin", "ethereum"])
        let ids = portfolioItems.map { $0.id }
        
        // 3. Sadece bu coinlerin güncel fiyatlarını API'den çek
        // (Senin güncellediğin fetchAssets(ids:) metodu burada çalışıyor)
        let remoteAssets = try await remoteRepository.fetchAssets(ids: ids)
        
        // 4. Verileri Birleştir
        var displayItems: [PortfolioDisplayEntity] = []
        
        for item in portfolioItems {
            // API'den gelen listede bu coini bul
            if let remoteAsset = remoteAssets.first(where: { $0.id == item.id }) {
                let displayItem = PortfolioDisplayEntity(
                    id: item.id,
                    symbol: item.symbol,
                    name: remoteAsset.name,
                    image: remoteAsset.iconURL,
                    amount: item.amount,
                    currentPrice: remoteAsset.price,
                    priceChange24h: remoteAsset.change24h
                )
                displayItems.append(displayItem)
            }
        }
        
        return displayItems
    }
}
