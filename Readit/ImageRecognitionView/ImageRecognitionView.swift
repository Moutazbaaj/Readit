//
//  ImageRecognitionView.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI
import PhotosUI

struct ImageRecognitionView: View {
    @StateObject private var viewModel = ImageRecognitionViewModel()
    @State private var selectedItem: PhotosPickerItem? // For the selected image from the picker
    
    var body: some View {
        VStack() {
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
                    ScrollView {
                        Text(extractedText)
                            .padding()
                            .padding(.horizontal)

                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .frame(maxHeight: 350)
                    
                }
            }
            
            // PhotosPicker to select an image
            PhotosPicker(
                selection: $selectedItem,
                matching: .images, // Show only images in the picker
                photoLibrary: .shared()
            ) {
                Text("Select Photo")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onChange(of: selectedItem) {_ , newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        viewModel.selectedImage = uiImage
                        viewModel.processImage(image: uiImage)
                    }
                }
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
        .onDisappear {
            viewModel.stopSpeaking()
        }
    }
}

#Preview {
    ImageRecognitionView()
}

#Preview {
    ImageRecognitionView()
}
