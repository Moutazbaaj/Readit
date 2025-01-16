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
                    .foregroundColor(.white)

                Text(library.timestamp.dateValue(), style: .time)
                    .font(.caption2)
                    .foregroundColor(.white)

            }
            
            Text(library.timestamp.dateValue(), style: .date)
                .font(.caption2)
                .foregroundColor(.white)
                .foregroundColor(.white.opacity(0.8))
            
            Text("Pages: \(library.textIds!.count)")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
            
        }
        .padding()
        .frame(width: 175 , height : 170)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.3), lineWidth: 1) // Add a subtle border to highlight the edges
        )
        .shadow(color: Color.black.opacity(0.4), radius: 15, x: 0, y: 10) // Deep shadow for floating effect
        .padding([.leading, .trailing], 10) // Padding to space out from other elements
    }
}

