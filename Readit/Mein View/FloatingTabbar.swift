//
//  FloatingTabbar.swift
//  Readit
//
//  Created by Moutaz Baaj on 31.01.25.
//

import SwiftUI


struct FloatingTabbar: View {
    @Binding var selected: Int
    @State var expand = false
    
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Button(action: {
                    self.expand.toggle() // Toggle expand on tap
                }) {
                    Image(systemName: expand ? "arrow.right" : "arrow.left") // Dynamic icon
                        .foregroundColor(.black)
                        .padding()
                }

                if expand {
                    
                    Button(action: { self.selected = 0; self.expand.toggle()}) {
                        Image(systemName: "plus.circle.dashed")
                            .foregroundColor(self.selected == 0 ? .black : .gray)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    Button(action: { self.selected = 1}) {
                        Image(systemName: "house")
                            .foregroundColor(self.selected == 1 ? .black : .gray)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    Button(action: { self.selected = 2}) {
                        Image(systemName: "books.vertical")
                            .foregroundColor(self.selected == 2 ? .black : .gray)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    
                    Button(action: { self.selected = 3}) {
                        Image(systemName: "document.viewfinder.fill")
                            .foregroundColor(self.selected == 3 ? .black : .gray)
                            .padding(.horizontal)
                    }
                    
                    Button(action: { self.selected = 4}) {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(self.selected == 4 ? .black : .gray)
                            .padding(.horizontal)
                    }
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.95), Color.white.opacity(0.95)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .padding(.bottom)
            .padding()
            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6), value: expand)
        }
    }
}
