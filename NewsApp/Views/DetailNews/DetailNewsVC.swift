//
//  DetailNewsVC.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import UIKit
import Kingfisher

class DetailNewsVC: UIViewController {
    let viewModel: DetailNewsViewModel
    var selectedNews: ArticleElement?
    var image: UIImage?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline).withSize(25)
        label.numberOfLines = 5
        label.textColor = .label
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 5
        label.textColor = .label
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    init(viewModel: DetailNewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let news = selectedNews {
            viewModel.checkIsFav(news: news)
            title = news.author
        }
        
        initView()
    }
    
    func initView() {
        view.backgroundColor = .systemBackground
        
        setupTitleLabel()
        setupContentLabel()
        setupImageView()
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func setupContentLabel() {
        view.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func setupImageView() {
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupNavBarItem() {
        let favImage = viewModel.check ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: favImage, style: .plain, target: self, action: #selector(addFavorites))
    }
    
    @objc func addFavorites() {
        if let news = selectedNews {
            viewModel.addToFav(news: news)
        }
    }
    
}

extension DetailNewsVC: DetailNewsDelegate {
    func showError(_ error: NetworkError) {
        CustomAlertView.showAlert(on: self, title: LocaleKeys.Error.error.rawValue.locale(), message: error.localizedDescription)
    }
    
    func loadViewDelegate() {
        DispatchQueue.main.async {
            self.contentLabel.text = self.selectedNews?.content
            self.titleLabel.text = self.selectedNews?.title
            if let url = URL(string: self.selectedNews!.urlToImage ?? "") {
                self.imageView.kf.setImage(with: url)
            }
        }
    }
    
    func refreshIcon() {
        DispatchQueue.main.async {
            if self.selectedNews != nil {
                let bool = self.viewModel.check
                let newIcon = bool ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: newIcon, style: .plain, target: self, action: #selector(self.addFavorites))
            }
        }
    }
    
}
