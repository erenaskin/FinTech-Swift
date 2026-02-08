//
//  CoinDetailEntity.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

struct CoinDetailEntity {
    let name: String
    let symbol: String
    let price: Double
    let high24h: Double
    let low24h: Double
    let priceChange: Double
    let description: String
    let imageURL: String?
    let sparklineData: [Double]
}
