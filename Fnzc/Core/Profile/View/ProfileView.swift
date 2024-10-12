import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingLocationAlert = false
    @State private var showingEditProfile = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with location enable message
                Text("This map is looking pretty empty. Enable location to start tracking your adventures!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Enable Location") {
                    showingLocationAlert = true
                }
                .foregroundColor(.blue)
                .alert(isPresented: $showingLocationAlert) {
                    Alert(title: Text("Enable Location"),
                          message: Text("This app needs your location to track your adventures."),
                          primaryButton: .default(Text("Enable")) {
                              // Handle location enabling
                          },
                          secondaryButton: .cancel())
                }
                
                // Profile Header
                VStack {
                                    if let profilePictureURL = viewModel.user?.profileImageUrl,
                                       let url = URL(string: profilePictureURL) {
                                        WebImage(url: url)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                    } else {
                                        ZStack {
                                            Circle()
                                                .fill(Color.orange)
                                                .frame(width: 80, height: 80)
                                            Text(String(viewModel.user?.fullname.prefix(1) ?? ""))
                                                .font(.title)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    Text(viewModel.user?.fullname ?? "")
                                        .font(.title2)
                                    Text(viewModel.user?.bio ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                        Text(viewModel.user?.location ?? "Location not set")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    
                                    Button("Edit") {
                                        showingEditProfile = true
                                    }
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .sheet(isPresented: $showingEditProfile) {
                                        EditProfileView(viewModel: viewModel)
                                    }
                                }
                
                // Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    StatView(title: "Check-ins", value: "\(viewModel.totalCheckIns)", color: .orange)
                    StatView(title: "Categories", value: "\(viewModel.categoriesVisited)/100", color: .green)
                    StatView(title: "Saved Places", value: "\(viewModel.savedPlaces)", color: .blue)
                    StatView(title: "Visited Places", value: "\(viewModel.visitedPlaces)", color: .orange)
                    StatView(title: "Streaks", value: "\(viewModel.streaks)", color: .red)
                    StatView(title: "Mayorships", value: "\(viewModel.mayorships)", color: .purple)
                }
                .padding()
                
                // Photos Section
                VStack(alignment: .leading) {
                    Text("Photos \(viewModel.photos.count)")
                        .font(.headline)
                    
                    if viewModel.photos.isEmpty {
                        Text("Nothing to see here...yet")
                            .foregroundColor(.gray)
                        Text("Add a photo to your next check-in! Future you will thank you.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        // Implement photo grid here
                    }
                }
                .padding()
                
                Button("Check in now") {
                    viewModel.checkIn(at: "Current Location")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .navigationBarItems(trailing: Button(action: {
            // Handle settings action
        }) {
            Image(systemName: "gearshape")
        })
    }
}

// Add the StatView struct here
struct StatView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}
