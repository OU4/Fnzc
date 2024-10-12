//
//  RegiesterViewModel.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//import Foundation
import Firebase
import FirebaseAuth

class RegiesterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var username = ""
    @Published var errorMessage: String?
    
    private let authService = AuthService.shared

    @MainActor
    func createUser() async {
        do {
            try await authService.createUser(
                withEmail: email,
                password: password,
                fullname: fullname,
                username: username
            )
        } catch let error as NSError {
            if error.domain == FirestoreErrorDomain && error.code == FirestoreErrorCode.permissionDenied.rawValue {
                errorMessage = "There was an issue saving your data. Please try again in a few moments."
            } else if error.domain == AuthErrorDomain {
                switch error.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    errorMessage = "This email is already in use. Please try logging in or use a different email."
                default:
                    errorMessage = error.localizedDescription
                }
            } else {
                errorMessage = "An unexpected error occurred. Please try again."
            }
            print("Detailed registration error: \(error)")
        }
    }
}
