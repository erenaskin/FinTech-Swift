//
//  Endpoint.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation
import Alamofire

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
}

extension Endpoint {
    var baseURL: String {
        return "https://api.coingecko.com/api/v3"
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
}
