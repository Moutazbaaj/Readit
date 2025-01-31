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
    var userId: String
    var selectedLanguage: String
    var selectedLanguageName: String
    var selectedVoice: VoiceData // Store voice as a structured object
    
    // Conform to Equatable
    static func == (lhs: FirePreference, rhs: FirePreference) -> Bool {
        return lhs.id == rhs.id &&
               lhs.userId == rhs.userId &&
               lhs.selectedLanguage == rhs.selectedLanguage &&
               lhs.selectedVoice == rhs.selectedVoice
    }
    
    struct VoiceData: Codable, Equatable {
        var identifier: String
        var language: String
        var name: String

        func toVoice() -> Voice {
            return .custom(identifier: identifier, language: language, name: name)
        }

        static func from(voice: Voice) -> VoiceData {
            return VoiceData(identifier: voice.identifier, language: voice.language, name: voice.displayName)
        }
    }
}
