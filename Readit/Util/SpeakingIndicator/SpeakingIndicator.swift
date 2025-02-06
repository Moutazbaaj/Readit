//
//  SpeakingIndicator.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.02.25.
//

import SwiftUI

struct SpeakingIndicator: View {
    @Binding var isAnimating: Bool
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3) { i in
                Capsule()
                    .frame(width: 3, height: isAnimating ? 10 : 5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(i) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .onAppear { isAnimating = true }
        .foregroundColor(.white.opacity(0.7))
    }
}
