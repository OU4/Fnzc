//
//  SwarmView.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//
//
//import SwiftUI
//import MapKit
//
//struct SwarmView: View {
//    @StateObject private var viewModel = SwarmViewModel()
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 37.3352, longitude: -122.0096),
//        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//    )
//    
//    var body: some View {
//        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: viewModel.nearbyPlaces) { place in
//            MapAnnotation(coordinate: place.coordinate) {
//                Image(systemName: "mappin")
//                    .foregroundColor(.red)
//            }
//        }
//        .edgesIgnoringSafeArea(.all)
//        .onAppear {
//            viewModel.fetchNearbyPlaces()
//        }
//    }
//}
