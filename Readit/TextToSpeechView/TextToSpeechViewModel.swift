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

    func readTextAloud() {
        guard !inputText.isEmpty else { return }
        let utterance = AVSpeechUtterance(string: inputText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}
