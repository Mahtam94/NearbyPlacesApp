//
//  ContentView.swift
//  NearbyPlaces
//
//  Created by Mahta Moezzi on 24/04/2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var placeManager = PlaceManager()
    
    struct UserLocation: Identifiable {
        var id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    
    var body: some View {
        VStack {
            if let location = locationManager.userLocation {
                
                //When we get location, fetch nearby places
                Map(coordinateRegion: .constant(
                    MKCoordinateRegion(
                        center: location,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                ), annotationItems: placeManager.places) { loc in
                    MapAnnotation(coordinate: loc.coordinate) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                            Text(loc.name)
                                .font(.caption)
                                .fixedSize()
                        }
                    }
                }
                .frame(height: 400)


                .onAppear {
                    placeManager.fetchNearbyPlaces(latitude: location.latitude, longitude: location.longitude)
                }
                
            } else {
                ProgressView("Getting your location...")
            }
        }
        .padding()
    }
}
