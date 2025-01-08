//
//  RegisterView.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 29.06.24.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var birthday: Date = Date()
    @State private var hidePassword: Bool = true
    @State private var errorMessage: String?
    @State private var showProfileCreatingView: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                    VStack {
                        // Dismiss Button
                        HStack {
                            Button(action: {
                                dismiss() // Dismiss the full screen cover
                            }) {
                                Image(systemName: "xmark")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            Spacer()
                        }
                        Spacer()
                        ZStack {
                            // Outer circle with shadow
                            Circle()
                                .stroke(lineWidth: 5) // Adjust the thickness of the circle
                                .foregroundColor(.blue) // The color of the circle
                                .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                                .frame(width: 220, height: 220)
                            Image("beeLogo")
                                .resizable()
                                .frame(width: 200, height: 200)
                                .padding()
                        }

                            Text("Registration")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.blue)
                        Spacer()
                        // Email TextField
                        HStack {
                            Text("Email Address")
                                .foregroundStyle(.black)
                                .padding(.bottom, -50)
                                .padding()
                            Spacer()
                        }
                        TextField("", text: $email)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(15)
                            .padding()
                            .submitLabel(.done) // Shows 'OK' on the return key
                        // Password Field
                        HStack {
                            Text("Password")
                                .foregroundStyle(.black)
                                .padding(.bottom, -50)
                                .padding()
                            Spacer()
                        }
                        HStack {
                            if hidePassword {
                                SecureField("", text: $password)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(15)
                                    .padding()
                                    .submitLabel(.done) // Shows 'OK' on the return key
                            } else {
                                TextField("", text: $password)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(15)
                                    .padding()
                                    .submitLabel(.done) // Shows 'OK' on the return key
                            }
                            Button(action: {
                                hidePassword.toggle()
                            }) {
                                Image(systemName: hidePassword ? "eye.slash" : "eye")
                                    .font(.callout)
                                    .foregroundColor(.blue)
                                    .padding()
                            }
                        }
                        // Error Message
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            Text(" ")
                                .foregroundColor(.red)
                                .padding()
                        }
                        Spacer()
                        // Next Button
                        Button("Next") {
                            if authViewModel.isValidEmail(email) {
                                if authViewModel.isStrongPassword(password) {
                                    // check if the email is already in use
                                    authViewModel.isEmailAlreadyInUse(email) { emailInUse in
                                        if emailInUse {
                                            errorMessage = "The email address is already in use by another account."
                                        } else {
                                            authViewModel.register(email: email, nickname: name, birthday: birthday, password: password)
                                            showProfileCreatingView.toggle()
                                        }
                                    }
                                } else {
                                    errorMessage = "Weak password. Ensure your password is at least 8 characters long and includes uppercase letters, lowercase letters, and numbers."
                                }
                            } else {
                                errorMessage = "Invalid email format."
                            }
                        }
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.blue)
                        .cornerRadius(15)
                        .fullScreenCover(isPresented: $showProfileCreatingView) {
                            ProfileCreatingView()
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
