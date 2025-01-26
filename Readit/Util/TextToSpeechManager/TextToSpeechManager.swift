//
//  TextToSpeechManager.swift
//  Readit
//
//  Created by Moutaz Baaj on 26.01.25.
//


import AVFoundation
import SwiftUICore

class TextToSpeechManager {
    
    static let shared = TextToSpeechManager()

    @Published var texts : [FireText] = []
    @Published var libreries : [FireLibrary] = []
    
    private var synthesizer = AVSpeechSynthesizer()

    
    func readTextAloudForLibrary(from library: FireLibrary, in language: Language, using voice: Voice) {
        guard !texts.isEmpty else {
            print("No texts available to read aloud.")
            return
        }

        // Filter and prepare texts to read
        let textsToRead = texts
            .filter { $0.libraryId == library.id } // Ensure the texts belong to the specified library
            .sorted(by: {
                $0.timestamp.dateValue() < $1.timestamp.dateValue() // Sort by timestamp in ascending order
            })
            .enumerated() // Enumerate to get both index and content
            .map { index, text in
                "\(language.pageTranslation) \(index + 1). \(text.text)" // Add "Page X" prefix before each text
            }
            .joined(separator: ". ") // Concatenate texts with a separator

        let utterance = AVSpeechUtterance(string: textsToRead)

        // Configure voice
        if let customVoice = AVSpeechSynthesisVoice(identifier: voice.identifier) {
            utterance.voice = customVoice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: language.rawValue) // Fallback to language-based voice
        }

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
