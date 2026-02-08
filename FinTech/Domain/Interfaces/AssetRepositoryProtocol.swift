//
//  AssetRepositoryProtocol.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

protocol AssetRepositoryProtocol {
    func fetchAssets(ids: [String]?) async throws -> [AssetEntity]
}
