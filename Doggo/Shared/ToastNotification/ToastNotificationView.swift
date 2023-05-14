//
//  ToastNotificationView.swift
//  Doggo
//
//  Created by Luis Alvarez on 18/05/2023.
//

import SwiftUI
enum ToastType {
    case success
    case error
}
struct ToastNotificationView: View {
    let message: String
    let type: ToastType
    
    var iconColor: Color {
        switch type {
        case .success:
            return .green
        case .error:
            return Color(hex: "F77D8E")
        }
    }
    
    var fontColor: Color {
        switch type {
        case .success:
            return .white
        case .error:
            return .white
        }
    }
    
    var topLineColor: Color {
        switch type {
        case .success:
            return .green
        case .error:
            return .red
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(topLineColor)
                    .padding(.trailing, 4)
                Text(message)
                    .customFont(.headline)
                    .foregroundColor(.black)
                    .padding()
                
            }
            .padding(.leading, 10)
        }
        .frame(width: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .transition(.opacity)
        .padding(.horizontal, 5)
    }
}

struct ToastNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ToastNotificationView(message: "Dummy", type: .error)
    }
}
