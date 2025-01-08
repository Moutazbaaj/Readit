//
//  PersistentStore.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 22.07.24.
//

import Foundation
import CoreData

// Singleton class responsible for handling Core Data operations for the app.
class PersistentStore {
    // Singleton instance for global access.
    static let shared = PersistentStore()

    // The Core Data persistent container used to manage the model and database.
    private let container: NSPersistentContainer

    // The managed object context for performing Core Data operations.
    var context: NSManagedObjectContext {
        container.viewContext
    }

    // Private initializer to prevent multiple instances and set up the Core Data stack.
    private init() {
        // Initialize the persistent container with the data model name.
        self.container = NSPersistentContainer(name: "ProfilePictureModel")

        // Automatically merge changes from other contexts to the view context.
        self.container.viewContext.automaticallyMergesChangesFromParent = true

        // Load the persistent stores and handle any errors that occur during setup.
        self.container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                // Critical error during setup, resulting in app termination.
                fatalError("Error loading data from the database: \(error.localizedDescription), UserInfo: \(error.userInfo)")
            }
        }
    }

    // Saves any changes in the context to the persistent store.
    func save() {
        // Check if there are any unsaved changes before attempting to save.
        guard context.hasChanges else {
            return
        }

        do {
            // Attempt to save the context.
            try context.save()
        } catch {
            // Handle errors during the save process, typically logging the issue.
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
