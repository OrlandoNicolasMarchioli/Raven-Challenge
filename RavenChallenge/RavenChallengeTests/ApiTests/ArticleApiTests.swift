//
//  ArticleApiTests.swift
//  RavenChallengeTests
//
//  Created by Nico on 10/07/2024.
//

import Foundation
import XCTest
@testable import RavenChallenge

class ArticleApiTests: XCTestCase {
    var api: ArticleApi!

    override func setUpWithError() throws {
        api = ArticleApi(baseUrl: ProcessInfo.processInfo.environment["baseUrl"] ?? "",
                         apiKey: ProcessInfo.processInfo.environment["apiKey"] ?? "",
                         cacheKey:  ProcessInfo.processInfo.environment["cacheKey"] ?? "")
    }

    func testGetAllProducts() {
        // Given
        let productName = "testProduct"

        // When
        api.getAllArticles(range: "1") { result, error in
            // Then
            if let result = result {
                print("Response: \(result)")
                XCTAssertNotNil(result)
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                XCTFail("Failed to fetch products")
            }
        }
    }
}
