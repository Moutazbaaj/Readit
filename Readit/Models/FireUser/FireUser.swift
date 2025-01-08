//
//  FireUser.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 29.06.24.
//

import Foundation
import SwiftUI

// Struct to represent a user in the Bee warning application
// Conforms to Codable and Identifiable protocols
struct FireUser: Codable, Identifiable {

    let id: String           // Unique identifier for the user
    let email: String        // Email address of the user
    var username: String     // Username chosen by the user
    var birthday: Date       // Birthday of the user
    let registerdAt: Date    // Date when the user registered
    var color: String     // Color associated with the comment, which could be used for UI customization.
}
