//
//  Location.swift
//  Fnzc
//
//  Created by Abdulaziz dot on 13/10/2024.
//
import Foundation
import CoreLocation

struct Location: Identifiable, Codable {
    let id: UUID
    let name: String
    let details: String
    let distance: String
    let coordinate: CLLocationCoordinate2D
    
    enum CodingKeys: String, CodingKey {
        case id, name, details, distance
        case latitude, longitude
    }
    
    init(id: UUID = UUID(), name: String, details: String, distance: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.details = details
        self.distance = distance
        self.coordinate = coordinate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        details = try container.decode(String.self, forKey: .details)
        distance = try container.decode(String.self, forKey: .distance)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(details, forKey: .details)
        try container.encode(distance, forKey: .distance)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}
