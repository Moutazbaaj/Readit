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
            
            HStack {
                Spacer()
                Text(selectedLanguage.displayName)
                
            }
            .padding(.horizontal)
            
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
                        viewModel.stopSpeaking()

                    }
                }
            }
            
            Button(action: {
                viewModel.stopSpeaking()
                viewModel.readTextAloud(in: selectedLanguage)
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: {
                    showLanguagePicker = true // Show the language picker sheet
                }) {
                    Label("Language", systemImage: "globe")
                }
                
                //                Menu {
                //                    Picker("Language", selection: $selectedLanguage) {
                //                        ForEach(Language.allCases, id: \.self) { language in
                //                            Text(language.displayName).tag(language)
                //                        }
                //                    }
                //                } label: {
                //                    Label("Language", systemImage: "globe")
                //                }
            }
        }
        .sheet(isPresented: $showLanguagePicker) {
            VStack {
                Text("Select Language")
                    .font(.headline)
                    .padding()
                
                Picker("Language", selection: $selectedLanguage) {
                    ForEach(Language.allCases, id: \.self) { language in
                        Text(language.displayName).tag(language)
                    }
                }
                .pickerStyle(WheelPickerStyle()) // Use WheelPicker style
                .frame(height: 200) // Adjust height for better appearance
                
                Button("Done") {
                    showLanguagePicker = false // Dismiss the sheet
                }
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }
            .presentationDetents([.medium])
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
            
            libViewModel.createText(text: extractedText, timestamp: Timestamp())
        }
    }
}

#Preview {
    ImageRecognitionView()
}

