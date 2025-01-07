//
//  TextToSpeechViewModel.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import Foundation
import AVFAudio


class TextToSpeechViewModel: ObservableObject {
    @Published var inputText: String = ""

    private let synthesizer = AVSpeechSynthesizer()

    func readTextAloud(in language: Language) {
        guard !inputText.isEmpty else { return }
        let utterance = AVSpeechUtterance(string: inputText)
        utterance.voice = AVSpeechSynthesisVoice(language: language.rawValue)
        
        // Configure audio session
    
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
        
        synthesizer.speak(utterance)
    }
    
    
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}
