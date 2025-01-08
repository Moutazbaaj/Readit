//
//  LibraryView.swift
//  Readit
//
//  Created by Moutaz Baaj on 07.01.25.
//

import SwiftUI

struct ScanView: View {
    
    // View model to manage the list of bee reports.
    @StateObject private var viewModel = ScanViewModel.shared
    
    
    @State private var showAlert = false // State variable to control the display of the alert.
    @State private var showEditSheet = false // State variable to control the display of the edit sheet.
    @State private var showBeeReportSheet = false  // State to control the visibility of the bee report sheet
    @State private var textItem: FireText? // State variable to keep track of the text to edit or delete.
    
    @State private var selectedLanguage: Language = .english
    @State private var showLanguagePicker: Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                if viewModel.texts.isEmpty {
                    Text("There is no Scans yet!")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.texts.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })) { text in
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text(text.timestamp.dateValue(), style: .date)
                                .font(.callout)
                            
                            Text(text.timestamp.dateValue(), style: .time)
                                .font(.callout)
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.stopSpeaking()
                                textItem = text
                                viewModel.readTextAloud(in: selectedLanguage, text: textItem?.text ?? "no text")
                            }) {
                                Image(systemName: "speaker.wave.2")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(text.text)
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(radius: 5)
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
                                showEditSheet = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                    .listStyle(.insetGrouped)
                    
                    .onAppear {
                        viewModel.fetchMyTexts()
                    }
                    .onDisappear {
                        viewModel.stopSpeaking()
                        
                    }
                }
            }
            .navigationTitle("My Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        showLanguagePicker = true // Show the language picker sheet
                    }) {
                        Label("Language", systemImage: "globe")
                    }
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
            .sheet(isPresented: $showEditSheet) {
                if let text = textItem {
                    //                        EditBeeReportSheetView(
                    //                            beeViewModel: beeViewModel,
                    //                            reportsViewModel: ReportsViewModel(),
                    //                            bee: bee
                    //                        )
                    //                        .presentationDetents([.medium, .large])
                }
            }
            .sheet(isPresented: $showBeeReportSheet) {
                //                    BeeReportSheetView(beeViewModel: beeViewModel)
                //                        .presentationDetents([.large])
            }
        }
    }
}

#Preview {
    
}
