//
//  ArticlesRepository.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import Foundation
import Combine

protocol ArticlesRepository{
    func fetchArticles(range: String) -> AnyPublisher<[SelectedArticleData], FetchError>
}

class ArticlesApiFetch: ArticlesRepository{
    private var articlesApi: ArticlesApiProtocol
    
    init(articlesApi: ArticlesApiProtocol) {
        self.articlesApi = articlesApi
    }
    
    func fetchArticles(range: String) -> AnyPublisher<[SelectedArticleData], FetchError> {
        return Future<[SelectedArticleData], Error>{ [self] promise in
            
            self.articlesApi.getAllArticles(range: range){ (response, err) in
                guard let response = response, err == nil else{
                    promise(.failure(FetchError.getArticlesError))
                    return
                }
                promise(.success(mapJSONToSelectedArticleData(json: response)))
            }
            
        }
        .mapError { _ in FetchError.getArticlesError }
        .eraseToAnyPublisher()
    }
    
    
}

func mapJSONToSelectedArticleData(json: [String: Any?]) -> [SelectedArticleData] {
    guard let results = json["results"] as? [[String: Any]] else {
        return []
    }
    
    var articles: [SelectedArticleData] = []
    
    for result in results {
        if let id = result["id"] as? Int,
           let title = result["title"] as? String,
           let abstract = result["abstract"] as? String,
           let date = result["published_date"] as? String,
           let source = result["source"] as? String,
           let byline = result["byline"] as? String,
           let media = result["media"] as? [[String: Any]],
           let firstMedia = media.first,
           let mediaMetadata = firstMedia["media-metadata"] as? [[String: Any]] {
            
            var thumbnailUrl = ""
            var mediumUrl = ""
            var largeUrl = ""
            
            for metadata in mediaMetadata {
                if let url = metadata["url"] as? String,
                   let format = metadata["format"] as? String {
                    switch format {
                    case "Standard Thumbnail":
                        thumbnailUrl = url
                    case "mediumThreeByTwo210":
                        mediumUrl = url
                    case "mediumThreeByTwo440":
                        largeUrl = url
                    default:
                        break
                    }
                }
            }
            
            if !thumbnailUrl.isEmpty && !mediumUrl.isEmpty && !largeUrl.isEmpty {
                let product = SelectedArticleData(
                    id: id,
                    thumbnailUrl: thumbnailUrl,
                    mediumUrl: mediumUrl,
                    largeUrl: largeUrl,
                    title: title,
                    abstract: abstract,
                    date: date,
                    source: source,
                    byline: byline
                )
                
                articles.append(product)
            }
        }
    }
    
    
    return articles
}
