//
//  HomeViewController.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 24.07.2024.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        self.title = "Home"
        
        // Adding Logout Button
        let logoutButton = UIBarButtonItem(title: "Çıkış Yap", style: .plain, target: self, action: #selector(logoutButtonTapped))
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            navigateToLoginScreen()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Navigation
    private func navigateToLoginScreen() {
        // Remove saved user email if necessary
        // UserDefaults.standard.removeObject(forKey: "userEmail") // Uncomment if you want to remove saved email on logout
        
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}
