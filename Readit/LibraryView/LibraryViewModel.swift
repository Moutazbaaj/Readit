//
//  LibraryViewModel.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation
import FirebaseStorage
import AVFAudio


class LibraryViewModel: ObservableObject {
    
    static let shared = LibraryViewModel()
    
    @Published var texts : [FireText] = []
    @Published var libreries : [FireLibrary] = []
    @Published var favLibreries : [FireLibrary] = []
    
    // Listener for Firestore updates.
    private var listener: ListenerRegistration?
    
    // Firebase authentication instance.
    private let firebaseAuthentication = Auth.auth()
    
    // Firestore instance.
    private let firebaseFirestore = Firestore.firestore()
    
    /// Firebase Storage instance.
    private let firebaseStorage = Storage.storage()
    
    
    private let synthesizer = AVSpeechSynthesizer()

    
    init() {
        self.fetchLibraries()
        self.fetchFavLibraries()
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
    
    
    func readTextAloud(from library: FireLibrary, in language: Language) {
        guard !texts.isEmpty else {
            print("No texts available to read aloud.")
            return
        }
        
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
