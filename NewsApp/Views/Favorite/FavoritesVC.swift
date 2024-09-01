//
//  FavoritesVC.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import UIKit
import WebKit

class FavoritesVC: UIViewController {
    var tableView = UITableView()
    
    let viewModel: FavoritesViewModel
    
    init(viewModel: FavoritesViewModel) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        Task{
            await viewModel.getNews()
        }
    }
    
    func initView() {
        title = LocaleKeys.Favorites.favorites.rawValue.locale()
        
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        setupTableView()
    }
    
    func setupWebKit() {
        
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteArticleCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteArticleCell", for: indexPath)
        cell.textLabel?.text = viewModel.articles[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsUrlString = viewModel.articles[indexPath.row].url
        guard let url = URL(string: newsUrlString) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)    }
}

extension FavoritesVC: FavoritesDelegate {
    func showError(_ error: NetworkError) {
        DispatchQueue.main.async{
            CustomAlertView.showAlert(on: self, title: "Error", message: error.localizedDescription)
        }
    }
    
    func reloadFavoritesTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
