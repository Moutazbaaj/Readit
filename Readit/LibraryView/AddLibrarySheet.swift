//
//  AddLibrarySheet 2.swift
//  Readit
//
//  Created by Moutaz Baaj on 80.01.25.
//

import SwiftUI


struct AddLibrarySheet: View {
    @StateObject var viewModel = LibraryViewModel.shared

    @Binding var newLibraryTitle: String
    var body: some View {
        VStack(spacing: 20) {
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
                }
            }
            .disabled(newLibraryTitle.isEmpty || newLibraryTitle.count > 50)
            .padding()
            .background(newLibraryTitle.isEmpty || newLibraryTitle.count > 50 ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
