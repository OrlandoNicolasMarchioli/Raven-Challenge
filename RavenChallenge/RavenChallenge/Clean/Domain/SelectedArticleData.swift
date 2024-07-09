//
//  SelectedArticleData.swift
//  RavenChallenge
//
//  Created by Nico on 09/07/2024.
//

import Foundation

struct SelectedArticleData: Identifiable{
    let id: Int
    let thumbnailUrl: String
    let mediumUrl: String
    let largeUrl: String
    let title: String
    let abstract: String
    let date: String
    let source: String
    let byline: String
}
