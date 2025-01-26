//
//  ProfileViewModel.swift
//  FireText warning
//
//  Created by Moutaz Baaj on 06.07.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import CoreData

/// ViewModel to manage user authentication and profile data.
class ProfileViewModel: ObservableObject {

    // Singleton instance for the ViewModel
    static let shared = ProfileViewModel()

    @Published var preferences : [FirePreference] = []

    
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
    
    /// Firebase Storage instance.
    private let firebaseStorage = Storage.storage()

    init() {
        /// Initialize and check if the user is already signed in.
        checkAuth()
        fetchPrefrences()
    }

    /// Check if the user is currently signed in.
    func checkAuth() {
        guard let currentUser = self.firebaseAuthentication.currentUser else {
            print("No user logged in!")
            return
        }
        self.fetchFirestoreUser(withId: currentUser.uid)
    }
    
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
        
        prefrence.updateData(["selectedLanguage": newLanguage,
                             ]) { error in
            if let error = error {
                print("Error updating prefrence: \(error.localizedDescription)")
            } else {
                print("prefrence successfully updated")
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
    
    
//    ///Compress the image to ensure it's under 100KB.
//    private func compressImage(_ image: UIImage, targetSizeKB: Int = 100) -> Data? {
//        let maxSize = targetSizeKB * 1024 // 100KB in bytes
//        var compressionQuality: CGFloat = 1.0
//        var imageData = image.jpegData(compressionQuality: compressionQuality)
//        
//        while imageData?.count ?? 0 > maxSize && compressionQuality > 0 {
//            compressionQuality -= 0.1
//            imageData = image.jpegData(compressionQuality: compressionQuality)
//        }
//        
//        // Additional step to check if the image needs to be resized
//        if imageData?.count ?? 0 > maxSize {
//            // Resize image to further reduce size
//            if let resizedImage = resizeImage(image, maxSizeKB: targetSizeKB) {
//                imageData = resizedImage.jpegData(compressionQuality: compressionQuality)
//            }
//        }
//        
//        return imageData
//    }
//    
//    /// Resize image to ensure it is under the maximum file size.
//    private func resizeImage(_ image: UIImage, maxSizeKB: Int) -> UIImage? {
//        let maxSize = maxSizeKB * 1024 // 100KB in bytes
//        var originalSize = image.jpegData(compressionQuality: 1.0)?.count ?? 0
//        
//        if originalSize <= maxSize {
//            return image
//        }
//        
//        var newSize = image.size
//        var _: CGFloat = max(newSize.width, newSize.height)
//        
//        while originalSize > maxSize {
//            let scaleFactor = sqrt(CGFloat(maxSize) / CGFloat(originalSize))
//            newSize.width *= scaleFactor
//            newSize.height *= scaleFactor
//            
//            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//            image.draw(in: CGRect(origin: .zero, size: newSize))
//            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            
//            if let resizedImageData = resizedImage?.jpegData(compressionQuality: 1.0) {
//                originalSize = resizedImageData.count
//                if originalSize <= maxSize {
//                    return resizedImage
//                }
//            }
//        }
//        
//        return nil
//    }
//    /// Upload the user's profile image to Firebase Storage.
//    func uploadProfileImage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
//        guard let userID = firebaseAuthentication.currentUser?.uid else {
//            print("No user is currently signed in.")
//            return
//        }
//
//        // Create a reference to the Firebase Storage
//        let storageRef = firebaseStorage.reference().child("profile_images/\(userID).png")
//        
//        // Compress the image
//        guard let imageData = compressImage(image) else {
//            print("Failed to compress image.")
//            return
//        }
//
//        // Upload the image data to Firebase Storage
//        _ = storageRef.putData(imageData, metadata: nil) { _, error in
//            if let error = error {
//                completion(.failure(error))
//                print("Error uploading image: \(error.localizedDescription)")
//            } else {
//                // Get the download URL for the uploaded image
//                storageRef.downloadURL { url, error in
//                    if let error = error {
//                        completion(.failure(error))
//                        print("Error getting download URL: \(error.localizedDescription)")
//                    } else if let url = url {
//                        completion(.success(url))
//                    }
//                }
//            }
//        }
//    }
}
