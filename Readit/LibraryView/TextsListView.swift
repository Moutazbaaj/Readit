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
    @StateObject private var viewModel = LibraryViewModel.shared
    @State private var showAddTextSheet = false
    @State private var showLanguagePicker = false
    @State private var selectedLanguage: Language = .english
    @State private var newTextContent = ""

    var body: some View {
        VStack {
            if viewModel.texts.isEmpty {
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
                }
                .listStyle(.plain)
            }
            
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

        .onAppear {
            viewModel.fetchTexts(forLibraryId: library.id ?? "")
        }
        .onDisappear {
            viewModel.stopSpeaking()

        }
    }
}
