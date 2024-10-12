//
//  PostService.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//

import Firebase

class PostService {
    static let shared = PostService()
    private init() {}
    
    func fetchPosts() async throws -> [Post] {
        let snapshot = try await Firestore.firestore().collection("posts").order(by: "timestamp", descending: true).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Post.self) }
    }
    
    func createPost(_ post: Post) async throws {
        try await Firestore.firestore().collection("posts").addDocument(from: post)
    }
}
