//
//  ProfileView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import SwiftUI
import PhotosUI

// View to display and manage the user's profile
struct ProfileView: View {
    
    // ViewModel instances for managing profile and reports
    @StateObject var profileViewModel = ProfileViewModel.shared // ViewModel for managing User Profile

    // Environment object to access authentication-related data and methods
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // State variables for UI control and user data
    @State private var showSettingSheet: Bool = false  // Controls the visibility of the settings sheet
    @State private var alertType: AlertType = .none  // Determines the type of alert to display
    @State private var showAlert: Bool = false  // Controls the display of alerts
    @State private var newUsername: String = ""  // Stores the new username
    @State private var newBirthday: Date = Date()  // Stores the new birthday
    @State private var newColor: Color = .black  // Stores the new Color tag
    
    @State private var selectedItem: PhotosPickerItem?  // Stores the selected photo item
    @State private var selectedImage: UIImage?  // Stores the selected image
    
    // Enum to define the type of alert
    enum AlertType {
        case none
        case logout
        case deleteAccount
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Section for displaying profile information
                    ZStack {
                            // Outer circle with shadow
                            Circle()
                                .stroke(lineWidth: 5) // Adjust the thickness of the circle
                                .foregroundColor(.blue) // The color of the circle
                                .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                                .frame(width: 220, height: 220)
                        HStack {
                            Spacer()
                            // Display profile image (view only, no editing)
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
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .padding()
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .padding()

                    // Display user information
                    HStack {
                        Text("Username: ")
//                            .foregroundStyle(.white)
                            .shadow(color: .blue, radius: 0.5)
                        Text("\(String(authViewModel.user?.username ?? "unknown"))")
                            .foregroundColor(Color(from: authViewModel.user?.color ?? "black"))
                            .shadow(color: .blue, radius: 0.5)
                            .bold()
                    }
                    .padding(.vertical)
                    
                    Text("Birthday: \(authViewModel.user?.birthday ?? Date(), style: .date)")
//                        .foregroundStyle(.white)
                        .shadow(color: .blue, radius: 0.5)
                        .padding(.vertical)
                    
                    Text("Email: \(String(authViewModel.user?.email ?? "unknown"))")
                        .foregroundStyle(.gray)
                        .shadow(color: .blue, radius: 0.5)
                        .padding(.vertical)
                    
                    Text("Registered since: \(authViewModel.user?.registerdAt ?? Date(), style: .date)")
                        .foregroundStyle(.gray)
                        .shadow(color: .blue, radius: 0.5)
                        .padding(.vertical)
                    

                                
                // Section for ImpressumView navigation
                Section {
                    NavigationLink(destination: ImpressumView()) {
                        HStack {
                            Spacer()
                            Text("About Us")
                                .foregroundStyle(.blue)
                                .shadow(color: .blue, radius: 10)
                            Spacer()
                        }
                    }
                }
                
                // Section for logging out
                Section {
                    Button(role: .destructive) {
                        print("Logout button tapped")
                        alertType = .logout
                        showAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log Out")
                            Spacer()
                        }
                    }
                }
                
                // Section for deleting the account
                Section {
                    Button(role: .destructive) {
                        print("Delete button tapped")
                        alertType = .deleteAccount
                        showAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Account")
                            Spacer()
                        }
                    }
                }
            }
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
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSettingSheet) {
                ProfileSheetView(authViewModel: authViewModel, newUsername: $newUsername, newBirthday: $newBirthday, showSettingSheet: $showSettingSheet, selectedColor: $newColor)
                    .presentationDetents([.large])
            }
            .alert(isPresented: $showAlert) {
                switch alertType {
                case .logout:
                    return Alert(
                        title: Text("Confirm Logout"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .destructive(Text("Log Out")) {
                            print("Logout confirmed")
                            authViewModel.logout()  // Log out the user
                            authViewModel.checkAuth()  // Check authentication status
                        },
                        secondaryButton: .cancel {}
                    )
                case .deleteAccount:
                    return Alert(
                        title: Text("Confirm Delete Account"),
                        message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete Account")) {
                            print("Delete confirmed")
                            authViewModel.deleteUserData()  // Delete user data
                            authViewModel.checkAuth()  // Check authentication status
                        },
                        secondaryButton: .cancel()
                    )
                case .none:
                    return Alert(title: Text("Error"), message: Text("An unknown error occurred"), dismissButton: .default(Text("OK")))
                }
            }
        }
        .onAppear {
            profileViewModel.loadProfileImage()  // Load the current profile image
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
