//
//  LibraryView.swift
//  Readit
//
//  Created by Moutaz Baaj on 08.01.25.
//

import SwiftUI

struct LibraryView: View {

        // View model to manage the list of bee reports.
    @StateObject private var viewModel = LibraryViewModel.shared
        
        // Environment object to access the login view model.
//        @EnvironmentObject var loginViewModel: AuthViewModel
        
        @State private var showAlert = false // State variable to control the display of the alert.
        @State private var showEditSheet = false // State variable to control the display of the edit sheet.
        @State private var showBeeReportSheet = false  // State to control the visibility of the bee report sheet
        @State private var textItem: FireText? // State variable to keep track of the text to edit or delete.
        
        var body: some View {
            
            NavigationStack {
                VStack {
                    
                    if viewModel.texts.isEmpty {
                        Text("Library is empty")
                            .font(.headline)
                            .foregroundColor(.gray)
                    } else {
                        List(viewModel.texts.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })) { text in
                            NavigationLink {
//                                BeeReportDetailsView(beeViewModel: beeViewModel, bee: bee)
                            } label: {
                                HStack {
//                                    Image(bee.kind)
//                                        .resizable()
//                                        .frame(width: 50, height: 50)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                        .padding(3)
//                                        .background(Color.appYellow.opacity(0.9))
//                                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                                        .shadow(radius: 10)
//                                        .scaledToFit()
//
                                    VStack(alignment: .leading) {
                                        Text(text.text)
                                            .font(.headline)
                                        HStack {
                                            Text(text.timestamp.dateValue(), style: .date)
                                            Text(text.timestamp.dateValue(), style: .time)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.black.opacity(0.1))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        textItem = text
                                        showAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                    
                                    Button {
                                        textItem = text
                                        showEditSheet = true
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        
                        .onAppear {
//                            viewModel.fetchMyTexts()
                        }
                    }
                }
                .navigationTitle("My Library")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button(action: { showBeeReportSheet = true
                }) {
                    Image(systemName: "plus")
                })
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirm Delete"),
                        message: Text("Are you sure you want to delete this text?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let text = textItem {
                                viewModel.deleteText(withId: text.id)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .sheet(isPresented: $showEditSheet) {
                    if let text = textItem {
//                        EditBeeReportSheetView(
//                            beeViewModel: beeViewModel,
//                            reportsViewModel: ReportsViewModel(),
//                            bee: bee
//                        )
//                        .presentationDetents([.medium, .large])
                    }
                }
                .sheet(isPresented: $showBeeReportSheet) {
//                    BeeReportSheetView(beeViewModel: beeViewModel)
//                        .presentationDetents([.large])
                }
            }
        }
    }

#Preview {

}
