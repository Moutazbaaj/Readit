//
//  ImageRecognitionView.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI
import PhotosUI
import FirebaseCore

struct ImageRecognitionView: View {
    
    @StateObject private var viewModel = ImageRecognitionViewModel.shared
    @StateObject private var libViewModel = LibraryViewModel.shared
    
    
    @State private var selectedItem: PhotosPickerItem? // For the selected image from the picker
    @State private var showLanguagePicker: Bool = false
    @State private var selectedLanguage: Language = .english
    @State private var showCamera: Bool = false // To trigger the camera
    @State private var capturedImage: UIImage? // To hold the captured image
    
    
    var body: some View {
        VStack() {
            Spacer()
            
            // Display the selected or captured image
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .cornerRadius(10)
            } else if let capturedImage = capturedImage {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .cornerRadius(10)
                    .onAppear {
                        // Process the captured image
                        viewModel.selectedImage = capturedImage
                        viewModel.processImage(image: capturedImage)
                    }
                
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
            
            // Language selection
            HStack {
                Text("Language:")
                    .font(.subheadline)
                Spacer()
                Text(selectedLanguage.displayName)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        showLanguagePicker = true
                    }
                    .padding()

            }
        
            HStack {
                CameraCaptureButton(capturedImage: $capturedImage)
                
                // PhotosPicker to select an image
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images, // Show only images in the picker
                    photoLibrary: .shared()
                ) {
                    Label("Select Photo", systemImage: "photo")
                    
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            
            // Action buttons
           HStack {
                Button(action: {
                    viewModel.stopSpeaking()
                    viewModel.readTextAloud(in: selectedLanguage)
                }) {
                    Label("Read Text", systemImage: "message.badge.waveform")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.stopSpeaking()
                    viewModel.selectedImage = nil
                    viewModel.extractedText = nil
                    capturedImage = nil
                }) {
                    Label("Clear Text", systemImage: "xmark.circle")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationTitle("Image Recognition")
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                
//                Button(action: {
//                    showLanguagePicker = true // Show the language picker sheet
//                }) {
//                    Label("Language", systemImage: "globe")
//                }
//            }
//        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePickerView(selectedLanguage: $selectedLanguage, isPresented: $showLanguagePicker)
        }
        .onAppear {
            viewModel.selectedImage = nil
            viewModel.extractedText = nil
        }
        .onDisappear {
            viewModel.stopSpeaking()
            
            guard let extractedText = viewModel.extractedText, !extractedText.isEmpty else {
                return
            }
            
            libViewModel.createText(text: extractedText, libraryId: " ")
        }
        .onChange(of: capturedImage) {_, newImage in
            if let newImage = newImage {
                viewModel.selectedImage = newImage
                viewModel.processImage(image: newImage)
                guard let extractedText = viewModel.extractedText, !extractedText.isEmpty else {
                    return
                }
                
                libViewModel.createText(text: extractedText, libraryId: " ")
            }
        }
        .onChange(of: selectedItem) {_ , newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    viewModel.selectedImage = uiImage
                    viewModel.processImage(image: uiImage)
                    viewModel.stopSpeaking()
                    guard let extractedText = viewModel.extractedText, !extractedText.isEmpty else {
                        return
                    }
                    
                    libViewModel.createText(text: extractedText, libraryId: " ")
                }
            }
        }
    }
}

#Preview {
    ImageRecognitionView()
}

