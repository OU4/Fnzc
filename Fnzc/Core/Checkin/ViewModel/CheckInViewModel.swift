////
////  CheckInViewModel.swift
////  Fnzc
////
////  Created by Abdulaziz dot on 13/10/2024.
////
//
//import SwiftUI
//import Combine
//
//class CheckInViewModel: ObservableObject {
//    @Published var selectedPlace: Place?
//    @Published var alertItem: AlertItem?
//    private var cancellables = Set<AnyCancellable>()
//    
//    func createCheckIn(comment: String) {
//        guard let place = selectedPlace else { return }
//        
//        PostService.createCheckIn(place: place, comment: comment)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    self.alertItem = AlertItem(title: Text("Success"), message: Text("You've checked in at \(place.name)!"))
//                case .failure(let error):
//                    self.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription))
//                }
//            } receiveValue: { _ in }
//            .store(in: &cancellables)
//    }
//}
