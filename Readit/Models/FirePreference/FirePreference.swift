//
//  FirePreference.swift
//  Readit
//
//  Created by Moutaz Baaj on 26.01.25.
//

import Foundation
import FirebaseFirestore

// Model for a bee report.
struct FirePreference: Codable, Identifiable, Equatable {

    @DocumentID var id: String?

    let userId: String
    var selectedLanguage: Language.RawValue


}
