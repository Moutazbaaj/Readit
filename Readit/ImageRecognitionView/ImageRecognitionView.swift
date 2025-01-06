//
//  ImageRecognitionView.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI

struct ImageRecognitionView: View {
    @StateObject private var viewModel = ImageRecognitionViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            if let extractedText = viewModel.extractedText {
                Text("Extracted Text:")
                    .font(.headline)
                Text(extractedText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            
            Button(action: {
                viewModel.showImagePicker = true
            }) {
                Text("Select Photo")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
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
        .navigationTitle("Image Recognition")
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage, onImagePicked: viewModel.processImage)
        }
        .onDisappear {
                viewModel.stopSpeaking()
            }
    }
}



#Preview {
    ImageRecognitionView()
}
