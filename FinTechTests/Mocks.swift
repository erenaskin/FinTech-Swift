//
//  Mocks.swift
//  FinTech
//
//  Created by Eren AŞKIN on 8.02.2026.
//

//
//  Mocks.swift
//  FinTech
//
//  Created by Eren AŞKIN on 8.02.2026.
//

import Foundation
import XCTest
@testable import FinTech

// 1. Mock Repository
class MockAssetRepository: AssetRepositoryProtocol {
    
    var shouldReturnError = false
    var mockEntities: [AssetEntity] = []
    
    func fetchAssets(ids: [String]? = nil) async throws -> [AssetEntity] {
        if shouldReturnError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return mockEntities
    }
}

// 2. Mock UseCase
class MockAssetUseCase: AssetUseCaseProtocol {
    
    var shouldReturnError = false
    var mockEntities: [AssetEntity] = []
    
    func execute() async throws -> [AssetEntity] {
        if shouldReturnError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return mockEntities
    }
}
