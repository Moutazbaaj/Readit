//
//  CollectionView.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import SwiftUI

struct CollectionView: View {
    @StateObject private var viewModel = CollectionViewModel.shared
    @State private var showAlert = false
    @State private var showEditSheet = false
    @State private var showAddLibrarySheet = false
    @State private var newLibraryTitle = "" // Stores the new library title
    @State private var libraryItem: FireLibrary? // Selected library for actions (edit/delete)
    @State private var searchQuery = "" // State for search input
    
    
    private var filteredLibraries: [FireLibrary] {
        if searchQuery.isEmpty {
            return viewModel.libreries
        } else {
            return viewModel.libreries.filter { $0.libraryTitle.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    // Define the grid layout with two columns.
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ScrollView {
                        // Search bar
                        TextField("Search Collections...", text: $searchQuery)
                            .padding()
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(4)
                        Spacer()
                        
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
                                            contextMenu(for: library)
                                        }
                                    }
                                }
//                                .padding()
                                
                            }
                            
                        }
                    }
                    HStack {
                        
                        Spacer()
                        
                        Text("\(filteredLibraries.count) items ")
                            .font(.caption)
                            .padding(.top, 2)
                            .padding(.bottom, 4)
                            .padding(.horizontal)
                    }
                    
                }
            }
        }
        .navigationTitle("My Collections")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            showAddLibrarySheet = true
        }) {
            Image(systemName: "plus")
        })
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
        .sheet(isPresented: $showAddLibrarySheet) {
            AddCollectionSheet(newLibraryTitle: $newLibraryTitle)
                .presentationDetents([.height(200)])
                .presentationCornerRadius(50)
            
        }
        .sheet(isPresented: $showEditSheet) {
            // Implement editing sheet logic here.
            
        }
        .onAppear {
            viewModel.fetchLibraries()
        }
    }
    
    @ViewBuilder
    private func contextMenu(for library: FireLibrary) -> some View {
        // Favorite/Unfavorite button
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

