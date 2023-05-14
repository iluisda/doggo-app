//
//  OnboardingView.swift
//  Doggo
//
//  Created by Luis Alvarez on 13/05/2023.
//

import SwiftUI
import RiveRuntime

struct OnboardingView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State var showSignInModal = false
    @State var showSignUpModal = false
    @State var showConfirmModal = false
    let username: String
    let button = RiveViewModel(fileName: "button")
    //    @ObservedObject var notificationManager = PopoverNotificationManager.shared
    var body: some View {
        ZStack {
            background
            content
                .offset(y: showSignInModal || showSignUpModal || showConfirmModal ? -10 : 0)
            Color("Shadow").opacity(showSignInModal || showSignUpModal ? 0.4 : 0)
                .ignoresSafeArea()
            if showSignInModal || sessionManager.getAuthState() == "login" {
                SignInView(onSignUpTriggered: {
                    withAnimation(.spring()) {
                        showSignInModal = false
                        sessionManager.setAuthState(state: .notYet)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            showSignUpModal = true
                            sessionManager.setAuthState(state: .signUp)
                        }
                    }
                    
                }, showSignInModal: $showSignInModal)
                .transition(.move(edge: .top).combined(with: .opacity))
                .overlay(
                    Button {
                        withAnimation(.spring()) {
                            showSignInModal = false
                            sessionManager.setAuthState(state: .notYet)
                        }
                        button.reset()
                    } label: {
                        Image(systemName: "xmark")
                            .frame(width: 36, height: 36)
                            .foregroundColor(.black)
                            .background(.white)
                            .mask(Circle())
                            .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                )
                .zIndex(1)
            }
            if showSignUpModal || sessionManager.getAuthState() == "signUp"  {
                SignUpView(onConfirmTriggered: {
                    withAnimation(.spring()) {
                        showSignUpModal = false
                        sessionManager.setAuthState(state: .notYet)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        withAnimation {
                            showConfirmModal = true
                            sessionManager.setAuthState(state: .confirmCode(username: ""))
                        }
                    }
                    
                },showSignUpModal: $showSignUpModal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .overlay(
                    Button {
                        withAnimation(.spring()) {
                            showSignUpModal = false
                            sessionManager.setAuthState(state: .notYet)
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .frame(width: 36, height: 36)
                            .foregroundColor(.black)
                            .background(.white)
                            .mask(Circle())
                            .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                )
                .zIndex(1)
            }
            if showConfirmModal || sessionManager.getAuthState() == "confirmCode"  {
                ConfirmUserView(onSignInTriggered: {
                    withAnimation(.easeIn) {
                        showConfirmModal = false
                        sessionManager.setAuthState(state: .notYet)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        withAnimation {
                            showSignInModal = true
                            sessionManager.setAuthState(state: .login)
                        }
                    }
                    
                },showConfirmModal: $showConfirmModal, username: username)
            }
        }
    }
    var content: some View {
        ZStack {
            background
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                HStack {
                    Text("Un Paseo Distinto").foregroundColor(.white).font(.custom("Poppins Bold", size: 60, relativeTo: .largeTitle))
                        .opacity(0.8)
                        .frame(width: 260, alignment: .leading)
                }
                Text("Dale paseos especiales, busquemos juntos donde podemos ir a jugar.").foregroundColor(.white).customFont(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                button.view()
                    .frame(width: 236, height: 64)
                    .overlay(
                        Label("Vamos a pasear?", systemImage: "arrow.forward")
                            .offset(x: 4, y: 4)
                            .font(.headline)
                    )
                    .background(
                        Color.black
                            .cornerRadius(30)
                            .blur(radius: 10)
                            .opacity(0.3)
                            .offset(y: 10)
                    )
                    .onTapGesture  {
                        try? button.play(animationName: "active")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation(.spring()) {
                                showSignInModal = true
                            }
                        }
                    }
            }
            .padding(20)
            .padding(.top, 20)
        }
        //        .popover(isPresented: $notificationManager.isShowing, content: {
        //            PopoverNotificationView(isShowing: $notificationManager.isShowing, message: notificationManager.message)
        //        })
        
    }
    var background: some View {
        RiveViewModel(fileName: "shapes").view()
            .ignoresSafeArea()
            .blur(radius: 30)
            .background(
                Image("holly")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
            )
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        OnboardingView(username: "iluisda")
//    }
//}
