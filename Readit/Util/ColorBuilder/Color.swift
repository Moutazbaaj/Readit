//
//  Color.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 04.08.24.
//

import SwiftUI

extension Color {
    init(from colorString: String) {
        // Define a default color in case the string is not recognized
        self = .blue

        // Try to parse the color string
        let components = colorString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: " ")

        guard components.count >= 4, // Ensure there are enough components
              let red = Double(components[1]),
              let green = Double(components[2]),
              let blue = Double(components[3]),
              let alpha = Double(components[4]) else { return }

        self = Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}
