//
//  CameraCaptureButton.swift
//  Readit
//
//  Created by Moutaz Baaj on 09.01.25.
//

import UIKit
import SwiftUI


struct CameraCaptureButton: View {
    @Binding var capturedImage: UIImage?
    
    @State private var showCamera = false
    
    var body: some View {
        Button(action: {
            capturedImage = nil // Reset the captured image
            showCamera = true
        }) {
            Label("Take Photo", systemImage: "camera")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .sheet(isPresented: $showCamera) {
            CameraView(image: $capturedImage)
        }
    }
}
