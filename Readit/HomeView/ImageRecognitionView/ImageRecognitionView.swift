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
    @StateObject private var libViewModel = CollectionViewModel.shared
    
    
    @State private var selectedPhoto: PhotosPickerItem? // For the selected image from the picker
    @State private var showPhotoPicker: Bool = false  // State to trigger the picker automatically
    
    @State private var showLanguagePicker: Bool = false
    @State private var selectedLanguage: Language = .englishUS
    
    
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.purple.opacity(0.3), .blue.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            
            VStack() {
                Spacer()
                
                // Display the selected or captured image
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                
                if let extractedText = viewModel.extractedText {
                    Text("Extracted Text:")
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    
                    if extractedText.isEmpty {
                        Text("Error: No Text found")
                            .padding()
                            .foregroundColor(.red)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                        
                    } else {
                        ScrollView {
                            Text(extractedText)
                                .padding()
                                .padding(.horizontal)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .frame(maxHeight: 350)
                        
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
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        viewModel.stopSpeaking()
                        viewModel.selectedImage = nil
                        viewModel.extractedText = nil
                        //                                capturedImage = nil
                    }) {
                        Label("Clear", systemImage: "xmark.circle")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                HStack {
                    
                    // PhotosPicker to select an image
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images, // Show only images in the picker
                        photoLibrary: .shared()
                    ) {
                        Label("Select another image", systemImage: "photo")
                        
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .background(.black.opacity(0.9))
        .navigationTitle("Image Recognition")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showLanguagePicker = true // Show the language picker sheet
                }) {
                    HStack{
                        Text(selectedLanguage.displayTag)
                        Image(systemName: "globe")
                    }
                }
            }
        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePickerView(selectedLanguage: $selectedLanguage, isPresented: $showLanguagePicker)
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) // Auto-open the picker
        .onAppear {
            showPhotoPicker = true
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
        .onChange(of: selectedPhoto) {_ , newItem in
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

