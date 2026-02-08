//
//  HomeViewController.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit
import SnapKit
import Combine

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    private var isLoading = true
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // 'tv' -> 'tableView'
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AssetCell.self, forCellReuseIdentifier: AssetCell.identifier)
        tableView.register(AssetSkeletonCell.self, forCellReuseIdentifier: AssetSkeletonCell.identifier)
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        setupNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        bindViewModel()
        
        viewModel.loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Market"
        
        view.addSubview(tableView)
        
        tableView.accessibilityIdentifier = "AssetListTableView"
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Coin (BTC, ETH...)"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupNavigationBar() {
        let sortIcon = UIImage(systemName: "arrow.up.arrow.down.circle")
        
        let menu = UIMenu(title: "Sort By", children: [
            UIAction(title: "Highest Rank (Default)", handler: { [weak self] _ in self?.viewModel.sort(by: .highestRank) }),
            UIAction(title: "Price: High to Low", image: UIImage(systemName: "arrow.down"), handler: { [weak self] _ in self?.viewModel.sort(by: .priceHighToLow) }),
            UIAction(title: "Price: Low to High", image: UIImage(systemName: "arrow.up"), handler: { [weak self] _ in self?.viewModel.sort(by: .priceLowToHigh) })
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: sortIcon, primaryAction: nil, menu: menu)
    }
    
    private func bindViewModel() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleStateChange(_ state: HomeViewState) {
        switch state {
        case .idle:
            break
        case .loading:
            isLoading = true
            tableView.isUserInteractionEnabled = false
            tableView.reloadData()
            
        case .success:
            isLoading = false
            tableView.isUserInteractionEnabled = true
            tableView.separatorStyle = .singleLine
            tableView.reloadData()
            
        case .error(let message):
            isLoading = false
            print("Hata Combine: \(message)")
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading { return 10 }
        return viewModel.assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetSkeletonCell.identifier, for: indexPath) as? AssetSkeletonCell else { return UITableViewCell() }
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetCell.identifier, for: indexPath) as? AssetCell else { return UITableViewCell() }
        let asset = viewModel.assets[indexPath.row]
        cell.configure(with: asset)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoading { return }
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath.row)
    }
}

// MARK: - Search Delegate
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.search(query: text)
    }
}
