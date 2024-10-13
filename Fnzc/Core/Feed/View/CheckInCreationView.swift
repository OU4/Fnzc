import SwiftUI
import UIKit
import CoreLocation

struct CheckInCreationView: View {
    @ObservedObject var viewModel: FeedViewModel
    @State private var content = ""
    @State private var selectedLocation: Location?
    @State private var isShowingLocationPicker = false
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingAuthAlert = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Location selection
                Button(action: {
                    isShowingLocationPicker = true
                }) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(selectedLocation?.name ?? "Choose a location")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .foregroundColor(.orange)
                }
                
                // Content input area
                VStack(alignment: .leading, spacing: 10) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                    }
                    
                    TextEditor(text: $content)
                        .frame(height: 100)
                        .padding(5)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    
                    HStack {
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            Image(systemName: "photo")
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        Text("\(content.count)/280")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 5)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding()
                
                Spacer()
            }
            .navigationBarTitle("Create Check-In", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Post") {
                    if viewModel.isAuthenticated {
                        if let location = selectedLocation {
                            viewModel.createCheckIn(content: content, location: location, image: selectedImage)
                            dismiss()
                        }
                    } else {
                        showingAuthAlert = true
                    }
                }
                .disabled(content.isEmpty || selectedLocation == nil)
            )
        }
        .sheet(isPresented: $isShowingLocationPicker) {
            LocationPickerView(selectedLocation: $selectedLocation)
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .alert(isPresented: $showingAuthAlert) {
            Alert(title: Text("Authentication Required"),
                  message: Text("Please sign in to create a check-in."),
                  primaryButton: .default(Text("Sign In"), action: {
                      // Navigate to sign in view
                  }),
                  secondaryButton: .cancel())
        }
    }
}

struct LocationPickerView: View {
    @Binding var selectedLocation: Location?
    @Environment(\.dismiss) var dismiss
    
    let locations = [
        Location(name: "Dhahban", details: "City", distance: "2", coordinate: CLLocationCoordinate2D(latitude: 21.7622, longitude: 39.0351)),
        Location(name: "Obhur Alshmalyyah", details: "3.5 km", distance: "7", coordinate: CLLocationCoordinate2D(latitude: 21.7589, longitude: 39.1221)),
        Location(name: "مكان عجيب", details: "1.2 km", distance: "", coordinate: CLLocationCoordinate2D(latitude: 21.7500, longitude: 39.0500)),
        Location(name: "BAE Systems", details: "300 m", distance: "", coordinate: CLLocationCoordinate2D(latitude: 21.7700, longitude: 39.0400)),
        Location(name: "Oia Beach", details: "Obhur Rd", distance: "4.9 km 3", coordinate: CLLocationCoordinate2D(latitude: 21.7800, longitude: 39.1300))
    ]

    var body: some View {
        NavigationView {
            List(locations) { location in
                Button(action: {
                    selectedLocation = location
                    dismiss()
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(location.name)
                                .font(.headline)
                            Text(location.details)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        if !location.distance.isEmpty {
                            Text(location.distance)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Choose Location")
            .navigationBarItems(leading: Button("Cancel") { dismiss() })
        }
    }
}
