//
//  AllArticlesState.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import Foundation

struct AllArticlesState{
    
    let articles: [SelectedArticleData]
    let errorMessage: String
    let message: String
    let hasError: Bool
    let noProductsFound: Bool
    
    func clone(articlesFetched: [SelectedArticleData]? = nil, withErrorMessage: String? = nil, withMessage: String? = nil, withHasError: Bool? = false, withNoProductsFound: Bool? = false) -> AllArticlesState{
        return  AllArticlesState(articles: articlesFetched ?? self.articles,errorMessage: withErrorMessage ?? self.errorMessage, message: withMessage ?? self.message, hasError: withHasError ?? self.hasError, noProductsFound: withNoProductsFound ?? self.noProductsFound)
    }
}
