//
//  LoginViewController.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 24.07.2024.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - Properties
    
    private let loginView = LoginView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - setupUI & Actions
extension LoginViewController{
    private func setupUI(){
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        self.action()
    }
    
    private func action(){
        self.loginView.toRegisterButton.addTarget(self, action: #selector(toRegister), for: .touchUpInside)
    }
    
    @objc
    private func toRegister(){
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}
