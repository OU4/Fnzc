//
//  Location.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 12/10/2024.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Codable {
    let id: String
    let name: String
    let category: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
