struct SheetView: View {
    @Environment(\.dismiss) var dismiss // Allows dismissing the sheet
    @State private var hideButton = true

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { dismiss() }) { // Close button
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                }
            }
            
            Spacer()
            
            VStack {
                NavigationLink(destination: TextToSpeechView()) {
                    VStack {
                        Image(systemName: "bubble.and.pencil")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                        Text("Text to Speech")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                
                NavigationLink(destination: ImageRecognitionView()) {
                    VStack {
                        Image(systemName: "photo.badge.plus.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                        Text("Text Recognition")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .cornerRadius(30)
                .padding()
            )
            
            Spacer()
        }
        .background(Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)) // Background styling
    }
}