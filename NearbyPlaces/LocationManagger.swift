//
//  LocationManagger.swift
//  NearbyPlaces
//
//  Created by Mahta Moezzi on 25/04/2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
           super.init()
           manager.delegate = self
           manager.desiredAccuracy = kCLLocationAccuracyBest
           manager.requestWhenInUseAuthorization()
           manager.startUpdatingLocation()
       }
       
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.first else { return }
           DispatchQueue.main.async {
               self.userLocation = location.coordinate
           }
       }
}

class PlaceManager: ObservableObject {
    @Published var places: [Place] = []
    
    private let apiKey = "ABC123" // Paste your real Geoapify API key here
    
    func fetchNearbyPlaces(latitude: Double, longitude: Double) {
        let radius = 2000 // meters (2 km)
        
        let urlString = "https://api.geoapify.com/v2/places?categories=food&filter=circle:\(longitude),\(latitude),\(radius)&limit=20&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let geoapifyResponse = try JSONDecoder().decode(GeoapifyResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.places = geoapifyResponse.features.map { feature in
                            Place(name: feature.properties.name ?? "Unknown",
                                  latitude: feature.geometry.coordinates[1],
                                  longitude: feature.geometry.coordinates[0])
                        }
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
}

// MARK: - Helper structs to match Geoapify JSON

struct GeoapifyResponse: Decodable {
    let features: [Feature]
}

struct Feature: Decodable {
    let properties: Properties
    let geometry: Geometry
}

struct Properties: Decodable {
    let name: String?
}

struct Geometry: Decodable {
    let coordinates: [Double]
}
