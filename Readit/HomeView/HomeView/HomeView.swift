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
    
    @AppStorage("showLast") var showLast: Bool = true
    @AppStorage("showFav") var showFav: Bool = false
    
//    @State private var libraryItem: FireLibrary? // Selected library for actions (edit/delete)
//    @State private var editingTextContent = ""
//    @State private var showAlert = false
//    @State private var showEditSheet = false
//
//    @State private var searchQuery = "" // State for search input
//
//    private var filteredLibraries: [FireLibrary] {
//        if searchQuery.isEmpty {
//            return viewModel.libreries
//        } else {
//            return viewModel.libreries.filter { $0.libraryTitle.localizedCaseInsensitiveContains(searchQuery) }
//        }
//    }

    
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                    if !showLast && !showFav {
                        ScrollView(.vertical, showsIndicators: false) {
                        LastCollectionsSection().hidden()
                        EmptyStateView()
                    }
                    Divider().hidden()
                    
                } else if showLast && !showFav {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LastCollectionsSection()
                        EmptyStateView()
                    }
                    Divider().hidden()
                    
                } else {
                    // Case 2: At least one toggle is on
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            if showLast {
                                // Show "Last Collections" section
                                LastCollectionsSection()
                            }
                            
                            if showFav {
                                // Show "Favorites" section
                                FavoritesSection()
                            }
                        }
                    }
                    Divider().hidden()
                }
            }
            
            // Side Menu
            SideMenuView(isShowing: $showMenu, isShowingLast: $showLast, isShowingFav: $showFav)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // Ensures content is visible above the keyboard
        .background(.black.opacity(0.9))
        .toolbar(showMenu ? .hidden : .visible, for: .tabBar)
        .navigationBarItems(leading: HStack {
            Button("", systemImage: "line.3.horizontal") {
                showMenu.toggle()
            }.disabled(showMenu)
            .padding(.bottom)
            .padding(.top)
            
            Text("Hello")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .foregroundColor(showMenu ? .gray : .white)
                .scaleEffect(animateText ? 1 : 0.3)
                .opacity(animateText ? 1 : 0)
                .onAppear {
                    withAnimation(.easeOut(duration: 2)) {
                        animateText = true
                    }
                }
                .padding(.bottom)
                .padding(.top)
            
            Spacer()
        })
        .navigationBarItems(trailing: HStack {
            if !showMenu {
            if showFav {
                Button("", systemImage: "plus") {
                    showSheet = true
                }
            }
        }
        })
        .sheet(isPresented: $showSheet) {
            SheetView()
                .presentationDetents([.large])
                .presentationCornerRadius(30)
                .presentationDragIndicator(.visible)
        }
        .onAppear{
            viewModel.fetchLibraries()
            viewModel.fetchFavLibraries()
        }

    }
    
    
    private func EmptyStateView() -> some View {
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
        
                    HStack {
//                        HStack {
                            NavigationLink(destination: TextToSpeechView()) {
                                FeatureButton(iconName: "bubble.left.and.bubble.right", title: "Text to Speech")
                            }
                            NavigationLink(destination: ImageRecognitionView()) {
                                FeatureButton(iconName: "photo.badge.plus.fill", title: "Text from Photo")
                            }
//                        }
                        
//                        HStack {
//                            NavigationLink(destination: CameraRecognitionView()) {
//                                FeatureButton(iconName: "scanner", title: "Scan Document")
//                            }
                            
                            NavigationLink(destination: PDFToSpeechView()) {
                                FeatureButton(iconName: "document", title: "PDF To Speech")
                            }
//                        }
                    }.padding(.horizontal, -10)
                }
    }
    
    private func LastCollectionsSection() -> some View {
        VStack {
            HStack {
                Text("Last Collections")
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
                    Text("There are no collections yet")
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
                Divider().padding(.horizontal)
                .frame(width: 300)
        }
    }
    
    private func FavoritesSection() -> some View {
        VStack {
            HStack {
                Text("Favorites")
                    .padding(.top)
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Text("\(viewModel.favLibreries.count) items")
                    .font(.caption2)
                Spacer()
            }
            .padding(.horizontal)
            
            if viewModel.favLibreries.isEmpty {
                VStack {
                    Spacer()
                    Image(systemName: "star.slash")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .padding()
                    Text("You have no favorites")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
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

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}

