//
//  NoArticlesFoundView.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import SwiftUI

struct NoArticlesFoundView: View {
    var body: some View {
        ZStack{
            VStack{
                Image(systemName: "message")
                    .resizable()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .foregroundColor(Color.red)
                Text("No articles found")
                    .foregroundColor(Color.red)
                    .bold()
            }
        }
    }
}

#Preview {
    NoArticlesFoundView()
}
