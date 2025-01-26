//
//  TextToSpeechView.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI
import FirebaseCore

struct TextToSpeechView: View {
    @StateObject private var textViewModel = TextToSpeechViewModel.shared
    @StateObject private var libViewModel = ScanViewModel.shared
    
    @State private var selectedLanguage: Language = .englishUS
    @State private var showLanguagePicker: Bool = false
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            .blur(radius: 10)

            
            VStack() {
                // Input text area
                VStack {
                    Text("Enter Text:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    TextEditor(text: $textViewModel.inputText)
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                
                // Language selection
//                HStack {
//                    Text("Language:")
//                        .font(.subheadline)
//                        .padding()
//
//                    Spacer()
//                    Text(selectedLanguage.displayName)
//                        .foregroundColor(.blue)
//                        .onTapGesture {
//                            showLanguagePicker = true
//                        }
//                        .padding()
//                    
//                }
                
                // Action buttons
                HStack {
                    Button(action: {
                        textViewModel.stopSpeaking()
                        textViewModel.readTextAloud(in: selectedLanguage)
                    }) {
                        Label("Read Text", systemImage: "message.badge.waveform")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        textViewModel.stopSpeaking()
                        textViewModel.inputText = ""
                    }) {
                        Label("Clear", systemImage: "xmark.circle")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationTitle("Text to Speech")
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
            .onDisappear {
                textViewModel.stopSpeaking()
                if !textViewModel.inputText.isEmpty {
                    libViewModel.createText(text: textViewModel.inputText)
                }
                textViewModel.inputText = ""
            }
        }
    }
}



#Preview {
    TextToSpeechView()
}
