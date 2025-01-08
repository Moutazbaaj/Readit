//
//  FireBee.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 29.06.24.
//

import Foundation
import FirebaseFirestore
import CoreLocation

// Model for a bee report.
struct FireBee: Codable, Identifiable {

    @DocumentID var id: String? // Unique identifier for the bee report.

    let userId: String     // User ID of the person who reported the bee.
    let userName: String     // UserName of the person who reported the bee.
    let title: String     // Title of the bee report.
    let description: String     // Description of the bee report.
    let address: String     // address of the bee report.
    var location: GeoPoint     // Location of the bee sighting.
    let timestamp: Timestamp     // Timestamp of the bee report.
    let editTimestamp: Timestamp?    // Edit Timestamp of the bee report.
    var likes: Int = 0    // count of likes

}
