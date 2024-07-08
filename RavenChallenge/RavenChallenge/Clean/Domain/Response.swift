//
//  Response.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import Foundation

struct Response: Codable {
    let status: String
    let copyright: String
    let numResults: Int
    let results: [ArticleData]

    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case numResults = "num_results"
        case results
    }
}
