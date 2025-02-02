//
//  SheetView.swift
//  Readit
//
//  Created by Moutaz Baaj on 03.02.25.
//

import SwiftUI


struct SheetView: View {
    @Environment(\.dismiss) var dismiss // Allows dismissing the sheet
    @State private var hideButton = true

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: TextToSpeechView()) {
                    VStack {
                        Image(systemName: "bubble.and.pencil")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                        Text("Text to Speech")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                
                NavigationLink(destination: ImageRecognitionView()) {
                    VStack {
                        Image(systemName: "photo.badge.plus.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                        Text("Text Recognition")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .cornerRadius(30)
                .padding()
            )
        }
    }
}
