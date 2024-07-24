//
//  LoginViewModel.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 24.07.2024.
//

import Foundation
import Firebase

class LoginViewModel {
    // MARK: - Properties
    var email: String = "" {
        didSet {
            validateInput()
        }
    }
    
    var password: String = "" {
        didSet {
            validateInput()
        }
    }
    
    // Callbacks for view to handle UI updates
    var isUserLoggedIn: ((Bool, String?) -> Void)?
    var isInputValid: ((Bool) -> Void)?
    
    // MARK: - Input Validation
    private func validateInput() {
        let isValid = !email.isEmpty && !password.isEmpty
        isInputValid?(isValid)
    }
    
    // MARK: - User Login
    func loginUser() {
        guard validateInputs() else {
            isUserLoggedIn?(false, "Please fill in all fields.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.isUserLoggedIn?(false, error.localizedDescription)
                return
            }
            
            guard (authResult?.user) != nil else {
                self.isUserLoggedIn?(false, "User login failed.")
                return
            }
            
            self.isUserLoggedIn?(true, "User logged in successfully.")
        }
    }
    
    // MARK: - Private Methods
    private func validateInputs() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }
}

