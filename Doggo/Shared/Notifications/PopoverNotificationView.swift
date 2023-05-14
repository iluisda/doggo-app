//
//  PopoverNotificationView.swift
//  Doggo
//
//  Created by Luis Alvarez on 18/05/2023.
//

import SwiftUI

struct PopoverNotificationView: View {
    @Binding var isShowing: Bool
    var message: String
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text(message)
                        .font(.headline)
                    Spacer()
                    
                    Button(action: {
                        isShowing = false
                    }) {
                        Image(systemName: "xmark")
                            .frame(width: 36, height: 36)
                            .background(Color(hex: "F77D8E"))
                            .foregroundColor(.white)
                            .mask(Circle())
                            .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                }
                .padding()
            }
            .transition(.move(edge: .top).combined(with: .opacity))
            .frame(width: 300, height: 50)
            .background(.regularMaterial)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
            .shadow(color: Color("Shadow").opacity(0.3), radius: 30, x: 0, y: 3)
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(.linearGradient(colors: [.white.opacity(0.8), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .topTrailing)))
        }
    }
}

struct PopoverNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverNotificationView(isShowing: .constant(true), message: "Dummy Message")
    }
}
