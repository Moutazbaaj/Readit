//
//  LibraryCard.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import SwiftUI


struct LibraryCard: View {
    let library: FireLibrary
    
    var body: some View {
        VStack() {
            
            Text(library.libraryTitle)
                .font(.callout)
                .foregroundColor(.white)
                .padding()
            
            HStack {
                Text("Created:")
                    .font(.caption2)
                Text(library.timestamp.dateValue(), style: .time)
                    .font(.caption2)
            }
            
            Text(library.timestamp.dateValue(), style: .date)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
            
            Text("Texts:")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
            
        }
        .padding()
        .frame(width: 175 , height : 170)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

