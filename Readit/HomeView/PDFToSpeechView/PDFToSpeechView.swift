//
//  PDFToSpeechView.swift
//  Readit
//
//  Created by Moutaz Baaj on 07.02.25.
//

import SwiftUI
import SwiftUI
import FirebaseCore

struct PDFToSpeechView: View {
    
    //    var body: some View {
    //        VStack {
    //            Button("Select PDF to Read") {
    //                showDocumentPicker = true
    //            }
    //            .padding()
    //            .background(Color.blue)
    //            .foregroundColor(.white)
    //            .cornerRadius(10)
    //        }
    //        .sheet(isPresented: $showDocumentPicker) {
    //            DocumentPicker { url in
    //                TextToSpeechManager.shared.readTextFromPDF(pdfURL: url)
    //            }
    //        }
    //    }
    //}
    
    
    @StateObject private var viewModel = PDFToSpeechViewModel.shared
    @StateObject private var libViewModel = CollectionViewModel.shared
    
    @State private var showLanguagePicker: Bool = false
    @State private var selectedLanguage: Language = .englishUS
    @State private var showDocumentPicker = false

    
    
    
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
                if let extractedText = viewModel.extractedText {
                    Text("Extracted Text:")
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    
                    Spacer()
                    
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
                        .frame(maxHeight: .infinity)
                        
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
                        guard let extractedText = viewModel.extractedText, !extractedText.isEmpty else {
                            return
                        }
                        
                        libViewModel.createText(text: extractedText, libraryId: " ")
                        //                        viewModel.selectedImage = nil
                        viewModel.extractedText = ""
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
                    VStack {
                        Button("Re Select PDF", systemImage: "document.badge.ellipsis") {
                            showDocumentPicker = true
                        }
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
        .navigationTitle("PDF Text Recognition")
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
        .onAppear {
            viewModel.extractedText = ""
            showDocumentPicker = true

        }
        .onDisappear {
            viewModel.stopSpeaking()
            
            guard let extractedText = viewModel.extractedText, !extractedText.isEmpty else {
                return
            }
            
            libViewModel.createText(text: extractedText, libraryId: " ")
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { url in
                viewModel.readTextFromPDF(pdfURL: url) // Corrected reference
            }
        }
    }
}

