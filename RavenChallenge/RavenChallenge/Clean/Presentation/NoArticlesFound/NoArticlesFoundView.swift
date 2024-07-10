//
//  NoArticlesFoundView.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import SwiftUI

struct NoArticlesFoundView: View {
    var message: String
    
    init(message: String) {
        self.message = message
    }
    
    var body: some View {
        ZStack{
            VStack{
                Image(systemName: "message")
                    .resizable()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .foregroundColor(Color("backgroundLogoGray"))
                Text(message)
                    .foregroundColor(Color("backgroundLogoGray"))
                    .bold()
            }
        }
    }
}

#Preview {
    NoArticlesFoundView(message: "No articles found")
}
