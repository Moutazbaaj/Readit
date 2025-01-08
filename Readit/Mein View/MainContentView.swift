//
//  MainContentView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isSplashScreenShown = true
    
    var body: some View {
        Group {
            if isSplashScreenShown {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isSplashScreenShown = false
                        }
                    }
            } else {
                if authViewModel.isUserLoggedIn {
                    MainTabView()
                    
                } else {
                    LoginView()
                }
                
            }
        }
    }
}
