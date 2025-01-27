//
//  ProfileCreatingView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 24.07.24.
//

import SwiftUI
import PhotosUI
import FirebaseAuth

struct ProfileCreatingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var profileViewModel = ProfileViewModel.shared // ViewModel for managing User Profile
    @State private var name = ""
    @State private var birthday: Date = Date()
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var selectedColor: Color = .blue // State for selected color
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .blur(radius: 10)
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                    VStack {
                        // Dismiss Button
                        HStack {
                            Button(action: {
                                dismiss()
                                authViewModel.deleteUserData()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            ZStack(alignment: .bottomTrailing) {
                                ZStack {
                                    // Outer circle with shadow
                                    Circle()
                                        .stroke(lineWidth: 5) // Adjust the thickness of the circle
                                        .foregroundColor(.blue) // The color of the circle
                                        .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                                        .frame(width: 220, height: 220)
                                    if let profileImage = selectedImage {
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
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                        .padding()
                                }
                                .onChange(of: selectedItem) { _, newItem in
                                    if let newItem = newItem {
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
                            }
                            Spacer()
                        }
                        
                        Spacer()
                        
                        // Nickname TextField
                        HStack {
                            Text("Nickname")
                                .foregroundStyle(.black)
                                .padding(.bottom, -50)
                                .padding()
                            Spacer()
                        }
                        TextField("", text: $name)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(15)
                            .padding()
                            .submitLabel(.done) // Shows 'OK' on the return key
                        
                        // Birthday DatePicker
                        DatePicker("Birthday", selection: $birthday, in: ...Date(), displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding()
                            .padding()
                        
                        // Color Picker
                        ColorPicker("Select a color", selection: $selectedColor)
                            .padding()
                        
                        // Save Button
                        
                        Button("Save Profile") {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                authViewModel.checkAuth()
                                let userId =  Auth.auth().currentUser?.uid
                                authViewModel.setUser(userId: userId ?? "", username: name, birthday: birthday, color: selectedColor.description)
                            }
                        }
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.blue)
                        .cornerRadius(15)
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .foregroundStyle(.blue)
    }
}

// Preview for SwiftUI Preview Provider
struct ProfileCreatingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCreatingView()
            .environmentObject(AuthViewModel())
    }
}
