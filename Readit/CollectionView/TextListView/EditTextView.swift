//
//  EditTextView.swift
//  Readit
//
//  Created by Moutaz Baaj on 05.02.25.
//

import SwiftUI

struct EditTextView: View {
    
    @Binding var showEditTextSheet: Bool
    @Binding var editingTextContent: String
    @StateObject private var viewModel = CollectionViewModel.shared
    
    var textItem: FireText?
    
    var body: some View {
        ZStack{
            VStack {
                Text("Edit Text")
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
                    if !editingTextContent.isEmpty, let textID = textItem?.id {
                        viewModel.editText(withId: textID, newText: editingTextContent)
                        showEditTextSheet = false
                    }
                }) {
                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(editingTextContent.isEmpty ? Color.gray : Color.blue)
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
                .edgesIgnoringSafeArea(.all)
            )
            .presentationDetents([.medium, .large]) // Adaptive sheet height
            .presentationCornerRadius(30)
        }
        .background(.black)
    }
}
