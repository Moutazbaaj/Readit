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
            // Display the selected image
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .cornerRadius(10)
            }
            
            if let extractedText = viewModel.extractedText {
                Text("Extracted Text:")
                    .font(.headline)
                
                if extractedText.isEmpty {
                    Text("Error: No Text found")
                        .padding()
                        .foregroundColor(.red)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                } else {
                    ScrollView { // Add a ScrollView for long text
                        Text(extractedText)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .frame(maxHeight: 300) // Optional: Limit the scroll area height
                }
            }
            
            Button(action: {
                viewModel.showImagePicker = true
                viewModel.stopSpeaking()
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
