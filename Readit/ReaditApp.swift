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
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                ContentView()
                    .tabItem {
                        Label("View2", systemImage: "gear")
                    }
            }
        }
    }
}
