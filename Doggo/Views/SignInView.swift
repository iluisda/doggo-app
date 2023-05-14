//
//  SignInView.swift
//  Doggo
//
//  Created by Luis Alvarez on 13/05/2023.
//

import SwiftUI
import RiveRuntime
import Amplify
struct SignInView: View {
    var onSignUpTriggered: () -> Void
    @EnvironmentObject var sessionManager: SessionManager
    @State var username = ""
    @State var password = ""
    @State var isLoading = false
    @Binding var showSignInModal: Bool
    @State private var resultMessage: String = ""
    @State private var showErrorToast: Bool = false

    let check = RiveViewModel(fileName: "check", stateMachineName: "State Machine 1")
    let confetti = RiveViewModel(fileName: "confetti", stateMachineName: "State Machine 1")
    
    func logIn() {
        isLoading = true
        if username != "" || password != "" {
            sessionManager.signIn(username: username, password: password)
                .done { result in
                    // Sign in succeeded
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        check.triggerInput("Check")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isLoading = false
                        sessionManager.getCurrentAuthUser()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            showSignInModal = false
                        }
                    }
                }
                .catch { error in
                    // Sign in failed
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
        //        confetti.reset()
    }
    var body: some View {
        VStack(spacing: 24) {
            Text("Iniciar sesion").customFont(.largeTitle)
            Text("Consigue los mejores espacios para estar con tu compañer@ en un solo lugar.").customFont(.headline).overlay(
                Group {
                    if showErrorToast {
                        ToastNotificationView(message: resultMessage,
                                              type: .error)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showErrorToast.toggle()
                                }
                                
                            }
                        }
                    }
                }
            )
            
            VStack(alignment: .leading) {
                Text("Nombre de usuario")
                    .customFont(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Nombre de usuario", text: $username)
                    .customTextField(image: Image(systemName: "person.fill"))
            }
            VStack(alignment: .leading) {
                Text("Contraseña")
                    .customFont(.subheadline)
                    .foregroundColor(.secondary)
                SecureField("Contraseña", text: $password)
                    .customTextField(image: Image(systemName: "key.fill"))
            }
            Button(action: {
                logIn()
            }) {
                Label("iniciar sesion", systemImage: "arrow.right")
                    .customFont(.headline)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "F77D8E"))
                    .foregroundColor(.white)
                    .cornerRadius(20, corners: [.topRight, .bottomLeft, .bottomRight])
                    .cornerRadius(8, corners: [.topLeft])
                    .shadow(color: Color(hex: "F77D8E").opacity(0.5), radius: 20, x: 0, y: 10)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(username.isEmpty || password.isEmpty || isLoading)
            .opacity(username.isEmpty || password.isEmpty ? 0.5 : 1.0)
            HStack {
                Rectangle().frame(height: 1).opacity(0.1)
                Text("O").customFont(.subheadline2).foregroundColor(.black.opacity(0.3))
                Rectangle().frame(height: 1).opacity(0.1)
            }
            Text("Registrate con tu Correo, Apple o Google")
                .customFont(.subheadline).foregroundColor(.secondary)
            HStack {
                Button(action: {
                    onSignUpTriggered()
                }){
                    Image("Envelope")
                }
                Spacer()
                Button(action: {
                    print("Go to register page with Apple Services")
                }){
                    Image("Apple")
                }
                Spacer()
                Button(action: {
                    print("Go to register page with Google Services")
                }){
                    Image("Google")
                    
                }
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(onSignUpTriggered: {}, showSignInModal: .constant(true))
    }
}
