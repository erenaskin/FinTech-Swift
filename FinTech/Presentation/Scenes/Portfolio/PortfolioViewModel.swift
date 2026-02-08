//
//  PortfolioViewModel.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation
import Combine

enum PortfolioViewState {
    case idle
    case loading
    case success
    case empty
    case error(String)
}

final class PortfolioViewModel {
    
    private let useCase: PortfolioUseCaseProtocol
    weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
    
    var viewState = CurrentValueSubject<PortfolioViewState, Never>(.idle)
    var isRefreshing = CurrentValueSubject<Bool, Never>(false)
    
    private(set) var assets: [PortfolioDisplayEntity] = []
    
    private var lastFetchDate: Date?
    
    var totalBalance: Double {
        return assets.reduce(0) { $0 + $1.totalValue }
    }
    
    init(useCase: PortfolioUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func didSelectAsset(id: String) {
        coordinatorDelegate?.didSelectAsset(withId: id, context: .portfolio)
    }
    
    func loadPortfolio(force: Bool = false) {
        // Önbellek kontrolü (Cache)
        if !force, let lastDate = lastFetchDate, Date().timeIntervalSince(lastDate) < 60 {
            print("⏳ Önbellek kullanılıyor")
            if !assets.isEmpty {
                self.viewState.send(.success)
            }
            return
        }
        
        if !force {
            viewState.send(.loading)
        }
        
        Task {
            do {
                if force { try await Task.sleep(nanoseconds: 500_000_000) }
                
                let items = try await useCase.execute()
                self.assets = items
                self.lastFetchDate = Date()
                
                if items.isEmpty {
                    self.viewState.send(.empty)
                } else {
                    self.viewState.send(.success)
                }
                
                self.isRefreshing.send(false)
                
            } catch {
                print("⚠️ Hata: \(error.localizedDescription)")
                
                if !self.assets.isEmpty {
                    self.viewState.send(.success)
                } else {
                    self.viewState.send(.error("Veri güncellenemedi."))
                }
                
                self.isRefreshing.send(false)
            }
        }
    }
}
