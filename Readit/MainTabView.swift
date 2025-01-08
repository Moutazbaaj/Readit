//
//  MainTabView.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
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
                LibraryView()
            }
            .tabItem {
                Label("My Library", systemImage: "books.vertical")
            }

            // Settings Tab
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("More", systemImage: "ellipsis.circle")
            }
        }
    }
}
