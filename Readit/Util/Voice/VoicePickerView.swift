//
//  VoicePickerView.swift
//  Readit
//
//  Created by Moutaz Baaj on 26.01.25.
//

import SwiftUI
import AVFoundation

struct VoicePickerView: View {
    @Binding var selectedVoice: Voice
    @Binding var isPresented: Bool
    var language: Language


    var body: some View {
        VStack {
            Text("Select Voice")
                .font(.headline)
                .padding()

            Picker("Voice", selection: $selectedVoice) {
                ForEach(Voice.voices(for: language.rawValue), id: \.identifier) { voice in
                    Text(voice.displayName).tag(voice)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 200)

            Button("Done") {
                isPresented = false
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .presentationDetents([.medium])
    }
}
