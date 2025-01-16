//
//  SplashScreenView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 02.07.24.
//

import SwiftUI

struct SplashScreenView: View {
//    @State private var imageOffset: CGFloat = UIScreen.main.bounds.width // Start position off-screen
//    @State private var bounce: Bool = true
//    @State private var isReturningToCenter: Bool = false

    var body: some View {
        VStack {
            ZStack {
                // Outer circle with shadow
                Circle()
                    .stroke(lineWidth: 2) // Adjust the thickness of the circle
                    .foregroundColor(.blue) // The color of the circle
                    .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                    .frame(width: 110, height: 110)
                Image("beeLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
//                .offset(x: imageOffset, y: bounce ? -50 : 50) // Apply bounce effect
//                .animation(
//                    Animation.easeInOut(duration: 0.5)
//                        .repeatForever(autoreverses: true)
//                        .delay(0.5), value: bounce
//                )
//                .onAppear {
//                    bounce.toggle()
//                    withAnimation(Animation.easeInOut(duration: 3.0)) {
//                        imageOffset = -UIScreen.main.bounds.width // Move image to off-screen left
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                        withAnimation(Animation.easeInOut(duration: 0.5)) {
//                            isReturningToCenter = true
//                        }
//                    }
//                }
//                .onChange(of: isReturningToCenter) {_, newValue in
//                    if newValue {
//                        imageOffset = 0 // Center the image
//                    }
//                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SplashScreenView()
}
