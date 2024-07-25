//
//  Transaction.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 25.07.2024.
//

// MARK: - Transaction
struct Transaction: Codable {
    let id: Int
    let name: String
    let type: TransactionType
    let amount: String
}

// MARK: - TransactionType
enum TransactionType: String, Codable {
    case income = "INCOME"
    case expense = "EXPENSE"
}
