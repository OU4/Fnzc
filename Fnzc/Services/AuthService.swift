//
//  AuthService.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//import Firebase
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    private init(){
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        self.userSession = result.user
        print("Debug: Logged in user \(result.user.uid)")
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String) async throws {
        do {
            // First, create the user in Firebase Authentication
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            print("Debug: Created user in Authentication \(result.user.uid)")
            
            // Check if a user document already exists in Firestore
            let db = Firestore.firestore()
            let userDoc = try await db.collection("users").document(result.user.uid).getDocument()
            
            if !userDoc.exists {
                // If the document doesn't exist, create it
                let userData = [
                    "email": email,
                    "username": username,
                    "fullname": fullname,
                    "uid": result.user.uid
                ]
                
                try await db.collection("users").document(result.user.uid).setData(userData)
                print("Debug: Created user document in Firestore for \(result.user.uid)")
            } else {
                print("Debug: User document already exists in Firestore for \(result.user.uid)")
            }
        } catch {
            print("Debug: Failed to create a user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            print("Debug: User signed out successfully")
        } catch {
            print("Debug: Failed to sign out with error \(error.localizedDescription)")
        }
    }
}
