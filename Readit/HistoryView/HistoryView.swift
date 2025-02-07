//
//  HistoryView.swift
//  Readit
//
//  Created by Moutaz Baaj on 07.01.25.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel.shared
    
    @State private var showAlert = false
    @State private var textItem: FireText?
    @State private var isAnimating = false
    
    
    @State private var isPlay = false
    @State private var isPause = false
    @State private var isResume = false
    @State private var isStop = true
    
//    @State private var selectedLanguage: Language = .englishUS
//    @State private var selectedVoice = Voice.allCases.first ?? .custom(identifier: "", language: "en-US", name: "") // Selected voice
//    @State private var showLanguagePicker: Bool = false
    
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    if viewModel.texts.isEmpty {
                        Text("There is no History yet!")
                            .font(.headline)
                            .foregroundColor(.gray)
                    } else {
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
                                    if TextToSpeechManager.shared.isSpeaking(text: text.text) {
                                        SpeakingIndicator(isAnimating: $isAnimating)
                                            .frame(width: 25)
                                            .opacity(isPlay ? 1 : 0)
                                    
                                    Spacer()
                                    if isPlay {
                                        Button(action: {
                                            isPause = true
                                            isPlay = false
                                            
                                            viewModel.pauseSpeaking()
                                        }) {
                                            Image(systemName: "pause")
                                                .frame(width: 25)  // Ensure consistent space
                                                .opacity(isPlay ? 1 : 0) // Hides without affecting layout
                                            
                                        }.padding()
                                        
                                    }
                                    
                                    if isPause {
                                        
                                        Button(action: {
                                            isPause = false
                                            isPlay = true
                                            
                                            viewModel.resumeSpeaking()
                                        }) {
                                            Image(systemName: "play")
                                                .frame(width: 25)  // Ensure consistent space
                                                .opacity(isPause ? 1 : 0) // Hides without affecting layout
                                            
                                        }.padding()
                                        
                                    }
                                        
                                    }

                                    if isStop {
                                        Divider()
                                            .padding()
                                        
                                        // Read text button
                                        Button(action: {
                                            isPlay = true
                                            isResume = true
                                            isStop = false
                                            
                                            viewModel.stopSpeaking()
                                            textItem = text
                                            viewModel.readTextAloud(form: textItem?.text ?? "no text")
                                            viewModel.stopSpeaking()
                                        }) {
                                            Image(systemName: "speaker.wave.2")
                                                .frame(width: 25 , height: 25)  // Ensure consistent space
                                        }.padding()
                                        
                                    }
                                    
                                    if isResume {
                                        Divider()
                                            .padding()
                                        
                                        // stpo Read text button
                                        Button(action: {
                                            isPause = false
                                            isPlay = false
                                            isResume = false
                                            isStop = true
                                            
                                            viewModel.stopSpeaking()
                                        }) {
                                            Image(systemName: "stop")
                                                .frame(width: 25 , height: 25)  // Ensure consistent space
                                        }.padding()
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
                                    Button(role: .destructive) {
                                        textItem = text
                                        showAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    Spacer()
                    
                }
                Divider().hidden()

            }
//            .onAppear {
//                TextToSpeechManager.shared.fetchPrefrences()
//            }
            .onDisappear {
                viewModel.stopSpeaking()
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
////                    showLanguagePicker = true // Show the language picker sheet
//                }) {
                    HStack{
                        let language = TextToSpeechManager.shared.preferences.first?.selectedLanguage
                        Text(language ?? ("en-US"))
                        Image(systemName: "globe")
                    }
                }
            }
//        }
//        .sheet(isPresented: $showLanguagePicker) {
//            LanguagePickerView(selectedLanguage: $selectedLanguage, isPresented: $showLanguagePicker)
//        }
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
