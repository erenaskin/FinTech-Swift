//
//  AssetStrategyFactory.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

final class AssetStrategyFactory {
    
    // Değişim yüzdesine bakarak doğru stratejiyi üretir
    static func make(for change: Double) -> AssetVisualStrategy {
        if change > 0 {
            return BullishStrategy()
        } else if change < 0 {
            return BearishStrategy()
        } else {
            return NeutralStrategy()
        }
    }
}
