//
//  MainTabView.swift
//  FireText warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        ZStack {
            TabView {
                // Home Tab
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                
                // Library Tab
                NavigationStack {
                    CollectionView()
                }
                .tabItem {
                    Label("Collections", systemImage: "books.vertical")
                }
                
                // Scan Tab
                NavigationStack {
                    HistoryView()
                }
                .tabItem {
                    Label("History", systemImage: "document.viewfinder.fill")
                }
                
                // Settings Tab
                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle")
                }
            }
            .tint(.white)
        }
    }
}



