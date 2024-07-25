//
//  TransictionViewController.swift
//  BudgetManage
//
//  Created by Şehriban Yıldırım on 25.07.2024.
//
import UIKit
import SnapKit
import FirebaseAuth

class TransactionViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = TransactionViewModel()
    private var currentType: TransactionType = .income
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appIndigo
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        return collectionView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appIndigo
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Income", "Expense"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .systemGray5
        control.selectedSegmentTintColor = .appIndigo
        control.setTitleTextAttributes([.foregroundColor: UIColor.appPurpleLight], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.appIndigo], for: .normal)
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return control
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Toplam: 0.00 TL"
        label.textColor = .appWhite
        label.backgroundColor = .appIndigo
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var usdExchangeRate: Double?
    private var eurExchangeRate: Double?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .appWhite
        navigationItem.titleView = segmentedControl
        
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.right.fill"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        
        logoutButton.tintColor = .appIndigo
        navigationItem.rightBarButtonItem = logoutButton
        
        view.addSubview(headerView)
        headerView.addSubview(totalLabel)
        view.addSubview(collectionView)
        view.addSubview(addButton)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.greaterThanOrEqualTo(120)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Data Fetching
    private func fetchData() {
        viewModel.fetchTransactions { [weak self] in
            self?.fetchExchangeRates()
        }
    }
    
    private func fetchExchangeRates() {
        ExchangeRateService.shared.fetchExchangeRates { [weak self] tryToUsd, tryToEur in
            DispatchQueue.main.async {
                self?.usdExchangeRate = tryToUsd
                self?.eurExchangeRate = tryToEur
                self?.filterAndReload()
            }
        }
    }
    
    private func updateTotalLabel() {
        let total = viewModel.totalAmount(for: currentType)
        
        var totalText = "Toplam: \(total) TL\n"
        
        if let usdRate = usdExchangeRate, let eurRate = eurExchangeRate {
            let totalInUsd = total / usdRate
            let totalInEur = total / eurRate
            totalText += String(format: "%.2f USD\n%.2f EUR", totalInUsd, totalInEur)
        }
        
        let attributedText = NSMutableAttributedString(string: totalText)
        
        let rangeTL = (totalText as NSString).range(of: "Toplam: \(total) TL")
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: rangeTL)
        
        totalLabel.attributedText = attributedText
        totalLabel.numberOfLines = 0
    }

    // MARK: - Actions
    @objc private func segmentChanged() {
        currentType = segmentedControl.selectedSegmentIndex == 0 ? .income : .expense
        filterAndReload()
    }
    
    @objc private func addButtonTapped() {
        let addTransactionVC = AddTransactionViewController(type: currentType)
        navigationController?.pushViewController(addTransactionVC, animated: true)
    }
    
    @objc private func logoutTapped() {
        do {
            try Auth.auth().signOut()
            navigateToLoginScreen()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    private func navigateToLoginScreen() {
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navigationController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    private func filterAndReload() {
        viewModel.filterTransactions(by: currentType)
        collectionView.reloadData()
        updateTotalLabel()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension TransactionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as! ListCell
        let transaction = viewModel.item(at: indexPath.item)
        cell.configure(with: transaction)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 2
        return CGSize(width: width, height: 100)
    }
}

