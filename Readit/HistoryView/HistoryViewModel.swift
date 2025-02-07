//
//  HistoryViewModel.swift
//  Readit
//
//  Created by Moutaz Baaj on 07.01.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation
import FirebaseStorage
import AVFAudio
import SwiftUI

class HistoryViewModel: ObservableObject {
    
    static let shared = HistoryViewModel()
    
    @Published var texts = [FireText]()
    
    @Published var currentWordRange: NSRange? = nil
    
    // Listener for Firestore updates.
    private var listener: ListenerRegistration?
    // Firebase authentication instance.
    private let firebaseAuthentication = Auth.auth()
    // Firestore instance.
    private let firebaseFirestore = Firestore.firestore()
    // Firebase Storage instance.
    private let firebaseStorage = Storage.storage()
    private let synthesizer = AVSpeechSynthesizer()
    private var textToSpeechManager = TextToSpeechManager.shared
    
    
    init() {
        self.fetchMyTexts()
        textToSpeechManager.$currentWordRange
            .receive(on: RunLoop.main)
            .assign(to: &$currentWordRange)
    }
    
    // Creates a new bee report.
    func createText(text: String) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        let newText = FireText(userId: userId, text: text, timestamp: Timestamp(), editTimestamp: nil, libraryId: " ")
        
        do {
            try self.firebaseFirestore.collection("texts").addDocument(from: newText) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document added successfully")
                }
            }
        } catch {
            print("Error encoding document: \(error.localizedDescription)")
        }
    }
    
    // Fetches all bee reports.
    func fetchMyTexts() {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        self.listener = self.firebaseFirestore.collection("texts")
            .whereField("userId", isEqualTo: userId)
            .whereField("libraryId", isEqualTo: " ")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching texts: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Snapshot is empty")
                    return
                }
                
                let texts = snapshot.documents.compactMap { document -> FireText? in
                    do {
                        var text = try document.data(as: FireText.self)
                        text.id = document.documentID
                        return text
                    } catch {
                        print("Error decoding Bee: \(error)")
                        return nil
                    }
                }
                self.texts = texts
            }
    }
    
    // Edit bee report.
    //    func editText(withId id: String, newText: String) {
    //        let beeReport = firebaseFirestore.collection("texts").document(id)
    //
    //        beeReport.updateData(["text": newText,
    //                              "editTimestamp": Timestamp()
    //                             ]) { error in
    //            if let error = error {
    //                print("Error updating document: \(error.localizedDescription)")
    //            } else {
    //                print("Document successfully updated")
    //            }
    //        }
    //    }
    
    // Deletes a bee report with the given ID.
    func deleteText(withId id: String?) {
        guard let id = id else {
            print("Item has no id!")
            return
        }
        
        // delete the bee report
        firebaseFirestore.collection("texts").document(id).delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("text deleted successfully")
            }
        }
    }
    
    func readTextAloud(form text: String) {
        textToSpeechManager.readTextAloud(from: text)
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
    
//    
//    func readTextAloud(in language: Language, text: String) {
//        guard !text.isEmpty else { return }
//        let utterance = AVSpeechUtterance(string: text)
//        utterance.voice = AVSpeechSynthesisVoice(language: language.rawValue)
//        
//        // Configure audio session
//    
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
//    
//    
//    func stopSpeaking() {
//        if synthesizer.isSpeaking {
//            synthesizer.stopSpeaking(at: .immediate)
//        }
//    }
//    

