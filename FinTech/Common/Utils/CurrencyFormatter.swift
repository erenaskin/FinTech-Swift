//
//  CurrencyFormatter.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

final class CurrencyFormatter {
    static func format(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        // Kripto paralar çok küçük olabilir (0.00004 gibi)
        if value < 0.01 {
            formatter.maximumFractionDigits = 6
        }
        
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
