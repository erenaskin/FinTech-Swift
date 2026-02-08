//
//  HomeViewModelTests.swift
//  FinTechTests
//
//  Created by Eren AŞKIN on 8.02.2026.
//

import XCTest
import Combine
@testable import FinTech

final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var mockUseCase: MockAssetUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockAssetUseCase()
        viewModel = HomeViewModel(useCase: mockUseCase)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }

    func test_loadData_whenUseCaseReturnsSuccess_shouldUpdateStateToSuccess() {
        let mockEntity = AssetEntity(
            id: "1",
            symbol: "ETH",
            name: "Ethereum",
            price: 2000,
            change24h: 1.2,
            iconURL: "",
            sparklineData: []
        )
        mockUseCase.mockEntities = [mockEntity]
        
        let expectation = XCTestExpectation(description: "State Success Olmalı")
        
        viewModel.viewState
            .dropFirst()
            .sink { state in
                switch state {
                case .success:
                    expectation.fulfill()
                case .error(let message):
                    XCTFail("Hata gelmemeliydi: \(message)")
                case .loading:
                    break
                case .idle:
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadData()
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(viewModel.assets.count, 1)
        XCTAssertEqual(viewModel.assets.first?.name, "Ethereum")
    }

    func test_loadData_whenUseCaseFails_shouldUpdateStateToError() {
        // GIVEN
        mockUseCase.shouldReturnError = true
        
        let expectation = XCTestExpectation(description: "State Error Olmalı")
        
        viewModel.viewState
            .dropFirst()
            .sink { state in
                switch state {
                case .error:
                    expectation.fulfill()
                case .success:
                    XCTFail("Başarılı olmamalıydı")
                case .loading:
                    break
                case .idle:
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadData()
        
        wait(for: [expectation], timeout: 2.0)
    }
}
