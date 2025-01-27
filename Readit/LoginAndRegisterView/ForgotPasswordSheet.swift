//
//  ForgotPasswordSheet.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 29.06.24.
//

import SwiftUI

struct ForgotPasswordSheet: View {
    @EnvironmentObject private var loginViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var forgotPasswordEmail: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .blur(radius: 7)
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                    VStack {
                        
                        Spacer()
                        
                        Text("Recover Password")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        // Email TextField
                        Text("Enter your email")
                        
                        TextField("", text: $forgotPasswordEmail)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .padding()
                            .submitLabel(.done) // Shows 'OK' on the return key
                        
                        // Send Reset Email Button
                        Button("Send Reset Email") {
                            loginViewModel.recoverPassword(email: forgotPasswordEmail)
                            dismiss()
                        }
                        .padding()
                        .background(Color.black) // Button background color
                        .foregroundColor(.blue) // Button text color
                        .cornerRadius(15)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .navigationBarItems(trailing: Button("Cancel") {
            dismiss()
        })
    }
}

#Preview {
    ForgotPasswordSheet(forgotPasswordEmail: .constant(""))
        .environmentObject(AuthViewModel())
}
