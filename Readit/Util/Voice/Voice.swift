//
//  Voice.swift
//  Readit
//
//  Created by Moutaz Baaj on 26.01.25.
//

import Foundation
import AVFoundation

enum Voice: CaseIterable, Hashable {
    
    case custom(identifier: String, language: String, name: String)

    // Dynamically fetches all available voices
    static var allCases: [Voice] {
        AVSpeechSynthesisVoice.speechVoices().map { voice in
            .custom(identifier: voice.identifier, language: voice.language, name: voice.name)
        }
    }

    // Returns a user-friendly display name for each voice
    var displayName: String {
        switch self {
        case .custom(_, let language, let name):
            return "\(name) (\(language))"
        }
    }

    // Returns the identifier of the voice, which is used for selection
    var identifier: String {
        switch self {
        case .custom(let identifier, _, _):
            return identifier
        }
    }

    // Returns the language code of the voice
    var language: String {
        switch self {
        case .custom(_, let language, _):
            return language
        }
    }

    // Helper to fetch voices by language
    static func voices(for language: String) -> [Voice] {
        allCases.filter { $0.language == language }
    }
}
