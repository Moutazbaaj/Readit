//
//  HomeView.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI

struct HomeView: View {
    //    @State private var animateContent: Bool = false // State variable for animation
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            VStack() {
                Text("Choose an Option")
                    .font(.largeTitle)
                    .padding()
                //                    .offset(y: animateContent ? 0 : UIScreen.main.bounds.height) // Start off-screen
                //                    .animation(.easeOut(duration: 0.6), value: animateContent) // Animate position
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
                
                HStack {
                    NavigationLink(destination: TextToSpeechView()) {
                        Image(systemName: "bubble.and.pencil")
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                        //                        .offset(x: animateContent ? 0 : UIScreen.main.bounds.height) // Start off-screen
                        //                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent) // Delay for staggered effect
                    }
                    
                    NavigationLink(destination: ImageRecognitionView()) {
                        Image(systemName: "photo.badge.plus.fill")
                            .font(.largeTitle)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                        //                        .offset(y: animateContent ? 0 : UIScreen.main.bounds.height) // Start off-screen
                        //                        .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent) // Delay for staggered effect
                    }
                }
            }
            .padding()
            //            .onAppear {
            //                animateContent = true
            //            }
        }
    }
}

#Preview {
    HomeView()
}
