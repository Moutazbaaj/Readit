//
//  TextToSpeechManager.swift
//  Readit
//
//  Created by Moutaz Baaj on 26.01.25.
//


import AVFoundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class TextToSpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    static let shared = TextToSpeechManager()
    
    @Published var texts: [FireText] = []
    @Published var libraries: [FireLibrary] = []
    @Published var preferences: [FirePreference] = []
    @Published var currentWordRange: NSRange? = nil
    @Published var currentText: String? = nil
    
    private var synthesizer = AVSpeechSynthesizer()
    private var listener: ListenerRegistration?
    private let firebaseAuthentication = Auth.auth()
    private let firebaseFirestore = Firestore.firestore()
    
    override init() {
        super.init()
        synthesizer.delegate = self
        fetchPrefrences()
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.currentWordRange = characterRange
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.currentWordRange = nil
        }
    }
    
    // MARK: - Speech Control Methods

    func readTextAloud(from inputText: String) {
        guard !inputText.isEmpty else {
            print("No text provided for reading.")
            return
        }
        
        currentText = inputText
        
        let utterance = AVSpeechUtterance(string: inputText)
        
        if let voice = preferences.first?.selectedVoice {
            if let customVoice = AVSpeechSynthesisVoice(identifier: voice.identifier) {
                utterance.voice = customVoice
            } else {
                utterance.voice = AVSpeechSynthesisVoice(language: voice.language)
            }
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: Language.englishUS.rawValue) // Default to English
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
    
    func readTextAloudForLibrary(from library: FireLibrary, from texts: [FireText]) {
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
                 "\(text.text)" // Add "Page X" prefix before each text
            }
            .joined(separator: ". ") // Concatenate texts with a separator
        
        let utterance = AVSpeechUtterance(string: textsToRead)
        
        if let voice = preferences.first?.selectedVoice {
            if let customVoice = AVSpeechSynthesisVoice(identifier: voice.identifier) {
                utterance.voice = customVoice
            } else {
                utterance.voice = AVSpeechSynthesisVoice(language: voice.language)
            }
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: Language.englishUS.rawValue) // Default to English
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
    
    func pauseSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
        }
    }
    
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    func highlightedText(_ fullText: String) -> Text {
        guard fullText == currentText,
              let range = currentWordRange,
              let textRange = Range(range, in: fullText) else {
            return Text(fullText)
        }

        let before = String(fullText[..<textRange.lowerBound])
        let highlighted = String(fullText[textRange])
        let after = String(fullText[textRange.upperBound...])

        return Text(before) + Text(highlighted).foregroundColor(.blue).font(.subheadline) + Text(after)
    }
    
    // MARK: - Firestore Methods
    
    func createPrefrences(language: Language, voice: Voice) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        let newPreferences = FirePreference(
            userId: userId,
            selectedLanguage: language.rawValue,
            selectedLanguageName: language.displayName,
            selectedVoice: FirePreference.VoiceData.from(voice: voice)
        )
        
        do {
            try self.firebaseFirestore.collection("Prefrences").addDocument(from: newPreferences) { error in
                if let error = error {
                    print("Error adding Preferences: \(error.localizedDescription)")
                } else {
                    print("Preferences added successfully")
                }
            }
        } catch {
            print("Error encoding Preferences: \(error.localizedDescription)")
        }
    }
    
    func fetchPrefrences() {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        self.listener = firebaseFirestore.collection("Prefrences")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching Preferences: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No Preferences found.")
                    return
                }
                
                let preferences = snapshot.documents.compactMap { document -> FirePreference? in
                    do {
                        var preference = try document.data(as: FirePreference.self)
                        preference.id = document.documentID
                        return preference
                    } catch {
                        print("Error decoding Preferences: \(error)")
                        return nil
                    }
                }
                self.preferences = preferences
            }
    }
    
    func editPrefrences(withId id: String, newLanguage: Language, newVoice: Voice) {
        let preferenceRef = firebaseFirestore.collection("Prefrences").document(id)
        
        let updatedData: [String: Any] = [
            "selectedLanguage": newLanguage.rawValue,
            "selectedLanguageName": newLanguage.displayName,
            "selectedVoice": [
                "identifier": newVoice.identifier,
                "language": newVoice.language,
                "name": newVoice.displayName
            ]
        ]
        
        preferenceRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating preference: \(error.localizedDescription)")
            } else {
                print("Preference successfully updated")
            }
        }
    }
    
}
