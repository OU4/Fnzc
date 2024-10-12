//
//  ProfileViewModel.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//import Foundation
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var totalCheckIns: Int = 0
    @Published var categoriesVisited: Int = 0
    @Published var savedPlaces: Int = 0
    @Published var visitedPlaces: Int = 0
    @Published var streaks: Int = 0
    @Published var mayorships: Int = 0
    @Published var photos: [String] = []

    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()

    
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
                    bio: data["bio"] as? String ?? "",
                    location: data["location"] as? String ?? "Location not set"
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

    
    func updateProfile(fullname: String, bio: String, location: String, profileImageUrl: String? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var updatedData: [String: Any] = [
            "fullname": fullname,
            "bio": bio.isEmpty ? "No bio yet!" : bio,
            "location": location
        ]
        
        if let profileImageUrl = profileImageUrl {
            updatedData["profileImageUrl"] = profileImageUrl
        }
        
        db.collection("users").document(uid).updateData(updatedData) { [weak self] error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                self?.user?.fullname = fullname
                self?.user?.bio = bio.isEmpty ? "No bio yet!" : bio
                self?.user?.location = location
                if let profileImageUrl = profileImageUrl {
                    self?.user?.profileImageUrl = profileImageUrl
                }
                self?.objectWillChange.send()
            }
        }
    }
    
    func updateProfileImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "ProfileViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
            print("Error: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            let error = NSError(domain: "ProfileViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
            print("Error: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        let imagePath = "profile_images/\(uid)/profile.jpg"
        let imageRef = storage.child(imagePath)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        print("Attempting to upload image to path: \(imagePath)")
        
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            print("Image uploaded successfully. Fetching download URL...")
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(.failure(error))
                } else if let url = url {
                    print("Successfully retrieved download URL: \(url.absoluteString)")
                    completion(.success(url.absoluteString))
                } else {
                    let error = NSError(domain: "ProfileViewModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
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
