//
//  DetailViewModel.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 25.07.2024.
//

import Foundation
import Firebase

class DetailViewModel {
    // MARK: - Properties
    let category: TransactionCategory
    private let type: TransactionType
    private let db = Firestore.firestore()
    
    var onTransactionSaved: ((Bool, String) -> Void)?
    
    init(category: TransactionCategory, type: TransactionType) {
        self.category = category
        self.type = type
    }
    
    func saveTransaction(amount: String) {
        guard !amount.isEmpty else {
            onTransactionSaved?(false, "Tutar boş olamaz.")
            return
        }
        
        let transaction = Transaction(
            id: UUID().hashValue,
            name: category.name,
            type: type,
            amount: amount
        )
        
        do {
            let data: [String: Any] = [
                "id": transaction.id,
                "name": transaction.name,
                "type": transaction.type == .income ? "income" : "expense",
                "amount": transaction.amount
            ]
            
            db.collection("transactions").document().setData(data) { error in
                if let error = error {
                    self.onTransactionSaved?(false, "İşlem kaydedilirken hata oluştu: \(error.localizedDescription)")
                } else {
                    self.onTransactionSaved?(true, "İşlem başarıyla kaydedildi.")
                }
            }
        } catch {
            onTransactionSaved?(false, "Veri işlenirken hata oluştu: \(error.localizedDescription)")
        }
    }
}

