//
//  TransictionViewModel.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 25.07.2024.
//

import Foundation
import Firebase

class TransactionViewModel {
    // MARK: - Properties
    private(set) var transactions: [Transaction] = []
    private(set) var filteredTransactions: [Transaction] = []
    private let db = Firestore.firestore()
    private var currentFilter: TransactionType? = .income
    
    // MARK: - Methods
    func fetchTransactions(completion: @escaping () -> Void) {
        db.collection("transactions").getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion()
                return
            }
            
            self?.transactions = querySnapshot?.documents.compactMap { document -> Transaction? in
                let data = document.data()
                guard let id = data["id"] as? Int,
                      let name = data["name"] as? String,
                      let typeString = data["type"] as? String,
                      let amount = data["amount"] as? String else {
                    return nil
                }
                
                let type: TransactionType
                if typeString.lowercased() == "income" {
                    type = .income
                } else if typeString.lowercased() == "expense" {
                    type = .expense
                } else {
                    return nil
                }
                
                return Transaction(id: id, name: name, type: type, amount: amount)
            } ?? []
            
            self?.filterTransactions(by: self?.currentFilter)
            completion()
        }
    }
    
    func filterTransactions(by type: TransactionType?) {
        currentFilter = type
        if let type = type {
            filteredTransactions = transactions.filter { $0.type == type }
        } else {
            filteredTransactions = transactions
        }
    }
    
    func numberOfItems() -> Int {
        return filteredTransactions.count
    }
    
    func item(at index: Int) -> Transaction {
        return filteredTransactions[index]
    }
    
    func totalAmount(for type: TransactionType) -> Double {
        return transactions.filter { $0.type == type }
            .reduce(0) { $0 + (Double($1.amount) ?? 0) }
    }
}
