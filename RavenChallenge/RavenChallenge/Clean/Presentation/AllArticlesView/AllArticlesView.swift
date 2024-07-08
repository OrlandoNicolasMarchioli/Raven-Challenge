//
//  AllArticlesView.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import SwiftUI

struct AllArticlesView: View {
    @ObservedObject var allArticlesViewModel = AllArticlesViewModel()
    
    @State var noArticlesFound = true
    let imageBaseURL: String = ProcessInfo.processInfo.environment["baseImageUrl"] ?? ""
    @State var filterName: String = ""
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    VStack(alignment: .center) {
                        VStack(alignment: .trailing){
                            HStack {
                                TextField("Search articles: ", text: $filterName)
                                    .foregroundColor(Color.black)
                                    .frame(minWidth: 100)
                                    .padding(.leading)
                                
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color.red)
                                        .bold()
                                        .padding(.trailing)
                                }.padding()
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.red, lineWidth: 2)
                            )
                            
                        }
                        .frame(width: geometry.size.width)
                        .padding(.top)
                        
                        if (noArticlesFound){
                            Spacer()
                            NoArticlesFoundView()
                            Spacer()
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
