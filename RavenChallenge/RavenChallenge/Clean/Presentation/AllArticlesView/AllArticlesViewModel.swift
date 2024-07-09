//
//  AllArticlesViewModel.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import Foundation
import Combine
class AllArticlesViewModel: ObservableObject{
    @Published var state: AllArticlesState
    static let defaultState = AllArticlesState(articles: [], errorMessage: "", message: "", hasError: false, noProductsFound: true)
    private let articlesFetchUseCase: DefaultArticlesFetchUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    init(initialState: AllArticlesState = defaultState, articlesFetchUseCase: DefaultArticlesFetchUseCase) {
        self.state = initialState
        self.articlesFetchUseCase = articlesFetchUseCase
    }

    func fetchArticlesByRange(range: String) -> Void{
        articlesFetchUseCase.getArticlesByDateRange(range: range)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        self?.state = (self?.state.clone(articlesFetched: [], withErrorMessage: error.localizedDescription, withMessage: "", withHasError: true, withNoProductsFound: true))!
                    }
                }
            },
                  receiveValue: {
                articles in DispatchQueue.main.async{
                    if(articles.isEmpty){
                        self.state = self.state.clone(withNoProductsFound: true)
                    }else{
                        self.state = self.state.clone(articlesFetched: articles,withNoProductsFound: false)
                    }
                }
            })
            .store(in: &cancellables)
    }
}
