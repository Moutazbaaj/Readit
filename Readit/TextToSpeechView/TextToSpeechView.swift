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
    
    @State private var selectedLanguage: Language = .english
    @State private var showLanguagePicker: Bool = false
    
    
    var body: some View {
        VStack {
            VStack() {
                
                // Expandable TextEditor for user input
                TextEditor(text: $textViewModel.inputText)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            HStack {
                Spacer()
                Text(selectedLanguage.displayName)
                
            }
            .padding(.horizontal)
            
            VStack {
                Button(action: {
                    textViewModel.stopSpeaking()
                    textViewModel.readTextAloud(in: selectedLanguage)
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
        .onDisappear {
            textViewModel.stopSpeaking()
            if !textViewModel.inputText.isEmpty {
                libViewModel.createText(text: textViewModel.inputText)
            }
            textViewModel.inputText = ""
        }
    }
}

#Preview {
    TextToSpeechView()
}
