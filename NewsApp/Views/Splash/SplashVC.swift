//
//  SplashVC.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import UIKit
import SnapKit

class SplashVC: UIViewController {
    
    private let viewModel: SplashViewModel
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "News"
        label.font = .preferredFont(forTextStyle: .headline).withSize(40)
        label.textColor = .label
        return label
    }()
    
    init(viewModel: SplashViewModel = SplashViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initView()
        
        Task{
            await viewModel.askPermissionNotification()
        }
    }
    
    func initView() {
        setupLabel()
    }
    
    func setupLabel() {
        label.text = "NewsApp"
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func labelAnimation() {
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, animations: {
            self.label.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }) { _ in
            let tabbar = TabBarController()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = tabbar
                window.makeKeyAndVisible()
            }
        }
    }
}

extension SplashVC: SplashViewModelProtocol {
    func didAskPermissionNotification(granted: Bool) {
        DispatchQueue.main.async{
            if granted {
                self.labelAnimation()
            } else {
                self.labelAnimation()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async{
            CustomAlertView.showAlert(on: self, title: "Error", message: error.localizedDescription)
        }
    }
}
