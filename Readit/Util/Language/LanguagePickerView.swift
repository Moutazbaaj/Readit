//
//  LanguagePickerView.swift
//  Readit
//
//  Created by Moutaz Baaj on 16.01.25.
//

import SwiftUI


struct LanguagePickerView: View {
    @Binding var selectedLanguage: Language
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .blur(radius: 10)
            .edgesIgnoringSafeArea(.all)
        VStack {
            Text("Select Language")
                .font(.headline)
                .padding()
            
            Picker("Language", selection: $selectedLanguage) {
                ForEach(Language.allCases, id: \.self) { language in
                    Text(language.displayName).tag(language)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 200)
            
            Button("Done") {
                isPresented = false
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.6))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .presentationDetents([.medium])
        .presentationCornerRadius(50)
    }
}
}
