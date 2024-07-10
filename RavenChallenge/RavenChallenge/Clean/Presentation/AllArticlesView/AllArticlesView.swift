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
    @State var filterName: String = "1"
    @State var apiError: Bool = false
    let with = UIScreen.main.bounds.size.width
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                VStack (alignment: .center){
                    HStack {
                        Image("newYorkTimesLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 250)
                    }
                }
                .padding(.top, -100)
                .padding(.bottom, -100)
                
                HStack(alignment: .top) {
                    Menu {
                        Button(action: {
                            filterName = "1"
                            allArticlesViewModel.fetchArticlesByRange(range: "1")
                        }) {
                            Text("1 day")
                        }
                        Button(action: {
                            filterName = "7"
                            allArticlesViewModel.fetchArticlesByRange(range: "7")
                        }) {
                            Text("7 days")
                        }
                        Button(action: {
                            filterName = "30"
                            allArticlesViewModel.fetchArticlesByRange(range: "30")
                        }) {
                            Text("30 days")
                        }
                    } label: {
                        Label("Select date range", systemImage: "line.horizontal.3.decrease.circle")
                            .labelStyle(TitleOnlyLabelStyle())
                            .bold()
                    }
                    .foregroundColor(.black)
                    .padding(.bottom)
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                }
                
                if (!apiError && !noArticlesFound) {
                    ScrollView {
                        Grid(alignment: .center, horizontalSpacing: 20, verticalSpacing: 10) {
                            ForEach(allArticlesViewModel.state.articles) { article in
                                NavigationLink(destination: ArticleDetailView(article: article, with: Int(with))) {
                                    ArticleCellChip<SelectedArticleData>(
                                        item: article,
                                        getArticleImageUrl: {
                                            if (with < 210) {
                                                $0.thumbnailUrl
                                            } else if (with < 440) {
                                                $0.mediumUrl
                                            } else {
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
                
                if (noArticlesFound && !apiError) {
                    Spacer()
                    NoArticlesFoundView(message: "No articles found")
                    Spacer()
                }else if (apiError){
                    Spacer()
                    NoArticlesFoundView(message: "We have some issues now, please try later")
                    Spacer()
                }
            }
            .onAppear {
                allArticlesViewModel.fetchArticlesByRange(range: filterName)
            }
            .onReceive(self.allArticlesViewModel.$state) { state in
                noArticlesFound = state.noProductsFound
                if(state.hasError && state.noProductsFound){
                    apiError = true
                }else{
                    apiError = false
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    AllArticlesView()
}
