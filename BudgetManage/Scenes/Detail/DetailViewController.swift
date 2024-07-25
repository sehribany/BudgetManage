//
//  DetailViewController.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 25.07.2024.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: DetailViewModel
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Tutar"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kaydet", for: .normal)
        button.tintColor = .appWhite
        button.backgroundColor = .appIndigo
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var onTransactionSaved: (() -> Void)?
    
    // MARK: - Initializer
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = viewModel.category.name
        
        view.addSubview(amountTextField)
        view.addSubview(saveButton)
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
    }
    
    // MARK: - Bindings Setup
    private func setupBindings() {
        viewModel.onTransactionSaved = { [weak self] success, message in
            self?.showAlert(message: message, success: success)
        }
    }
    
    // MARK: - Actions
    @objc private func saveButtonTapped() {
        guard let amountText = amountTextField.text, !amountText.isEmpty else {
            showAlert(message: "Lütfen bir miktar girin.", success: false)
            return
        }
        
        guard let amount = Double(amountText), amount > 0 else {
            showAlert(message: "Lütfen geçerli bir miktar girin.", success: false)
            return
        }
        
        viewModel.saveTransaction(amount: String(amount))
    }

    
    private func showAlert(message: String, success: Bool) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            if success {
                self?.onTransactionSaved?()
                let transactionVC = TransactionViewController()
                self?.navigationController?.pushViewController(transactionVC, animated: true)
            }
        })
        present(alert, animated: true, completion: nil)
    }
}
