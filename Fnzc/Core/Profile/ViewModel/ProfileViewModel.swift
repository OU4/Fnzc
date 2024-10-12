//
//  ProfileViewModel.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//import Foundation
import Foundation
import Firebase
import FirebaseAuth
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var totalCheckIns: Int = 0
    @Published var categoriesVisited: Int = 0
    @Published var savedPlaces: Int = 0
    @Published var visitedPlaces: Int = 0
    @Published var streaks: Int = 0
    @Published var mayorships: Int = 0
    @Published var photos: [String] = []  // Array of photo URLs
    
    private let db = Firestore.firestore()
    
    init() {
        fetchProfileData()
    }

    func fetchProfileData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No authenticated user")
            return
        }
        
        db.collection("users").document(uid).getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists else {
                print("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let data = document.data() {
                self.user = User(
                    id: uid,
                    email: data["email"] as? String ?? "",
                    username: data["username"] as? String ?? "",
                    fullname: data["fullname"] as? String ?? "",
                    profileImageUrl: data["profileImageUrl"] as? String,
                    bio: data["bio"] as? String ?? ""
                )
                
                self.totalCheckIns = data["totalCheckIns"] as? Int ?? 0
                self.categoriesVisited = data["categoriesVisited"] as? Int ?? 0
                self.savedPlaces = data["savedPlaces"] as? Int ?? 0
                self.visitedPlaces = data["visitedPlaces"] as? Int ?? 0
                self.streaks = data["streaks"] as? Int ?? 0
                self.mayorships = data["mayorships"] as? Int ?? 0
                self.photos = data["photos"] as? [String] ?? []
            }
        }
    }

    func updateProfile(username: String, bio: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).updateData([
            "username": username,
            "bio": bio
        ]) { [weak self] error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                self?.user?.username = username
                self?.user?.bio = bio
            }
        }
    }

    func checkIn(at place: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).updateData([
            "totalCheckIns": FieldValue.increment(Int64(1)),
            "visitedPlaces": FieldValue.increment(Int64(1))
        ]) { [weak self] error in
            if let error = error {
                print("Error updating check-in: \(error.localizedDescription)")
            } else {
                self?.totalCheckIns += 1
                self?.visitedPlaces += 1
            }
        }
        
        // Add check-in to user's history
        db.collection("users").document(uid).collection("checkIns").addDocument(data: [
            "place": place,
            "timestamp": FieldValue.serverTimestamp()
        ])
    }
}
