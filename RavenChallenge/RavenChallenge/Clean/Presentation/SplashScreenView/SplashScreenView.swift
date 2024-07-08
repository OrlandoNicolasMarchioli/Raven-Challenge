//
//  SplashScreenView.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack{
            VStack{
                Image("spashScreenImage")
                    .resizable()
                    .frame(maxWidth: 350,maxHeight: 350)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
