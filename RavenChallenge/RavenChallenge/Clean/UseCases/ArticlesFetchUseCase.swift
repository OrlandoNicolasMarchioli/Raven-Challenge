//
//  ArticlesFetchUseCase.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import Foundation

import Combine

protocol ArticlesFetchUseCase{
    func getArticlesByDateRange(range: String) -> AnyPublisher<[SelectedArticleData], Error>
}


class DefaultArticlesFetchUseCase: ArticlesFetchUseCase{

    private let articlesRepository: ArticlesRepository
    
    init(articlesRepository: ArticlesRepository) {
        self.articlesRepository = articlesRepository
    }
    
    func getArticlesByDateRange(range: String) -> AnyPublisher<[SelectedArticleData], Error> {
        return articlesRepository.fetchArticles(range: range).map{result in
            return result
        }.mapError{err in
            return err
        }
        .eraseToAnyPublisher()
    }
    
    
}
