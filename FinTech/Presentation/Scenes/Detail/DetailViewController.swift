//
//  DetailViewController.swift
//  FinTech
//
//  Created by Eren AŞKIN on 7.02.2026.
//

import UIKit
import SnapKit
import Kingfisher
import Combine

final class DetailViewController: UIViewController {
    
    private let viewModel: DetailViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 32, weight: .bold)
        return lbl
    }()
    
    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 28, weight: .medium)
        lbl.textColor = .systemGreen
        return lbl
    }()
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = .tertiaryLabel
        lbl.textAlignment = .left
        lbl.text = "Last 7 Days"
        return lbl
    }()
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .secondaryLabel
        return lbl
    }()

    private let chartView: SparklineView = {
        let view = SparklineView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindViewModel()
        viewModel.loadData()
    }
    
    private func bindViewModel() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
        
        viewModel.viewMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.handleMessage(message)
            }
            .store(in: &cancellables)
    }
    
    private func handleStateChange(_ state: DetailViewState) {
        switch state {
        case .idle:
            break
        case .loading:
            loadingIndicator.startAnimating()
            contentView.isHidden = true
        case .success:
            loadingIndicator.stopAnimating()
            contentView.isHidden = false
            updateUI()
        case .error(let msg):
            loadingIndicator.stopAnimating()
            print("Error: \(msg)")
        }
    }
    
    private func handleMessage(_ message: DetailViewMessage) {
        let title: String
        let msg: String
        
        switch message {
        case .success(let text):
            title = "Success"
            msg = text
        case .error(let text):
            title = "Error"
            msg = text
        }
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupNavigationBar() {
        let context = viewModel.context
        var barButtonItems: [UIBarButtonItem] = []
        
        switch context {
        case .market:
            let buyBtn = createBarButton(title: "Buy", color: .systemGreen, action: #selector(didTapBuy))
            barButtonItems.append(UIBarButtonItem(customView: buyBtn))
        case .portfolio:
            let sellBtn = createBarButton(title: "Sell", color: .systemRed, action: #selector(didTapSell))
            barButtonItems.append(UIBarButtonItem(customView: sellBtn))
        }
        navigationItem.rightBarButtonItems = barButtonItems
    }
    
    private func createBarButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(color, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.frame = CGRect(x: 0, y: 0, width: 70, height: 32)
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = btn.bounds
        blurView.isUserInteractionEnabled = false
        blurView.layer.cornerRadius = 16
        blurView.clipsToBounds = true
        
        btn.insertSubview(blurView, at: 0)
        btn.layer.cornerRadius = 16
        btn.backgroundColor = color.withAlphaComponent(0.1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = color.withAlphaComponent(0.2).cgColor
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }
    
    @objc private func didTapSell() {
        let currentAmount = viewModel.currentHoldings
        let alert = UIAlertController(title: "Sell Asset", message: "You have: \(currentAmount) \(viewModel.coinDetail?.symbol ?? "")\nHow much do you want to sell?", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Amount (Max: \(currentAmount))"
            textField.keyboardType = .decimalPad
        }
        
        let sellAction = UIAlertAction(title: "Sell", style: .destructive) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, let amount = Double(text) else { return }
            self?.viewModel.sellCoin(amount: amount)
        }
        alert.addAction(sellAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func didTapBuy() {
        let alert = UIAlertController(title: "Buy Asset", message: "How much \(viewModel.coinDetail?.symbol ?? "coin") do you want to buy?", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Amount (e.g. 0.5)"
            textField.keyboardType = .decimalPad
        }
        
        let buyAction = UIAlertAction(title: "Buy", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, let amount = Double(text) else { return }
            self?.viewModel.buyCoin(amount: amount)
        }
        alert.addAction(buyAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func updateUI() {
        guard let data = viewModel.coinDetail else { return }
        title = data.symbol
        nameLabel.text = data.name
        priceLabel.text = CurrencyFormatter.format(data.price)
        let desc = data.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        descriptionLabel.text = desc
        
        if let urlString = data.imageURL, let url = URL(string: urlString) {
            iconImageView.kf.setImage(with: url)
        }
        
        if data.priceChange < 0 {
            chartView.graphColor = .systemRed
        } else {
            chartView.graphColor = .systemGreen
        }
        
        DispatchQueue.main.async {
            self.chartView.setData(data.sparklineData)
        }
    }
    
    private func getDate(for index: Int, totalPoints: Int) -> String {
        let now = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let totalSeconds = now.timeIntervalSince(sevenDaysAgo)
        let secondsPerPoint = totalSeconds / Double(totalPoints)
        let offset = Double(index) * secondsPerPoint
        let selectedDate = sevenDaysAgo.addingTimeInterval(offset)
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM HH:mm"
        return formatter.string(from: selectedDate)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        chartView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(loadingIndicator)
        scrollView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        loadingIndicator.snp.makeConstraints { make in make.center.equalToSuperview() }
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        priceLabel.accessibilityIdentifier = "DetailPriceLabel"
        
        contentView.addSubview(chartView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }
        chartView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(250)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}

// MARK: - Sparkline Delegate
extension DetailViewController: SparklineViewDelegate {
    func didTouchChart(index: Int, price: Double) {
        priceLabel.text = CurrencyFormatter.format(price)
        priceLabel.textColor = .secondaryLabel
        guard let data = viewModel.coinDetail else { return }
        let dateString = getDate(for: index, totalPoints: data.sparklineData.count)
        dateLabel.text = dateString
        dateLabel.textColor = .label
    }
    
    func didEndTouchingChart() {
        guard let data = viewModel.coinDetail else { return }
        priceLabel.text = CurrencyFormatter.format(data.price)
        if data.priceChange < 0 {
            priceLabel.textColor = .systemRed
        } else {
            priceLabel.textColor = .systemGreen
        }
        dateLabel.text = "Last 7 Days"
        dateLabel.textColor = .tertiaryLabel
    }
}
