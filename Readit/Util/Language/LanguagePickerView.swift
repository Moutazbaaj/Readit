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
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                VStack {
//                    Text("Select Language")
//                        .font(.headline)
//                        .padding()
//                    
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(Language.allCases, id: \.self) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 200)
                    
//                    Button("Done") {
//                        isPresented = false
//                    }
//                    .font(.headline)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.black.opacity(0.6))
//                    .foregroundColor(.white)
//                    .cornerRadius(20)
//                    .padding()
                }
                .navigationBarTitle("Select Language")
                .presentationDetents([.medium])
                .presentationCornerRadius(30)
            }
            .background(.black.opacity(0.9))
        }
    }
}
