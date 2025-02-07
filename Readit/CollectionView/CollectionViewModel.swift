//
//  CollectionViewModel.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth
import AVFAudio
import Vision
import SwiftUI


class CollectionViewModel: ObservableObject {
    
    static let shared = CollectionViewModel()
    
    @Published var selectedImage: UIImage?
    @Published var extractedText: String?
    @Published var currentWordRange: NSRange? = nil
    
    @Published var texts : [FireText] = []
    @Published var libreries : [FireLibrary] = []
    @Published var favLibreries : [FireLibrary] = []
    
    // Listener for Firestore updates.
    private var listener: ListenerRegistration?
    
    // Firebase authentication instance.
    private let firebaseAuthentication = Auth.auth()
    
    // Firestore instance.
    private let firebaseFirestore = Firestore.firestore()
    
    private var textToSpeechManager = TextToSpeechManager.shared
    
    private let synthesizer = AVSpeechSynthesizer()
    
    @Published var isPaused: Bool = false
    
    
    init() {
        self.fetchLibraries()
        self.fetchFavLibraries()
        textToSpeechManager.$currentWordRange
            .receive(on: RunLoop.main)
            .assign(to: &$currentWordRange)
    }
    
    
    // Creates a new librery.
    func createLibrary(libraryTitle: String) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        let newLibrary = FireLibrary(
            userId: userId,
            libraryTitle: libraryTitle,
            timestamp: Timestamp(),
            editTimestamp: nil,
            textIds: [],
            isFavorites: false
        )
        
        do {
            try self.firebaseFirestore.collection("Librarys").addDocument(from: newLibrary) { error in
                if let error = error {
                    print("Error adding Library: \(error.localizedDescription)")
                } else {
                    print("Library added successfully")
                }
            }
        } catch {
            print("Error encoding Library: \(error.localizedDescription)")
        }
    }
    
    // Creates a new text.
    func createText(text: String, libraryId: String) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        let newText = FireText(
            userId: userId,
            text: text,
            timestamp: Timestamp(),
            editTimestamp: nil,
            libraryId: libraryId
        )
        
        do {
            let docRef = try self.firebaseFirestore.collection("texts").addDocument(from: newText)
            
            // Update library with new text ID
            firebaseFirestore.collection("Librarys").document(libraryId).updateData([
                "textIds": FieldValue.arrayUnion([docRef.documentID])
            ]) { error in
                if let error = error {
                    print("Error updating library: \(error.localizedDescription)")
                } else {
                    print("Text added and library updated successfully")
                }
            }
        } catch {
            print("Error encoding Text: \(error.localizedDescription)")
        }
    }
    
    // Fetches all my text
    func fetchTexts(forLibraryId libraryId: String) {
        self.firebaseFirestore.collection("texts")
            .whereField("libraryId", isEqualTo: libraryId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching texts: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No texts found.")
                    return
                }
                
                self.texts = snapshot.documents.compactMap { document in
                    try? document.data(as: FireText.self)
                }
            }
    }
    
    // Fetches all my Librareis
    func fetchLibraries() {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        self.listener = firebaseFirestore.collection("Librarys")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching libraries: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No libraries found.")
                    return
                }
                
                let libraries = snapshot.documents.compactMap { document -> FireLibrary? in
                    do {
                        var library = try document.data(as: FireLibrary.self)
                        library.id = document.documentID
                        return library
                    } catch {
                        print("Error decoding library: \(error)")
                        return nil
                    }
                }
                self.libreries = libraries
            }
    }
    
    // Fetches all my Fav Librareis
    func fetchFavLibraries() {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        self.listener = firebaseFirestore.collection("Librarys")
            .whereField("userId", isEqualTo: userId)
            .whereField("isFavorites", isEqualTo: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching libraries: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No libraries found.")
                    return
                }
                
                let libraries = snapshot.documents.compactMap { document -> FireLibrary? in
                    do {
                        var library = try document.data(as: FireLibrary.self)
                        library.id = document.documentID
                        return library
                    } catch {
                        print("Error decoding library: \(error)")
                        return nil
                    }
                }
                self.favLibreries = libraries
            }
    }
    
    // Edit text.
    func editText(withId id: String, newText: String) {
        let text = firebaseFirestore.collection("texts").document(id)
        
        text.updateData(["text": newText,
                         "editTimestamp": Timestamp()
                        ]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func editLibrary(libraryId: String?, newTitle: String) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        guard let libraryId = libraryId else {
            print("Library ID is nil")
            return
        }
        
        let libraryRef = self.firebaseFirestore.collection("Librarys").document(libraryId)
        
        libraryRef.getDocument { document, error in
            if let error = error {
                print("Error fetching Library: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists, let libraryData = try? document.data(as: FireLibrary.self) else {
                print("Library does not exist or data decoding failed")
                return
            }
            
            guard libraryData.userId == userId else {
                print("Unauthorized: User does not own this library")
                return
            }
            
            libraryRef.updateData([
                "libraryTitle": newTitle,
                "editTimestamp": Timestamp()
            ]) { error in
                if let error = error {
                    print("Error updating Library: \(error.localizedDescription)")
                } else {
                    print("Library updated successfully")
                }
            }
        }
    }
    
    func addLibraryToFav(withId id: String, isFavorites: Bool) {
        let library = firebaseFirestore.collection("Librarys").document(id)
        
        library.updateData(["isFavorites": isFavorites,
                            "editTimestamp": Timestamp()
                           ]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    // Deletes a text with the given ID.
    func deleteText(withId textId: String?, fromLibrary libraryId: String) {
        guard let textId = textId else {
            print("Text has no id!")
            return
        }
        
        // Step 1: Remove the text document from the "texts" collection
        firebaseFirestore.collection("texts").document(textId).delete { error in
            if let error = error {
                print("Error deleting text: \(error.localizedDescription)")
                return
            }
            print("Text deleted successfully")
            
            // Step 2: Remove the text ID from the library's "textIds" field
            self.firebaseFirestore.collection("Librarys").document(libraryId).updateData([
                "textIds": FieldValue.arrayRemove([textId])
            ]) { error in
                if let error = error {
                    print("Error updating library: \(error.localizedDescription)")
                } else {
                    print("Text ID removed from library successfully")
                }
            }
        }
    }
    
    func deleteLibrary(withId id: String?) {
        guard let id = id else {
            print("Library has no id!")
            return
        }
        
        firebaseFirestore.collection("Librarys").document(id).delete { error in
            if let error = error {
                print("Error deleting library: \(error.localizedDescription)")
            } else {
                print("Library deleted successfully")
            }
        }
    }
    
    func processImage(image: UIImage?) async -> String? {
        guard let image = image, let cgImage = image.cgImage else { return nil }
        
        return await withCheckedContinuation { continuation in
            Task.detached {
                let request = VNRecognizeTextRequest()
                request.recognitionLanguages = ["en", "ar", "ja", "zh-Hans", "zh-Hant"]
                request.usesLanguageCorrection = true
                
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                
                do {
                    try handler.perform([request])
                    
                    let recognizedText = (request.results)?
                        .compactMap { $0.topCandidates(1).first?.string }
                        .joined(separator: " ") ?? ""
                    
                    await MainActor.run {
                        self.extractedText = recognizedText
                        continuation.resume(returning: recognizedText)
                    }
                    
                } catch {
                    print("Text recognition failed: \(error.localizedDescription)")
                    await MainActor.run {
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
    }
    //        guard let image = image, let cgImage = image.cgImage else { return }
    //
    //        // Specify the languages you want to recognize
    //        let request = VNRecognizeTextRequest { request, error in
    //            if let error = error {
    //                print("Text recognition failed with error: \(error.localizedDescription)")
    //                return
    //            }
    //
    //            if let results = request.results as? [VNRecognizedTextObservation] {
    //                let recognizedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
    //                DispatchQueue.main.async {
    //                    self.extractedText = recognizedText
    //                }
    //            }
    //        }
    //
    //        // Set recognition languages
    //        request.recognitionLanguages = ["en", "ar", "ja", "zh-Hans", "zh-Hant"] // English, Arabic, Japanese, Simplified and Traditional Chinese
    //
    //        // Fallback to automatic language detection if needed
    //        request.usesLanguageCorrection = true
    //
    //        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    //        DispatchQueue.global(qos: .userInitiated).async {
    //            try? handler.perform([request])
    //        }
    //    }
    
    //    func readTextAloudForLibrary(from library: FireLibrary, in language: Language, using voice: Voice) {
    //        guard !texts.isEmpty else {
    //            print("No texts available to read aloud.")
    //            return
    //        }
    //
    //        // Filter and prepare texts to read
    //        let textsToRead = texts
    //            .filter { $0.libraryId == library.id } // Ensure the texts belong to the specified library
    //            .sorted(by: {
    //                $0.timestamp.dateValue() < $1.timestamp.dateValue() // Sort by timestamp in ascending order
    //            })
    //            .enumerated() // Enumerate to get both index and content
    //            .map { index, text in
    //                "\(language.pageTranslation) \(index + 1). \(text.text)" // Add "Page X" prefix before each text
    //            }
    //            .joined(separator: ". ") // Concatenate texts with a separator
    //
    //        let utterance = AVSpeechUtterance(string: textsToRead)
    //
    //        // Configure voice
    //        if let customVoice = AVSpeechSynthesisVoice(identifier: voice.identifier) {
    //            utterance.voice = customVoice
    //        } else {
    //            utterance.voice = AVSpeechSynthesisVoice(language: language.rawValue) // Fallback to language-based voice
    //        }
    //
    //        // Configure audio session
    //        do {
    //            let audioSession = AVAudioSession.sharedInstance()
    //            try audioSession.setCategory(.playback, mode: .default, options: [])
    //            try audioSession.setActive(true)
    //        } catch {
    //            print("Failed to configure audio session: \(error.localizedDescription)")
    //        }
    //
    //        synthesizer.speak(utterance)
    //    }
    
    //    func stopSpeaking() {
    //        if synthesizer.isSpeaking {
    //            synthesizer.stopSpeaking(at: .immediate)
    //        }
    //    }
    
    
    func readTextAloud(form text: String) {
        textToSpeechManager.readTextAloud(from: text)
    }
    
    func readTextAloudForLibrary(from library: FireLibrary) {
        textToSpeechManager.readTextAloudForLibrary(from: library, from: texts)
    }
    
    func pauseSpeaking() {
        textToSpeechManager.pauseSpeaking()
    }
    
    func resumeSpeaking() {
        textToSpeechManager.resumeSpeaking()
    }
    
    func stopSpeaking() {
        textToSpeechManager.stopSpeaking()
    }
    
    func highlightedText(_ fullText: String) -> Text {
        return textToSpeechManager.highlightedText(fullText)
    }
    
}
