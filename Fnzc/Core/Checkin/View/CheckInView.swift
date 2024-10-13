//
//  CheckInView.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 13/10/2024.
//import FirebaseFirestoreSwift

import FirebaseFirestore

struct CheckIn: Identifiable, Codable {
    @DocumentID var id: String?
    let uid: String
    let placeId: String
    let placeName: String
    let latitude: Double
    let longitude: Double
    let comment: String
    let timestamp: Timestamp
    var imageURL: String?
    
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case placeId
        case placeName
        case latitude
        case longitude
        case comment
        case timestamp
        case imageURL
    }
}
