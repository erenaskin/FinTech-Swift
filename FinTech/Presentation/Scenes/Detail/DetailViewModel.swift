//
//  DetailViewModel.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation
import Combine

enum DetailViewState {
    case idle
    case loading
    case success
    case error(String)
}

enum DetailContext {
    case market
    case portfolio
}

enum DetailViewMessage {
    case success(String)
    case error(String)
}

protocol DetailViewModelProtocol: AnyObject {

    var viewState: CurrentValueSubject<DetailViewState, Never> { get }
    
    var viewMessage: PassthroughSubject<DetailViewMessage, Never> { get }
    
    var coinDetail: CoinDetailEntity? { get }
    var currentHoldings: Double { get }
    var context: DetailContext { get }
    
    func loadData()
    func buyCoin(amount: Double)
    func sellCoin(amount: Double)
}

final class DetailViewModel: DetailViewModelProtocol {
    
    private let useCase: DetailUseCaseProtocol
    private let coinId: String
    let context: DetailContext
    
    var viewState = CurrentValueSubject<DetailViewState, Never>(.idle)
    var viewMessage = PassthroughSubject<DetailViewMessage, Never>()
    
    private(set) var coinDetail: CoinDetailEntity?
    
    var currentHoldings: Double {
        return useCase.getCurrentHoldings(id: coinId)
    }
    
    init(useCase: DetailUseCaseProtocol, coinId: String, context: DetailContext) {
        self.useCase = useCase
        self.coinId = coinId
        self.context = context
    }
    
    func buyCoin(amount: Double) {
        guard let coin = coinDetail else { return }
        
        useCase.buyAsset(id: coinId, symbol: coin.symbol, amount: amount)
        
        viewMessage.send(.success("Successfully bought \(amount) \(coin.symbol)"))
        
        viewState.send(.success)
        
        print("✅ \(amount) adet \(coin.symbol) portföye eklendi!")
    }
    
    func sellCoin(amount: Double) {
        guard let coin = coinDetail else { return }
        do {
            try useCase.sellAsset(id: coinId, amount: amount)
            
            viewMessage.send(.success("Successfully sold \(amount) \(coin.symbol)"))
            
            viewState.send(.success)
        } catch {
            viewMessage.send(.error(error.localizedDescription))
        }
    }
    
    func loadData() {
        viewState.send(.loading)
        
        Task {
            do {
                let detail = try await useCase.execute(id: coinId)
                self.coinDetail = detail
                
                self.viewState.send(.success)
                
            } catch {
                self.viewState.send(.error(error.localizedDescription))
            }
        }
    }
}
