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
                .padding(.top, 5)
                .padding(.bottom, 2)
                .padding(.horizontal)
            
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
            
            HStack {
                
                Text("Pages: \(library.textIds!.count)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                    .padding()
                
                Spacer()
                
                if (library.isFavorites) {
                    Image(systemName: "star")
                        .font(.callout)
                        .foregroundColor(.white.opacity(0.8))
                        .padding()
                    
                }

            }
        }
        .frame(width: 175 , height : 170)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.1), .gray.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.3), lineWidth: 2) // Add a subtle border to highlight the edges
        )
        .shadow(color: Color.black.opacity(0.4), radius: 15, x: 0, y: 10) // Deep shadow for floating effect
    }
}

