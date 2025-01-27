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
    
    
    @State private var showLanguagePicker = false
    @State private var selectedLanguage: Language = .englishUS
    @State private var showVoicePicker = false // Controls the voice picker presentation
    @State private var selectedVoice = Voice.allCases.first ?? .custom(identifier: "", language: "", name: "") // Selected voice
    @State private var isLoadingPreferences = true
    
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
                .edgesIgnoringSafeArea(.all)
                
                
                //mein Stack
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
                            
                            //                            Text("\(authViewModel.user?.birthday ?? Date(), style: .date)")
                            //                                .font(.callout)
                            //                                .font(.callout)
                            
                            
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
                    
                    //Option Stack
                    VStack {
                        HStack {
                            Text("preferences:")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .padding()
                            
                            Spacer()
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        if isLoadingPreferences {
                            ProgressView("Loading preferences...")
                        } else {
                            //Language
                            HStack {
                                Text("Language:")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                
                                Spacer()
                                Button(action: {
                                    showLanguagePicker = true
                                }) {
                                    Text(selectedLanguage.displayName)
                                        .font(.subheadline)
                                        .foregroundColor(.white) // Text color for the button
                                        .padding()
                                        .background(Color.black.opacity(0.5)) // Button background color
                                        .cornerRadius(20) // Rounded corners
                                }
                            }
                            .padding()
                            
                            //Voice
                            HStack {
                                Text("Voice:")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                
                                
                                Spacer()
                                
                                Button(action: {
                                    showVoicePicker = true
                                }) {
                                    Text(selectedVoice.displayName)
                                        .font(.subheadline)
                                        .foregroundColor(.white) // Text color for the button
                                        .padding()
                                        .background(Color.black.opacity(0.5)) // Button background color
                                        .cornerRadius(20) // Rounded corners
                                }
                            }
                            .padding()
                        }
                        Divider()
                    }
                    .padding()
                    
                    Spacer()
                    
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
                    .presentationCornerRadius(50)
                }
                .sheet(isPresented: $showLanguagePicker) {
                    LanguagePickerView(selectedLanguage: $selectedLanguage, isPresented: $showLanguagePicker)
                }
                .sheet(isPresented: $showVoicePicker) {
                    VoicePickerView(selectedVoice: $selectedVoice, isPresented: $showVoicePicker, language: selectedLanguage)
                }
                .onChange(of: profileViewModel.preferences) {_ , preferences in
                    if let rawSelectedLanguage = preferences.first?.selectedLanguage,
                       let language = Language(rawValue: rawSelectedLanguage),
                       let firstVoice = Voice.voices(for: language.rawValue).first {
                        selectedLanguage = language
                        selectedVoice = firstVoice
                    }
                }
                .onChange(of: selectedLanguage) {_, newLanguage in
                    if let firstVoice = Voice.voices(for: newLanguage.rawValue).first {
                        selectedVoice = firstVoice
                    }
                    if profileViewModel.preferences.isEmpty {
                        profileViewModel.createPrefrences(language: selectedLanguage.rawValue)
                        print("created")
                        
                    } else {
                        profileViewModel.editPrefrences(withId: profileViewModel.preferences.first?.id ?? "", newLanguage: selectedLanguage.rawValue)
                        print("updated")
                        
                    }
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
                profileViewModel.fetchPrefrences()
                profileViewModel.loadProfileImage()
                isLoadingPreferences = false


            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
