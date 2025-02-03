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
    
    @State private var selected =  0
    @State private var expand = false
    
    
    
    //    @State private var showVoicePicker = false // Controls the voice picker presentation
    //    @State private var selectedVoice = Voice.allCases.first ?? .custom(identifier: "", language: "", name: "") // Selected voice
    //    @State private var showLanguagePicker = false
    //    @State private var selectedLanguage: Language = .englishUS
    
    
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
                        List(viewModel.texts.sorted(by: {
                            $0.timestamp.dateValue() < $1.timestamp.dateValue()
                        })) { text in
                            VStack(alignment: .leading) {
                                
                                // Text display
                                let highlightedTextView = viewModel.highlightedText(text.text)
                                
                                highlightedTextView
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                                
                                Text(text.timestamp.dateValue(), style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom)
                            .contextMenu{
                                Button {
                                    viewModel.stopSpeaking()
                                    textItem = text
                                    viewModel.readTextAloud(form: text.text)
                                } label: {
                                    Label("Read", systemImage: "speaker.wave.2")
                                }
                                .tint(.blue)
                                Button {
                                    textItem = text
                                    editingTextContent = text.text
                                    showEditTextSheet = true
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                                Button(role: .destructive) {
                                    textItem = text
                                    showAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
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
                                Button {
                                    viewModel.stopSpeaking()
                                    textItem = text
                                    viewModel.readTextAloud(form: text.text)
                                } label: {
                                    Label("Read", systemImage: "speaker.wave.2")
                                }
                                .tint(.yellow)
                            }
                        }
                        .listStyle(.plain)
                        .background(Color.clear) // Transparent list background
                    }
                    Divider().hidden()
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
                            
                            //                             Button(action: { self.selected = 0}) {
                            //                                 NavigationLink(destination: HistoryView()){
                            //                                     Image(systemName: "house")
                            //                                         .foregroundColor(self.selected == 0 ? .black : .gray)
                            //                                 }
                            //                             }
                            
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
                                capturedImage = nil
                                showCameraCaptureView = true
                                
                            } label: {
                                Image(systemName: "camera")
                            }
                            .foregroundColor(self.selected == 3 ? .black : .gray)
                            
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
                    .clipShape(Capsule())
                    .padding(.bottom)
                    .padding()
                    .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6), value: expand)
                }
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            Text(textToSpeechManager.preferences.first?.selectedLanguageName ?? "English")
            Image(systemName: "globe")
//            Menu {
//                Button("Add New Text") {
//                    showAddTextSheet = true
//                }
//                Button("Scan a Document") {
//                    capturedImage = nil
//                    showCameraCaptureView = true
//                }
//                .onChange(of: capturedImage) { _, newImage in
//                    if let newImage = newImage {
//                        viewModel.selectedImage = newImage
//                        viewModel.processImage(image: newImage)
//                        guard let extractedText = viewModel.extractedText, !extractedText.isEmpty else {
//                            return
//                        }
//                        viewModel.createText(text: extractedText, libraryId: library.id ?? "")
//                        viewModel.fetchTexts(forLibraryId: library.id ?? "")
//                        
//                    }
//                }
//                
//            } label: {
//                Image(systemName: "ellipsis.circle")
//                    .font(.title2)
//            }
        })
        .sheet(isPresented: $showCameraCaptureView) {
            CameraView(image: $capturedImage)
                .presentationCornerRadius(20)
            
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
            .presentationCornerRadius(30)
            
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
        }
        .onDisappear {
            viewModel.stopSpeaking()
            capturedImage = nil
        }
    }
}
