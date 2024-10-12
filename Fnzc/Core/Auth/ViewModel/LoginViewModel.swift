//
//  LoginViewModel.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//
import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    private let authService = AuthService.shared

    @MainActor
    func login() async throws {
        try await authService.login(withEmail: email, password: password)
    }
}
