//
//  RegisterViewController.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 24.07.2024.
//

import UIKit

class RegisterViewController: UIViewController {
    // MARK: - Properties
    private let registerView = RegisterView()
    private let viewModel = RegisterViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        view.addSubview(registerView)
        registerView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        registerView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerView.toLoginButton.addTarget(self, action: #selector(toLoginButton), for: .touchUpInside)
    }
    
    // MARK: - Bindings Setup
    private func setupBindings() {
        viewModel.isUserRegistered = { [weak self] success, message in
            guard let self = self else { return }
            if success {
                self.navigateToVerificationScreen()
            } else {
                self.showAlert(message: message ?? "An error occurred.")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func registerButtonTapped() {
        viewModel.email = registerView.emailText.text ?? ""
        viewModel.password = registerView.passwordText.text ?? ""
        viewModel.registerUser()
    }
    
    @objc private func toLoginButton(){
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    // MARK: - Helpers
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func navigateToVerificationScreen() {
        let verificationVC = VerificationViewController()
        navigationController?.pushViewController(verificationVC, animated: true)
    }
}
