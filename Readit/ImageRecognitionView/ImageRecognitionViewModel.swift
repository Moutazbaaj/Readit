//
//  ImageRecognitionViewModel.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import Foundation
import UIKit
import Vision
import AVFAudio


class ImageRecognitionViewModel: ObservableObject {
    
    private let synthesizer = AVSpeechSynthesizer()

    @Published var showImagePicker = false
    @Published var selectedImage: UIImage?
    @Published var extractedText: String?

    func processImage(image: UIImage?) {
        guard let image = image, let cgImage = image.cgImage else { return }
        let request = VNRecognizeTextRequest { request, error in
            if let results = request.results as? [VNRecognizedTextObservation] {
                let recognizedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
                DispatchQueue.main.async {
                    self.extractedText = recognizedText
                }
            }
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
    
    func readTextAloud(in language: Language) {
        if let text = extractedText, !text.isEmpty {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: language.rawValue)
            synthesizer.speak(utterance)
        }
    }
    
    
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}

