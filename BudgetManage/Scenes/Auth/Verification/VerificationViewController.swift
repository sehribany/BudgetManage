//
//  VerificationViewController.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 24.07.2024.
//

import UIKit
import Firebase

class VerificationViewController: UIViewController {
    // MARK: - Properties
    private let verificationView = VerificationView()
    private let viewModel = VerificationViewModel()
    private let userEmailKey = "userEmail"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(verificationView)
        verificationView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        verificationView.verifyButton.addTarget(self, action: #selector(checkVerificationStatus), for: .touchUpInside)
    }
    
    // MARK: - Bindings Setup
    private func setupBindings() {
        viewModel.isEmailVerified = { [weak self] success, message in
            guard let self = self else { return }
            if success {
                self.showSaveUsernameAlert()
            } else {
                self.showAlert(message: message ?? "Email not verified. Please try again.")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func checkVerificationStatus() {
        viewModel.checkEmailVerification()
    }
    
    // MARK: - Helpers
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSaveUsernameAlert() {
        let alert = UIAlertController(title: "User Verified", message: "Kullanıcı adınız otomatik olarak kayıt edildi. İsterseniz 'Beni Unut' diyerek işlemi iptal edebilirsiniz.", preferredStyle: .alert)
        
        let forgetAction = UIAlertAction(title: "Beni Unut", style: .destructive) { [weak self] _ in
            self?.forgetUser()
            self?.navigateToHomeScreen()
        }
        
        let continueAction = UIAlertAction(title: "Devam Et", style: .default) { [weak self] _ in
            self?.saveUserEmail()
            self?.navigateToHomeScreen()
        }
        
        alert.addAction(forgetAction)
        alert.addAction(continueAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func saveUserEmail() {
        if let userEmail = Auth.auth().currentUser?.email {
            UserDefaults.standard.set(userEmail, forKey: userEmailKey)
        }
    }
    
    private func forgetUser() {
        // Kullanıcıyı unutma işlemi
        UserDefaults.standard.removeObject(forKey: userEmailKey)
    }
    
    private func navigateToHomeScreen() {
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
}

