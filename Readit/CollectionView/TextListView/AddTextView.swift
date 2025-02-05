//
//  AddTextView.swift
//  Readit
//
//  Created by Moutaz Baaj on 05.02.25.
//

import SwiftUI

struct AddTextView: View {
    
    @Binding var showAddTextSheet: Bool
    @Binding var newTextContent: String
    @StateObject private var viewModel = CollectionViewModel.shared

    var library: FireLibrary?
    
    var body: some View {
        ZStack {
            VStack {
                Text("Add New Text")
                    .font(.headline)
                    .padding()
                
                TextEditor(text: $newTextContent)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Button(action: {
                    if !newTextContent.isEmpty, let libraryID = library?.id {
                        viewModel.createText(text: newTextContent, libraryId: libraryID)
                        newTextContent = ""
                        showAddTextSheet = false
                    }
                }) {
                    Text("Add Text")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(newTextContent.isEmpty ? Color.gray : Color.blue) // Gray out when empty
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(newTextContent.isEmpty) // Disable when text is empty
                
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .presentationDetents([.medium, .large]) // Adaptive sheet height
            .presentationCornerRadius(30)
        }
        .background(.black)
    }
}
