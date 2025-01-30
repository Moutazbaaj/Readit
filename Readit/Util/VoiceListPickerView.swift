//
//  VoicePickerView.swift
//  Readit
//
//  Created by Moutaz Baaj on 30.01.25.
//


import SwiftUI
import AVFoundation

struct VoicePickerView: View {
    @Binding var selectedVoice: Voice
    @Binding var isPresented: Bool
    var language: Language

    let voices: [Voice] = Voice.voices(for: language.rawValue) // Get available voices

    var body: some View {
        NavigationView {
            List {
                ForEach(voices, id: \.identifier) { voice in
                    HStack {
                        Text(voice.displayName)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if voice.identifier == selectedVoice.identifier {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle()) // Ensure the whole row is tappable
                    .onTapGesture {
                        selectedVoice = voice
                        isPresented = false
                    }
                }
            }
            .navigationTitle("Select a Voice")
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
    }
}