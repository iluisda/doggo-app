//
//  PopoverNotificationManager.swift
//  Doggo
//
//  Created by Luis Alvarez on 18/05/2023.
//

import SwiftUI

class PopoverNotificationManager: ObservableObject {
    @Published var isShowing: Bool = false
    @Published var message: String = ""
    
    static let shared = PopoverNotificationManager()
    
    static func showNotification(message: String) {
        shared.message = message
        shared.isShowing = true
    }
}

