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
    
    func readTextAloud(from inputText: String, in language: Language, using voice: Voice) {
        if !inputText.isEmpty {
            let utterance = AVSpeechUtterance(string: inputText)

            if let customVoice = AVSpeechSynthesisVoice(identifier: voice.identifier) {
                utterance.voice = customVoice
            } else {
                utterance.voice = AVSpeechSynthesisVoice(language: language.rawValue)
            }

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
    
    // MARK: - Firestore Methods
    
    func createPrefrences(language: Language.RawValue) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        let newPrefrences = FirePreference(userId: userId, selectedLanguage: language)
        
        do {
            try self.firebaseFirestore.collection("Prefrences").addDocument(from: newPrefrences) { error in
                if let error = error {
                    print("Error adding Prefrences: \(error.localizedDescription)")
                } else {
                    print("Prefrences added successfully")
                }
            }
        } catch {
            print("Error encoding Prefrences: \(error.localizedDescription)")
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
                    print("Error fetching Prefrences: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No Prefrences found.")
                    return
                }
                
                let Prefrences = snapshot.documents.compactMap { document -> FirePreference? in
                    do {
                        var Prefrenc = try document.data(as: FirePreference.self)
                        Prefrenc.id = document.documentID
                        return Prefrenc
                    } catch {
                        print("Error decoding Prefrences: \(error)")
                        return nil
                    }
                }
                self.preferences = Prefrences
            }
    }
    
    func editPrefrences(withId id: String, newLanguage: Language.RawValue) {
        let prefrence = firebaseFirestore.collection("Prefrences").document(id)
        
        prefrence.updateData(["selectedLanguage": newLanguage]) { error in
            if let error = error {
                print("Error updating prefrence: \(error.localizedDescription)")
            } else {
                print("prefrence successfully updated")
            }
        }
    }
}
