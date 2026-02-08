//
//  CoinDetailDTO.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

struct CoinDetailDTO: Decodable {
    let id: String?
    let symbol: String?
    let name: String?
    let description: CoinDescription?
    let marketData: MarketData?
    let image: CoinImage?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, description, image
        case marketData = "market_data"
    }
    
    // Mapping: DTO -> Entity
    func toDomain() -> CoinDetailEntity {
        return CoinDetailEntity(
            name: name ?? "",
            symbol: (symbol ?? "").uppercased(),
            price: marketData?.currentPrice?["usd"] ?? 0.0,
            high24h: marketData?.high24h?["usd"] ?? 0.0,
            low24h: marketData?.low24h?["usd"] ?? 0.0,
            priceChange: marketData?.priceChange24h ?? 0.0,
            description: description?.englishDescription ?? "No description available.",
            imageURL: image?.large,
            sparklineData: marketData?.sparkline7d?.price ?? []
        )
    }
}

struct CoinImage: Decodable {
    let large: String?
    let small: String?
}

struct CoinDescription: Decodable {
    let englishDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case englishDescription = "en"
    }
}

struct MarketData: Decodable {
    let currentPrice: [String: Double]?
    let high24h: [String: Double]?
    let low24h: [String: Double]?
    let priceChange24h: Double?
    let sparkline7d: Sparkline?
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case sparkline7d = "sparkline_7d"
    }
}

struct Sparkline: Decodable {
    let price: [Double]?
}
