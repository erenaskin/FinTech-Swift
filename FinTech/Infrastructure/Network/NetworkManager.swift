//
//  NetworkManager.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Alamofire
import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let url = endpoint.baseURL + endpoint.path
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: URLEncoding.default,
                headers: endpoint.headers
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        // CoinGecko bazen snake_case döner, bunu yönetmek için:
                        // decoder.keyDecodingStrategy = .convertFromSnakeCase                        
                        let result = try decoder.decode(T.self, from: data)
                        continuation.resume(returning: result)
                    } catch {
                        print("\n❌ DECODING ERROR: \(error)")
                        
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("📦 GELEN JSON: \(jsonString)\n")
                        }
                        
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("\n❌ NETWORK ERROR: \(error)\n")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
