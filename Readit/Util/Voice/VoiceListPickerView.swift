//
//  VoiceListPickerView.swift
//  Readit
//
//  Created by Moutaz Baaj on 30.01.25.
//


import SwiftUI
import AVFoundation

struct VoiceListPickerView: View {
    @Binding var selectedVoice: Voice
    @Binding var isPresented: Bool
    var language: Language
    
    //    let voices: [Voice] = Voice.voices(for: language.rawValue) // Get available voices
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.purple.opacity(0.3), .blue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView {
                    ForEach(Voice.voices(for: language.rawValue), id: \.identifier) { voice in
                            HStack {
                                Text(voice.displayName)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if voice.identifier == selectedVoice.identifier {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .contentShape(Rectangle()) // Ensure the whole row is tappable
                            .overlay{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .onTapGesture {
                                selectedVoice = voice
                                //                        isPresented = false
                            }
                        }
                    }
                    .padding()
                }
                .listStyle(.plain)
                .navigationTitle("Select a Voice")
                .presentationDetents([.medium])
                .presentationCornerRadius(50)
            }
        }
    }
}
