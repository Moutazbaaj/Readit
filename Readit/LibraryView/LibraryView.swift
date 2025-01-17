//
//  LibraryView.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

//
//  LibraryView.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel.shared
    @State private var showAlert = false
    @State private var showEditSheet = false
    @State private var showAddLibrarySheet = false
    @State private var newLibraryTitle = "" // Stores the new library title
    @State private var libraryItem: FireLibrary? // Selected library for actions (edit/delete)
    
    // Define the grid layout with two columns.
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    // Computed property for sorted libraries
    var sortedLibraries: [FireLibrary] {
        viewModel.libreries.sorted {
            $0.timestamp.dateValue() > $1.timestamp.dateValue()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 10) // Adding a subtle blur effect to the background
                
                VStack {
                    if viewModel.libreries.isEmpty {
                        Text("Your library is empty")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: gridItems, spacing: 20) {
                                ForEach(sortedLibraries) { library in
                                    NavigationLink(destination: TextsListView(library: library)) {
                                        LibraryCard(library: library)
                                    }
                                    .contextMenu {
                                        contextMenu(for: library)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .navigationTitle("My Libraries")
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
            AddLibrarySheet(
                newLibraryTitle: $newLibraryTitle,
                onAdd: {
                    if !newLibraryTitle.isEmpty {
                        viewModel.createLibrary(libraryTitle: newLibraryTitle)
                        newLibraryTitle = ""
                        showAddLibrarySheet = false
                    }
                }
            )
            .presentationDetents([.height(200)])
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

