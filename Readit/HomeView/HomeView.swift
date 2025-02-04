//
//  HomeView.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var animateText = false // State to control animation
    
    @StateObject private var viewModel = CollectionViewModel.shared
    
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    // Define the grid layout with two columns.
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
//    @State var hideButton = false
    
    @State private var showSheet = false // Controls sheet visibility


    
    
    var body: some View {
        ZStack {
            // Animated background gradient
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                ScrollView (.vertical, showsIndicators: false) {
                    VStack {
                        
                        HStack {
                            Text("last collections")
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        
                        if viewModel.libreries.isEmpty {
                            HStack {
                                Spacer()
                                Image(systemName: "bookmark.slash")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                    .padding()
                                Text("There is no collections yet")
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
                            .frame(height: 160)
                            .padding(.horizontal, 2)
                        }
                        
                        VStack {
                            // Content above the scroll view
                            HStack {
                                Text("Favorites")
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            HStack {
                                Text("\(viewModel.favLibreries.count) items ")
                                    .font(.caption2)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            if viewModel.favLibreries.isEmpty {
                                
                                Spacer()
                                
                                Image(systemName: "star.slash")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                    .padding()
                                Text("Your Have no Favorites")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding()
                                
                                Spacer()
                                
                            } else {
                                
                                Divider().hidden()
                                LazyVGrid(columns: gridItems, spacing: 20) {
                                    ForEach(viewModel.favLibreries.sorted(by: {
                                        $0.editTimestamp?.dateValue() ?? Date() > $1.editTimestamp?.dateValue() ?? Date()
                                    })) { library in
                                        NavigationLink(destination: TextsListView(library: library)) {
                                            CollectionCard(library: library)
                                                .frame(width: 175, height: 170)
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
//                    Divider().hidden().padding(.bottom).padding()
                }
                Divider().hidden()
            }
//            VStack {
//                Spacer()
//                if hideButton {
//                    VStack {
//                        // Navigation Buttons
//                        NavigationLink(destination: TextToSpeechView()) {
//                            VStack {
//                                Image(systemName: "bubble.and.pencil")
//                                    .font(.title)
//                                    .foregroundColor(.white)
//                                    .shadow(radius: 10)
//                                Text("Text to Speech")
//                                    .font(.caption)
//                                    .foregroundColor(.white)
//                            }
//                            .padding()
//                        }
//                        NavigationLink(destination: ImageRecognitionView()) {
//                            VStack {
//                                Image(systemName: "photo.badge.plus.fill")
//                                    .font(.title)
//                                    .foregroundColor(.white)
//                                    .shadow(radius: 10)
//                                Text("Text Recognition")
//                                    .font(.caption)
//                                    .foregroundColor(.white)
//                            }
//                            .padding()
//                        }
//                    }
//                    .transition(.scale) // Smooth animation when appearing/disappearing
//                    .padding() // Space from the bottom
//                    .background(
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0.7)]),
//                            startPoint: .top,
//                            endPoint: .bottom
//                        )
//                        .cornerRadius(30)
//                        .padding()
//                    )
//                }
//            }
        }
//        .onTapGesture {
//            hideButton = false
//        }
        .navigationBarItems(leading: HStack {
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
                .padding(.bottom)
                .padding(.top)
            Spacer()
                })
        .navigationBarItems(trailing: HStack {
            Button("", systemImage: "plus.circle") {
//                hideButton.toggle()
                showSheet = true
            }
//            Spacer()
//            //History
//            NavigationLink(destination: HistoryView()) {
//                Image(systemName: "clock")
//                    .foregroundColor(.white)
//                    .padding()
//            }
        })
        .sheet(isPresented: $showSheet){
            SheetView()
                .presentationDetents([.large])
                .presentationCornerRadius(30)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}

