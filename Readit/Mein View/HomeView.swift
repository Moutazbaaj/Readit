//
//  HomeView.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var animateText = false // State to control animation
    
    @StateObject private var viewModel = LibraryViewModel.shared
    
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    // Define the grid layout with two columns.
    
    // Card dimensions
    let libraryCardWidth: CGFloat = 175
    let libraryCardHeight: CGFloat = 175
    
    var body: some View {
        ZStack {
            // Animated background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            .blur(radius: animateText ? 10 : 0) // Add blur effect during animation
            VStack {
                Text("Hello, \(authViewModel.user?.username ?? "User")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .scaleEffect(animateText ? 1 : 0.5) // Start from smaller size and scale up
                    .opacity(animateText ? 1 : 0) // Start with opacity 0 and fade in
                    .onAppear {
                        // Trigger the animation when the view appears
                        withAnimation(.easeOut(duration: 1)) {
                            animateText = true
                        }
                    }
                
                HStack {
                    Text("last Books")
                        .padding()
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(viewModel.libreries.sorted(by: {
                            $0.timestamp.dateValue() > $1.timestamp.dateValue()
                        }).prefix(5)) { library in
                            NavigationLink(destination: TextsListView(library: library)) {
                                LibraryCard(library: library)
                                    .frame(width: libraryCardWidth, height: libraryCardHeight)
                            }
                        }
                    }
                    .padding(.horizontal, 1)
                }
                .frame(height: libraryCardHeight)
                
                HStack {
                    Text("Favorites")
                        .padding()
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(viewModel.favLibreries.sorted(by: {
                            ($0.editTimestamp!.dateValue()) > ($1.editTimestamp!.dateValue())
                        })) { library in
                            NavigationLink(destination: TextsListView(library: library)) {
                                LibraryCard(library: library)
                                    .frame(width: libraryCardWidth, height: libraryCardHeight)
                            }
                        }
                    }
                    .padding(.horizontal, 1)
                }
                .frame(height: libraryCardHeight)
                Spacer()
                
                HStack {
                    // First navigation button
                    NavigationLink(destination: TextToSpeechView()) {
                        Image(systemName: "bubble.and.pencil")
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    
                    // Second navigation button
                    NavigationLink(destination: ImageRecognitionView()) {
                        Image(systemName: "photo.badge.plus.fill")
                            .font(.largeTitle)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                }
                
                
            }
            .padding()
            
        }
    }
}

#Preview {
    HomeView()
}
