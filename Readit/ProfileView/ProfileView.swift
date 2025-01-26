//
//  ProfileView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @StateObject var profileViewModel = ProfileViewModel.shared
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var showSettingSheet: Bool = false
    @State private var alertType: AlertType = .none
    @State private var showAlert: Bool = false
    @State private var newUsername: String = ""
    @State private var newBirthday: Date = Date()
    @State private var newColor: Color = .black
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    enum AlertType {
        case none
        case logout
        case deleteAccount
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .blur(radius: 10)
                .edgesIgnoringSafeArea(.all)
                
                
                // Custom layout replacing Form
                VStack {
                    HStack {
                        // Profile Image Section
                        VStack {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.blue)
                                    .shadow(color: .white, radius: 10)
                                    .frame(width: 110, height: 110)

                                if let profileImage = profileViewModel.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .padding()
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                        .padding()
                                }
                            }
                        }
                        .padding()
                        // User Info Section
                        VStack(alignment: .leading) {
                            Text("\(authViewModel.user?.username ?? "unknown")")
                                .foregroundColor(Color(from: authViewModel.user?.color ?? "black"))
                                .bold()
                                .font(.callout)
                            
                            Text("\(authViewModel.user?.birthday ?? Date(), style: .date)")
                                .font(.callout)
                                .font(.callout)
                            
                            
                            Text("\(authViewModel.user?.email ?? "unknown")")
                                .foregroundStyle(.gray)
                                .font(.callout)
                                .font(.callout)
                            
//                            Text("Registered since:\n \(authViewModel.user?.registerdAt ?? Date(), style: .date)")
//                                .foregroundStyle(.gray)
//                                .font(.callout)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showSettingSheet = true
                            newUsername = authViewModel.user?.username ?? ""
                            newBirthday = authViewModel.user?.birthday ?? Date()
                            newColor = Color(from: authViewModel.user?.color ?? "")
                        }) {
                            Image(systemName: "gearshape")
                                .imageScale(.large)
                        }
                        .padding()
                    }
                    Divider()
                    
                    
                    Spacer()
                    
                    HStack {
                        // Logout Button
                        Button(role: .destructive) {
                            alertType = .logout
                            showAlert = true
                        } label: {
                            Text("Log Out")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding()
                            
                        }
                        
                        
                        Spacer()
                        
                        
                        // Delete Account Button
                        Button(role: .destructive) {
                            alertType = .deleteAccount
                            showAlert = true
                        } label: {
                            Text("Delete Account")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding()
                            
                        }
                    }
                }
                .padding()
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showSettingSheet) {
                    ProfileSheetView(
                        authViewModel: authViewModel,
                        newUsername: $newUsername,
                        newBirthday: $newBirthday,
                        showSettingSheet: $showSettingSheet,
                        selectedColor: $newColor
                    )
                    .presentationDetents([.medium, .large])
                }
                .alert(isPresented: $showAlert) {
                    switch alertType {
                    case .logout:
                        return Alert(
                            title: Text("Confirm Logout"),
                            message: Text("Are you sure you want to log out?"),
                            primaryButton: .destructive(Text("Log Out")) {
                                authViewModel.logout()
                                authViewModel.checkAuth()
                            },
                            secondaryButton: .cancel()
                        )
                    case .deleteAccount:
                        return Alert(
                            title: Text("Confirm Delete Account"),
                            message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete Account")) {
                                authViewModel.deleteUserData()
                                authViewModel.checkAuth()
                            },
                            secondaryButton: .cancel()
                        )
                    case .none:
                        return Alert(title: Text("Error"), message: Text("An unknown error occurred"), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .onAppear {
                profileViewModel.loadProfileImage()
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
