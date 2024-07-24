//
//  VerificationView.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 24.07.2024.
//

import UIKit

class VerificationView: UIView {
    // MARK: - Properties
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Please verify your email address. Check your inbox and click the verification link."
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Email Verified", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 9
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(infoLabel)
        addSubview(verifyButton)
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        verifyButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.height.equalTo(60)
        }
    }
}
