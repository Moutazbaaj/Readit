//
//  SheetView.swift
//  Readit
//
//  Created by Moutaz Baaj on 03.02.25.
//

import SwiftUI

struct SheetView: View {
//    @Environment(\.dismiss) var dismiss // Allows dismissing the sheet
    @State private var hideButton = true
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.title)
                        .padding()
                    
                    Text("Choose a way to Start")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.9))
                        .padding()
                    
                    Spacer()
                    
                    HStack() {
                        NavigationLink(destination: TextToSpeechView()) {
                            FeatureButton(iconName: "bubble.left.and.bubble.right", title: "Text to Speech")
                        }
                        
                        NavigationLink(destination: ImageRecognitionView()) {
                            FeatureButton(iconName: "photo.badge.plus.fill", title: "Text from Photo")
                        }
                        
                        NavigationLink(destination: CameraRecognitionView()) {
                            FeatureButton(iconName: "scanner", title: "Scan document")
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }
}




#Preview {
    SheetView()
}
