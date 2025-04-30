//
//  PlaceManager.swift
//  NearbyPlaces
//
//  Created by Mahta Moezzi on 30/04/2025.
//

import Foundation
import CoreLocation

class PlaceManager: ObservableObject {
    @Published var places: [Place] = []

    private let apiKey = "ffe08187663a4121b26c35e1791926a2" 

    func fetchNearbyPlaces(latitude: Double, longitude: Double, categories: [String]) {
        guard !categories.isEmpty else {
            print("No categories selected.")
            self.places = []
            return
        }

        let categoryString = categories.joined(separator: ",")
        let radius = 3000 // meters (you can adjust)

        let urlString = """
        https://api.geoapify.com/v2/places?categories=\(categoryString)&filter=circle:\(longitude),\(latitude),\(radius)&limit=20&apiKey=\(apiKey)
        """

        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data from Geoapify Places API.")
                return
            }

            do {
                let response = try JSONDecoder().decode(PlaceAPIResponse.self, from: data)
                let fetchedPlaces = response.features.map { feature in
                    Place(
                        name: feature.properties.name ?? "Unknown",
                        latitude: feature.geometry.coordinates[1],
                        longitude: feature.geometry.coordinates[0]
                    )
                }
                DispatchQueue.main.async {
                    self.places = fetchedPlaces
                }
            } catch {
                print("Error decoding places: \(error)")
            }
        }.resume()
    }
}

// MARK: - Geoapify Response Structs

struct PlaceAPIResponse: Codable {
    let features: [PlaceFeature]
}

struct PlaceFeature: Codable {
    let properties: PlaceProperties
    let geometry: PlaceGeometry
}

struct PlaceProperties: Codable {
    let name: String?
}

struct PlaceGeometry: Codable {
    let coordinates: [Double]
}
