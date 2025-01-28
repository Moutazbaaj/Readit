//
//  ProfileViewModel.swift
//  FireText warning
//
//  Created by Moutaz Baaj on 06.07.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import CoreData

/// ViewModel to manage user authentication and profile data.
class ProfileViewModel: ObservableObject {

    // Singleton instance for the ViewModel
    static let shared = ProfileViewModel()
    
    /// Published variable to track the currently signed-in user.
    @Published private(set) var user: FireUser?

    /// Published variable to track the user's profile image.
    @Published var profileImage: UIImage?

    // Firestore listener for real-time updates
    private var listener: ListenerRegistration?

    /// Firebase Authentication instance.
    private let firebaseAuthentication = Auth.auth()

    /// Firebase Firestore instance.
    private let firebaseFirestore = Firestore.firestore()

    init() {
        /// Initialize and check if the user is already signed in.
        checkAuth()
    }

    /// Check if the user is currently signed in.
    func checkAuth() {
        guard let currentUser = self.firebaseAuthentication.currentUser else {
            print("No user logged in!")
            return
        }
        self.fetchFirestoreUser(withId: currentUser.uid)
    }

    /// Fetch user data from Firestore based on the provided user ID.
    func fetchFirestoreUser(withId id: String) {
        self.firebaseFirestore.collection("users").document(id).getDocument { document, error in
            if let error {
                print("Error fetching user: \(error)")
                return
            }

            guard let document else {
                print("Document does not exist")
                return
            }

            do {
                // Decode the Firestore document into a FireUser object
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                print("Could not decode user: \(error)")
            }
        }
    }

    /// Send a password reset email to the specified address.
    func recoverPassword(email: String) {
        firebaseAuthentication.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Failed to send password reset email: \(error.localizedDescription)")
            } else {
                print("Password reset email sent.")
            }
        }
    }

    /// Save the user's profile image to Core Data.
    func saveProfileImage(image: UIImage) {
        guard let userID = firebaseAuthentication.currentUser?.uid else {
            print("No user is currently signed in.")
            return
        }

        let context = PersistentStore.shared.context
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)

        do {
            let results = try context.fetch(fetchRequest)
            let userProfile: UserProfile

            if results.isEmpty {
                // Create a new UserProfile entity if none exists
                userProfile = UserProfile(context: context)
                userProfile.userID = userID
            } else {
                // Use the existing UserProfile entity
                userProfile = results.first!
            }

            // Save the profile image as PNG data
            userProfile.profileImage = image.pngData()
            PersistentStore.shared.save()

            // Ensure updates to @Published properties are on the main thread
            DispatchQueue.main.async {
                self.profileImage = image
            }
        } catch {
            print("Failed to save profile image: \(error.localizedDescription)")
        }
    }

    /// Load the user's profile image from Core Data.
    func loadProfileImage() {
        guard let userID = firebaseAuthentication.currentUser?.uid else {
            print("No user is currently signed in.")
            return
        }

        let context = PersistentStore.shared.context
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)

        do {
            let results = try context.fetch(fetchRequest)
            if let userProfile = results.first, let imageData = userProfile.profileImage {
                // Convert PNG data back to UIImage
                DispatchQueue.main.async {
                    self.profileImage = UIImage(data: imageData)
                }
            } else {
                // No profile image found for this user
                DispatchQueue.main.async {
                    self.profileImage = nil
                }
            }
        } catch {
            print("Failed to load profile image: \(error.localizedDescription)")
        }
    }
}
