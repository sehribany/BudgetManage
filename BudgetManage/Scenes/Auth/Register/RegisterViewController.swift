//
//  RegisterViewController.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 24.07.2024.
//

import UIKit

class RegisterViewController: UIViewController {

    //MARK: - Properties
    
    private let registerView = RegisterView()
   
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - setupUI & Actions
extension RegisterViewController{
    private func setupUI(){
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        view.addSubview(registerView)
        registerView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        self.action()
    }
    
    private func action(){
        self.registerView.toLoginButton.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
    }
    
    @objc
    private func toLogin(){
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
