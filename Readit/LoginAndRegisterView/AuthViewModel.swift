//
//  AuthViewModel.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 29.06.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

/// View model to manage user authentication.
class AuthViewModel: ObservableObject {

    // singleton shared for the viewModel
    //    static let shared = AuthViewModel()

    /// Published variable to track if the user is signed in.
    @Published private(set) var user: FireUser?

    @Published var errorMessage: String?

    /// Published variable to hold the current user.
    var isUserLoggedIn: Bool {
        self.user != nil
    }

    /// Firebase authentication instance.
    private let firebaseAuthntication = Auth.auth()

    /// Firebase Firestore instance.
    private let firebaseFirestore = Firestore.firestore()

    init() {
        /// Check if the user is already signed in.
        checkAuth()
    }

    /// Validates the format of an email address.
    func isValidEmail(_ email: String) -> Bool {
        // A more comprehensive regex for email validation
        let emailRegEx = "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }

    /// Validates the strength of a password.
    func isStrongPassword(_ password: String) -> Bool {
        // Password should be at least 8 characters long
        // Must contain at least one uppercase letter, one lowercase letter, and one number
        let passwordRegEx = "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: password)
    }

    func isEmailAlreadyInUse(_ email: String, completion: @escaping (Bool) -> Void) {
        firebaseFirestore.collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error checking email: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                let emailInUse = !(querySnapshot?.isEmpty ?? true)
                completion(emailInUse)
            }
    }

    func register(email: String, nickname: String, birthday: Date, password: String) {
        guard isValidEmail(email) else {
            print("Invalid email format.")
            return
        }

        guard isStrongPassword(password) else {
            print("Weak password. It must be at least 8 characters long and include uppercase, lowercase, number, and special character.")
            return
        }

        firebaseAuthntication.createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                print("Error in registration: \(error)")
                return
            }

            guard let authResult, let email = authResult.user.email else {
                print("authResult or Email are empty!")
                return
            }

            print("Signed in with user ID \(authResult.user.uid) and email \(email)")
            self.creatUser(id: authResult.user.uid, email: email, nickname: nickname, birthday: birthday, color: "black")

        }
    }

    func login(email: String, password: String) {

        firebaseAuthntication.signIn(withEmail: email, password: password) { authResult, error in
            if let error {
                print("Error in login : \(error)")
                return
            }

            guard let authResult, let email = authResult.user.email else {
                print("authResult or Email are empty!")
                return
            }

            print("Signed in with user ID \(authResult.user.uid) and email \(email)")
            self.checkAuth()
        }
    }

    /// Check if the user is already signed in.
    func checkAuth() {
        guard let currentUser = self.firebaseAuthntication.currentUser else {
            print("no user Logedin!")
            return
        }
        self.fetchFirestoreUser(withId: currentUser.uid)

    }

    func recoverPassword(email: String) {
        firebaseAuthntication.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Failed to send password reset email: \(error.localizedDescription)")
            } else {
                print("Password reset email sent.")
            }
        }
    }

    func creatUser(id: String, email: String, nickname: String, birthday: Date, color: String) {
        let newUser = FireUser(id: id, email: email, username: nickname, birthday: birthday, registerdAt: Date(), color: color)

        do {
            try self.firebaseFirestore.collection("users").document(id).setData(from: newUser)
        } catch {
            print("error saving user in firstore \(error)")
        }
    }

    func updateUser(username: String, birthday: Date, color: String) {
        guard let userId = self.user?.id else {
            print("No user is currently logged in.")
            return
        }

        let user = self.firebaseFirestore.collection("users").document(userId)

        user.updateData(["username": username, "birthday": birthday, "color": color]) { error in
            if let error = error {
                print("Error updating user: \(error)")
            } else {
                self.user?.username = username
                self.user?.birthday = birthday
                self.user?.color = color
                print("User successfully updated.")
            }
        }
    }

    func setUser(userId: String, username: String, birthday: Date, color: String) {
        let user = self.firebaseFirestore.collection("users").document(userId)
        user.updateData(["username": username, "birthday": birthday, "color": color]) { error in
            if let error = error {
                print("Error updating user: \(error)")
            } else {
                self.user?.username = username
                self.user?.birthday = birthday
                print("User successfully updated.")
            }
        }
    }

    func fetchFirestoreUser(withId id: String) {
        self.firebaseFirestore.collection("users").document(id).getDocument { document, error in
            if let error {
                print("error fetching user \(error)")
                return
            }

            guard let document else {
                print("Document dose nto exist")
                return
            }

            do {
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                print("Cloud not decoded user: \(error)")
            }

        }
    }

    func logout() {
        do {
            try firebaseAuthntication.signOut()
            self.user = nil
        } catch {
            print("Error Logout: \(error)")
        }
    }

    func deleteUserData() {

        guard let userId = firebaseAuthntication.currentUser?.uid else {
            print("No user is currently signed in.")
            return
        }

        // Function to delete all used documents and data in a collection
        func deleteCollection(collectionPath: String, completion: @escaping (Error?) -> Void) {
            firebaseFirestore.collection(collectionPath).whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
                if let error = error {
                    completion(error)
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    completion(nil)
                    return
                }

                let batch = self.firebaseFirestore.batch()
                for document in documents {
                    batch.deleteDocument(document.reference)
                }

                batch.commit { error in
                    completion(error)
                }
            }
        }

        // Group to manage async tasks
        let dispatchGroup = DispatchGroup()

        // Add tasks to delete related data
        dispatchGroup.enter()
        deleteCollection(collectionPath: "userlikes") { error in
            if let error = error {
                print("Failed to delete likes: \(error.localizedDescription)")
            } else {
                print("Likes successfully deleted.")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        deleteCollection(collectionPath: "comments") { error in
            if let error = error {
                print("Failed to delete comments: \(error.localizedDescription)")
            } else {
                print("Comments successfully deleted.")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        deleteCollection(collectionPath: "reports") { error in
            if let error = error {
                print("Failed to delete reports: \(error.localizedDescription)")
            } else {
                print("Reports successfully deleted.")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        deleteCollection(collectionPath: "sos") { error in
            if let error = error {
                print("Failed to delete SOS profiles: \(error.localizedDescription)")
            } else {
                print("SOS profiles successfully deleted.")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        deleteCollection(collectionPath: "bees") { error in
            if let error = error {
                print("Failed to delete bees : \(error.localizedDescription)")
            } else {
                print("bees successfully deleted.")
            }
            dispatchGroup.leave()
        }

        // Wait for all deletions to complete
        dispatchGroup.notify(queue: .main) {
            // Delete user data from Firestore
            self.firebaseFirestore.collection("users").document(userId).delete { error in
                if let error = error {
                    print("Failed to delete user data from Firestore: \(error.localizedDescription)")
                    return
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // Reset the user state to nil
            self.user = nil

            // Sign out and handle deletion from Firebase
            do {
                try self.firebaseAuthntication.signOut()
                self.user = nil
                self.firebaseAuthntication.currentUser?.delete()
                self.user = nil
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
        
        self.firebaseAuthntication.currentUser?.delete()
        print("Account successfully deleted.")
    }
}
