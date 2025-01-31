//
//  LanguageListPickerView.swift
//  Readit
//
//  Created by Moutaz Baaj on 31.01.25.
//


//
//  LanguageListPickerView.swift
//  Readit
//
//  Created by Moutaz Baaj on 31.01.25.
//

import SwiftUI


struct LanguageListPickerView: View {
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
                    ScrollView {
                        ForEach(Language.allCases, id: \.rawValue) { language in
                            HStack {
                                Text(language.displayName)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if language.displayName == selectedLanguage.displayName {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .contentShape(Rectangle()) // Ensure the whole row is tappable
                            .overlay{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .onTapGesture {
                                selectedLanguage = language
                                //                        isPresented = false
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarTitle("Select Language")
                .presentationDetents([.medium])
                .presentationCornerRadius(50)
            }
        }
    }
}
