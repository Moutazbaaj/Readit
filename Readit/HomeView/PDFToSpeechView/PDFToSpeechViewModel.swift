//
//  PDFToSpeechViewModel.swift
//  Readit
//
//  Created by Moutaz Baaj on 07.02.25.
//

import Foundation
import UIKit
import Vision
import AVFAudio
import PDFKit


class PDFToSpeechViewModel: ObservableObject {
    
    static let shared = PDFToSpeechViewModel()
    private let synthesizer = AVSpeechSynthesizer()

    @Published var extractedText: String? = nil

    // MARK: - PDF Text Extraction
    func extractText(from pdfURL: URL) async throws -> String {
        guard let pdfDocument = PDFDocument(url: pdfURL) else {
            throw NSError(domain: "PDFError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to load PDF document."])
        }
        
        var textContent = ""  // Local variable to store extracted text

        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex), let pageText = page.string {
                textContent += pageText + "\n"  // Append extracted text
            }
        }

        if textContent.isEmpty {
            throw NSError(domain: "PDFError", code: 2, userInfo: [NSLocalizedDescriptionKey: "No text found in PDF."])
        }
        
        return textContent
    }
    
    func readTextFromPDF(pdfURL: URL) {
        Task {
            do {
                let extractedText = try await extractText(from: pdfURL)
                await MainActor.run {
                    self.extractedText = extractedText  // Update extractedText on the main thread
                }
            } catch {
                print("Error extracting text: \(error.localizedDescription)")
            }
        }
    }
    
    func readTextAloud(in language: Language) {
        if let text = extractedText, !text.isEmpty {
            let utterance = AVSpeechUtterance(string: extractedText ?? "no text")
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
