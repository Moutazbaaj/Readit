//
//  FireLibrery.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import Foundation
import FirebaseFirestore

// Model for a bee report.
struct FireLibrary: Codable, Identifiable {

    @DocumentID var id: String? // Unique identifier for the bee report.

    let userId: String     // User ID of the person who reported the bee.
    var libraryTitle: String     // Title of the bee report.
    let timestamp: Timestamp     // Timestamp of the bee report.
    let editTimestamp: Timestamp?     // Timestamp of the bee report.
    var textIds: [String]?      // List of text document IDs.
    var isFavorites: Bool


}

