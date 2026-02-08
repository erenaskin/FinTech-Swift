//
//  PortfolioRepository.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import Foundation
import CoreData

final class PortfolioRepository: PortfolioRepositoryProtocol {
    
    private let context = CoreDataManager.shared.context
    
    // 1. Verileri Çekme (Fetch)
    func fetchPortfolio() throws -> [PortfolioItem] {
        let fetchRequest: NSFetchRequest<PortfolioEntity> = PortfolioEntity.fetchRequest()
        
        let results = try context.fetch(fetchRequest)
        
        return results.map { entity in
            PortfolioItem(
                id: entity.id ?? "",
                symbol: entity.symbol ?? "",
                amount: entity.amount
            )
        }
    }
    
    // 2. Ekleme veya Güncelleme (Upsert)
    func addAsset(id: String, symbol: String, amount: Double) {
        let fetchRequest: NSFetchRequest<PortfolioEntity> = PortfolioEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let existingEntity = results.first {
                // Zaten varsa üzerine ekle
                existingEntity.amount += amount
            } else {
                // Yoksa yeni oluştur
                let newEntity = PortfolioEntity(context: context)
                newEntity.id = id
                newEntity.symbol = symbol
                newEntity.amount = amount
            }
            
            CoreDataManager.shared.saveContext()
            
        } catch {
            print("Ekleme hatası: \(error)")
        }
    }
    
    // 3. Silme
    func removeAsset(id: String) {
        let fetchRequest: NSFetchRequest<PortfolioEntity> = PortfolioEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                CoreDataManager.shared.saveContext()
            }
        } catch {
            print("Silme hatası: \(error)")
        }
    }
    
    // 4. Satma
    func sellAsset(id: String, amount: Double) throws {
        let fetchRequest: NSFetchRequest<PortfolioEntity> = PortfolioEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let results = try context.fetch(fetchRequest)
        
        guard let existingEntity = results.first else {
            // Hiç yoksa satamaz
            throw NSError(domain: "PortfolioError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Portföyde bu coin bulunamadı."])
        }
        
        if existingEntity.amount < amount {
            // Yetersiz bakiye
            throw NSError(domain: "PortfolioError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Yetersiz bakiye. Mevcut: \(existingEntity.amount)"])
        }
        
        existingEntity.amount -= amount
        
        // Eğer miktar 0 veya altına düştüyse tamamen sil
        if existingEntity.amount <= 0.000001 {
            context.delete(existingEntity)
        }
        
        CoreDataManager.shared.saveContext()
    }
}
