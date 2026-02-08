//
//  AssetRepository.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

final class AssetRepository: AssetRepositoryProtocol {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchAssets(ids: [String]? = nil) async throws -> [AssetEntity] {
        let endpoint = AssetsEndpoint.getCryptoAssets(ids: ids)
        let dtos: [AssetDTO] = try await networkManager.request(endpoint)
        return dtos.map { $0.toDomain() }
    }
}
