//
//  FireText.swift
//  FireText warning
//
//  Created by Moutaz Baaj on 29.06.24.
//

import Foundation
import FirebaseFirestore

// Model for a bee report.
struct FireText: Codable, Identifiable {

    @DocumentID var id: String? // Unique identifier for the bee report.

    let userId: String     // User ID of the person who reported the bee.
    var text: String     // Title of the bee report.
    let timestamp: Timestamp     // Timestamp of the bee report.
    let editTimestamp: Timestamp?    // Timestamp of the bee report.
    let libraryId: String?       // The ID of the associated library.


}
