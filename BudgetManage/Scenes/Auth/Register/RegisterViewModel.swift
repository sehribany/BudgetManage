//
//  RegisterViewModel.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 24.07.2024.
//

import Foundation
import Firebase

class RegisterViewModel {
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
    var isUserRegistered: ((Bool, String?) -> Void)?
    var isInputValid: ((Bool) -> Void)?
    
    // MARK: - Input Validation
    private func validateInput() {
        let isValid = !email.isEmpty && !password.isEmpty
        isInputValid?(isValid)
    }
    
    // MARK: - User Registration
    func registerUser() {
        guard validateInputs() else {
            isUserRegistered?(false, "Please fill in all fields.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.isUserRegistered?(false, error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else {
                self.isUserRegistered?(false, "User creation failed.")
                return
            }
            
            user.sendEmailVerification { error in
                if let error = error {
                    print("Failed to send verification email: \(error.localizedDescription)")
                }
            }
            
            self.isUserRegistered?(true, nil)
        }
    }
    
    // MARK: - Private Methods
    private func validateInputs() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }
}
