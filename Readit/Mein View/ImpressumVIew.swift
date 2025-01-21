//
//  ImpressumView.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import SwiftUI

struct ImpressumView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        LogoSection()
                        
                        AppInfoSection()
                        
                        PrivacyPolicySection()
                        
                        DeveloperInfoSection()
                        
                        CopyrightSection()
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("About Us")
        }
        .foregroundColor(.black)
    }
}

// MARK: - Logo Section
struct LogoSection: View {
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                Circle()
                    .stroke(lineWidth: 5)
                    .foregroundColor(.blue)
                    .shadow(color: .white, radius: 10)
                    .frame(width: 220, height: 220)
                
                Image("beeLogo")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
            }
            Spacer()
        }
    }
}

// MARK: - App Information Section
struct AppInfoSection: View {
    var body: some View {
        Group {
            Text("App Information")
                .font(.title2)
                .foregroundColor(.blue)
                .padding(.bottom, 5)
            
            Text("Bee-Spotter is an app that allows users to track and report bee sightings, contributing to citizen science efforts while helping individuals stay aware of bee activity in their area. The app includes real-time notifications, statistical data, and detailed information about various bee species.")
                .padding(.vertical, 5)
        }
        .sectionStyle()
    }
}

// MARK: - Privacy Policy Section
struct PrivacyPolicySection: View {
    var body: some View {
        Group {
            Text("Privacy Policy")
                .font(.title2)
                .foregroundColor(.blue)
                .padding(.bottom, 5)
            
            Text("Bee-Spotter respects your privacy and does not collect unnecessary personal data. Your location is only used for reporting sightings and is never shared with third parties. You can manage your data and delete reports at any time.")
                .padding(.vertical, 5)
        }
        .sectionStyle()
    }
}

// MARK: - Developer Information Section
struct DeveloperInfoSection: View {
    var body: some View {
        Group {
            Text("Developer Information")
                .font(.title2)
                .foregroundColor(.blue)
                .padding(.bottom, 5)
            
            HStack {
                Text("Name:")
                    .bold()
                Spacer()
                Text("Moutaz Baaj")
            }
            .padding(.vertical, 5)
            
            HStack {
                Text("GitHub:")
                    .bold()
                Spacer()
                Link("https://github.com/Moutazbaaj", destination: URL(string: "https://github.com/Moutazbaaj")!)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 5)
            
            HStack {
                Text("Email:")
                    .bold()
                Spacer()
                Link("moutazbaaj@gmail.com", destination: URL(string: "mailto:moutazbaaj@gmail.com")!)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 5)
        }
        .sectionStyle()
    }
}

// MARK: - Copyright Section
struct CopyrightSection: View {
    var body: some View {
        Group {
            Text("Copyright & Legal")
                .font(.title2)
                .foregroundColor(.blue)
                .padding(.bottom, 5)
            
            Text("© 2024 Moutaz Baaj. All rights reserved. Unauthorized distribution or use of this app is prohibited. Bee-Spotter and its content are protected by copyright laws and intellectual property rights.")
                .padding(.vertical, 5)
        }
        .sectionStyle()
    }
}

// MARK: - Section Style Modifier
extension View {
    func sectionStyle() -> some View {
        self
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(15)
            .foregroundColor(.white)
    }
}


// Preview
#Preview {
    ImpressumView()
}
