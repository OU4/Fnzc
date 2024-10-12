//
//  PostService.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//import Firebase
import Combine
import FirebaseAuth
import FirebaseFirestore

class PostService {
    
    static func createCheckIn(place: Place, comment: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else {
                promise(.failure(NSError(domain: "PostService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
                return
            }
            
            let data: [String: Any] = [
                "uid": uid,
                "placeId": place.id,
                "placeName": place.name,
                "latitude": place.latitude,
                "longitude": place.longitude,
                "comment": comment,
                "timestamp": Timestamp()
            ]
            
            Firestore.firestore().collection("check-ins").addDocument(data: data) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
