//
//  Post.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//

import Foundation
import FirebaseFirestore

struct Post: Codable, Identifiable {
    @DocumentID var id: String?
    let authorID: String
    let authorName: String
    let content: String
    let timestamp: Date
    let locationName: String
    let locationDetails: String
    var likes: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case authorID
        case authorName
        case content
        case timestamp
        case locationName
        case locationDetails
        case likes
    }
}
