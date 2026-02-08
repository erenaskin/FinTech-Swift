//
//  AssetStatusStrategy.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit

// 📈 Boğa Piyasası (Yükseliş)
struct BullishStrategy: AssetVisualStrategy {
    var color: UIColor { return .systemGreen }
    var arrowIcon: String { return "arrowtriangle.up.fill" }
    
    func format(value: Double) -> String {
        return String(format: "+%.2f%%", value)
    }
}

// 📉 Ayı Piyasası (Düşüş)
struct BearishStrategy: AssetVisualStrategy {
    var color: UIColor { return .systemRed }
    var arrowIcon: String { return "arrowtriangle.down.fill" }
    
    func format(value: Double) -> String {
        return String(format: "%.2f%%", value)
    }
}

// 😐 Nötr Piyasa (Değişim Yok)
struct NeutralStrategy: AssetVisualStrategy {
    var color: UIColor { return .systemGray }
    var arrowIcon: String { return "minus" }
    
    func format(value: Double) -> String {
        return String(format: "%.2f%%", value)
    }
}
