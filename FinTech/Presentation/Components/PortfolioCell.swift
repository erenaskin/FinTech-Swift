//
//  PortfolioCell.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit
import SnapKit
import Kingfisher

final class PortfolioCell: UITableViewCell {
    static let identifier = "PortfolioCell"
    
    // 1. İKON
    // 'iv' -> 'iconImageView'
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    // 2. SOL TARAF (İsim ve Sembol)
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.textColor = .label
        return lbl
    }()
    
    private let amountLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .medium)
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    
    // 3. SAĞ TARAF (Toplam Değer ve Fiyat)
    private let totalValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .right
        lbl.textColor = .label
        return lbl
    }()
    
    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        lbl.textAlignment = .right
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    
    // StackView'lar (Düzen için)
    private let leftStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private let rightStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.spacing = 2
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = .clear
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(leftStack)
        contentView.addSubview(rightStack)
        
        leftStack.addArrangedSubview(nameLabel)
        leftStack.addArrangedSubview(amountLabel)
        
        rightStack.addArrangedSubview(totalValueLabel)
        rightStack.addArrangedSubview(priceLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        leftStack.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        rightStack.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with model: PortfolioDisplayEntity) {
        nameLabel.text = model.name
        // Örn: 1.5 BTC
        amountLabel.text = "\(model.amount) \(model.symbol.uppercased())"
        
        // Örn: $75,000.00
        totalValueLabel.text = CurrencyFormatter.format(model.totalValue)
        
        // Örn: $50,000.00 (Anlık Fiyat)
        priceLabel.text = CurrencyFormatter.format(model.currentPrice)
        
        if let url = URL(string: model.image) {
            iconImageView.kf.setImage(with: url)
        }
    }
}
