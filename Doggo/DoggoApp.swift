//
//  DoggoApp.swift
//  Doggo
//
//  Created by Luis Alvarez on 13/05/2023.
//
import Amplify
import AWSCognitoAuthPlugin

import SwiftUI

@main
struct DoggoApp: App {
    
    @ObservedObject var sessionManager = SessionManager()    
    /**
     Configure Amplify
     */
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .login:
                OnboardingView(username: "")
                    .environmentObject(sessionManager)
            case .signUp:
                OnboardingView(username: "")
                    .environmentObject(sessionManager)
            case .confirmCode(let username):
                OnboardingView(username: username)
                    .environmentObject(sessionManager)
            case .session(user: let user):
                ContentView(user: user)
                    .environmentObject(sessionManager)
            case .notYet:
                OnboardingView(username: "")
                    .environmentObject(sessionManager)
            default:
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                sessionManager.getCurrentAuthUser()
                            }
                        }
                    }
            }
        }
    }
    
    private func configureAmplify () {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured successfully")
        } catch {
            print("could not initialize Amplify", error)
        }
    }
}
