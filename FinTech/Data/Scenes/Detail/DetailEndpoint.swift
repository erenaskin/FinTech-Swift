//
//  DetailEndpoint.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation
import Alamofire

enum DetailEndpoint: Endpoint {
    case fetchDetail(id: String)
    
    var path: String {
        switch self {
        case .fetchDetail(let id):
            return "/coins/\(id)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchDetail:
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
    
    var headers: HTTPHeaders? {
        return [
            "Accept": "application/json",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        ]
    }
}
