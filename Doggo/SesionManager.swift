//
//  SesionManager.swift
//  Doggo
//
//  Created by Luis Alvarez on 15/05/2023.
//

import Amplify
import Combine
import Dispatch
import AWSCognitoAuthPlugin
import PromiseKit

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
    case notYet
    case splashScreen
    var stringValue: String {
        switch self {
        case .login:
            return "login"
        case .signUp:
            return "signUp"
        case .confirmCode(username: _):
            return "confirmCode"
        case .session(user: _):
            return "session"
        case .notYet:
            return "notYet"
        default: return "splashScreen"
        }
    }
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .splashScreen
    
    func getCurrentAuthUser() {
        Task{
            if let user = try? await Amplify.Auth.getCurrentUser() {
                authState = .session(user: user)
            } else {
                authState = .notYet
            }
        }
        
    }
    /**
     SIGN UP AWS COGNITO METHOD AS PROMISE
     */
    func signUp(username: String, password: String, email: String) -> Promise<String> {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        return Promise<String> { seal in
            Task {
                do {
                    let signUpResult = try await Amplify.Auth.signUp(
                        username: username,
                        password: password,
                        options: options
                    )
                    
                    if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                        print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
                        // Resolve the seal with a value or an appropriate error
                        seal.fulfill("SignUp Complete")
//                        setAuthState(state: .login)
                    } else {
                        seal.fulfill("SignUp Complete")
//                        setAuthState(state: .login)
                    }
                } catch let error as AuthError {
                    seal.reject(AuthError.unknown("An error occurred while registering a user \(error)"))
                } catch {
                    seal.reject(error)
                }
            }
        }
    }

    /**
     CONFIRM SIGN UP AWS COGNITO METHOD AS PROMISE
     */
    func confirmSignUp(for username: String, with confirmationCode: String) -> Promise<String> {
        return Promise<String> { seal in
            Task {
                do {
                    let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                        for: username,
                        confirmationCode: confirmationCode
                    )
                    seal.fulfill("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
                } catch let error as AuthError {
                    seal.reject(AuthError.unknown("An error occurred while confirming sign up \(error)"))
                }
                catch {
                    seal.reject(error)
                }
            }
        }
    }
    /**
     SIGN IN AWS COGNITO METHOD AS PROMISE
     */
    func signIn(username: String, password: String) -> Promise<String> {
        return Promise<String> { seal in
            Task {
                do {
                    let signInResult = try await Amplify.Auth.signIn(username: username, password: password)
                    if signInResult.isSignedIn {
                        seal.fulfill("Sign in succeeded")
                    } else {
                        seal.reject(AuthError.unknown("Sign in failed"))
                    }
                } catch {
                    seal.reject(error)
                }
            }
        }
    }
    /**
     SIGN OUT AWS COGNITO METHOD AS PROMISE
     */
    func signOut() -> Promise<String> {
        return Promise<String> { seal in
            Task {
                do {
                    let result = try? await Amplify.Auth.signOut(options: .init(globalSignOut: true))
                    
                    if let signOutResult = result as? AWSCognitoSignOutResult {
                        switch signOutResult {
                        case .complete:
                            seal.fulfill("Sign out succeeded")
                        default:
                            seal.reject(AuthError.unknown("Sign out failed"))
                        }
                    } else {
                        seal.reject(AuthError.unknown("Sign out failed"))
                    }
                } catch {
                    seal.reject(error)
                }
            }
        }
    }
    
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin() {
        authState = .login
    }
    
    func setAuthState(state: AuthState) {
        authState = state
    }
    
    func getAuthState() -> String {
        var getState: String = "notYet"
        switch authState {
        case .login:
            getState = "login"
        case .signUp:
            getState = "signUp"
        case .confirmCode(username: _):
            getState = "confirmCode"
        case .session(user: _):
            getState = "session"
        case .notYet:
            return "notYet"
        case .splashScreen:
            return "splashScreen"
        }
        return getState
    }
}

