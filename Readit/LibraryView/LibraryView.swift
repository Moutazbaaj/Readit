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
                    Text(" ")
                    if viewModel.libreries.isEmpty {
                        Text("Your library is empty")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: gridItems, spacing: 20) {
                                ForEach(viewModel.libreries.sorted(by: {
                                    $0.timestamp.dateValue() > $1.timestamp.dateValue()
                                })) { library in
                                    NavigationLink(destination: TextsListView(library: library)) {
                                        LibraryCard(library: library)
                                    }
                                    .contextMenu {
                                        Button("Edit") {
                                            libraryItem = library
                                            showEditSheet = true
                                        }
                                        Button(role: .destructive) {
                                            libraryItem = library
                                            showAlert = true
                                        } label: {
                                            Text("Delete")
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .navigationTitle("My libreries")
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
            //TODO: sheet for edits
        }
        .onAppear {
            viewModel.fetchLibraries()
        }
    }
}


