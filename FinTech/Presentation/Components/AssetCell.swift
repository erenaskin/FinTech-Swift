//
//  AssetCell.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit
import SnapKit
import Kingfisher

final class AssetCell: UITableViewCell {
    static let identifier = "AssetCell"
    
    // UI Elemanları
    // 'iv' -> 'iconImageView'
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .right
        return label
    }()
    
    private let rightStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.spacing = 4
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rightStackView)
        
        rightStackView.addArrangedSubview(priceLabel)
        rightStackView.addArrangedSubview(changeLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.top.equalTo(iconImageView).offset(2)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(symbolLabel)
            make.top.equalTo(symbolLabel.snp.bottom).offset(2)
            // İsim çok uzun olursa sağ tarafa (fiyata) girmesin
            make.right.lessThanOrEqualTo(rightStackView.snp.left).offset(-8)
        }
        
        rightStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with model: AssetEntity) {
        symbolLabel.text = model.symbol
        nameLabel.text = model.name
        priceLabel.text = CurrencyFormatter.format(model.price)
        
        // Strateji Deseni
        let strategy = AssetStrategyFactory.make(for: model.change24h)
        changeLabel.text = strategy.format(value: model.change24h)
        changeLabel.textColor = strategy.color
        
        // Kingfisher ile resim yükle
        if let url = URL(string: model.iconURL) {
            iconImageView.kf.setImage(with: url)
        }
    }
}
