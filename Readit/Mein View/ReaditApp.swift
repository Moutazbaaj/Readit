//
//  ReaditApp.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI
import FirebaseCore

@main
struct ReaditApp: App {
    @StateObject private var authViewModel = AuthViewModel()  // Shared instance of AuthViewModel

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
    
        WindowGroup {
            MainContentView()
                .environmentObject(authViewModel)
        }
    }
}
