//
//  Place.swift
//  NearbyPlaces
//
//  Created by Mahta Moezzi on 27/04/2025.
//

import Foundation
import CoreLocation

struct Place: Identifiable, Decodable {
    var id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
