//
//  FavoritesViewModelTest.swift
//  NewsAppTests
//
//  Created by Metehan Gürgentepe on 1.09.2024.
//

import XCTest
@testable import NewsApp

final class FavoritesViewModelTest: XCTestCase {
    var viewModel: FavoritesViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = FavoritesViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    
    //add fav news
    func test_getNews() async throws {
            
        let news = ArticleElement(author: nil, title: "title", url: "", urlToImage: nil, publishedAt: "", content: "")
        try UserDefaultsManager.shared.addToFav(news: news)
        
        
        await viewModel.getNews()
        
        let newsArr = viewModel.articles
        
        XCTAssert(newsArr.count > 0)
    }

}
