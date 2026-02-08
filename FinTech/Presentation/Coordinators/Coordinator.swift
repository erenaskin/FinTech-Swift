//
//  Coordinator.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

// Opsiyonel olarak child coordinator temizleme metodu ekleyebiliriz
extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        // For-Where kullanımı
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}
