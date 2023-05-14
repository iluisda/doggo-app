//
//  ConfirmUserView.swift
//  Doggo
//
//  Created by Luis Alvarez on 16/05/2023.
//

import SwiftUI
import RiveRuntime
import Amplify
struct ConfirmUserView: View {
    @EnvironmentObject var sessionManager: SessionManager
    var onSignInTriggered: () -> Void
    @State var confirm = ""
    @State var isLoading = false;
    @Binding var showConfirmModal: Bool
    @State private var resultMessage: String = ""
    @State private var showErrorToast: Bool = false
    let check = RiveViewModel(fileName: "check", stateMachineName: "State Machine 1")
    let confetti = RiveViewModel(fileName: "confetti", stateMachineName: "State Machine 1")
    let username: String
    func confirmUser() {
        isLoading = true
        if confirm != "" {
            sessionManager.confirmSignUp(for: username, with: confirm)
                .done { result in
                    // Confirm Sign Up succeeded
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        check.triggerInput("Check")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isLoading = false
                        confetti.triggerInput("Trigger explosion")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            showConfirmModal = false
                            sessionManager.setAuthState(state: .login)
                        }
                    }
                    
                }
                .catch { error in
                    // Sign Up failed
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        check.triggerInput("Error")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isLoading = false
                        showErrorToast.toggle()
                    }
                    if let authError = error as? AuthError {
                        self.resultMessage = authError.errorDescription
                    } else {
                        self.resultMessage = "Unknown error occurred"
                    }
                    print(resultMessage)
                }
        }
        check.reset()
        confetti.reset()
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Confirma tu usuario").customFont(.title)
            Text("Ultimo paso parra unirte a la comunidad Doggo!").customFont(.headline)
            
            VStack(alignment: .leading) {
                Text("Confirmar @\(username)")
                    .customFont(.subheadline)
                    .foregroundColor(.secondary)
                SecureField("Confirmar", text: $confirm)
                    .customTextField(image: Image(systemName: "key.fill"))
            }
            Button {
                confirmUser()
            } label: {
                Label("confirmar", systemImage: "arrow.right")
                    .customFont(.headline)
                    .buttonStyle(PlainButtonStyle())
                    .disabled(confirm.isEmpty || isLoading)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "F77D8E"))
                    .foregroundColor(.white)
                    .cornerRadius(20, corners: [.topRight, .bottomLeft, .bottomRight])
                    .cornerRadius(8, corners: [.topLeft])
                    .shadow(color: Color(hex: "F77D8E").opacity(0.5), radius: 20, x: 0, y: 10)
            }
            
        }
        .padding(30)
        .background(.regularMaterial)
        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
        .shadow(color: Color("Shadow").opacity(0.3), radius: 30, x: 0, y: 3)
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(.linearGradient(colors: [.white.opacity(0.8), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .topTrailing)))
        .padding()
        .overlay(
            ZStack {
                if isLoading {
                    check.view()
                        .frame(width: 100, height: 100)
                        .allowsHitTesting(false)
                }
                confetti.view()
                    .scaleEffect(3)
                    .allowsHitTesting(false)
            }
        )
    }
}

struct ConfirmUserView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmUserView(onSignInTriggered: {}, showConfirmModal: .constant(true), username: "iluisda")
    }
}
