//
//  ArticleDetailCell.swift
//  RavenChallenge
//
//  Created by Nico on 09/07/2024.
//

import SwiftUI

struct ArticleDetailCell: View {
    @State var article: SelectedArticleData
    
    var body: some View {
        HStack{
            
        }
    }
}

struct ArticleDetailCellChip<T>: View {
    let item: T
    let getArticleImageUrl: ((T) -> String)
    let getArticleTitle: ((T) -> String)
    let getArticleAbstract: ((T) -> String)
    let getArticleDate: ((T) -> String)
    let getArticleSource: ((T) -> String)
    let getArticleByline: ((T) -> String)
    let onChipTapped: (() -> Void)

    
    var body: some View {
        GeometryReader{ geometry in
            ScrollView {
                VStack(alignment: .leading){
                    Text(getArticleTitle(item))
                        .padding(.bottom, 0)
                        .padding(.leading,5)
                        .foregroundColor(Color.black)
                        .bold()
                        .font(.custom("Georgia", size: 22))
                        .padding(.bottom, 20)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                    
                    AsyncImage(url: URL(string: convertToSecureURL(getArticleImageUrl(item)))) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .scaleEffect(2.0, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 350)
                                .padding(.horizontal)
                                .cornerRadius(8)
                        case .failure:
                            SpinnerView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding()
                    HStack {
                        
                        VStack(alignment: .leading) {
                            
                            HStack(alignment: .center){
                                Text (getArticleDate(item))
                                    .foregroundColor(Color.gray)
                                    .bold()
                                    .font(.custom("Georgia", size: 12))
                                Spacer()
                                Text(getArticleByline(item) + " for " + getArticleSource(item))
                                    .foregroundColor(Color.gray)
                                    .bold()
                                    .font(.custom("Georgia", size: 12))
                            }
                            Text( (getArticleAbstract(item)))
                                .padding(.leading,5)
                                .padding(.top)
                                .foregroundColor(Color.black)
                                .font(.custom("Georgia", size: 16))
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                            
                        }
                    }
                }
                .onTapGesture {
                    onChipTapped()
                }
                .padding()
            }
        }
    }
}

private func convertToSecureURL(_ urlString: String) -> String {
    var secureURLString = urlString
    if urlString.hasPrefix("http://") {
        secureURLString = "https://" + urlString.dropFirst(7)
    }
    return secureURLString
}

struct ProductDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailCellChip<SelectedArticleData>(item: SelectedArticleData(id: 123,thumbnailUrl: "", mediumUrl: "",largeUrl: "https://static01.nyt.com/images/2023/06/22/well/well-sleep-age-topper/well-sleep-age-topper-mediumThreeByTwo210-v4.jpg", title: "How Biden Is Leveraging His Defiance to Try to Stem Democratic Defections", abstract: "President Biden is making it clear that he holds all the cards when determining his political future. Can he get his critics to fold?", date: "7-9-2024", source: "New York Times and Infobae", byline: "Tom Brenner"), getArticleImageUrl: {item in return item.largeUrl}, getArticleTitle: {item in return item.title}, getArticleAbstract: {item in return item.abstract}, getArticleDate: {item in return item.date}, getArticleSource: {item in return item.source}, getArticleByline: {item in return item.byline},onChipTapped: {} )
    }
}
