//
//  ProfileSheetView.swift
//  Readit
//
//  Created by Moutaz Baaj on 8.01.25.
//

import SwiftUI
import PhotosUI

struct ProfileSheetView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject var profileViewModel = ProfileViewModel.shared
    
    @Binding var newUsername: String
    @Binding var newBirthday: Date
    @Binding var showSettingSheet: Bool
    @Binding var selectedColor: Color
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showAlert = false
    
    @State private var alertType: AlertType = .none

    
//    enum AlertType {
//        case none
//        case logout
//        case deleteAccount
//    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView {
                        VStack {
                            
                            Divider()
                                .padding()
                                .hidden()
                            // Profile Image Section
                            ZStack(alignment: .bottomTrailing) {
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 5)
                                        .foregroundColor(.blue)
                                        .shadow(color: .white, radius: 10)
                                        .frame(width: 220, height: 220)
                                    
                                    Group {
                                        if let profileImage = profileViewModel.profileImage {
                                            Image(uiImage: profileImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 200, height: 200)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .frame(width: 200, height: 200)
                                                .clipShape(Circle())
                                        }
                                    }
                                    .padding()
                                }
                                
                                PhotosPicker(selection: $selectedItem, matching: .images) {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(8)
                                        .background(Color.black)
                                        .foregroundStyle(.blue)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                        .padding()
                                }
                                .onChange(of: selectedItem) { _, newItem in
                                    handlePhotoPickerChange(newItem: newItem)
                                }
                            }
                            
                            // User Details Section
                            TextField("Username", text: $newUsername)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(20)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .submitLabel(.done)
                                .onChange(of: newUsername) { _, newValue in
                                    if newValue.count > 20 {
                                        newUsername = String(newValue.prefix(20))
                                        showAlert = true
                                    }
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Character Limit Exceeded"),
                                        message: Text("Username cannot exceed 20 characters."),
                                        dismissButton: .default(Text("OK"))
                                    )
                                }
                            
                            DatePicker("Birthday:", selection: $newBirthday, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .padding(.vertical)
                                .foregroundColor(.white)
                            
                            ColorPicker("Profile Color Tag", selection: $selectedColor)
                                .padding(.vertical)
                                .foregroundColor(.white)
                            
                            // Save Button
                            HStack {
                                Spacer()
                                Button(action: {
                                    authViewModel.updateUser(username: newUsername, birthday: newBirthday, color: selectedColor.description)
                                    print("User data updated")
                                    showSettingSheet = false
                                }) {
                                    Text("Save Changes")
                                        .padding()
                                        .background(Color.black.opacity(0.6))
                                        .cornerRadius(20)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                        .padding()
                    }
                    
//                    Divider()
//                    //Buttons log and del
//                    HStack {
//                        // Logout Button
//                        Button(role: .destructive) {
//                            alertType = .logout
//                            showAlert = true
//                        } label: {
//                            Text("Log Out")
//                                .font(.subheadline)
//                                .foregroundColor(.red) // Text color for the button
//                                .padding()
//                                .background(Color.black.opacity(0.5)) // Button background color
//                                .cornerRadius(20) // Rounded corners
//                            
//                        }
//                        
//                        
//                        Spacer()
//                        
//                        
//                        // Delete Account Button
//                        Button(role: .destructive) {
//                            alertType = .deleteAccount
//                            showAlert = true
//                        } label: {
//                            Text("Delete Account")
//                                .font(.subheadline)
//                                .foregroundColor(.red) // Text color for the button
//                                .padding()
//                                .background(Color.black.opacity(0.5)) // Button background color
//                                .cornerRadius(20) // Rounded corners
//                        }
//                    }
//                    .padding()
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
                        case .noPrefrence:
                            return Alert(title: Text("Error"), message: Text("An unknown error occurred"), dismissButton: .default(Text("OK")))

                        }
                    }
                }
            }
            .background(.black.opacity(0.9))

        }
        .presentationDetents([.medium, .large])
        .presentationCornerRadius(50)
    }
    
    // Handle the image selection and update
    private func handlePhotoPickerChange(newItem: PhotosPickerItem?) {
        guard let newItem = newItem else { return }
        newItem.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data, let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    profileViewModel.saveProfileImage(image: uiImage)
                }
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
}

// Preview
#Preview {
    ProfileSheetView(
        authViewModel: AuthViewModel(),
        newUsername: .constant("JohnDoe"),
        newBirthday: .constant(Date()),
        showSettingSheet: .constant(true),
        selectedColor: .constant(.yellow)
    )
}
