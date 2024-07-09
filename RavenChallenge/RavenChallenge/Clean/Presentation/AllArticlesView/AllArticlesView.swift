//
//  AllArticlesView.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import SwiftUI

struct AllArticlesView: View {
    @ObservedObject var allArticlesViewModel = AllArticlesViewModel(articlesFetchUseCase: DefaultArticlesFetchUseCase(articlesRepository: ArticlesApiFetch(articlesApi: ArticleApi.getInstance())))
    
    @State var noArticlesFound = false
    let imageBaseURL: String = ProcessInfo.processInfo.environment["baseImageUrl"] ?? ""
    @State var filterName: String = ""
    let with = UIScreen.main.bounds.size.width
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    VStack(alignment: .center) {
                        VStack() {
                            Image("newYorkTimesLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 250)
                        }
                        .padding(.top, -100)
                        .padding(.bottom, -100)
                        
                        if (!allArticlesViewModel.state.noProductsFound) {
                            ScrollView {
                                Grid(alignment: .center, horizontalSpacing: 20, verticalSpacing: 10) {
                                    ForEach(allArticlesViewModel.state.articles) { article in
                                        NavigationLink(destination: Text("Detail View")) {
                                            ArticleCellChip<SelectedArticleData>(
                                                item: article,
                                                getArticleImageUrl: {
                                                    if(with < 210){
                                                        $0.thumbnailUrl
                                                    }
                                                    else if( with < 440 ){
                                                        $0.mediumUrl
                                                    }else{
                                                        $0.largeUrl
                                                    }
                                                },
                                                getArticleTitle: { $0.title },
                                                getArticleAbstract: { $0.abstract },
                                                getArticleDate: { $0.date },
                                                getArticleSource: { $0.source },
                                                getArticleByline: { $0.byline },
                                                onChipTapped: {}
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (noArticlesFound) {
                            Spacer()
                            NoArticlesFoundView()
                            Spacer()
                        }
                    }.onAppear(){
                        allArticlesViewModel.fetchArticlesByRange(range: "1")
                    }.onReceive(self.allArticlesViewModel.$state){state in
                        if(state.noProductsFound){
                            noArticlesFound = true
                        }else{
                            noArticlesFound = false
                        }
                    }
                }
            }
        }
    }
    
}

#Preview {
    AllArticlesView()
}
