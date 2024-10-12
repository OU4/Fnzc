//
//  AuthViewModel.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//import Firebase
import Firebase
import FirebaseAuth
import Foundation

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    private let authService = AuthService.shared
    
    init() {
        self.currentUser = nil
        if let firebaseUser = Auth.auth().currentUser {
            self.currentUser = User(firebaseUser: firebaseUser)
        }
        print("Debug: Current user in AuthViewModel init: \(self.currentUser?.id ?? "nil")")
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        try await authService.login(withEmail: email, password: password)
        if let firebaseUser = Auth.auth().currentUser {
            self.currentUser = User(firebaseUser: firebaseUser)
        }
        print("Debug: User logged in, currentUser updated: \(self.currentUser?.id ?? "nil")")
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String) async throws {
        try await authService.createUser(withEmail: email, password: password, fullname: fullname, username: username)
        if let firebaseUser = Auth.auth().currentUser {
            self.currentUser = User(firebaseUser: firebaseUser)
        }
        print("Debug: User created, currentUser updated: \(self.currentUser?.id ?? "nil")")
    }
    
    func signOut() {
        authService.signOut()
        self.currentUser = nil
        print("Debug: User signed out, currentUser set to nil")
    }
}
