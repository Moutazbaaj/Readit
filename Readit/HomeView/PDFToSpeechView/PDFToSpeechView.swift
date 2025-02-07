//
//  PDFToSpeechView.swift
//  Readit
//
//  Created by Moutaz Baaj on 07.02.25.
//

import SwiftUI

struct PDFToSpeechView: View {
    @State private var showDocumentPicker = false

    var body: some View {
        VStack {
            Button("Select PDF to Read") {
                showDocumentPicker = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { url in
                TextToSpeechManager.shared.readTextFromPDF(pdfURL: url)
            }
        }
    }
}

#Preview {
    PDFToSpeechView()
}
