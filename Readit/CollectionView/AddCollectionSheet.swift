//
//  AddCollectionSheet.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import SwiftUI


struct AddCollectionSheet: View {
    @StateObject var viewModel = CollectionViewModel.shared
    @Environment(\.dismiss) var dismiss // Environment value for dismissing

    @Binding var newLibraryTitle: String
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
        VStack() {
            TextField("Enter library title", text: $newLibraryTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: newLibraryTitle) {_, newValue in
                    // Trim the input if it exceeds 50 characters
                    if newLibraryTitle.count > 50 {
                        newLibraryTitle = String(newValue.prefix(50))
                    }
                }
                .padding()
            
            Text("\(newLibraryTitle.count)/50 characters")
                .font(.caption)
                .foregroundColor(newLibraryTitle.count > 50 ? .red : .gray)
            
            Button("Add") {
                if !newLibraryTitle.isEmpty {
                    viewModel.createLibrary(libraryTitle: newLibraryTitle)
                    newLibraryTitle = ""
                    dismiss()
                }
            }
            .disabled(newLibraryTitle.isEmpty || newLibraryTitle.count > 50)
            .padding()
            .frame(maxWidth: .infinity)
            .background(newLibraryTitle.isEmpty || newLibraryTitle.count > 50 ? Color.gray : Color.black.opacity(0.6))
            .foregroundColor(.white)
            .cornerRadius(30)
        }
        .padding()
    }
    }
}
