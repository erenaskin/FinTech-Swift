//
//  DetailRepositoryProtocol.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation

protocol DetailRepositoryProtocol {
    func fetchCoinDetail(id: String) async throws -> CoinDetailEntity
}
