//
//  HomeCard.swift
//  Readit
//
//  Created by Moutaz Baaj on 17.01.25.
//



import SwiftUI

struct HomeCard: View {
    let library: FireLibrary
    
    var body: some View {
        VStack(alignment: .leading) {
            // Library title
            Text(library.libraryTitle)
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading) // Ensures multiline text aligns to the leading edge
                .frame(maxWidth: .infinity, alignment: .leading) // Aligns the entire text block to the left
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
                .padding(.top, 10)
            
            Spacer()
            
            // Pages count
            HStack {
                Text("Pages: \(library.textIds?.count ?? 0)") // Safely unwrap textIds
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
        .frame(width: 100, height: 100) // Adjusted height for better layout
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20) // Fully rounded corners
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.3), lineWidth: 2) // Subtle border
        )
        .shadow(color: Color.black.opacity(0.4), radius: 15, x: 0, y: 10) // Softer shadow
        .padding(.horizontal, 5) // Padding between cards
    }
}
