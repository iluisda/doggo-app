//
//  SplashScreenView.swift
//  Doggo
//
//  Created by Luis Alvarez on 17/05/2023.
//

import SwiftUI
import RiveRuntime

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            background
        }
    }
    var background: some View {
        RiveViewModel(fileName: "shapes").view()
            .ignoresSafeArea()
            .blur(radius: 30)
            .background(
                Image("dora")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
            )
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
