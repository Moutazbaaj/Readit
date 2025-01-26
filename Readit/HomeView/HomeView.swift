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
    
//    @State private var searchQuery = "" // State for search input

//    private var filteredLibraries: [FireLibrary] {
//         if searchQuery.isEmpty {
//             return viewModel.libreries
//         } else {
//             return viewModel.libreries.filter { $0.libraryTitle.localizedCaseInsensitiveContains(searchQuery) }
//         }
//     }
    
    
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
            .blur(radius: animateText ? 10 : 0) // Add blur effect during animation
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Divider()
                    .hidden()
                
//                Text("Hello, \(authViewModel.user?.username ?? "User")")
                Text("Hello")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .scaleEffect(animateText ? 1 : 0.3) // Start from smaller size and scale up
                    .opacity(animateText ? 1 : 0) // Start with opacity 0 and fade in
                    .onAppear {
                        // Trigger the animation when the view appears
                        withAnimation(.easeOut(duration: 2)) {
                            animateText = true
                        }
                    }
                
                VStack {
                    
                    // Search bar
                    
//                    HStack {
//                        TextField("Search libraries...", text: $searchQuery)
//                            .padding()
//                            .background(Color.black.opacity(0.4))
//                            .cornerRadius(10)
//                            .shadow(radius: 2)
//                        Spacer()
//                    }
                    
                    HStack {
                        Text("last Books")
                            .padding(.top)
                        Spacer()
                    }
                    
                    if viewModel.libreries.isEmpty {
                        HStack {
                            Spacer()
                            Text("Your Have no Books")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                            Spacer()
                        }
                    } else {
                        
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
                        .padding(.horizontal, 2)
                    }

                    VStack {
                        // Content above the scroll view
                        HStack {
                            Text("Favorites")
                            Spacer()
                        }
                        HStack {
                            Text("\(viewModel.favLibreries.count) items ")
                                .font(.caption2)
                            Spacer()
                        }
                        
                        ZStack {
                            // ScrollView with favorite libraries
                            ScrollView(.vertical, showsIndicators: false) {
                                if viewModel.favLibreries.isEmpty {
                                    Text("Your Have no Favorites")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                        .padding()
                                } else {
                                    Divider().hidden()
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
                        }
                    }
                }
                .padding()
            }
        }
        .onTapGesture {
            if hideButton {
                withAnimation {
                    hideButton = false // Hide the buttons when tapped outside
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
