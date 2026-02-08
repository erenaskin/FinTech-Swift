//
//  AssetVisualStrategy.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit

// Tüm stratejilerin uyması gereken kural seti
protocol AssetVisualStrategy {
    var color: UIColor { get }
    var arrowIcon: String { get } // SF Symbol ismi
    func format(value: Double) -> String
}
