//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import Foundation

protocol HomeDelegate: AnyObject {
    func refreshNews()
    func showError(_ error: NetworkError)

}

class HomeViewModel {
    weak var delegate: HomeDelegate?
    let httpClient: HTTPClient
    
    private(set) var articles = [ArticleElement]() {
        didSet {
            delegate?.refreshNews()
        }
    }
    
    private(set) var countArticle: Int?
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getNews() async{
        let url = Constants.baseURL!
        
        let queryItems = [
            URLQueryItem(name: "country", value: "tr"),
            URLQueryItem(name: "apiKey", value: Constants.apiKey)
        ]
        
        let resource = Resource(url: url, path: .headlines, method: .get(queryItems), modelType: Article.self)
        
        do{
            let articles = try await httpClient.load(resource)
            self.articles = articles.articles
            self.countArticle = articles.totalResults
            self.delegate?.refreshNews()
        } catch {
            self.delegate?.showError(error as! NetworkError)
        }
    }
    
    func searchNews(query: String?, fromDate: String?, toDate: String?) async {
        guard let question = query, question.count > 2 else { return }
        
        let url = Constants.baseURL
        
        let queryItems = [
            URLQueryItem(name: "sortBy", value: "latest"),
            URLQueryItem(name: "apiKey", value: Constants.apiKey),
            URLQueryItem(name: "q", value: question),
            URLQueryItem(name: "from", value: fromDate),
            URLQueryItem(name: "to", value: toDate),
        ]
        
        let resource = Resource(url: Constants.baseURL!, path: .everything, method: .get(queryItems), modelType: Article.self)
        
        do{
            let articles = try await httpClient.load(resource)
            self.articles = articles.articles
            self.countArticle = articles.totalResults
            self.delegate?.refreshNews()
        } catch {
            self.delegate?.showError(error as! NetworkError)
        }
    }
}
