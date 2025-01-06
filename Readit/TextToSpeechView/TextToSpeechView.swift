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
        VStack(spacing: 20) {
            Spacer()
            TextField("Type your text here", text: $viewModel.inputText, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
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
        .padding()
        .navigationTitle("Text-to-Speech")
        .onDisappear {
                viewModel.stopSpeaking()
            }
    }
}



#Preview {
    TextToSpeechView()
}
