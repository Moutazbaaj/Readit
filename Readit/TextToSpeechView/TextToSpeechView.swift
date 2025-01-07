//
//  TextToSpeechView.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI

struct TextToSpeechView: View {
    @StateObject private var viewModel = TextToSpeechViewModel()
    
    var body: some View {
        VStack {
            VStack() {
                
                // Expandable TextEditor for user input
                TextEditor(text: $viewModel.inputText)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding()
            VStack {
                Button(action: {
                    viewModel.readTextAloud()
                }) {
                    Text("Read Text")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("Text to Speech")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.stopSpeaking()
        }
    }
}

#Preview {
    TextToSpeechView()
}
