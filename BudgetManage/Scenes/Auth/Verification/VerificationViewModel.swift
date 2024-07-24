//
//  VerificationViewModel.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 24.07.2024.
//

import Firebase

class VerificationViewModel {
    var isEmailVerified: ((Bool, String?) -> Void)?
    
    func checkEmailVerification() {
        Auth.auth().currentUser?.reload { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.isEmailVerified?(false, "Error reloading user: \(error.localizedDescription)")
                return
            }
            
            if let user = Auth.auth().currentUser, user.isEmailVerified {
                self.isEmailVerified?(true, "Email verified successfully.")
            } else {
                self.isEmailVerified?(false, "Email is not verified. Please check your email and verify.")
            }
        }
    }
}

