//
//  FeedView.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//
import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.checkIns) { checkIn in
                CheckInRowView(checkIn: checkIn)
            }
            .navigationTitle("Feed")
            .refreshable {
                viewModel.fetchCheckIns()
            }
        }
    }
}

struct CheckInRowView: View {
    let checkIn: CheckIn
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(checkIn.placeName)
                .font(.headline)
            Text(checkIn.comment)
                .font(.subheadline)
            Text(checkIn.timestamp.dateValue(), style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
