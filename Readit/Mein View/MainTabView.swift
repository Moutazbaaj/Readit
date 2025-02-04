//
//  MainTabView.swift
//  FireText warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import SwiftUI

struct MainTabView: View {
    //    @State var selected = 0
    //    @State var hideButton = false
    
//    @State private var showMenu = false
//    @State private var showSheet = false

    
    
    var body: some View {
//        NavigationStack {
            ZStack {
                TabView {
                    // Home Tab
                    NavigationStack {
                        HomeView()
                    }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    
                    // Library Tab
                    NavigationStack {
                        CollectionView()
                    }
                    .tabItem {
                        Label("Collections", systemImage: "books.vertical")
                    }
                    
                    // Scan Tab
                    NavigationStack {
                        HistoryView()
                    }
                    .tabItem {
                        Label("History", systemImage: "document.viewfinder.fill")
                    }
                    
                    // Settings Tab
                    NavigationStack {
                        ProfileView()
                    }
                    .tabItem {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                }
                .tint(.white)
                
//                SideMenuView(isShowing: $showMenu)
                
            }

//            .navigationBarItems(leading: HStack {
//                
//                Button("", systemImage: "line.3.horizontal") {
//                    showMenu.toggle()
//                }.padding()
//                
//                Spacer()
//            })
//            .navigationBarItems(trailing: HStack {
//                Button("", systemImage: "plus.circle") {
//                    showSheet = true
//                }
//    //            Spacer()
//    //            //History
//    //            NavigationLink(destination: HistoryView()) {
//    //                Image(systemName: "clock")
//    //                    .foregroundColor(.white)
//    //                    .padding()
//    //            }
//            })
//            .sheet(isPresented: $showSheet){
//                SheetView()
//                    .presentationDetents([.large])
//                    .presentationCornerRadius(30)
//                    .presentationDragIndicator(.visible)
//            }


//        }
//        .tint(.white)
    }
}



