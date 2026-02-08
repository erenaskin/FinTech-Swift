//
//  AppCoordinator.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // Tab Bar Controller Oluştur
        let tabBarController = UITabBarController()
        
        // 1. HOME TAB (Market Ekranı)
        // HomeBuilder'da 'coordinator: self' parametresini kullanıyoruz
        let homeVC = HomeBuilder.make(coordinator: self)
        
        // HomeVC'yi kendi Navigasyon Controller'ına saralım ki başlığı olsun
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Market", image: UIImage(systemName: "chart.bar"), tag: 0)
        
        // 2. PORTFOLIO TAB (Cüzdan Ekranı)
        let portfolioVC = PortfolioBuilder.make(coordinator: self) // Bu zaten NavController dönüyor
        portfolioVC.tabBarItem = UITabBarItem(title: "Portfolio", image: UIImage(systemName: "briefcase"), tag: 1)
        
        // Tabları ekle
        tabBarController.viewControllers = [homeNav, portfolioVC]
        tabBarController.tabBar.tintColor = .systemBlue
        
        // Ana navigasyonu (SceneDelegate'ten gelen) gizle ve Tab Bar'ı göster
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}

// Delegate: Home ekranından Detay'a geçişi yönetir
extension AppCoordinator: HomeViewModelCoordinatorDelegate {
    func didSelectAsset(withId id: String, context: DetailContext) {
        if let tabBarController = navigationController.viewControllers.first as? UITabBarController,
           let selectedNav = tabBarController.selectedViewController as? UINavigationController {
            
            let detailVC = DetailBuilder.make(with: id, context: context)
            selectedNav.pushViewController(detailVC, animated: true)
        }
    }
}
