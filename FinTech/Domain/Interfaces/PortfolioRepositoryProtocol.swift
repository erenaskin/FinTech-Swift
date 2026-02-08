//
//  PortfolioRepositoryProtocol.swift
//  FinTech
//
//  Created by Eren AŞKIN on 8.02.2026.
//

import Foundation

protocol PortfolioRepositoryProtocol {
    func fetchPortfolio() throws -> [PortfolioItem]
    func addAsset(id: String, symbol: String, amount: Double)
    func removeAsset(id: String)
    func sellAsset(id: String, amount: Double) throws
}
