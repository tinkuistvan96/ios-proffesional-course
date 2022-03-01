//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Tinku István on 2022. 02. 07..
//

import UIKit

class AccountSummaryViewController: UIViewController {
    
    var profile: Profile?
    var accounts: [Account] = []
    var isLoaded = false
    
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "", date: Date())
    var accountCellViewModels: [AccountSummaryCell.ViewModel] = []
    
    var profileManager: ProfileManageable = ProfileManager()
    
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    var tableView = UITableView()
    var headerView = AccountSummaryHeaderView(frame: .zero)
    let barButtonItem = UIBarButtonItem()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButtonItem()
        setupTableView()
        setupTableHeaderView()
        layout()
        setupRefreshControl()
        setupSkeletons()
        fetchData()
    }
}


extension AccountSummaryViewController {
    private func setupBarButtonItem() {
        barButtonItem.tintColor = .label
        barButtonItem.style = .plain
        barButtonItem.title = "Logout"
        barButtonItem.target = self
        barButtonItem.action = #selector(logoutTapped)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseIdentifier)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()
    }
    
    private func setupTableHeaderView() {
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size
        
        tableView.tableHeaderView = headerView
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func layout() {
        navigationItem.rightBarButtonItem = barButtonItem
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
    }
    
    private func setupSkeletons() {
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)
        
        configureTableCells(with: accounts)
    }
}


// MARK: - TableView Delegate & Datasource methods

extension AccountSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
        
        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseIdentifier, for: indexPath) as! AccountSummaryCell
            cell.configure(with: accountCellViewModels[indexPath.row])
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        return cell
    }

}

// MARK: - Actions

extension AccountSummaryViewController {
    @objc func logoutTapped() {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc func refreshContent() {
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }
    
    private func reset() {
        profile = nil
        accounts = []
        isLoaded = false
    }
}

// MARK: - Networking

extension AccountSummaryViewController {
    private func fetchData() {
        let group = DispatchGroup()
        
        let userId = String(Int.random(in: 1..<4))
        
        fetchProfile(group: group, userId: userId)
        fetchAccounts(group: group, userId: userId)
        
        group.notify(queue: .main) {
            self.reloadView()
        }
    }
    
    private func fetchProfile(group: DispatchGroup, userId: String) {
        group.enter()
        profileManager.fetchProfile(forUserId: userId) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }
    }
    
    private func fetchAccounts(group: DispatchGroup, userId: String) {
        group.enter()
        fetchAccounts(forUserId: userId) { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }
    }
    
    private func reloadView() {
        self.tableView.refreshControl?.endRefreshing()
        
        guard let profile = self.profile else { return }
        self.isLoaded = true
        self.configureTableCells(with: self.accounts)
        self.configureTableHeaderView(with: profile)
        self.tableView.reloadData()
    }
    
    private func configureTableCells(with accounts: [Account]) {
        accountCellViewModels = accounts.map {
            AccountSummaryCell.ViewModel(accountType: $0.type, accountName: $0.name, balance: $0.amount)
        }
    }
    
    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,", name: profile.firstName, date: Date())
        headerView.configure(viewModel: vm)
    }
    
    private func showErrorAlert(title: String, message: String) {
        //let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        errorAlert.title = title
        errorAlert.message = message
        present(errorAlert, animated: true, completion: nil)
    }
    
    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    //Extracting the functionality to make more testable
    private func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        
        switch error {
        case .serverError:
            title = "Server Error"
            message = "Ensure you are connected to the internet. Please try again."
        case .decodingError:
            title = "Decoding Error"
            message = "We could not process your request. Please try again."
        }
        
        return (title, message)
    }
}

//MARK: - Unit testing
//I made this func to keep the other func private
extension AccountSummaryViewController {
    func titleAndMessageForTesting(_ error: NetworkError) -> (String, String) {
        return titleAndMessage(for: error)
    }
    
    func fetchProfileForTesting() {
        fetchProfile(group: DispatchGroup(), userId: "1")
    }
}
