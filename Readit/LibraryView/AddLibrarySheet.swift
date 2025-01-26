//
//  AddLibrarySheet 2.swift
//  Readit
//
//  Created by Moutaz Baaj on 80.01.25.
//

import SwiftUI


struct AddLibrarySheet: View {
    @StateObject var viewModel = LibraryViewModel.shared
    @Environment(\.dismiss) var dismiss // Environment value for dismissing

    @Binding var newLibraryTitle: String
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .blur(radius: 10)
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
            .cornerRadius(20)
        }
        .padding()
    }
    }
}
