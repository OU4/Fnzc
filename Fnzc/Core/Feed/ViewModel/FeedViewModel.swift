//
//  FeedViewModel.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//

import Foundation

class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private let postService = PostService.shared
    
    func fetchPosts() async {
        do {
            self.posts = try await postService.fetchPosts()
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
}
