//
//  TextsListView.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import Foundation
import SwiftUI

struct TextsListView: View {
    
    let library: FireLibrary
    
    @State private var textItem: FireText? // State variable to keep track of the text to edit or delete.
    @State private var showEditTextSheet = false
    @State private var showAlert = false // State variable to control the display of the alert.
    @StateObject private var viewModel = LibraryViewModel.shared
    @State private var showAddTextSheet = false
    @State private var showLanguagePicker = false
    @State private var selectedLanguage: Language = .english
    @State private var newTextContent = ""
    @State private var editingTextContent = ""


    var body: some View {
        VStack {
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
                        Text(text.timestamp.dateValue(), style: .date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(8)
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
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Text(selectedLanguage.displayName)
                Button(action: {
                    showLanguagePicker = true // Show the language picker sheet
                }) {
                    Label("Language", systemImage: "globe")
                }
            }
            .padding()
        }
        .navigationTitle(library.libraryTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                viewModel.stopSpeaking()
                viewModel.readTextAloud(from: library, in: Language(rawValue: selectedLanguage.rawValue) ?? Language.english)
            }) {
                Image(systemName: "speaker.wave.2.fill")
            }
            
            Button(action: {
                showAddTextSheet = true
            }) {
                Image(systemName: "plus")
            }
        })
        .sheet(isPresented: $showAddTextSheet) {
            VStack {
                Text("Add New Text")
                    .font(.headline)
                    .padding()

                // Expandable TextEditor for user input
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
        .sheet(isPresented: $showEditTextSheet) {
            VStack {
                Text("Edit Text")
                    .font(.headline)
                    .padding()

                // TextEditor bound to editingTextContent
                TextEditor(text: $editingTextContent)
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .frame(maxHeight: .infinity)

                // Save button
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
                .disabled(editingTextContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) // Prevent saving empty content

                Spacer()
            }
            .padding()
            .presentationDetents([.medium, .large])
        }        .alert(isPresented: $showAlert) {
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

