//
//  PortfolioViewController.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit
import SnapKit
import Combine

final class PortfolioViewController: UIViewController {
    
    private let viewModel: PortfolioViewModel
    private let refreshControl = UIRefreshControl()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let balanceCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let totalBalanceTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Total Balance"
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .white.withAlphaComponent(0.8)
        return lbl
    }()
    
    private let totalBalanceLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "$0.00"
        lbl.font = .systemFont(ofSize: 34, weight: .bold)
        lbl.textColor = .white
        return lbl
    }()
    
    // 'tv' -> 'tableView'
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PortfolioCell.self, forCellReuseIdentifier: PortfolioCell.identifier)
        tableView.rowHeight = 80
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let emptyLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Portföyün boş.\nMarketten coin alarak başla!"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .secondaryLabel
        lbl.isHidden = true
        return lbl
    }()
    
    // MARK: - Init & Lifecycle
    init(viewModel: PortfolioViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.delegate = self
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadPortfolio()
    }
    
    private func bindViewModel() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
        
        viewModel.isRefreshing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRefreshing in
                if !isRefreshing {
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleStateChange(_ state: PortfolioViewState) {
        switch state {
        case .idle, .loading:
            break
        case .success:
            emptyLabel.isHidden = true
            tableView.isHidden = false
            totalBalanceLabel.text = CurrencyFormatter.format(viewModel.totalBalance)
            tableView.reloadData()
        case .empty:
            emptyLabel.isHidden = false
            tableView.isHidden = true
            totalBalanceLabel.text = "$0.00"
        case .error(let msg):
            print("Hata: \(msg)")
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Portfolio"
        
        view.addSubview(balanceCardView)
        balanceCardView.addSubview(totalBalanceTitleLabel)
        balanceCardView.addSubview(totalBalanceLabel)
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        
        // Layout Constraints
        balanceCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        
        totalBalanceTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(20)
        }
        
        totalBalanceLabel.snp.makeConstraints { make in
            make.top.equalTo(totalBalanceTitleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(balanceCardView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
    }
    
    @objc private func didPullToRefresh() {
        viewModel.loadPortfolio(force: true)
    }
}

// MARK: - DataSource
extension PortfolioViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PortfolioCell.identifier, for: indexPath) as? PortfolioCell else {
            return UITableViewCell()
        }
        let asset = viewModel.assets[indexPath.row]
        cell.configure(with: asset)
        return cell
    }
}

// MARK: - Delegate
extension PortfolioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let asset = viewModel.assets[indexPath.row]
        viewModel.didSelectAsset(id: asset.id)
    }
}
