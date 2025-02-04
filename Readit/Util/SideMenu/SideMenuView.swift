//
//  SideMenuView.swift
//  Readit
//
//  Created by Moutaz Baaj on 04.02.25.
//

import SwiftUI
import PhotosUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    
    
    @StateObject var profileViewModel = ProfileViewModel.shared
    @StateObject var textToSpeechManager = TextToSpeechManager.shared
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
    @State private var selectedVoice = Voice.custom(identifier: "com.apple.voice.compact.en-US.Samantha", language: "en-US", name: "Samantha (en-US)") // Selected voice
    @State private var isLoadingPreferences = true
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isShowing {
                    Rectangle()
                        .opacity(0.3)
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            isShowing.toggle()
                        }
                    HStack {
                        VStack(alignment: .leading) {
                            VStack {
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
                                                    .frame(width: 55, height: 55)
                                                
                                                if let profileImage = profileViewModel.profileImage {
                                                    Image(uiImage: profileImage)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 50, height: 50)
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
                                        
                                        // User Info Section
                                        VStack(alignment: .leading) {
                                            Text("\(authViewModel.user?.username ?? "unknown")")
                                                .foregroundColor(Color(from: authViewModel.user?.color ?? "black"))
                                                .bold()
                                                .font(.subheadline)
                                            
                                            Text("\(authViewModel.user?.birthday ?? Date(), style: .date)")
                                                .font(.caption2)
                                            
                                            
                                            Text("\(authViewModel.user?.email ?? "unknown")")
                                                .foregroundStyle(.gray)
                                                .font(.caption2)
                                        }
                                        
                                        Spacer()
                                        // settings
                                        Button(action: {
                                            showSettingSheet = true
                                            newUsername = authViewModel.user?.username ?? ""
                                            newBirthday = authViewModel.user?.birthday ?? Date()
                                            newColor = Color(from: authViewModel.user?.color ?? "")
                                        }) {
                                            Image(systemName: "gearshape")
                                                .imageScale(.large)
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    Spacer()
                                    
                                    //Option Stack
                                    VStack {
                                        HStack {
                                            Text("preferences:")
                                                .font(.subheadline)
                                                .foregroundStyle(.gray)
                                            
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
                                                    Text(textToSpeechManager.preferences.first?.selectedLanguageName ?? "select Language")
                                                        .font(.caption2)
                                                        .foregroundColor(.white) // Text color for the button
                                                        .padding()
                                                        .background(Color.black.opacity(0.5)) // Button background color
                                                        .cornerRadius(20) // Rounded corners
                                                }
                                            }
                                            
                                            //Voice
                                            HStack {
                                                Text("Voice:")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.gray)
                                                Spacer()
                                                Button(action: {
                                                    showVoicePicker = true
                                                }) {
                                                    Text(textToSpeechManager.preferences.first?.selectedVoice.name ?? "select voice")
                                                        .font(.caption2)
                                                        .foregroundColor(.white) // Text color for the button
                                                        .padding()
                                                        .background(Color.black.opacity(0.5)) // Button background color
                                                        .cornerRadius(20) // Rounded corners
                                                }
                                            }
                                        }
                                        Divider()
                                    }
                                    
                                    Spacer()
                                    Spacer()

                                }
                                .sheet(isPresented: $showSettingSheet) {
                                    ProfileSheetView(
                                        authViewModel: authViewModel,
                                        newUsername: $newUsername,
                                        newBirthday: $newBirthday,
                                        showSettingSheet: $showSettingSheet,
                                        selectedColor: $newColor
                                    )
                                    
                                }
                                .sheet(isPresented: $showLanguagePicker) {
                                    LanguageListPickerView(selectedLanguage: $selectedLanguage, isPresented: $showLanguagePicker)
                                }
                                .sheet(isPresented: $showVoicePicker) {
                                    VoiceListPickerView(selectedVoice: $selectedVoice, isPresented: $showVoicePicker, language: $selectedLanguage)
                                }
                                .onChange(of: textToSpeechManager.preferences) { _, preferences in
                                    
                                    if preferences.isEmpty {
                                        alertType = .noPrefrence
                                        showAlert = true
                                    } else {
                                        if let firstPreference = preferences.first {
                                            let language = Language(rawValue: firstPreference.selectedLanguage) ?? .englishUS
                                            let voice = Voice.custom(identifier: firstPreference.selectedVoice.identifier,
                                                                     language: language.rawValue,
                                                                     name: firstPreference.selectedVoice.name)
                                            
                                            // Update only if values are different
                                            if selectedLanguage != language {
                                                selectedLanguage = language
                                            }
                                            
                                            if selectedVoice != voice {
                                                selectedVoice = voice
                                            }
                                        }
                                    }
                                }
                                .onChange(of: selectedLanguage) { _, newLanguage in
                                    if let firstVoice = Voice.voices(for: newLanguage.rawValue).first {
                                        selectedVoice = firstVoice
                                    }
                                    
                                    if textToSpeechManager.preferences.isEmpty {
                                        textToSpeechManager.createPrefrences(language: selectedLanguage, voice: selectedVoice)
                                        print("created")
                                    } else {
                                        if textToSpeechManager.preferences.first?.selectedLanguage != selectedLanguage.rawValue {
                                            textToSpeechManager.editPrefrences(
                                                withId: textToSpeechManager.preferences.first?.id ?? "",
                                                newLanguage: selectedLanguage,
                                                newVoice: selectedVoice
                                            )
                                            print("updated")
                                        }
                                    }
                                }
                                .onChange(of: selectedVoice) { _, newVoice in
                                    if textToSpeechManager.preferences.isEmpty {
                                        textToSpeechManager.createPrefrences(language: selectedLanguage, voice: selectedVoice)
                                        print("created with voice")
                                    } else {
                                        if textToSpeechManager.preferences.first?.selectedVoice.identifier != newVoice.identifier {
                                            textToSpeechManager.editPrefrences(
                                                withId: textToSpeechManager.preferences.first?.id ?? "",
                                                newLanguage: selectedLanguage,
                                                newVoice: selectedVoice
                                            )
                                            print("updated with voice")
                                        }
                                    }
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
                                case .noPrefrence:
                                    return Alert(title: Text("Warning"), message: Text(" there is no preferences set please choose language and voice"), dismissButton: .default(Text("OK")))
                                }
                            }
                            .onAppear {
                                isLoadingPreferences = true
                                textToSpeechManager.fetchPrefrences()
                                isLoadingPreferences = false
                                profileViewModel.loadProfileImage()
                            }

                        }
                        .padding()
                        .frame(maxWidth: 270, alignment: .leading)
                        .presentationCornerRadius(30)
                        .background(
                            LinearGradient(
                            gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .edgesIgnoringSafeArea(.all))
                        .background(.black.opacity(0.9))
                        
                        Spacer()
                    }
                }
            }
            .transition(.move(edge: .leading))
            .animation(.easeInOut, value: isShowing)
            
        }
    }
}

#Preview {
    SideMenuView(isShowing: .constant(true))
}
