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
    
    @State private var libraryItem: FireLibrary? // Selected library for actions (edit/delete)
    @State private var editingTextContent = ""
    @State private var showAlert = false
    @State private var showEditSheet = false

    @State private var searchQuery = "" // State for search input

    private var filteredLibraries: [FireLibrary] {
        if searchQuery.isEmpty {
            return viewModel.libreries
        } else {
            return viewModel.libreries.filter { $0.libraryTitle.localizedCaseInsensitiveContains(searchQuery) }
        }
    }

    
    
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
                
                // Search bar
                TextField("Search Collections...", text: $searchQuery)
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(4)
                    .padding(.top)
                Spacer()
                
                if searchQuery.isEmpty {
                    if !showLast && !showFav {
                    ScrollView {
                        LastCollectionsSection().hidden()
                        EmptyStateView()
                    }
                    Divider().hidden()
                    
                } else if showLast && !showFav {
                    
                    ScrollView {
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
                } else {
                    VStack {
                        ScrollView(.vertical, showsIndicators: false) {


                            Spacer()
                            
                            HStack {
                                
                                Spacer()
                                
                                Text("\(filteredLibraries.count) items ")
                                    .font(.caption)
                                    .padding(.top, 2)
                                    .padding(.bottom, 4)
                                    .padding(.horizontal)
                            }
                            
                            
                            if viewModel.libreries.isEmpty {
                                Image(systemName: "tray")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                    .padding()
                                Text("You have No Collections yet")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Text("Click on the Plus (+) button to start")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                            } else {
                                if filteredLibraries.isEmpty {
                                    VStack {
                                        Text("No results found")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                            .padding()
                                        Spacer()
                                    }
                                } else {
                                    LazyVGrid(columns: gridItems, spacing: 20) {
                                        ForEach(filteredLibraries.sorted {
                                            $0.timestamp.dateValue() > $1.timestamp.dateValue()
                                        }) { library in
                                            NavigationLink(destination: TextsListView(library: library)) {
                                                CollectionCard(library: library)
                                            }
                                            .contextMenu {
                                                Button(library.isFavorites ? "Unfavorite" : "Favorite") {
                                                    if let libraryId = library.id {
                                                        viewModel.addLibraryToFav(withId: libraryId, isFavorites: !library.isFavorites)
                                                    } else {
                                                        print("Error: Library ID is missing")
                                                    }
                                                }
                                                
                                                // Edit button
                                                Button("Edit") {
                                                    libraryItem = library
                                                    editingTextContent = library.libraryTitle
                                                    showEditSheet = true
                                                }
                                                
                                                // Delete button
                                                Button(role: .destructive) {
                                                    libraryItem = library
                                                    showAlert = true
                                                } label: {
                                                    Text("Delete")
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                        Divider().hidden()
                    }
                }
            
            }
            
            // Side Menu
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
            if showFav {
                Button("", systemImage: "plus") {
                    showSheet = true
                }
            }
        })
        .sheet(isPresented: $showSheet) {
            SheetView()
                .presentationDetents([.large])
                .presentationCornerRadius(30)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showEditSheet) {
            CollaectionEditView(showEditSheet: $showEditSheet, editingTextContent: $editingTextContent)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirm Delete"),
                message: Text("Are you sure you want to delete this library?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let library = libraryItem {
                        viewModel.deleteLibrary(withId: library.id)
                    }
                },
                secondaryButton: .cancel()
            )
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
        
                }
        
//        return VStack {Text("Hello World")}
        
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
        }
    }
    
    private func FavoritesSection() -> some View {
        VStack {
            HStack {
                Text("Favorites")
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
    
    
    //    var body: some View {
    //        ZStack {
    //            // Animated background gradient
    //            LinearGradient(
    //                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
    //                startPoint: .top,
    //                endPoint: .bottom
    //            )
    //            .edgesIgnoringSafeArea(.all)
    //
    //            VStack {
    //                ScrollView (.vertical, showsIndicators: false) {
    //
    //                    VStack {
    //                        if showLast {
    //                            HStack {
    //                                Text("last collections")
    //                                Spacer()
    //                            }
    //                            .padding(.horizontal)
    //                            .padding(.top)
    //
    //
    //                            if viewModel.libreries.isEmpty {
    //                                HStack {
    //                                    Spacer()
    //                                    Image(systemName: "bookmark.slash")
    //                                        .font(.largeTitle)
    //                                        .foregroundColor(.gray)
    //                                        .padding()
    //                                    Text("There is no collections yet")
    //                                        .font(.headline)
    //                                        .foregroundColor(.gray)
    //                                        .padding()
    //                                    Spacer()
    //                                }
    //                            } else {
    //
    //                                ScrollView(.horizontal, showsIndicators: false) {
    //                                    LazyHStack(spacing: 5) {
    //                                        ForEach(viewModel.libreries.sorted(by: {
    //                                            $0.timestamp.dateValue() > $1.timestamp.dateValue()
    //                                        }).prefix(6)) { library in
    //                                            NavigationLink(destination: TextsListView(library: library)) {
    //                                                LastInCard(library: library)
    //                                                    .frame(width: 110, height: 110)
    //                                            }
    //                                        }
    //                                    }
    //                                    .padding(.horizontal, 1)
    //                                }
    //                                .frame(height: 160)
    //                                .padding(.horizontal, 2)
    //                            }
    //                        }
    //                        if showFav {
    //                            VStack {
    //                                // Content above the scroll view
    //                                HStack {
    //                                    Text("Favorites")
    //                                    Spacer()
    //                                }
    //                                .padding(.horizontal)
    //
    //                                HStack {
    //                                    Text("\(viewModel.favLibreries.count) items ")
    //                                        .font(.caption2)
    //                                    Spacer()
    //                                }
    //                                .padding(.horizontal)
    //
    //                                if viewModel.favLibreries.isEmpty {
    //
    //                                    Spacer()
    //
    //                                    Image(systemName: "star.slash")
    //                                        .font(.largeTitle)
    //                                        .foregroundColor(.gray)
    //                                        .padding()
    //                                    Text("Your Have no Favorites")
    //                                        .font(.headline)
    //                                        .foregroundColor(.gray)
    //                                        .padding()
    //
    //                                    Spacer()
    //
    //                                } else {
    //                                    Divider().hidden()
    //                                    ForEach(viewModel.favLibreries.sorted(by: {
    //                                        $0.editTimestamp?.dateValue() ?? Date() > $1.editTimestamp?.dateValue() ?? Date()
    //                                    })) { library in
    //                                        NavigationLink(destination: TextsListView(library: library)) {
    //                                            FavCollectionCard(library: library)
    //                                        }
    //                                    }
    //                                }
    //                            }
    //
    //
    //                        }
    //                    }
    //                }
    //                Divider().hidden()
    //            }
    //
    //            SideMenuView(isShowing: $showMenu, isShowingLast: $showLast, isShowingFav: $showFav)
    //        }
    //        .background(.black.opacity(0.9))
    //        .toolbar(showMenu ? .hidden : .visible, for: .tabBar)
    //        .navigationBarItems(leading: HStack {
    //
    //            Button("", systemImage: "line.3.horizontal") {
    //                showMenu.toggle()
    //            }
    //            .padding(.bottom)
    //            .padding(.top)
    //
    //            Text("Hello")
    //                .font(.largeTitle)
    //                .fontWeight(.bold)
    //                .lineLimit(1)
    //                .foregroundColor(.white)
    //                .scaleEffect(animateText ? 1 : 0.3) // Start from smaller size and scale up
    //                .opacity(animateText ? 1 : 0) // Start with opacity 0 and fade in
    //                .onAppear {
    //                    // Trigger the animation when the view appears
    //                    withAnimation(.easeOut(duration: 2)) {
    //                        animateText = true
    //                    }
    //                }
    //                .padding(.bottom)
    //                .padding(.top)
    //
    //            Spacer()
    //        })
    //        .navigationBarItems(trailing: HStack {
    //            if !showFav && !showLast { } else if !showFav && showLast {} else {
    //                Button("", systemImage: "plus") {
    //                    showSheet = true
    //                }
    //            }
    //        })
    //        .sheet(isPresented: $showSheet){
    //            SheetView()
    //                .presentationDetents([.large])
    //                .presentationCornerRadius(30)
    //                .presentationDragIndicator(.visible)
    //        }
    //    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}

