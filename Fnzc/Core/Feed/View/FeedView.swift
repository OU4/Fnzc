//
//  FeedView.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        List(viewModel.posts) { post in
            VStack(alignment: .leading) {
                Text(post.authorName)
                    .font(.headline)
                Text(post.content)
                Text(post.locationName)
                    .font(.caption)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchPosts()
            }
        }
    }
}
