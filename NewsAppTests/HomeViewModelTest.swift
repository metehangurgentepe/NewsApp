//
//  HomeViewModelTest.swift
//  NewsAppTests
//
//  Created by Metehan Gürgentepe on 1.09.2024.
//

import XCTest
@testable import NewsApp

final class HomeViewModelTest: XCTestCase {
    
    var viewModel: HomeViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = HomeViewModel(httpClient: HTTPClient(session: .shared))
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func test_getNews_shouldCountIs20() async throws {
        // Beklenen sonuçları belirleyin
        let expectedNewsCount = 20 // Örnek olarak 10 haber bekleniyor
        
        // Asenkron metodu çağırın
        await viewModel.getNews()
        
        // Test assertion: Beklenen ile gerçek değerleri karşılaştırın
        XCTAssertEqual(viewModel.articles.count, expectedNewsCount, "Fetched news count should match the expected count.")
    }
    
    func test_searchNews_searchOnlyQuery() async throws {
        let query = "Technology"
        
        await viewModel.searchNews(query: query, fromDate: nil, toDate: nil)
        
        XCTAssertTrue(viewModel.articles.count > 0, "All fetched articles should relate to the query.")
    }
    
    func test_searchNews_searchQueryWithDates() async throws {
        let query = "Apple"
        
        let fromDate = Date().formatDate()
        let toDate = "2024-08-28"
        
        await viewModel.searchNews(query: query, fromDate: fromDate, toDate: toDate)
        
        XCTAssertTrue(viewModel.articles.count > 0, "All fetched articles should relate to the query and dates.")
    }
    
    func test_QueryCount() async throws {
        let query = "Ap"
        
        let fromDate = Date().formatDate()
        let toDate = "2024-08-28"
        
        await viewModel.searchNews(query: query, fromDate: fromDate, toDate: toDate)
        
        XCTAssertTrue(viewModel.articles.count == 0, "To test if the number of query letters is less than three")
    }
    
}
