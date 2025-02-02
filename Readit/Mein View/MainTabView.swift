//
//  MainTabView.swift
//  FireText warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import SwiftUI

struct MainTabView: View {
    @State var selected = 0
    @State var hideButton = false
    
    var body: some View {
//        ZStack() {  // Ensures no gaps between views
//            
//            // Main View Switching Logic
//            VStack {
//                switch selected {
//                case 0:
//                    NavigationStack { HomeView() }
//                case 1:
//                    NavigationStack { TextToSpeechView() }
//                case 2:
//                    NavigationStack { ImageRecognitionView() }
//                case 3:
//                    NavigationStack { CollectionView() }
//                case 5:
//                    NavigationStack { ProfileView() }
//                default:
//                    NavigationStack { HomeView() }
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)  // Ensures the content takes full available space
//            .ignoresSafeArea(.all, edges: .top) // Only ignore safe area at the top if needed
//            
//            // Floating Tab Bar
//            FloatingTabbar(selected: self.$selected)
//                .padding(.bottom, 10)  // Adds space at the bottom for safe area
//        }
        TabView {
            // Home Tab
            NavigationStack {
                ZStack {
                    HomeView() // The main home view will go here
                    VStack {
                        Spacer()
                        // Navigation buttons shown when `hideButton` is true
                        if hideButton {
                            VStack {
                                // Navigation Buttons
                                NavigationLink(destination: TextToSpeechView()) {
                                    VStack {
                                        Image(systemName: "bubble.and.pencil")
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .shadow(radius: 10)
                                        Text("Text to Speech")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                }
                                NavigationLink(destination: ImageRecognitionView()) {
                                    VStack {
                                        Image(systemName: "photo.badge.plus.fill")
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .shadow(radius: 10)
                                        Text("Text Recognition")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                }
                            }
                            .transition(.scale) // Smooth animation when appearing/disappearing
                            .padding() // Space from the bottom
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0.7)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .cornerRadius(30)
                                .padding()
                            )
                        }

                        // Floating button at the bottom
                        Button(action: {
                            withAnimation {
                                hideButton.toggle()
                            }
                        }) {
                            Image(systemName: "plus.circle.dashed")
                                .font(.largeTitle)
                                .foregroundColor(.white) // Icon color
                                .shadow(color: .black.opacity(0.5), radius: 10) // Subtle shadow
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.3)) // Fully transparent background
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1) // Transparent border
                                        )
                                )
                        }
                        .padding(.bottom, -2)
                    }
                }
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
//        .edgesIgnoringSafeArea(.bottom) // Ensures tab bar doesn’t collide with home indicator
    }
}



