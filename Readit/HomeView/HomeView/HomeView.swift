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
    
    @State private var showSheet = false
    @State public var showMenu = false
    //    @State private var showLast: Bool = UserDefaults.standard.bool(forKey: "showLast")
    //    @State private var showFav: Bool = UserDefaults.standard.bool(forKey: "showFav")
    @AppStorage("showLast") var showLast: Bool = true
    @AppStorage("showFav") var showFav: Bool = true
    
    
    
    
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
                if !showFav && !showLast {
                    
                    
                    VStack {
                        Spacer()
                        Image(systemName: "document.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundStyle(.white.opacity(0.8))
                            .font(.title)
                            .padding()
                        
                        Text("Choose a way to Start")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                            .padding()
                        
                        Spacer()
                        
                        HStack() {
                            NavigationLink(destination: TextToSpeechView()) {
                                FeatureButton(iconName: "bubble.left.and.bubble.right", title: "Text to Speech")
                            }
                            
                            NavigationLink(destination: ImageRecognitionView()) {
                                FeatureButton(iconName: "photo.badge.plus.fill", title: "Text from Photo")
                            }
                            
                            NavigationLink(destination: CameraRecognitionView()) {
                                FeatureButton(iconName: "scanner", title: "Scan document")
                            }
                        }
                        .padding()
                        
                        Divider().padding().hidden()
                        Spacer()
                    }
                    
                } else {
                    
                    ScrollView (.vertical, showsIndicators: false) {
                        
                        VStack {
                            
                            if showLast {
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
                                                    LastInCard(library: library)
                                                        .frame(width: 110, height: 110)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 1)
                                    }
                                    .frame(height: 160)
                                    .padding(.horizontal, 2)
                                }
                            }
                            
                            else if showLast && !showFav {
                                
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
                                                    LastInCard(library: library)
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
                                    Image(systemName: "document.badge.plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .foregroundStyle(.white.opacity(0.8))
                                        .font(.title)
                                        .padding()
                                    
                                    Text("Choose a way to Start")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white.opacity(0.9))
                                        .padding()
                                    
                                    Spacer()
                                    
                                    HStack() {
                                        NavigationLink(destination: TextToSpeechView()) {
                                            FeatureButton(iconName: "bubble.left.and.bubble.right", title: "Text to Speech")
                                        }
                                        
                                        NavigationLink(destination: ImageRecognitionView()) {
                                            FeatureButton(iconName: "photo.badge.plus.fill", title: "Text from Photo")
                                        }
                                        
                                        NavigationLink(destination: CameraRecognitionView()) {
                                            FeatureButton(iconName: "scanner", title: "Scan document")
                                        }
                                    }
                                    .padding()
                                    
                                }

                            }
                            
                            
                            if showFav {
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
                                        ForEach(viewModel.favLibreries.sorted(by: {
                                            $0.editTimestamp?.dateValue() ?? Date() > $1.editTimestamp?.dateValue() ?? Date()
                                        })) { library in
                                            NavigationLink(destination: TextsListView(library: library)) {
                                                FavCollectionCard(library: library)
                                            }
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                    }
                }
                Divider().hidden()
            }
            
            SideMenuView(isShowing: $showMenu, isShowingLast: $showLast, isShowingFav: $showFav)
        }
        .background(.black.opacity(0.9))
        .toolbar(showMenu ? .hidden : .visible, for: .tabBar)
        .navigationBarItems(leading: HStack {
            
            Button("", systemImage: "line.3.horizontal") {
                showMenu.toggle()
            }
            .padding(.bottom)
            .padding(.top)
            
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
            if !showFav && !showLast { } else {
                
                Button("", systemImage: "plus") {
                    showSheet = true
            }
            }
        })
        .sheet(isPresented: $showSheet){
            SheetView()
                .presentationDetents([.large])
                .presentationCornerRadius(30)
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}

