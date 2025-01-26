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
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .blur(radius: 10)
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack {
                        ProfileImageSection(
                            profileViewModel: profileViewModel,
                            selectedItem: $selectedItem,
                            selectedImage: $selectedImage
                        )
                        .padding(.top, 10)
                        
                        UserDetailsSection(
                            newUsername: $newUsername,
                            newBirthday: $newBirthday,
                            selectedColor: $selectedColor,
                            showAlert: $showAlert
                        )
                        
                        SaveButton(authViewModel: authViewModel, showSettingSheet: $showSettingSheet, newUsername: newUsername, newBirthday: newBirthday, selectedColor: selectedColor)
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        showSettingSheet = false
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}

struct ProfileImageSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .padding()
                }
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
    }
    
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

struct UserDetailsSection: View {
    @Binding var newUsername: String
    @Binding var newBirthday: Date
    @Binding var selectedColor: Color
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack {
            TextField("Username", text: $newUsername)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
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
        }
    }
}

struct SaveButton: View {
    var authViewModel: AuthViewModel
    @Binding var showSettingSheet: Bool
    var newUsername: String
    var newBirthday: Date
    var selectedColor: Color
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                authViewModel.updateUser(username: newUsername, birthday: newBirthday, color: selectedColor.description)
                print("User data updated")
                showSettingSheet = false
            }) {
                Text("Save Changes")
                    .padding()
                    .foregroundColor(.blue)
                    .background(Color.black)
                    .cornerRadius(15)
            }
            Spacer()
        }
        .padding()
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
