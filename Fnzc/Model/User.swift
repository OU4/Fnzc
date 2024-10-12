//
//  User.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//
import FirebaseAuth

struct User: Identifiable, Codable {
    let id: String
    let email: String
    var username: String
    var fullname: String
    var profileImageUrl: String?
    var bio: String
    var location: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case fullname
        case profileImageUrl
        case bio
        case location
    }
    
    init(firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.username = firebaseUser.displayName ?? ""
        self.fullname = ""  // Firebase doesn't store fullname by default
        self.profileImageUrl = firebaseUser.photoURL?.absoluteString
        self.bio = ""
        self.location = ""
    }
    
    init(id: String, email: String, username: String, fullname: String, profileImageUrl: String? = nil, bio: String = "", location: String = "") {
        self.id = id
        self.email = email
        self.username = username
        self.fullname = fullname
        self.profileImageUrl = profileImageUrl
        self.bio = bio
        self.location = location
    }
}
