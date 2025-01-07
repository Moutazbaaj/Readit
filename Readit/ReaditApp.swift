//
//  ReaditApp.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI

@main
struct ReaditApp: App {
    var body: some Scene {
        WindowGroup {
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
                    SettingsView()
                }
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle")
                }
            }
        }
    }
}
