//
//  TabBarController.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 31.08.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        let homeVM = HomeViewModel(httpClient: HTTPClient(session: .shared))
        let homeVC = HomeVC(viewModel: homeVM)
        let homeNav = UINavigationController(rootViewController: homeVC)
        
        let favoriteVM = FavoritesViewModel()
        let favoritesVC = FavoritesVC(viewModel: favoriteVM)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        
        homeVC.tabBarItem = UITabBarItem(title: LocaleKeys.Tab.Home.rawValue.locale(), image: UIImage(systemName: "house"), tag: 0)
        favoritesVC.tabBarItem = UITabBarItem(title: LocaleKeys.Favorites.favorites.rawValue.locale(), image: UIImage(systemName: "star"), tag: 1)
        
        self.viewControllers = [homeNav,favoritesNav]
        selectedIndex = 0
    }

}
