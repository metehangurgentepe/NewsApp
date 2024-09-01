//
//  DetailNewsViewModel.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import Foundation


protocol DetailNewsDelegate: AnyObject {
    func loadViewDelegate()
    func refreshIcon()
    func showError(_ error: NetworkError)
}


class DetailNewsViewModel {
    weak var delegate: DetailNewsDelegate?
    private(set) var check: Bool =  false
    
    func checkIsFav(news: ArticleElement) {
        do{
            check = try UserDefaultsManager.shared.checkIsAddedToFav(news: news)
            self.delegate?.loadViewDelegate()
            self.delegate?.refreshIcon()
        } catch {
            self.delegate?.showError(error as! NetworkError)
        }
    }
    
    func addToFav(news: ArticleElement) {
        do{
            if check {
                try UserDefaultsManager.shared.removeToFav(news: news)
                check = false
            } else {
                try UserDefaultsManager.shared.addToFav(news: news)
                check = true
            }
            self.delegate?.refreshIcon()
        } catch {
            self.delegate?.showError(error as! NetworkError)
        }
    }
    
    
}
