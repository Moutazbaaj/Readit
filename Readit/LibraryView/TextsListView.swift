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
    @State private var showPhotoPicker = false
    @State private var showAlert = false // State variable to control the display of the alert.
    @StateObject private var viewModel = LibraryViewModel.shared
    @State private var showAddTextSheet = false
    @State private var showLanguagePicker = false
    @State private var selectedLanguage: Language = .english
    @State private var newTextContent = ""
    @State private var editingTextContent = ""
    @State private var capturedImage: UIImage? // To hold the captured image
    @State private var selectedItem: PhotosPickerItem? // For the selected image from the picker
    
    
    
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
                                .padding(5)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                            
                            Text(text.timestamp.dateValue(), style: .date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.clear) // Clear background for the row
                        .listRowBackground(Color.clear) // Ensure no opaque row background
                        .cornerRadius(10)
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
                    Text("Language:")
                        .font(.subheadline)
                    Spacer()
                    Text(selectedLanguage.displayName)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showLanguagePicker = true
                        }
                        .padding(.vertical)
                }
                .padding()
            }
        }
        //        .navigationTitle(library.libraryTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                viewModel.stopSpeaking()
                viewModel.readTextAloud(from: library, in: selectedLanguage)
            }) {
                Image(systemName: "speaker.wave.2.fill")
            }
            
            Menu {
                Button("Add New Text", action: {
                    showAddTextSheet = true
                })
                Button("Scan Text") {
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
                
                Button("Extract Text From a Photo") {
                    showPhotoPicker = true
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
                            
                            viewModel.createText(text: extractedText, libraryId: library.id ?? "")
                        }
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title2)
            }
        })
        .sheet(isPresented: $showCameraCaptureView) {
            CameraView(image: $capturedImage)
        }
        .sheet(isPresented: $showPhotoPicker) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images, // Show only images in the picker
                photoLibrary: .shared()
            ) {
                Label("Select Photo", systemImage: "photo")
                
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .presentationDetents([.medium])
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
        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePickerView(selectedLanguage: $selectedLanguage, isPresented: $showLanguagePicker)
        }
        .sheet(isPresented: $showEditTextSheet) {
            VStack {
                Text("Edit Text")
                    .font(.headline)
                    .padding()
                
                TextEditor(text: $editingTextContent)
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .frame(maxHeight: .infinity)
                
                Button("Save Changes") {
                    if let textItem = textItem {
                        viewModel.editText(withId: textItem.id ?? "", newText: editingTextContent)
                        showEditTextSheet = false
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(editingTextContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                Spacer()
            }
            .padding()
            .presentationDetents([.medium, .large])
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirm Delete"),
                message: Text("Are you sure you want to delete this text?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let text = textItem {
                        viewModel.deleteText(withId: text.id)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            viewModel.fetchTexts(forLibraryId: library.id ?? "")
        }
        .onDisappear {
            viewModel.stopSpeaking()
        }
    }
}
