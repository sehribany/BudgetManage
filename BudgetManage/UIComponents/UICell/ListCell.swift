//
//  ListCell.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 25.07.2024.
//

import UIKit

class ListCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "ListCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.backgroundColor = .appPurpleLight
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.appIndigo.cgColor
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(amountLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
    
    // MARK: - Configuration
    func configure(with transaction: Transaction) {
        nameLabel.text = transaction.name
        amountLabel.text = transaction.amount
    }
}

