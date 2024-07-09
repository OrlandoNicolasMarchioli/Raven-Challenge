//
//  ArticleDetailView.swift
//  RavenChallenge
//
//  Created by Nico on 09/07/2024.
//

import SwiftUI

struct ArticleDetailView: View {
    @State var article: SelectedArticleData
    var with: Int
    
    init(article: SelectedArticleData, with: Int) {
        self.article = article
        self.with = with
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                ZStack{
                    VStack{
                        ArticleDetailCellChip<SelectedArticleData>(item: article,
                                                                   getArticleImageUrl: {                                                     if(with < 210){
                                                                       $0.thumbnailUrl
                                                                   }
                                                                   else if( with < 440 ){
                                                                       $0.mediumUrl
                                                                   }else{
                                                                       $0.largeUrl
                                                                   } },
                                                                   getArticleTitle: { item in item.title }, getArticleAbstract: {item in item.abstract}
                                                                   ,
                                                                   getArticleDate: { item in item.date}
                                                                   ,
                                                                   getArticleSource: { item in item.source  }
                                                                   ,
                                                                   getArticleByline: { item in item.byline },
                                                                   onChipTapped: {
                        })
                    }
                }
            }
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailView(article: SelectedArticleData(id: 123,thumbnailUrl: "", mediumUrl: "",largeUrl: "https://static01.nyt.com/images/2023/06/22/well/well-sleep-age-topper/well-sleep-age-topper-mediumThreeByTwo210-v4.jpg", title: "How Biden Is Leveraging His Defiance to Try to Stem Democratic Defections", abstract: "President Biden is making it clear that he holds all the cards when determining his political future. Can he get his critics to fold?", date: "7-9-2024", source: "New York Times", byline: "Tom Brenner"), with: 170)
    }
}
