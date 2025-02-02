//
//  FloatingTabbar.swift
//  Readit
//
//  Created by Moutaz Baaj on 31.01.25.
//
//
//import SwiftUI
//
//
//struct FloatingTabbar: View {
//    @State var selected =  1
//    @State var expand = true
//    
//    
//    @State var Tap1SystemName = "house"
//    @State var Tap2SystemName = "bubble.and.pencil"
//    @State var Tap3SystemName = "photo.badge.plus.fill"
//    @State var Tap4SystemName = "books.vertical"
//    @State var Tap5SystemName = "books.vertical"
//    
//    
//    
//    var body: some View {
//       HStack {
//            Spacer()
//            HStack {
//                Button(action: {
//                    self.expand.toggle() // Toggle expand on tap
//                }) {
//                    Image(systemName: expand ? "arrow.right" : "plus") // Dynamic icon
//                        .foregroundColor(.black)
//                        .padding()
//                }
//                
//                if expand {
//                    
//                    Button(action: { self.selected = 0}) {
//                        NavigationLink(destination: HistoryView()){
//                            Image(systemName: Tap1SystemName)
//                                .foregroundColor(self.selected == 0 ? .black : .gray)
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                    Button(action: { self.selected = 1}) {
//                        Image(systemName: Tap2SystemName)
//                            .foregroundColor(self.selected == 1 ? .black : .gray)
//                    }
//                    
//                    Spacer()
//                    
//                    Button(action: { self.selected = 2}) {
//                        Image(systemName: Tap3SystemName)
//                            .foregroundColor(self.selected == 2 ? .black : .gray)
//                    }
//                    
//                    Spacer()
//                    
//                    
//                    Button(action: { self.selected = 3}) {
//                        Image(systemName: "books.vertical")
//                            .foregroundColor(self.selected == 3 ? .black : .gray)
//                    }
//                    
//                    Spacer()
//                    
////                    Button(action: { self.selected = 4}) {
////                        Image(systemName: Tap4SystemName)
////                            .foregroundColor(self.selected == 4 ? .black : .gray)
////                    }
////                    
////                    Spacer()
//                    
//                    Button(action: { self.selected = 5}) {
//                        Image(systemName: Tap5SystemName)
//                            .foregroundColor(self.selected == 5 ? .black : .gray)
//                    }
//                    
//                    Spacer()
//                }
//            }
//            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color.white.opacity(0.95), Color.white.opacity(0.95)]),
//                    startPoint: .leading,
//                    endPoint: .trailing
//                )
//            )
//            .clipShape(Capsule())
//            .padding(.bottom)
//            .padding()
//            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6), value: expand)
//        }
//    }
//}
