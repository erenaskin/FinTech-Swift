//
//  AssetUseCaseTests.swift
//  FinTechTests
//
//  Created by Eren AŞKIN on 8.02.2026.
//

import XCTest
@testable import FinTech

@MainActor
final class AssetUseCaseTests: XCTestCase {

    var useCase: AssetUseCase!
    var mockRepository: MockAssetRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockAssetRepository()
        useCase = AssetUseCase(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_execute_whenRepositoryReturnsSuccess_shouldReturnEntities() async throws {
        // GIVEN
        // 👇 ARTIK DTO DEĞİL, DOĞRUDAN ENTITY OLUŞTURUYORUZ
        // Çünkü Repository artık mapping işlemini kendi içinde hallediyor.
        let mockEntity = AssetEntity(
            id: "bitcoin",
            symbol: "btc",
            name: "Bitcoin",
            price: 50000.0,
            change24h: 5.0,
            iconURL: "http://btc.png",
            sparklineData: []
        )
        
        // Mock Repository'ye Entity veriyoruz
        mockRepository.mockEntities = [mockEntity]

        // WHEN
        let result = try await useCase.execute()

        // THEN
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Bitcoin")
        XCTAssertEqual(result.first?.price, 50000.0)
    }
    
    func test_execute_whenRepositoryFails_shouldThrowError() async {
        // GIVEN
        mockRepository.shouldReturnError = true
        
        // WHEN & THEN
        do {
            _ = try await useCase.execute()
            XCTFail("Hata fırlatmalıydı ama başarılı oldu.")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
