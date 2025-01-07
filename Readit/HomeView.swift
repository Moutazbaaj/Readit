//
//  HomeView.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI

struct HomeView: View {
    @State private var animateContent: Bool = false // State variable for animation

    var body: some View {
        NavigationStack {
            VStack() {
                Text("Choose an Option")
                    .font(.largeTitle)
                    .padding()
                    .offset(y: animateContent ? 0 : UIScreen.main.bounds.height) // Start off-screen
                    .animation(.easeOut(duration: 0.6), value: animateContent) // Animate position
                Spacer()
                Text("text implmnted latert")
                    .cornerRadius(10)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .frame(maxHeight: 350)

                Spacer()
                NavigationLink(destination: TextToSpeechView()) {
                    Text("Text to Speech")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .offset(x: animateContent ? 0 : UIScreen.main.bounds.height) // Start off-screen
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent) // Delay for staggered effect
                }

                NavigationLink(destination: ImageRecognitionView()) {
                    Text("Image Recognition")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .offset(y: animateContent ? 0 : UIScreen.main.bounds.height) // Start off-screen
                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent) // Delay for staggered effect
                }
            }
            .padding()
            .navigationTitle("Home")
            .onAppear {
                animateContent = true
            }
        }
    }
}

#Preview {
    HomeView()
}
