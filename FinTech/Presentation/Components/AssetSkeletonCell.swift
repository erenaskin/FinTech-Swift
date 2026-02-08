//
//  AssetSkeletonCell.swift
//  FinTech
//
//  Created by Eren AŞKIN on 8.02.2026.
//

import UIKit
import SnapKit

final class AssetSkeletonCell: UITableViewCell {
    static let identifier = "AssetSkeletonCell"
    
    private let iconView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let symbolView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let priceView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(iconView)
        contentView.addSubview(symbolView)
        contentView.addSubview(nameView)
        contentView.addSubview(priceView)
        
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        symbolView.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.top.equalTo(iconView).offset(4)
            make.width.equalTo(60)
            make.height.equalTo(14)
        }
        
        nameView.snp.makeConstraints { make in
            make.left.equalTo(symbolView)
            make.top.equalTo(symbolView.snp.bottom).offset(6)
            make.width.equalTo(100)
            make.height.equalTo(12)
        }
        
        priceView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
    }
    
    // Animasyonu başlatma komutu
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.startSkeletonAnimation()
        symbolView.startSkeletonAnimation()
        nameView.startSkeletonAnimation()
        priceView.startSkeletonAnimation()
    }
}
