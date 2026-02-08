//
//  CoreDataManager.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    // Singleton: Tüm uygulama tek bir veritabanı kuyruğunu kullansın
    static let shared = CoreDataManager()
    
    private init() {}
    
    // Veritabanı Konteyneri (SQL dosyasını tutan yapı)
    // DİKKAT: name parametresi .xcdatamodeld dosyanın ismiyle ("FinTech") AYNI olmalı!
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FinTech")
        container.loadPersistentStores { _, error in // unused parameter 'storeDescription' replaced with '_'
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Çalışma Alanı (Context): Değişiklikleri yaptığımız geçici alan
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Kaydetme Fonksiyonu
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("CoreData Save Error: \(nserror.localizedDescription)")
            }
        }
    }
}
