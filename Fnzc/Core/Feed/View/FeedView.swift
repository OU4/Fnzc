import SwiftUI
import MapKit
import Firebase

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var searchText = ""
    @State private var showingProfile = false
    @State private var showingPostCreation = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3352, longitude: -122.0096),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top bar with search
                HStack {
                    Button(action: { showingProfile = true }) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 30, height: 30)
                            .overlay(Text("A").foregroundColor(.orange))
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(8)
                    
                    Image(systemName: "bell")
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.top, 50)
                .padding(.bottom, 10)
                .background(Color.orange)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        // Map view
                        ZStack(alignment: .bottomTrailing) {
                            Map(coordinateRegion: $region)
                                .frame(height: 200)
                            
                            Text("Apple Maps")
                                .font(.caption)
                                .padding(4)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(4)
                                .padding(8)
                        }
                        
                        // Statistics
                        HStack(spacing: 0) {
                            FeedStatView(title: "Visited", value: "\(viewModel.checkIns.count)")
                            FeedStatView(title: "Saved", value: "0")
                            FeedStatView(title: "Categories", value: "0/100")
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        
                        // Check-ins header
                        Text("\(viewModel.checkIns.count) Check-in")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Check-ins list
                        ForEach(viewModel.checkIns) { checkIn in
                            CheckInView(checkIn: checkIn)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.fetchCheckIns()
            }
            .sheet(isPresented: $showingProfile) {
                Text("Profile View") // Replace with your actual ProfileView when implemented
            }
            .sheet(isPresented: $showingPostCreation) {
                CheckInCreationView(viewModel: viewModel)
            }
            .navigationBarItems(trailing: Button(action: {
                showingPostCreation = true
            }) {
                Image(systemName: "square.and.pencil")
            })
        }
    }
}

struct FeedStatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white)
    }
}

struct CheckInView: View {
    let checkIn: CheckIn
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Circle()
                .fill(Color.orange)
                .frame(width: 50, height: 50)
                .overlay(Image(systemName: "building.2").foregroundColor(.white))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(checkIn.placeName)
                    .font(.headline)
                Text("Saudi Arabia")
                    .font(.subheadline)
                    .foregroundColor(.gray)
              
                Text(checkIn.timestamp.dateValue(), style: .time)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if !checkIn.comment.isEmpty {
                    Text(checkIn.comment)
                        .padding(.top, 5)
                }
            }
        }
        .padding(.vertical, 10)
    }
}

