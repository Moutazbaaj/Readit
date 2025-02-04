//
//  CameraRecognitionViewModel.swift
//  Readit
//
//  Created by Moutaz Baaj on 04.02.25.
//


import Foundation
import UIKit
import Vision
import AVFAudio


class CameraRecognitionViewModel: ObservableObject {
    
    static let shared = CameraRecognitionViewModel()
    private let synthesizer = AVSpeechSynthesizer()

    @Published var selectedImage: UIImage?
    @Published var extractedText: String?

    func processImage(image: UIImage?) {
        guard let image = image, let cgImage = image.cgImage else { return }
        
        // Specify the languages you want to recognize
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Text recognition failed with error: \(error.localizedDescription)")
                return
            }
            
            if let results = request.results as? [VNRecognizedTextObservation] {
                let recognizedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
                DispatchQueue.main.async {
                    self.extractedText = recognizedText
                }
            }
        }
        
        // Set recognition languages
        request.recognitionLanguages = ["en", "ar", "ja", "zh-Hans", "zh-Hant"] // English, Arabic, Japanese, Simplified and Traditional Chinese
        
        // Fallback to automatic language detection if needed
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
    
    func readTextAloud(in language: Language) {
        if let text = extractedText, !text.isEmpty {
            let utterance = AVSpeechUtterance(string: text)
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
    }
    
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}
