//
//  SparklineView.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit

// Controller ile iletişim kuracak protokol
protocol SparklineViewDelegate: AnyObject {
    func didTouchChart(index: Int, price: Double)
    func didEndTouchingChart()
}

final class SparklineView: UIView {
    
    weak var delegate: SparklineViewDelegate?
    
    private let mainPath = UIBezierPath()
    private let shapeLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    // Dokunma anında çıkan dikey çizgi
    private let cursorLineLayer = CAShapeLayer()
    // Dokunma anında çıkan nokta
    private let cursorDotLayer = CAShapeLayer()
    
    // Titreşim motoru
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    private var dataPoints: [Double] = []
    
    var graphColor: UIColor = .systemBlue {
        didSet {
            shapeLayer.strokeColor = graphColor.cgColor
            updateGradientColors()
            cursorDotLayer.fillColor = graphColor.cgColor
            cursorLineLayer.strokeColor = graphColor.withAlphaComponent(0.5).cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        setupGestures()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupLayers() {
        // 1. Gradient Layer (En altta)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.addSublayer(gradientLayer)
        
        // 2. Çizgi Layer
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        layer.addSublayer(shapeLayer)
        
        // 3. Cursor (Başlangıçta gizli)
        cursorLineLayer.lineWidth = 1
        cursorLineLayer.lineDashPattern = [4, 4] // Kesikli çizgi
        cursorLineLayer.isHidden = true
        layer.addSublayer(cursorLineLayer)
        
        cursorDotLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8)).cgPath
        cursorDotLayer.isHidden = true
        layer.addSublayer(cursorDotLayer)
    }
    
    private func setupGestures() {
        // Parmağı sürükleme ve basılı tutma olaylarını yakala
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        longPressGesture.minimumPressDuration = 0.1
        
        addGestureRecognizer(panGesture)
        addGestureRecognizer(longPressGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        gradientLayer.frame = bounds
        cursorLineLayer.frame = bounds
        
        // Ekran döndürülürse veya boyut değişirse yeniden çiz
        if !dataPoints.isEmpty {
            drawChart()
        }
    }
    
    private func updateGradientColors() {
        // Üst taraf ana renk, alt taraf şeffaf
        let topColor = graphColor.withAlphaComponent(0.3).cgColor
        let bottomColor = graphColor.withAlphaComponent(0.0).cgColor
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setData(_ data: [Double]) {
        self.dataPoints = data
        updateGradientColors()
        drawChart()
    }
    
    private func drawChart() {
        guard dataPoints.count > 1 else { return }
        
        let width = bounds.width
        let height = bounds.height
        
        // Veriyi normalize et
        let minVal = dataPoints.min() ?? 0
        let maxVal = dataPoints.max() ?? 0
        let range = maxVal - minVal
        
        guard range > 0 else { return }
        
        mainPath.removeAllPoints()
        
        // Çizgi yolu ve Gradient maskesi yolu
        let gradientPath = UIBezierPath()
        
        let stepX = width / CGFloat(dataPoints.count - 1)
        
        for (index, value) in dataPoints.enumerated() {
            let xPosition = CGFloat(index) * stepX
            let normalizedY = CGFloat(value - minVal) / CGFloat(range) * (height - 20) // 20px padding
            let yPosition = height - normalizedY - 10 // Alttan biraz boşluk
            
            let point = CGPoint(x: xPosition, y: yPosition)
            
            if index == 0 {
                mainPath.move(to: point)
                gradientPath.move(to: CGPoint(x: xPosition, y: height)) // Sol alt köşe
                gradientPath.addLine(to: point)
            } else {
                mainPath.addLine(to: point)
                gradientPath.addLine(to: point)
            }
            
            // Son noktadaysak gradient path'i kapat
            if index == dataPoints.count - 1 {
                gradientPath.addLine(to: CGPoint(x: xPosition, y: height)) // Sağ alt köşe
                gradientPath.close()
            }
        }
        
        shapeLayer.path = mainPath.cgPath
        
        // Gradient Maskesi (Sadece çizginin altını boyamak için)
        let maskLayer = CAShapeLayer()
        maskLayer.path = gradientPath.cgPath
        gradientLayer.mask = maskLayer
        
        // Çizim Animasyonu (Sadece ilk açılışta güzel durur, veri güncellemelerinde kapatılabilir)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.0
        shapeLayer.add(animation, forKey: "lineAnim")
    }
    
    // MARK: - Gesture Handling
    @objc private func handleGesture(_ sender: UIGestureRecognizer) {
        let location = sender.location(in: self)
        let width = bounds.width
        
        switch sender.state {
        case .began, .changed:
            // Dokunulan X noktasına karşılık gelen data indexini bul
            let stepX = width / CGFloat(dataPoints.count - 1)
            let index = Int((location.x / stepX).rounded())
            
            // Sınırları kontrol et
            guard index >= 0 && index < dataPoints.count else { return }
            
            let currentPrice = dataPoints[index]
            
            // Cursor pozisyonunu güncelle
            let xPos = CGFloat(index) * stepX
            
            // Y pozisyonunu bul (Çizginin üzerindeki nokta)
            // (DrawChart'taki formülün aynısı)
            let minVal = dataPoints.min() ?? 0
            let maxVal = dataPoints.max() ?? 0
            let range = maxVal - minVal
            let height = bounds.height
            let normalizedY = CGFloat(currentPrice - minVal) / CGFloat(range) * (height - 20)
            let yPos = height - normalizedY - 10
            
            // Çizgi ve Noktayı göster
            cursorLineLayer.isHidden = false
            cursorDotLayer.isHidden = false
            
            // Dikey çizgi yolu
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: xPos, y: 0))
            linePath.addLine(to: CGPoint(x: xPos, y: bounds.height))
            cursorLineLayer.path = linePath.cgPath
            
            // Nokta konumu (CATransaction animasyonunu kapatarak anlık tepki verelim)
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            cursorDotLayer.position = CGPoint(x: xPos, y: yPos)
            CATransaction.commit()
            
            // Titreşim (Sadece index değiştiyse titret - Performans için)
            // Basitlik adına her harekette hafif titreşim:
             feedbackGenerator.selectionChanged()
            
            // Delegate'e haber ver
            delegate?.didTouchChart(index: index, price: currentPrice)
            
        case .ended, .cancelled, .failed:
            // İşlem bitince gizle
            cursorLineLayer.isHidden = true
            cursorDotLayer.isHidden = true
            delegate?.didEndTouchingChart()
            
        default:
            break
        }
    }
}
