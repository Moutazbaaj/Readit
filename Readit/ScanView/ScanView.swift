//
//  LibraryView.swift
//  Readit
//
//  Created by Moutaz Baaj on 07.01.25.
//

import SwiftUI

struct ScanView: View {
    @StateObject private var viewModel = ScanViewModel.shared

    @State private var showAlert = false
    @State private var textItem: FireText?

    @State private var selectedLanguage: Language = .english
    @State private var showLanguagePicker: Bool = false

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            .blur(radius: 10) // Adding a subtle blur effect to the background

            VStack {
                if viewModel.texts.isEmpty {
                    Text("There is no Scans yet!")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.texts.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })) { text in
                        VStack(alignment: .leading) {
                            // Date and time display
                            HStack(alignment: .firstTextBaseline) {
                                Text(text.timestamp.dateValue(), style: .date)
                                    .font(.callout)

                                Text(text.timestamp.dateValue(), style: .time)
                                    .font(.callout)

                                Spacer()

                                // Read text button
                                Button(action: {
                                    viewModel.stopSpeaking()
                                    textItem = text
                                    viewModel.readTextAloud(in: selectedLanguage, text: textItem?.text ?? "no text")
                                }) {
                                    Image(systemName: "speaker.wave.2")
                                }
                            }

                            // Text display
                            Text(text.text)
                                .font(.headline)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                textItem = text
                                showAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .listRowBackground(Color.clear) // Ensure list rows have no default background
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
                }
                .padding(.vertical)
            }
            .padding()
            .onDisappear {
                viewModel.stopSpeaking()
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    showLanguagePicker = true
//                }) {
//                    Label("Language", systemImage: "globe")
//                }
//            }
//        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePickerView(selectedLanguage: $selectedLanguage, isPresented: $showLanguagePicker)
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
    }
}

#Preview {
    
}
