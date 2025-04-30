//
//  GeocoderManager.swift
//  NearbyPlaces
//
//  Created by Mahta Moezzi on 30/04/2025.
//

import Foundation
import CoreLocation

class GeocoderManager {
    let apiKey = "ffe08187663a4121b26c35e1791926a2"
    
    func geocodeCity(_ city: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("City encoding failed.")
            completion(nil)
            return
        }

        let urlString = "https://api.geoapify.com/v1/geocode/search?text=\(encodedCity)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid geocoding URL.")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data from geocoding API.")
                completion(nil)
                return
            }

            do {
                let decoded = try JSONDecoder().decode(GeocodeResponse.self, from: data)
                if let first = decoded.features.first {
                    let lon = first.geometry.coordinates[0]
                    let lat = first.geometry.coordinates[1]
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    DispatchQueue.main.async {
                        completion(coordinate)
                    }
                } else {
                    print("No coordinates found for city.")
                    completion(nil)
                }
            } catch {
                print("Error decoding geocoding response: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

// MARK: - Response structs
struct GeocodeResponse: Codable {
    let features: [GeocodeFeature]
}

struct GeocodeFeature: Codable {
    let geometry: GeocodeGeometry
}

struct GeocodeGeometry: Codable {
    let coordinates: [Double]
}
