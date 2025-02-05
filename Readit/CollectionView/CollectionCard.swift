//
//  CollectionCard.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import SwiftUI
import FirebaseCore

struct CollectionCard: View {
    let library: FireLibrary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            Text(library.libraryTitle)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.top, 12)
                .padding(.horizontal, 16)
            
            // Divider
            Divider()
                .background(Color.white.opacity(0.3))
                .padding(.horizontal, 16)
            
            // Creation Date and Time
            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Created:")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                    }
                 VStack {
                        Text(library.timestamp.dateValue(), style: .date)
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(library.timestamp.dateValue(), style: .time)
                        .font(.caption)
                        .foregroundColor(.white)
                }
                VStack{
                    Text(library.timestamp.dateValue(), style: .relative)
                        .font(.caption2)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            // Pages and Favorites
            HStack {
                HStack {
                    Image(systemName: "book")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Pages: \(library.textIds?.count ?? 0)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                if library.isFavorites {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .shadow(color: .yellow, radius: 2, x: 0, y: 0)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .frame(width: 175, height: 170)
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
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 5)
        .padding(.vertical, 8)
    }
}

