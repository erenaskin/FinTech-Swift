//
//  PortfolioDisplayEntity.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

struct PortfolioDisplayEntity {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let amount: Double
    let currentPrice: Double
    let priceChange24h: Double
    
    var totalValue: Double {
        return amount * currentPrice
    }
}
