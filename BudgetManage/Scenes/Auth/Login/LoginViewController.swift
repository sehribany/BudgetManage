//
//  LoginViewController.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 24.07.2024.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - Properties
    private let loginView = LoginView()
    private let viewModel = LoginViewModel()
    private let userEmailKey = "userEmail"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        populateUserEmail()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.toRegisterButton.addTarget(self, action: #selector(toRegisterButton), for: .touchUpInside)
    }
    
    // MARK: - Bindings Setup
    
    private func setupBindings() {
        viewModel.isUserLoggedIn = { [weak self] success, message in
            guard let self = self else { return }
            if success {
                self.navigateToHomeScreen()
            } else {
                self.showAlert(message: message ?? "An error occurred.")
            }
        }
        
        viewModel.isInputValid = { [weak self] isValid in
            self?.loginView.loginButton.isEnabled = isValid
        }
        
        loginView.emailText.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        loginView.passwordText.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        viewModel.email = loginView.emailText.text ?? ""
        viewModel.password = loginView.passwordText.text ?? ""
        viewModel.loginUser()
    }
    
    @objc private func textFieldDidChange() {
        viewModel.email = loginView.emailText.text ?? ""
        viewModel.password = loginView.passwordText.text ?? ""
    }
    
    @objc private func toRegisterButton(){
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    // MARK: - Helpers
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func populateUserEmail() {
        if let savedEmail = UserDefaults.standard.string(forKey: userEmailKey) {
            loginView.emailText.text = savedEmail
        }
    }
    
    private func navigateToHomeScreen() {
        navigationController?.pushViewController(TransactionViewController(), animated: true)
    }
}
