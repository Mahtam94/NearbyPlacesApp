//
//  ContentView.swift
//  NearbyPlaces
//
//  Created by Mahta Moezzi on 24/04/2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var cityName: String = ""
    @StateObject private var placeManager = PlaceManager()
    @State private var selectedCategories: [String] = []
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )


    //Category Toggle

    let allCategories = [
        ("🍽️ Restaurants", "catering.restaurant"),
        ("🎶 Clubs", "entertainment.dance"),
        ("☕️ Cafes", "catering.cafe"),
        ("🎬 Cinemas", "entertainment.cinema")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Enter city or area", text: $cityName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            //Category checkboxes

            Text("Select place types:")
                        .font(.headline)

                    ForEach(allCategories, id: \.1) { label, value in
                        Toggle(label, isOn: Binding(
                            get: { selectedCategories.contains(value) },
                            set: { isOn in
                                if isOn {
                                    selectedCategories.append(value)
                                } else {
                                    selectedCategories.removeAll { $0 == value }
                                }
                            }
                        ))
                    }
                    .padding(.horizontal, 24)
            //Search button
            Button(action: {
                performSearch()
            }) {
                Text("Search")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            .padding(.horizontal, 24)
            
            Spacer()
            
            
        }
        // Show map with pins
        if !placeManager.places.isEmpty {
            Map(
                coordinateRegion: $mapRegion,
                interactionModes: [.all], // Enables zoom, scroll, etc.
                annotationItems: placeManager.places
            ) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                        Text(place.name)
                            .font(.caption)
                            .padding(2)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(4)
                    }
                }
            }

            .frame(height: 400)
            .cornerRadius(10)
            .padding()
        }


    }
    func performSearch() {
        let geocoder = GeocoderManager()
        geocoder.geocodeCity(cityName) { coordinate in
            guard let coordinate = coordinate else {
                print("City not found.")
                return
            }
            
            print("City coordinates: \(coordinate.latitude), \(coordinate.longitude)")
            mapRegion = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )

            placeManager.fetchNearbyPlaces(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude,
                        categories: selectedCategories
                    )
            
        }
    }
    
}
