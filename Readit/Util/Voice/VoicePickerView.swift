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
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .blur(radius: 10)
            .edgesIgnoringSafeArea(.all)
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
            .background(Color.black.opacity(0.6))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .presentationDetents([.medium])
        .presentationCornerRadius(50)
    }
}
}
