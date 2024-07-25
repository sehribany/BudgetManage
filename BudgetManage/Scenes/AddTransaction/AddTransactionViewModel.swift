//
//  AddTransactionViewModel.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 25.07.2024.
//

import Foundation

class AddTransactionViewModel {
    // MARK: - Properties
    private(set) var categories: [TransactionCategory] = []
    var onCategoriesFetched: (() -> Void)?
    
    // MARK: - Methods
    func fetchCategories(for type: TransactionType) {
        let fileName: String
        switch type {
        case .income:
            fileName = "income"
        case .expense:
            fileName = "expense"
        }
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("JSON dosyası bulunamadı.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode([String: [TransactionCategory]].self, from: data)
            if type == .income {
                self.categories = decodedData["incomeCategories"] ?? []
            } else {
                self.categories = decodedData["expenseCategories"] ?? []
            }
            onCategoriesFetched?()
        } catch {
            print("JSON verisi işlenirken hata oluştu: \(error)")
        }
    }
}
