//
//  ContentView.swift
//  Doggo
//
//  Created by Luis Alvarez on 13/05/2023.
//

import SwiftUI
import Amplify

struct ContentView: View {
    
    let user: AuthUser
    @AppStorage("selectedTab") var selectedTab: Tab = .chat
    var body: some View {
        ZStack {
            switch selectedTab {
            case .chat:
                Text("Chat")
            case .search:
                Text("Search")
            case .timer:
                Text("Timer")
            case .bell:
                Text("Bell")
            case .user:
                UserView(user: user)
            }
            TabBar()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    private struct DummyUser: AuthUser {
        let username: String = "hola"
        let userId: String = "1"
        let email: String = "hola@hola.com"
    }
    static var previews: some View {
        ContentView(user: DummyUser())
    }
}
