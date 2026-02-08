//
//  DetailRepository.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

final class DetailRepository: DetailRepositoryProtocol {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchCoinDetail(id: String) async throws -> CoinDetailEntity {
        let endpoint = DetailEndpoint.fetchDetail(id: id)
        let dto: CoinDetailDTO = try await networkManager.request(endpoint)
        return dto.toDomain()
    }
}
