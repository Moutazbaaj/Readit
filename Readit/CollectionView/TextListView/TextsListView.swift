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
    
    @StateObject private var viewModel = CollectionViewModel.shared
    @StateObject private var textToSpeechManager = TextToSpeechManager.shared
    
    @State private var textItem: FireText? // State variable to keep track of the text to edit or delete.
    @State private var showEditTextSheet = false
    @State private var showCameraCaptureView = false
    @State private var showAlert = false // State variable to control the display of the alert.
    @State private var showAddTextSheet = false
    @State private var newTextContent = ""
    @State private var editingTextContent = ""
    @State private var capturedImage: UIImage? // To hold the captured image
    @State private var selectedPhoto: PhotosPickerItem? // For the selected image from the picker
    @State private var showPhotoPicker: Bool = false  // State to trigger the picker automatically
    @State private var isLoading: Bool = false  // Controls loading state
    @State private var isAnimating = false
    
    
    @State private var isPlay = false
    @State private var isPause = false
    @State private var isResume = false
    @State private var isStop = false
    
    
    
    @State private var selected =  0
    @State private var expand = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .bottomTrailing){
                
                VStack {
                    HStack {
                        Text(library.libraryTitle)
                            .font(.largeTitle)
                            .bold()
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
                        ScrollView {
                            ForEach(viewModel.texts.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })) { text in
                                VStack(alignment: .leading) {
                                    // Date and time display
                                    Divider()
                                    HStack() {
                                        
                                        Text(text.timestamp.dateValue(), style: .date)
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                        
                                        Text(text.timestamp.dateValue(), style: .time)
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                        
                                        Spacer()
                                        
                                        if textToSpeechManager.isSpeaking(text: text.text) {
                                            SpeakingIndicator(isAnimating: $isAnimating)
                                            Divider()
                                                .padding()
                                            
                                        }
                                        
//                                        Button(action: {
//                                            viewModel.pauseSpeaking()
//                                        }) {
//                                            Image(systemName: "pause")
//                                        }
//                                        
//                                        Divider()
//                                            .padding()
//                                        
//                                        Button(action: {
//                                            viewModel.resumeSpeaking()
//                                        }) {
//                                            Image(systemName: "play")
//                                        }
//                                        
//                                        Divider()
//                                            .padding()

                                        
                                        // Read text button
                                        Button(action: {
                                            viewModel.stopSpeaking()
                                            textItem = text
                                            viewModel.readTextAloud(form: textItem?.text ?? "no text")
                                            viewModel.stopSpeaking()
                                        }) {
                                            Image(systemName: "play")
//                                          Image(systemName: "speaker.wave.2")
                                        }
                                        
                                        
                                        Divider()
                                            .padding()
                                        
                                        
                                        // stpo Read text button
                                        Button(action: {
                                            viewModel.stopSpeaking()
                                        }) {
                                            Image(systemName: "stop")
                                        }
                                        
                                    }
                                    
                                    
                                    VStack(alignment: .leading) {
                                        // Text display
                                        let highlightedTextView = viewModel.highlightedText(text.text)
                                        
                                        highlightedTextView
                                            .font(.subheadline)
                                            .padding()
                                            .frame(maxWidth: .infinity , alignment: .leading)
                                            .background(Color.white.opacity(0.2))
                                            .cornerRadius(15)
                                            .shadow(radius: 5)
                                    }
                                    .contextMenu{
                                        Button {
                                            textItem = text
                                            editingTextContent = text.text
                                            showEditTextSheet = true
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        Button(role: .destructive) {
                                            textItem = text
                                            showAlert = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }.padding()
                            }
                            Text("Space holder").hidden()
                            
                            
                        }
                        Divider().padding().hidden()
                        
                    }
                }
                
                //floting tab bar
                HStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            self.expand.toggle() // Toggle expand on tap
                        }) {
                            Image(systemName: expand ? "arrow.right" : "plus") // Dynamic icon
                                .foregroundColor(.black)
                                .padding()
                        }
                        
                        if expand {
                            
                            Button {
                                self.selected = 0
                                viewModel.stopSpeaking()
                                viewModel.readTextAloudForLibrary(from: library)
                            } label: {
                                Label("", systemImage: "speaker.wave.2")
                            }
                            .foregroundColor(self.selected == 0 ? .black : .gray)
                            
                            Spacer()
                            
                            Button {
                                self.selected = 1
                                viewModel.stopSpeaking()
                            } label: {
                                Label("", systemImage: "stop")
                            }
                            .foregroundColor(self.selected == 1 ? .black : .gray)
                            
                            Spacer()
                            
                            Button {
                                self.selected = 2
                                showAddTextSheet = true
                            } label: {
                                Label("", systemImage: "plus")
                            }
                            .foregroundColor(self.selected == 2 ? .black : .gray)
                            
                            Spacer()
                            
                            Button {
                                self.selected = 3
                                selectedPhoto = nil
                                showPhotoPicker = true
                                
                            } label: {
                                Image(systemName: "photo")
                            }
                            .foregroundColor(self.selected == 3 ? .black : .gray)
                            
                            Spacer()
                            
                            Button {
                                self.selected = 4
                                capturedImage = nil
                                showCameraCaptureView = true
                                
                            } label: {
                                Image(systemName: "scanner")
                            }
                            .foregroundColor(self.selected == 4 ? .black : .gray)
                            
                            Spacer()
                        }
                    }
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.95), Color.white.opacity(0.95)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.bottom)
                    .padding()
                    .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6), value: expand)
                }.padding(.horizontal, 4)
                
            }
            
            if isLoading {
                ZStack {
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    VStack {
                        ProgressView("Processing Image...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .font(.headline)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            Text(textToSpeechManager.preferences.first?.selectedLanguageName ?? "English")
            Image(systemName: "globe")
        })
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) // Auto-open the picker
        .onChange(of: capturedImage) { _, newImage in
            Task {
                if let newImage = newImage {
                    isLoading = true
                    viewModel.selectedImage = newImage
                    if let extractedText = await viewModel.processImage(image: newImage), !extractedText.isEmpty {
                        viewModel.createText(text: extractedText, libraryId: library.id ?? "")
                        viewModel.fetchTexts(forLibraryId: library.id ?? "")
                    }
                    isLoading = false
                }
            }
        }
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    isLoading = true
                    viewModel.selectedImage = uiImage
                    if let extractedText = await viewModel.processImage(image: uiImage), !extractedText.isEmpty {
                        viewModel.createText(text: extractedText, libraryId: library.id ?? "")
                        viewModel.fetchTexts(forLibraryId: library.id ?? "")
                    }
                    isLoading = false
                }
            }
        }
        .sheet(isPresented: $showCameraCaptureView) {
            CameraView(image: $capturedImage)
                .presentationCornerRadius(30)
            
        }
        .sheet(isPresented: $showAddTextSheet) {
            AddTextView(showAddTextSheet: $showAddTextSheet, newTextContent: $newTextContent, library: library)
        }
        .sheet(isPresented: $showEditTextSheet) {
            //            EditTextView(showEditTextSheet: $showEditTextSheet, editingTextContent: $editingTextContent, textItem: textItem)
            ZStack {
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
                        if !editingTextContent.isEmpty, let textID = textItem?.id {
                            viewModel.editText(withId: textID, newText: editingTextContent)
                            showEditTextSheet = false
                        }
                    }) {
                        Text("Done")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(editingTextContent.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(editingTextContent.isEmpty)
                    
                    Spacer()
                }
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)
                )
                .presentationDetents([.medium, .large]) // Adaptive sheet height
                .presentationCornerRadius(30)
            }
            .background(.black)
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
        .onAppear {
            viewModel.fetchTexts(forLibraryId: library.id ?? "")
            viewModel.extractedText = nil
            viewModel.selectedImage = nil
        }
        .onDisappear {
            viewModel.stopSpeaking()
            capturedImage = nil
        }
    }
}
