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

        ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            
            VStack {

                Spacer()
                
                Image(systemName: "document.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.white.opacity(0.5))
                    .font(.title)
                Text("chose a way to read")
                
                Spacer()
                    HStack {
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
            }
            .padding()
            

            }
        }
    }
}
