//
//  AssetsEndpoint.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation
import Alamofire 

enum AssetsEndpoint: Endpoint {
    case getCryptoAssets(ids: [String]?)
    case getCryptoDetail(id: String)
    
    var path: String {
        switch self {
        case .getCryptoAssets:
            return "/coins/markets"
        case .getCryptoDetail(let id):
            return "/coins/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCryptoAssets, .getCryptoDetail:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getCryptoAssets(let ids):
            var params: [String: Any] = [
                "vs_currency": "usd",
                "order": "market_cap_desc",
                "per_page": 20,
                "page": 1,
                "sparkline": true,
                "price_change_percentage": "24h"
            ]
            // Eğer özel ID'ler istenmişse (Portfolio için) ekle
            if let ids = ids {
                params["ids"] = ids.joined(separator: ",")
            }
            return params
            
        case .getCryptoDetail:
            return [
                "localization": "false",
                "tickers": "false",
                "market_data": "true",
                "community_data": "false",
                "developer_data": "false",
                "sparkline": "true"
            ]
        }
    }
}
