//
//  ContentView.swift
//  Readit
//
//  Created by Moutaz Baaj on 06.01.25.
//

import SwiftUI
import Vision
import AVFoundation

struct ContentView: View {
    @State private var typedText: String = ""
    @State private var extractedText: String = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 20) {
            // Text Input Section
            TextField("Type your text here", text: $typedText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                readTextAloud(typedText)
            }) {
                Text("Read Typed Text")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // Photo Capture Section
            Button(action: {
                showingImagePicker = true
            }) {
                Text("Capture/Select Photo")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // Extracted Text Display
            if !extractedText.isEmpty {
                Text("Extracted Text:")
                    .font(.headline)
                    .padding(.top)
                Text(extractedText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            
            // Read Extracted Text
            if !extractedText.isEmpty {
                Button(action: {
                    readTextAloud(extractedText)
                }) {
                    Text("Read Extracted Text")
                        .font(.headline)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker(selectedImage: $selectedImage, onImagePicked: handleImage)
        })
    }
    
    // Function to Handle Text-to-Speech
    func readTextAloud(_ text: String) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
    // Function to Handle Image Processing
    func handleImage(image: UIImage?) {
        guard let image = image else { return }
        recognizeText(from: image)
    }
    
    // Function to Extract Text from Image
    func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let request = VNRecognizeTextRequest { request, error in
            if let results = request.results as? [VNRecognizedTextObservation] {
                let recognizedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
                DispatchQueue.main.async {
                    extractedText = recognizedText
                }
            }
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var onImagePicked: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary // Change to .camera for camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
                parent.onImagePicked(uiImage)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
#Preview {
    ContentView()
}
