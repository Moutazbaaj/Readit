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
    
    @State private var hideButton = false
    
    
    // Define the grid layout with two columns.
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    
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
                    LazyHStack(spacing: 5) {
                        ForEach(viewModel.libreries.sorted(by: {
                            $0.timestamp.dateValue() > $1.timestamp.dateValue()
                        }).prefix(6)) { library in
                            NavigationLink(destination: TextsListView(library: library)) {
                                HomeCard(library: library)
                                    .frame(width: 110, height: 110)
                            }
                        }
                    }
                    .padding(.horizontal, 1)
                }
                .frame(height: 110)
                
                
                VStack {
                    HStack {
                        Text("Favorites")
                        Spacer()
                    }
                    
                    HStack {
                        
                        Text("\(viewModel.favLibreries.count) items ")
                            .font(.caption2)
                        Spacer()
                    }
                }
                .padding()
                
                if viewModel.favLibreries.isEmpty {
                    Text("Your Have no Favorites")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        Divider()
                            .hidden()
                        
                        LazyVGrid(columns: gridItems, spacing: 20) {
                            ForEach(viewModel.favLibreries.sorted(by: {
                                $0.editTimestamp?.dateValue() ?? Date() > $1.editTimestamp?.dateValue() ?? Date()
                            })) { library in
                                NavigationLink(destination: TextsListView(library: library)) {
                                    LibraryCard(library: library)
                                        .frame(width: 175, height: 170)
                                }
                            }
                        }
                    }
                }
                Spacer()
                
                // Show navigation buttons if hideButton is true
                if hideButton {
                        VStack {
                            // First Navigation Button
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
                            
                            // Second Navigation Button
                            NavigationLink(destination: ImageRecognitionView()) {
                                VStack {
                                    Image(systemName: "photo.badge.plus.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                    Text("Image Recognition")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                .padding()
                            }
                            
                        }
                    .transition(.scale) // Smooth animation when appearing/disappearing
                    .padding()
                }
                
                // Floating button at the bottom
                VStack {
                    Button(action: {
                        withAnimation {
                            hideButton.toggle()
                        }
                    }) {
                        Image(systemName: "plus.circle.dashed")
                            .font(.largeTitle)
                            .foregroundColor(.white) // Icon color
                            .shadow(color: .black.opacity(0.3), radius: 10) // Subtle shadow
                            .background(
                                Circle()
                                    .fill(Color.clear) // Fully transparent background
                                    .frame(width: 70, height: 70)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1) // Transparent border
                                    )
                            )
                    }
                    .padding(.bottom, 20) // Space from the bottom of the screen
                }            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
