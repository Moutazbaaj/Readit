//
//  FavCollectionCard.swift
//  Readit
//
//  Created by Moutaz Baaj on 05.02.25.
//


import SwiftUI
import FirebaseCore

struct FavCollectionCard: View {
    let library: FireLibrary
    
    var body: some View {
        HStack(spacing: 10) { // Horizontal layout
            // Library Icon or Image
            Image(systemName: "book")
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 40, height: 40)
//                .background(
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
//                    .cornerRadius(10)
//                )
                .padding(.leading, 12)
            
            // Library Details
            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(library.libraryTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1) // Ensure title fits in one line
                
                // Pages Count
                HStack {
                    Image(systemName: "book")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Pages: \(library.textIds?.count ?? 0)")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Creation Date
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(library.timestamp.dateValue(), style: .date)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.vertical, 8)
            
            Spacer()
            
            // Favorite Icon
            if library.isFavorites {
                Image(systemName: "star.fill")
                    .font(.subheadline)
                    .foregroundColor(.yellow)
                    .shadow(color: .yellow, radius: 2, x: 0, y: 0)
                    .padding(.trailing, 12)
            }
        }
        .frame(height: 80) // Wider but shorter
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                Color.black.opacity(0.3) // Adds a dark overlay for better text readability
            )
        )
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 5)
        .padding(.horizontal, 8) // Padding between cards
    }
}
