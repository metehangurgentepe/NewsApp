//
//  DetailNewsViewModelTest.swift
//  NewsAppTests
//
//  Created by Metehan Gürgentepe on 1.09.2024.
//

import XCTest
@testable import NewsApp

final class DetailNewsViewModelTest: XCTestCase {
    var viewModel: DetailNewsViewModel!
    var mockDelegate: MockDetailNewsDelegate!
    var mockArticle: ArticleElement!
    
    override func setUpWithError() throws {
        super.setUp()
        viewModel = DetailNewsViewModel()
        mockDelegate = MockDetailNewsDelegate()
        viewModel.delegate = mockDelegate
        
        mockArticle = ArticleElement(
            author: "Test Author",
            title: "Test Title",
            url: "https://www.example.com",
            urlToImage: "https://www.example.com/image.jpg",
            publishedAt: "2024-09-01T12:00:00Z",
            content: "Test Content"
        )
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockDelegate = nil
        mockArticle = nil
        super.tearDown()
    }
    
    func test_checkIsFav_shouldUpdateCheckAndCallDelegateMethods() {
        
        XCTAssertNoThrow(try UserDefaultsManager.shared.addToFav(news: mockArticle))
        
        viewModel.checkIsFav(news: mockArticle)
        
        XCTAssertTrue(viewModel.check, "Check should be true for a favorite article.")
        XCTAssertTrue(mockDelegate.didCallLoadViewDelegate, "loadViewDelegate should be called.")
        XCTAssertTrue(mockDelegate.didCallRefreshIcon, "refreshIcon should be called.")
    }
    
    func test_addToFav_shouldAddAndRemoveFromFavorites() {
        // Act: Try to add to favorites
        viewModel.addToFav(news: mockArticle)
        
        // Assert: Check that the article was added
        XCTAssertTrue(viewModel.check, "Check should be true after adding to favorites.")
        XCTAssertTrue(mockDelegate.didCallRefreshIcon, "refreshIcon should be called after adding to favorites.")
        
        // Act: Try to remove from favorites
        viewModel.addToFav(news: mockArticle)
        
        // Assert: Check that the article was removed
        XCTAssertFalse(viewModel.check, "Check should be false after removing from favorites.")
        XCTAssertTrue(mockDelegate.didCallRefreshIcon, "refreshIcon should be called after removing from favorites.")
    }
    
    func test_checkIsFav_shouldShowErrorOnFailure() {
        // Arrange: Use a non-favorite article and simulate an error
        mockArticle = ArticleElement(
            author: "Invalid Author",
            title: "Invalid Title",
            url: "https://www.invalid.com",
            urlToImage: "https://www.invalid.com/image.jpg",
            publishedAt: "Invalid Date",
            content: "Invalid Content"
        )
        
        // Act: Perform the operation you want to test
        viewModel.checkIsFav(news: mockArticle)
        
        // Assert: Check that the operation had the expected result
        XCTAssertFalse(viewModel.check, "Check should be false for a non-favorite article.")
        XCTAssertFalse(mockDelegate.didCallShowError, "showError should be called on failure.")
    }
}


class MockDetailNewsDelegate: DetailNewsDelegate {
    var didCallLoadViewDelegate = false
    var didCallRefreshIcon = false
    var didCallShowError = false
    
    func loadViewDelegate() {
        didCallLoadViewDelegate = true
    }
    
    func refreshIcon() {
        didCallRefreshIcon = true
    }
    
    func showError(_ error: NetworkError) {
        didCallShowError = true
    }
}

