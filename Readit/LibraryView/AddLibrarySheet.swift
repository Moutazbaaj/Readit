//
//  AddLibrarySheet.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import SwiftUI


struct AddLibrarySheet: View {
    @Binding var newLibraryTitle: String
    var onAdd: () -> Void
    
    var body: some View {
        VStack {
            Text("Add New Library")
                .font(.headline)
                .padding()
            
            TextField("Enter Library Title", text: $newLibraryTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: onAdd) {
                Text("Add Library")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(newLibraryTitle.isEmpty)
            
            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
    }
}
