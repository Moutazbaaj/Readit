//
//  LibraryViewModel.swift
//  Readit
//
//  Created by Moutaz Baaj on 07.01.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation
import FirebaseStorage

class LibraryViewModel: ObservableObject {
    
    static let shared = LibraryViewModel()
    
    @Published var texts = [FireText]()
    
    // Listener for Firestore updates.
    private var listener: ListenerRegistration?
    
    // Firebase authentication instance.
    private let firebaseAuthentication = Auth.auth()
    
    // Firestore instance.
    private let firebaseFirestore = Firestore.firestore()
    
    /// Firebase Storage instance.
    private let firebaseStorage = Storage.storage()
    
    init() {
        self.fetchTexts()
    }
    
    
    
    // Creates a new bee report.
    func createText(userName: String, text: String, timestamp: Timestamp) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("User is not signed in")
            return
        }
        
        let newText = FireText(userId: userId, userName: userName, text: text, timestamp: timestamp, editTimestamp: nil)
        
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
    func fetchTexts() {
        guard (self.firebaseAuthentication.currentUser?.uid) != nil else {
            print("User is not signed in")
            return
        }
        
        self.listener = self.firebaseFirestore.collection("texts")
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
                //                self.deleteOldReports()
            }
    }
    
    // Edit bee report.
    func editText(withId id: String, newText: String, editTimestamp: Timestamp) {
        let beeReport = firebaseFirestore.collection("texts").document(id)
        
        beeReport.updateData(["text": newText,
                              "editTimestamp": Timestamp()
                             ]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
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
    
}
