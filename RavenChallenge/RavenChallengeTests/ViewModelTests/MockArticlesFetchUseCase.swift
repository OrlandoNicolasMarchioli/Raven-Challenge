//
//  MockArticlesFetchUseCase.swift
//  RavenChallengeTests
//
//  Created by Nico on 10/07/2024.
//

import Foundation
import Combine
@testable import RavenChallenge

class MockArticlesFetchUseCase: ArticlesFetchUseCase {
    var articles: [SelectedArticleData] = []
    var shouldReturnError = false
    
    func getArticlesByDateRange(range: String) -> AnyPublisher<[SelectedArticleData], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "TestError", code: 1, userInfo: nil))
                .eraseToAnyPublisher()
        } else {
            return Just(articles)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
