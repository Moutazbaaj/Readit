struct LanguagePickerView: View {
    @Binding var selectedLanguage: Language
    @Binding var isPresented: Bool
    
    var body: some View {
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
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .presentationDetents([.medium])
    }
}