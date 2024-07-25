//
//  RegisterView.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 24.07.2024.
//

import UIKit

class RegisterView: UIView {
    
    //MARK: - Properties
    
    private lazy var backGroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgIntro")
        return imageView
    }()
    
    private lazy var emailLabel: UILabel = {
        let label  = UILabel()
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .appGray
        return label
    }()

    lazy var emailText: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .appPurpleLight
        textField.textColor = .appBlack
        textField.placeholder = "Enter your email"
        textField.layer.cornerRadius = 9
        textField.keyboardType = .emailAddress
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }()
    
    
    private lazy var passwordLabel: UILabel = {
        let label  = UILabel()
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .appGray
        return label
    }()

    lazy var passwordText: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .appPurpleLight
        textField.textColor = .appBlack
        textField.placeholder = "Enter your password"
        textField.layer.cornerRadius = 9
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appIndigo.withAlphaComponent(0.8)
        button.setTitle("Register", for: .normal)
        button.tintColor = .appWhite
        button.layer.cornerRadius = 9
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 23)
        return button
    }()
    
    private lazy var toLoginLabel: UILabel = {
        let label  = UILabel()
        label.text = "Don't have an account ?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .appGray
        return label
    }()
    
     lazy var toLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Login", for: .normal)
        button.tintColor = .appIndigo
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 14)
        return button
    }()

    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - setupUI
extension RegisterView{
    private func setupUI(){
        addBackground()
        addEmail()
        addEmailText()
        addPassword()
        addPasswordText()
        addRegisterButton()
        addtoLoginLabel()
        addLoginButton()
    }
    
    private func addBackground(){
        addSubview(backGroundImage)
        backGroundImage.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalToSuperview()
        }
    }
    
    private func addEmail(){
        addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(70)
            make.leading.equalTo(25)
        }
    }
    
    private func addEmailText(){
        addSubview(emailText)
        emailText.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(15)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.height.equalTo(60)
        }
    }
    
    private func addPassword(){
        addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailText.snp.bottom).offset(30)
            make.leading.equalTo(25)
        }
    }
    
    private func addPasswordText(){
        addSubview(passwordText)
        passwordText.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(15)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.height.equalTo(60)
        }
    }

    private func addRegisterButton(){
        addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordText.snp.bottom).offset(60)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.height.equalTo(60)
        }
    }
    
    private func addtoLoginLabel(){
        addSubview(toLoginLabel)
        toLoginLabel.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.leading.equalTo(85)
        }
    }
    
    private func addLoginButton(){
        addSubview(toLoginButton)
        toLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-15)
            make.leading.equalTo(toLoginLabel.snp.trailing).offset(7)
        }
    }
}
