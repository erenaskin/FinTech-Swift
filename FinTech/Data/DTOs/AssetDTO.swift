//
//  AssetDTO.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

// API'den gelen JSON'ın birebir karşılığı (Codable)
struct AssetDTO: Decodable {
    let id: String?
    let symbol: String?
    let name: String?
    let currentPrice: Double?
    let priceChangePercentage24H: Double?
    let image: String?
    
    // 👇 Sparkline verisi (Grafik için). Portfolio'da null gelebilir, o yüzden Optional.
    let sparklineIn7d: SparklineIn7d?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case sparklineIn7d = "sparkline_in_7d"
    }
    
    // Grafik verisi alt objesi
    struct SparklineIn7d: Decodable {
        let price: [Double]?
    }
}

// DTO -> Entity Dönüştürücü (Mapper)
extension AssetDTO {
    func toDomain() -> AssetEntity {
        print("🔍 MAPPING: ID: \(id ?? "nil") - Symbol: \(symbol ?? "nil") - Price: \(currentPrice ?? -1)")
        return AssetEntity(
            id: id ?? UUID().uuidString,
            symbol: (symbol ?? "").uppercased(),
            name: name ?? "",
            price: currentPrice ?? 0.0,
            change24h: priceChangePercentage24H ?? 0.0,
            iconURL: image ?? "",
            sparklineData: sparklineIn7d?.price ?? []
        )
    }
}
