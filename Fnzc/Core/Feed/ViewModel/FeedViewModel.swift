//
//  FeedViewModel.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//
// ViewModelimport SwiftUI
import SwiftUI
import Combine
import Firebase
import FirebaseStorage
import CoreLocation
import FirebaseAuth
import SwiftUI
import Combine
import Firebase
import FirebaseStorage
import CoreLocation

class FeedViewModel: ObservableObject {
    @Published var checkIns: [CheckIn] = []
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        checkAuthenticationStatus()
    }
    
    private func checkAuthenticationStatus() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
                if let userId = user?.uid {
                    self?.fetchUserData(userId: userId)
                } else {
                    self?.currentUser = nil
                }
            }
        }
    }
    
    private func fetchUserData(userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User document does not exist")
                return
            }
            
            do {
                let user = try document.data(as: User.self)
                DispatchQueue.main.async {
                    self?.currentUser = user
                }
            } catch {
                print("Error decoding user data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchCheckIns() {
        db.collection("check-ins").order(by: "timestamp", descending: true).addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self?.checkIns = documents.compactMap { queryDocumentSnapshot -> CheckIn? in
                return try? queryDocumentSnapshot.data(as: CheckIn.self)
            }
        }
    }
    
    func createCheckIn(content: String, location: Location, image: UIImage?) {
        guard isAuthenticated, let userId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }
        
        var checkIn = CheckIn(
            id: nil,
            uid: userId,
            placeId: location.id.uuidString,
            placeName: location.name,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            comment: content,
            timestamp: Timestamp()
        )
        
        if let image = image {
            uploadImage(image) { url in
                checkIn.imageURL = url
                self.saveCheckIn(checkIn)
            }
        } else {
            saveCheckIn(checkIn)
        }
    }
    
    private func saveCheckIn(_ checkIn: CheckIn) {
        do {
            _ = try db.collection("check-ins").addDocument(from: checkIn)
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        let imageName = UUID().uuidString
        let imageRef = storage.reference().child("check-in-images/\(imageName).jpg")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            imageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                
                completion(downloadURL.absoluteString)
            }
        }
    }
}
