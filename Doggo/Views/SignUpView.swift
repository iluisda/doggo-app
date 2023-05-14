//
//  SignUpView.swift
//  Doggo
//
//  Created by Luis Alvarez on 15/05/2023.
//

import SwiftUI
import RiveRuntime
import Amplify

struct SignUpView: View {
    @EnvironmentObject var sessionManager: SessionManager
    var onConfirmTriggered: () -> Void
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    @State var isLoading = false;
    @Binding var showSignUpModal: Bool
    @State private var resultMessage: String = ""
    @State private var showErrorToast: Bool = false
    @State private var isEmailValid: Bool = true
    
    let check = RiveViewModel(fileName: "check", stateMachineName: "State Machine 1")
    let confetti = RiveViewModel(fileName: "confetti", stateMachineName: "State Machine 1")
    
    func signUp()  {
        isLoading = true
        if email != "" || username != "" || password != "" {
            sessionManager.signUp(username: username, password: password, email: email)
                .done { result in
                    // Sign Up succeeded
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        check.triggerInput("Check")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isLoading = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        sessionManager.setAuthState(state: .confirmCode(username: username))
                        withAnimation {
                            showSignUpModal = false
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
            
            check.reset()
        }
        //        confetti.reset()
    }
    var body: some View {
        VStack(spacing: 24) {
            Text("Registrate").customFont(.largeTitle)
            Text("Muy cerca de unirte a la comunidad Doggo").customFont(.headline).overlay(
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
                Text("Usuario")
                    .customFont(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Usuario", text: $username)
                    .customTextField(image: Image(systemName: "person.fill"))
            }
            VStack(alignment: .leading) {
                Text("Correo")
                    .customFont(.subheadline)
                    .foregroundColor(.secondary)
                TextField("Correo", text: $email)
                    .customTextField(image: Image(systemName: "envelope.fill"))
                    .autocapitalization(.none)
                    .onChange(of: email) { newValue in
                        isEmailValid = Validation.isValidEmail(newValue)
                    }
                
                if !isEmailValid && email != "" {
                    Text("Please enter a valid email address.")
                        .customFont(.footnote2)
                        .foregroundColor(.red)
                        .padding(.leading)
                }
            }
            VStack(alignment: .leading) {
                Text("Contraseña")
                    .customFont(.subheadline)
                    .foregroundColor(.secondary)
                SecureField("Contraseña", text: $password)
                    .customTextField(image: Image(systemName: "key.fill"))
            }
            Button {
                signUp()
            } label: {
                Label("registrarme", systemImage: "arrow.right")
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
            .disabled(username.isEmpty && email.isEmpty && password.isEmpty || isLoading)
            .opacity(username.isEmpty || password.isEmpty ? 0.5 : 1.0)
            
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(onConfirmTriggered: {}, showSignUpModal: .constant(true))
    }
}
