//
//  RavenChallengeApp.swift
//  RavenChallenge
//
//  Created by Nico on 08/07/2024.
//

import SwiftUI

@main
struct RavenChallengeApp: App {
    @StateObject var navigationManager = NavigationManager.shared()
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                switch navigationManager.state{
                case .allArticles:
                    MainView()
                case .splash:
                    SplashScreenView()
                case .admin:
                    EmptyView()
                case .user:
                    EmptyView()
                }
            }.onAppear(){
                if(navigationManager.state == .splash){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        navigationManager.onAppInit()
                    }
                }else{
                    navigationManager.onAppInit()
                }
            }
        }
    }
}
