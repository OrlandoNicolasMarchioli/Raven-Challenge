//
//  articleRepositoryTests.swift
//  RavenChallengeTests
//
//  Created by Nico on 10/07/2024.
//
import Foundation
import XCTest
import Combine
@testable import RavenChallenge

class ArticlesApiFetchTests: XCTestCase {
    
    var articlesApiFetch: ArticlesApiFetch!
    var mockArticlesApi: MockArticlesApi!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockArticlesApi = MockArticlesApi()
        articlesApiFetch = ArticlesApiFetch(articlesApi: mockArticlesApi)
        cancellables = []
    }
    
    override func tearDown() {
        articlesApiFetch = nil
        mockArticlesApi = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchArticlesSuccess() {
        // Given
        let jsonResponse: [String: Any] = [
            "status": "OK",
            "results": [
                [
                    "id": 100000008975663,
                    "title": "Sleep Better at Every Age",
                    "abstract": "Sleep needs shift throughout the lifespan. Experts offer tips to get more rest —  no matter how old you are.",
                    "published_date": "2023-07-07",
                    "source": "New York Times",
                    "byline": "By Dani Blum",
                    "media": [
                        [
                            "type": "image",
                            "media-metadata": [
                                [
                                    "url": "https://static01.nyt.com/images/2023/06/22/well/well-sleep-age-topper/well-sleep-age-topper-thumbStandard-v3.jpg",
                                    "format": "Standard Thumbnail"
                                ],
                                [
                                    "url": "https://static01.nyt.com/images/2023/06/22/well/well-sleep-age-topper/well-sleep-age-topper-mediumThreeByTwo210-v4.jpg",
                                    "format": "mediumThreeByTwo210"
                                ],
                                [
                                    "url": "https://static01.nyt.com/images/2023/06/22/well/well-sleep-age-topper/well-sleep-age-topper-mediumThreeByTwo440-v4.jpg",
                                    "format": "mediumThreeByTwo440"
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
        
        mockArticlesApi.response = jsonResponse
        
        // When
        let expectation = self.expectation(description: "Fetch articles success")
        
        articlesApiFetch.fetchArticles(range: "7").sink { completion in
            switch completion {
            case .failure(let error):
                XCTFail("Expected success but got error \(error)")
            case .finished:
                break
            }
        } receiveValue: { articles in
            // Then
            XCTAssertEqual(articles.count, 1)
            XCTAssertEqual(articles.first?.title, "Sleep Better at Every Age")
            expectation.fulfill()
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchArticlesFailure() {
        // Given
        mockArticlesApi.shouldReturnError = true
        
        // When
        let expectation = self.expectation(description: "Fetch articles failure")
        
        articlesApiFetch.fetchArticles(range: "7").sink { completion in
            switch completion {
            case .failure(let error):
                XCTAssertEqual(error, FetchError.getArticlesError)
                expectation.fulfill()
            case .finished:
                XCTFail("Expected failure but got success")
            }
        } receiveValue: { articles in
            XCTFail("Expected failure but got articles \(articles)")
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}


class MockArticlesApi: ArticlesApiProtocol {
    var shouldReturnError = false
    var response: [String: Any]?
    
    func getAllArticles(range: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        if shouldReturnError {
            completion(nil, NSError(domain: "TestError", code: 1, userInfo: nil))
        } else {
            completion(response, nil)
        }
    }
}
