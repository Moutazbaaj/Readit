//
//  HomeCard.swift
//  Readit
//
//  Created by Moutaz Baaj on 17.01.25.
//



import SwiftUI

struct FavLibCard: View {
    let library: FireLibrary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Library Title
            Text(library.libraryTitle)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(2) // Allow up to 2 lines for the title
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 12)
                .padding(.top, 12)
            
            Spacer()
            
            // Pages Count
            HStack {
                Image(systemName: "book")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("\(library.textIds?.count ?? 0)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(width: 100, height: 100)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                Color.black.opacity(0.3) // Adds a dark overlay for better text readability
            )
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 5)
    }
}
