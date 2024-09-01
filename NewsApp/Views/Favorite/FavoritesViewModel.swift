//
//  FavoritesViewModel.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import Foundation

protocol FavoritesDelegate: AnyObject {
    func showError(_ error: NetworkError)
    func reloadFavoritesTable()
}

class FavoritesViewModel {
    weak var delegate: FavoritesDelegate?
    
    private(set) var articles = [ArticleElement]() {
        didSet {
            delegate?.reloadFavoritesTable()
        }
    }
    
    func getNews() async{
        do{
            if let articles = try UserDefaultsManager.shared.getFavNews() {
                self.articles = articles
            }
        } catch {
            self.delegate?.showError(error as! NetworkError)
        }
    }
}
