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
                        // Profile Image Section
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 5)
                                .foregroundColor(.blue)
                                .shadow(color: .white, radius: 10)
                                .frame(width: 220, height: 220)
                            
                            if let profileImage = profileViewModel.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .padding()
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                        .padding()
                        
                        // User Info Section
                        VStack {
                            Text("Username: \(authViewModel.user?.username ?? "unknown")")
                                .foregroundColor(Color(from: authViewModel.user?.color ?? "black"))
                                .bold()
                                .shadow(color: .blue, radius: 0.5)
                                .padding()
                            
                            Text("Birthday: \(authViewModel.user?.birthday ?? Date(), style: .date)")
                                .shadow(color: .blue, radius: 0.5)
                                .padding()
                            
                            Text("Email: \(authViewModel.user?.email ?? "unknown")")
                                .foregroundStyle(.gray)
                                .shadow(color: .blue, radius: 0.5)
                                .padding()
                            
                            Text("Registered since: \(authViewModel.user?.registerdAt ?? Date(), style: .date)")
                                .foregroundStyle(.gray)
                                .shadow(color: .blue, radius: 0.5)
                                .padding()
                        }
                        .padding()
                        
                        Spacer()
                        
                        // Navigation Link to ImpressumView
                        NavigationLink(destination: ImpressumView()) {
                            Text("About Us")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding()

                        }
                        
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
                .navigationBarItems(trailing:
                    Button(action: {
                        showSettingSheet = true
                        newUsername = authViewModel.user?.username ?? ""
                        newBirthday = authViewModel.user?.birthday ?? Date()
                        newColor = Color(from: authViewModel.user?.color ?? "")
                    }) {
                        Image(systemName: "gearshape")
                            .imageScale(.large)
                    }
                )
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
