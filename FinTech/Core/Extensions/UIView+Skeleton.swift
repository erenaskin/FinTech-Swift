//
//  UIView+Skeleton.swift
//  FinTech
//
//  Created by Eren AŞKIN on 8.02.2026.
//

import UIKit

extension UIView {
    
    // İskelet animasyonunu başlat
    func startSkeletonAnimation() {
        // Önce temizle ki üst üste binmesin
        stopSkeletonAnimation()
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Gri tonları arasındaki geçiş (Shimmer effect)
        let baseColor = UIColor.systemGray5.cgColor
        let highlightColor = UIColor.systemGray4.cgColor
        gradient.colors = [baseColor, highlightColor, baseColor]
        gradient.locations = [0.0, 0.5, 1.0]
        
        // View'ın boyutuna tam otursun
        gradient.frame = self.bounds
        gradient.cornerRadius = self.layer.cornerRadius
        
        // Animasyon Tanımı
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 0.9 // Hız (saniye)
        animation.repeatCount = .infinity // Sonsuza kadar dön
        
        gradient.add(animation, forKey: "skeletonAnimation")
        
        // Katmanı ekle
        self.layer.addSublayer(gradient)
    }
    
    // Animasyonu durdur
    func stopSkeletonAnimation() {
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
    }
}
