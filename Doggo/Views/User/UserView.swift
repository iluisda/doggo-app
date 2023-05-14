//
//  UserView.swift
//  Doggo
//
//  Created by Luis Alvarez on 17/05/2023.
//

import SwiftUI
import RiveRuntime
import Amplify

struct UserView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State var isLoading = false
    let check = RiveViewModel(fileName: "check", stateMachineName: "State Machine 1")
    let user: AuthUser
    
    func signOut() {
        isLoading = true
        sessionManager.signOut()
            .done { result in
                // Sign out succeeded
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    check.triggerInput("Check")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isLoading = false
                    sessionManager.getCurrentAuthUser()
                }
            }
            .catch { error in
                // Sign in failed
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    check.triggerInput("Error")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isLoading = false
                }
            }
    }
    
    var body: some View {
        VStack{
            Button( action: {
                signOut()
            }) {
                Label("Sign Out! \u{1F64B} ", systemImage: "arrow.right")
                    .customFont(.headline)
                    .padding(20)
                
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "F77D8E"))
                    .foregroundColor(.white)
                    .cornerRadius(20, corners: [.topRight, .bottomLeft, .bottomRight])
                    .cornerRadius(8, corners: [.topLeft])
                    .shadow(color: Color(hex: "F77D8E").opacity(0.5), radius: 20, x: 0, y: 10)
            }.padding()
                .buttonStyle(PlainButtonStyle())
                .disabled(isLoading)
                .opacity(isLoading ? 0.5 : 1.0)
        }.overlay(
            ZStack {
                if isLoading {
                    check.view()
                        .frame(width: 100, height: 100)
                        .allowsHitTesting(false)
                }
                
            }
        )
        
    }
}

struct UserView_Previews: PreviewProvider {
    private struct DummyUser: AuthUser {
        let username: String = "hola"
        let userId: String = "1"
        let email: String = "hola@hola.com"
    }
    static var previews: some View {
        UserView(user: DummyUser())
    }
}
