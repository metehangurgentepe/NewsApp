//
//  HomeVC.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import UIKit

class HomeVC: UIViewController {
    let viewModel: HomeViewModel
    var tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    let searchTextField = UISearchController()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        Task{
            await viewModel.getNews()
        }
    }
    
    func initView() {
        title = "NewsApp"
        
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        setupSearchTextField()
        setupTableView()
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func selectDateRange() {
        let alert = UIAlertController(title: LocaleKeys.Home.selectDate.rawValue.locale(), message: nil, preferredStyle: .alert)
        
        let startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .compact
        
        let endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .compact
        
        let stackView = UIStackView(arrangedSubviews: [
            createPickerStackView(str: LocaleKeys.Home.from.rawValue.locale(), picker: startDatePicker),
            createPickerStackView(str: LocaleKeys.Home.to.rawValue.locale(), picker: endDatePicker)
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        alert.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -60)
        ])
        
        alert.addAction(UIAlertAction(title: LocaleKeys.Home.done.rawValue.locale(), style: .default) { _ in
            let startDate = startDatePicker.date.formatDate()
            let endDate = endDatePicker.date.formatDate()
            
            Task {
                await self.viewModel.searchNews(query: self.searchTextField.searchBar.text, fromDate: startDate, toDate: endDate)
            }
        })
        
        alert.addAction(UIAlertAction(title: LocaleKeys.Home.cancel.rawValue.locale(), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func createPickerStackView(str: String, picker: UIDatePicker) -> UIStackView {
        let label = UILabel()
        label.text = str
        label.font = .preferredFont(forTextStyle: .headline)
        
        let stackView = UIStackView(arrangedSubviews: [label, picker])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }
    
    
    @objc private func refreshData() {
        Task {
            await viewModel.getNews()
            refreshControl.endRefreshing()
        }
    }
    
    func setupSearchTextField() {
        navigationItem.searchController = searchTextField
        searchTextField.searchResultsUpdater = self
        searchTextField.obscuresBackgroundDuringPresentation = false
        searchTextField.searchBar.placeholder = LocaleKeys.Home.searchField.rawValue.locale()
        
        if let searchBar = searchTextField.searchBar.value(forKey: "searchField") as? UITextField {
            let calendarIcon = UIButton()
            calendarIcon.setImage(UIImage(systemName: "calendar"), for: .normal)
            calendarIcon.addTarget(self, action: #selector(selectDateRange), for: .touchUpInside)
            searchBar.leftView = calendarIcon
            searchBar.leftViewMode = .always
        }
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

extension HomeVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 2 {
            Task{
                await viewModel.getNews()
            }
        }
        
        Task {
            await viewModel.searchNews(query: searchController.searchBar.text!, fromDate: nil, toDate: nil)
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        cell.textLabel?.text = viewModel.articles[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = DetailNewsViewModel()
        let vc = DetailNewsVC(viewModel: vm)
        let news = viewModel.articles[indexPath.row]
        vc.selectedNews = news
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: HomeDelegate {
    func showError(_ error: NetworkError) {
        DispatchQueue.main.async{
            CustomAlertView.showAlert(on: self, title: LocaleKeys.Error.error.rawValue.locale(), message: error.localizedDescription)
        }
    }
    
    func refreshNews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
