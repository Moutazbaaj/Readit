//
//  TextsListView.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import Foundation
import SwiftUI
import PhotosUI

struct TextsListView: View {
    
    let library: FireLibrary
    
    @State private var textItem: FireText? // State variable to keep track of the text to edit or delete.
    @State private var showEditTextSheet = false
    @State private var showCameraCaptureView = false
    @State private var showAlert = false // State variable to control the display of the alert.
    @StateObject private var viewModel = LibraryViewModel.shared
    @State private var showAddTextSheet = false
    @State private var showLanguagePicker = false
    @State private var selectedLanguage: Language = .englishUS
    @State private var newTextContent = ""
    @State private var editingTextContent = ""
    @State private var capturedImage: UIImage? // To hold the captured image
    @State private var showVoicePicker = false // Controls the voice picker presentation
    @State private var selectedVoice = Voice.allCases.first ?? .custom(identifier: "", language: "", name: "") // Selected voice
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text(library.libraryTitle)
                        .font(.largeTitle)
                        .padding()
                    
                    Spacer()
                    
                }
                
                
                if viewModel.texts.isEmpty {
                    Spacer()
                    Text("No texts in this library.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.texts.sorted(by: {
                        $0.timestamp.dateValue() < $1.timestamp.dateValue()
                    })) { text in
                        VStack(alignment: .leading) {
                            Text(text.text)
                                .font(.headline)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(15)
                            
                            Text(text.timestamp.dateValue(), style: .date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.clear) // Clear background for the row
                        .listRowBackground(Color.clear) // Ensure no opaque row background
                        .cornerRadius(15)
                        .swipeActions {
                            Button(role: .destructive) {
                                textItem = text
                                showAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                            
                            Button {
                                textItem = text
                                editingTextContent = text.text
                                showEditTextSheet = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                    .listStyle(.plain)
                    .background(Color.clear) // Transparent list background
                }
                
                Spacer()
                HStack {
                    //Language
                    VStack {
                        Text("Language:")
                            .font(.subheadline)
                        Button(action: {
                            showLanguagePicker = true
                        }) {
                            Text(selectedLanguage.displayName)
                                .foregroundColor(.white) // Text color for the button
                                .padding()
                                .background(Color.black.opacity(0.5)) // Button background color
                                .cornerRadius(20) // Rounded corners
                        }
                    }
                    .padding()
                    Spacer()
                    //Voice
                    VStack {
                        Text("Voice:")
                            .font(.subheadline)
                        Button(action: {
                            showVoicePicker = true
                        }) {
                            Text(selectedVoice.displayName)
                                .foregroundColor(.white) // Text color for the button
                                .padding()
                                .background(Color.black.opacity(0.5)) // Button background color
                                .cornerRadius(20) // Rounded corners
                        }
                    }
                    .padding()
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                viewModel.stopSpeaking()
                viewModel.readTextAloudForLibrary(from: library, in: selectedLanguage, using: selectedVoice)
            }) {
                Image(systemName: "speaker.wave.2.fill")
            }
            
            Menu {
                Button("Add New Text") {
                    showAddTextSheet = true
                }
                Button("Scan a Document") {
                    capturedImage = nil
                    showCameraCaptureView = true
                }
                .onChange(of: capturedImage) { _, newImage in
                    if let newImage = newImage {
                        viewModel.selectedImage = newImage
                        viewModel.processImage(image: newImage)
                        guard let extractedText = viewModel.extractedText, !extractedText.isEmpty else {
                            return
                        }
                        viewModel.createText(text: extractedText, libraryId: library.id ?? "")
                    }
                }
                
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
            }
        })
        .sheet(isPresented: $showCameraCaptureView) {
            CameraView(image: $capturedImage)
                .presentationCornerRadius(20)

        }
        .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerView(selectedLanguage: $selectedLanguage, isPresented: $showLanguagePicker)
        }
        .sheet(isPresented: $showVoicePicker) {
            VoicePickerView(selectedVoice: $selectedVoice, isPresented: $showVoicePicker, language: selectedLanguage)
        }
        .sheet(isPresented: $showAddTextSheet) {
            VStack {
                Text("Add New Text")
                    .font(.headline)
                    .padding()
                
                TextEditor(text: $newTextContent)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Button(action: {
                    if !newTextContent.isEmpty {
                        viewModel.createText(text: newTextContent, libraryId: library.id ?? "")
                        newTextContent = ""
                        showAddTextSheet = false
                    }
                }) {
                    Text("Add Text")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(newTextContent.isEmpty)
                
                Spacer()
            }
            .padding()
            .presentationDetents([.medium, .large])
            .presentationCornerRadius(50)

        }
        .sheet(isPresented: $showEditTextSheet) {
                VStack {
                    Text("Edit Text")
                        .font(.headline)
                        .padding()
                    
                    TextEditor(text: $editingTextContent)
                        .padding()
                        .frame(maxHeight: .infinity)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    Button(action: {
                        if !editingTextContent.isEmpty {
                            viewModel.editText(withId: textItem?.id ?? " ", newText: editingTextContent)
                            editingTextContent = ""
                            showEditTextSheet = false
                        }
                    }) {
                        Text("Done")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(editingTextContent.isEmpty)
                    
                    Spacer()
                }
                .padding()
                .presentationDetents([.medium, .large])
                .presentationCornerRadius(50)

            }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirm Delete"),
                message: Text("Are you sure you want to delete this text?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let text = textItem {
                        viewModel.deleteText(withId: text.id, fromLibrary: library.id ?? "")
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onChange(of: selectedLanguage) {_, newLanguage in
            if let firstVoice = Voice.voices(for: newLanguage.rawValue).first {
                selectedVoice = firstVoice
            }
        }
        .onAppear {

            viewModel.fetchTexts(forLibraryId: library.id ?? "")
                
            if let firstVoice = Voice.voices(for: selectedLanguage.rawValue).first {
                        selectedVoice = firstVoice
                    }
                }
        .onDisappear {
            viewModel.stopSpeaking()
            capturedImage = nil
        }
    }
}
