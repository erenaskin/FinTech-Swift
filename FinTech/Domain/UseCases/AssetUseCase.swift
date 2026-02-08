//
//  AssetUseCaseProtocol.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

protocol AssetUseCaseProtocol {
    func execute() async throws -> [AssetEntity]
}

final class AssetUseCase: AssetUseCaseProtocol {
    private let repository: AssetRepositoryProtocol
    
    init(repository: AssetRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [AssetEntity] {
        // İleride burada "Sadece Bitcoin'i getir" veya "Fiyata göre sırala" gibi
        // iş mantıkları (Business Logic) dönecek.
        // Şimdilik sadece veriyi olduğu gibi iletiyoruz.
        return try await repository.fetchAssets(ids: nil)
    }
}
