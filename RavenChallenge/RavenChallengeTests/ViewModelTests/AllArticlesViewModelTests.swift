//
//  ArticleViewModelTests.swift
//  RavenChallengeTests
//
//  Created by Nico on 10/07/2024.
//

import XCTest
import Combine
@testable import RavenChallenge

import XCTest
import Combine
@testable import RavenChallenge

class AllArticlesViewModelTests: XCTestCase {
    
    var viewModel: AllArticlesViewModel!
    var mockUseCase: MockArticlesFetchUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockArticlesFetchUseCase()
        viewModel = AllArticlesViewModel(articlesFetchUseCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchArticlesSuccess() {
        // Given
        let articles = [
            SelectedArticleData(id: 1, thumbnailUrl: "thumb1", mediumUrl: "medium1", largeUrl: "large1", title: "Title 1", abstract: "Abstract 1", date: "2023-07-07", source: "Source 1", byline: "Byline 1"),
            SelectedArticleData(id: 2, thumbnailUrl: "thumb2", mediumUrl: "medium2", largeUrl: "large2", title: "Title 2", abstract: "Abstract 2", date: "2023-07-08", source: "Source 2", byline: "Byline 2")
        ]
        mockUseCase.articles = articles
        
        // When
        let expectation = self.expectation(description: "Fetch articles success")
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                // Then
                XCTAssertEqual(state.articles.count, 2)
                XCTAssertEqual(state.articles.first?.title, "Title 1")
                XCTAssertFalse(state.noProductsFound)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchArticlesByRange(range: "7")
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchArticlesFailure() {
        // Given
        mockUseCase.shouldReturnError = true
        
        // When
        let expectation = self.expectation(description: "Fetch articles failure")
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                // Then
                XCTAssertTrue(state.hasError)
                XCTAssertTrue(state.articles.isEmpty)
                XCTAssertTrue(state.noProductsFound)
                XCTAssertEqual(state.errorMessage, "The operation couldn’t be completed. (TestError error 1.)")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchArticlesByRange(range: "7")
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchArticlesEmpty() {
        // Given
        mockUseCase.articles = []
        
        // When
        let expectation = self.expectation(description: "Fetch articles empty")
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                // Then
                XCTAssertTrue(state.articles.isEmpty)
                XCTAssertTrue(state.noProductsFound)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchArticlesByRange(range: "7")
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
