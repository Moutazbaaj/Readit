//
//  CollaectionEditView.swift
//  Readit
//
//  Created by Moutaz Baaj on 05.02.25.
//

import SwiftUI

struct CollaectionEditView: View {
    @Binding var showEditSheet: Bool
    @Binding var editingTextContent: String
    @StateObject private var viewModel = CollectionViewModel.shared
    
     var libraryItem: FireLibrary?
    
    var body: some View {
        ZStack {
            VStack {
                Text("Edit Library title")
                    .font(.headline)
                    .padding()
                
                TextEditor(text: $editingTextContent)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
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
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
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
