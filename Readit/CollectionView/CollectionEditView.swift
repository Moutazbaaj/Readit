//
//  CollectionEditView.swift
//  Readit
//
//  Created by Moutaz Baaj on 05.02.25.
//

import SwiftUI

struct CollectionEditView: View {
    @Binding var showEditSheet: Bool
    @Binding var editingTextContent: String
    @StateObject private var viewModel = CollectionViewModel.shared
    
     var libraryItem: FireLibrary?
    
    var body: some View {
        ZStack {
            VStack {
                Text("Edit Collection title")
                    .font(.headline)
                    .padding()
                
                TextEditor(text: $editingTextContent)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Button(action: {
                    if !editingTextContent.isEmpty {
                        viewModel.editLibrary(libraryId: libraryItem?.id, newTitle: editingTextContent)
                        editingTextContent = ""
                        showEditSheet = false
                    }
                }) {
                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(editingTextContent.isEmpty ? Color.black.opacity(0.6) : Color.gray.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .disabled(editingTextContent.isEmpty)
                
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all))
            .presentationDetents([.medium, .large])
            .presentationCornerRadius(30)
        }
        .background(.black)
    }
}
