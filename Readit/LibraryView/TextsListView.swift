//
//  TextsListView.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import Foundation
import SwiftUI

struct TextsListView: View {
    let library: FireLibrary
    @StateObject private var viewModel = LibraryViewModel.shared
    @State private var showAddTextSheet = false
    @State private var newTextContent = ""

    var body: some View {
        VStack {
            if viewModel.texts.isEmpty {
                Text("No texts in this library.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.texts.sorted(by: {
                    $0.timestamp.dateValue() > $1.timestamp.dateValue()
                })) { text in
                    VStack(alignment: .leading) {
                        Text(text.text)
                            .font(.headline)
                        Text(text.timestamp.dateValue(), style: .date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(8)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle(library.libraryTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            showAddTextSheet = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showAddTextSheet) {
            VStack {
                Text("Add New Text")
                    .font(.headline)
                    .padding()

                TextField("Enter Text Content", text: $newTextContent, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    if !newTextContent.isEmpty {
                        viewModel.createText(text: newTextContent, libraryId: library.id ?? "")
                        newTextContent = ""
                        showAddTextSheet = false
                    }
                }) {
                    Text("Add Text")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(newTextContent.isEmpty)

                Spacer()
            }
            .padding()
            .presentationDetents([.medium, .large])
        }
        .onAppear {
            viewModel.fetchTexts(forLibraryId: library.id ?? "")
        }
    }
}

//#Preview {
//    TextsListView()
//}
