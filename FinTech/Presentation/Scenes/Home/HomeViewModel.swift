//
//  HomeViewModel.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation
import Combine

enum HomeViewState {
    case idle
    case loading
    case success
    case error(String)
}

enum SortOption {
    case highestRank
    case priceHighToLow
    case priceLowToHigh
}

protocol HomeViewModelProtocol: AnyObject {
    var coordinatorDelegate: HomeViewModelCoordinatorDelegate? { get set }
    
    var viewState: CurrentValueSubject<HomeViewState, Never> { get }
    
    var assets: [AssetEntity] { get }
    func loadData()
    func didSelectRow(at index: Int)
    func search(query: String)
    func sort(by option: SortOption)
}

protocol HomeViewModelCoordinatorDelegate: AnyObject {
    func didSelectAsset(withId id: String, context: DetailContext)
}

final class HomeViewModel: HomeViewModelProtocol {
    
    weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
    private let useCase: AssetUseCaseProtocol
    
    var viewState = CurrentValueSubject<HomeViewState, Never>(.idle)
    
    private var allAssets: [AssetEntity] = []
    
    private(set) var assets: [AssetEntity] = []
    
    private var currentSortOption: SortOption = .highestRank
    
    init(useCase: AssetUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func didSelectRow(at index: Int) {
        let selectedAsset = assets[index]
        coordinatorDelegate?.didSelectAsset(withId: selectedAsset.id, context: .market)
    }
    
    func loadData() {
        viewState.send(.loading)
        
        Task {
            do {
                let result = try await useCase.execute()
                self.allAssets = result
                self.assets = result
                
                self.viewState.send(.success)
                
            } catch {
                self.viewState.send(.error(error.localizedDescription))
            }
        }
    }
    
    func search(query: String) {
        if query.isEmpty {
            assets = allAssets
        } else {
            assets = allAssets.filter { coin in
                return coin.name.lowercased().contains(query.lowercased()) ||
                       coin.symbol.lowercased().contains(query.lowercased())
            }
        }
        sort(by: currentSortOption)
    }
    
    func sort(by option: SortOption) {
            self.currentSortOption = option
            
            switch option {
            case .highestRank:
                // 🛠 DÜZELTME: 'a' ve 'b' yerine 'first' ve 'second' kullandık.
                assets.sort { (first, second) -> Bool in
                    guard let indexA = allAssets.firstIndex(where: { $0.id == first.id }),
                          let indexB = allAssets.firstIndex(where: { $0.id == second.id }) else { return false }
                    return indexA < indexB
                }
            case .priceHighToLow:
                assets.sort { $0.price > $1.price }
            case .priceLowToHigh:
                assets.sort { $0.price < $1.price }
            }
            
            viewState.send(.success)
        }
}
