//
//  FeedViewModel.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//
import Firebase

class FeedViewModel: ObservableObject {
    @Published var checkIns = [CheckIn]()
    
    init() {
        fetchCheckIns()
    }
    
    func fetchCheckIns() {
        Firestore.firestore().collection("check-ins")
            .order(by: "timestamp", descending: true)
            .limit(to: 50)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self.checkIns = documents.compactMap({ try? $0.data(as: CheckIn.self) })
            }
    }
}

struct CheckIn: Identifiable, Codable {
    let id: String
    let uid: String
    let placeId: String
    let placeName: String
    let latitude: Double
    let longitude: Double
    let comment: String
    let timestamp: Timestamp
    
    var user: User?
}
