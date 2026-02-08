//
//  AssetEntity.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

// Uygulamanın içinde kullanacağımız saf model.
// UI sadece bunu bilecek.
struct AssetEntity {
    let id: String
    let symbol: String
    let name: String
    let price: Double
    let change24h: Double 
    let iconURL: String
    let sparklineData: [Double]
}
