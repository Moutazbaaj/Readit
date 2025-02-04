//
//  SideMenuView.swift
//  Readit
//
//  Created by Moutaz Baaj on 04.02.25.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    var body: some View {
        NavigationStack {
            ZStack {
                if isShowing {
                    Rectangle()
                        .opacity(0.3)
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            isShowing.toggle()
                        }
                    HStack {
                        VStack(alignment: .leading) {
                            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                                .foregroundStyle(.blue)
                            Spacer()
                        }
                        .padding()
                        .frame(width: 250, alignment: .leading)
                        .background(.white)
                        
                        Spacer()
                    }
                }
            }
            .transition(.move(edge: .leading))
            .animation(.easeInOut, value: isShowing)

        }
    }
}

#Preview {
    SideMenuView(isShowing: .constant(true))
}
