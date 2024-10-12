//
//  FnzcApp.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//
import SwiftUI
import Firebase

@main
struct FnzcApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
