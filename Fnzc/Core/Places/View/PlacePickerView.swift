//
//  PlacePickerView.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 13/10/2024.
////
//import SwiftUI
//
//struct PlacePickerView: View {
//    @Binding var selectedPlace: Place?
//    @StateObject private var viewModel = PlacePickerViewModel()
//    @State private var searchText = ""
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        NavigationView {
//            List(viewModel.places) { place in
//                Button(action: {
//                    selectedPlace = place
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    Text(place.name)
//                }
//            }
//            .searchable(text: $searchText)
//            .onChange(of: searchText) { _ in
//                viewModel.searchPlaces(query: searchText)
//            }
//            .navigationTitle("Select a Place")
//            .navigationBarItems(trailing: Button("Cancel") {
//                presentationMode.wrappedValue.dismiss()
//            })
//        }
//    }
//}
