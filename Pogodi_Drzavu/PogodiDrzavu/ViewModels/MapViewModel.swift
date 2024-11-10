//
//  MapViewModel.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 10.05.2024..
//
import SwiftUI
import GoogleMaps


class MapViewModel: ObservableObject {
    
        let country: String
        let continent: String
        private let firebaseStorageService = FirebaseStorageService()
    
        init(country: String, continent: String) {
            self.country = country
            self.continent = continent
        }
    
    func loadGeoJsonData(_ mapView: GMSMapView) {
            firebaseStorageService.fetchGeoJsonData(continent: continent, country: country) { 
                result in
                switch result {
                case .success(let data):
                    self.parseAndDisplayGeoJson(data, on: mapView)
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }
        }

    func parseAndDisplayGeoJson(_ data: Data, on mapView: GMSMapView) {
        let path = GMSMutablePath()
        var minLatitude: Double = Double.greatestFiniteMagnitude
        var maxLatitude: Double = -Double.greatestFiniteMagnitude
        var minLongitude: Double = Double.greatestFiniteMagnitude
        var maxLongitude: Double = -Double.greatestFiniteMagnitude

        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let features = jsonObject["features"] as? [[String: Any]] {
            for feature in features {
                guard let geometry = feature["geometry"] as? [String: Any],
                      let coordinates = geometry["coordinates"] as? [[[Double]]] else { continue }

                for polygon in coordinates {
                    for coordinate in polygon {
                        let latitude = coordinate[1]
                        let longitude = coordinate[0]
                        path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                        
                        minLatitude = min(minLatitude, latitude)
                        maxLatitude = max(maxLatitude, latitude)
                        minLongitude = min(minLongitude, longitude)
                        maxLongitude = max(maxLongitude, longitude)
                    }

                    let polygonView = GMSPolygon(path: path)
                    polygonView.fillColor = UIColor(red: 0.4, green: 0.3, blue: 0.7, alpha: 0.5)
                    polygonView.strokeColor = .black
                    polygonView.strokeWidth = 3.0
                    polygonView.map = mapView

                    path.removeAllCoordinates()
                }
            }

            if minLatitude <= maxLatitude, minLongitude <= maxLongitude {
                let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: minLatitude, longitude: minLongitude),
                                                 coordinate: CLLocationCoordinate2D(latitude: maxLatitude, longitude: maxLongitude))
                let update = GMSCameraUpdate.fit(bounds, withPadding: 250)
                
                mapView.animate(with: update)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let minimumZoomLevel: Float = 7.0
                    let maximumZoomLevel: Float = 5.0
                    if mapView.camera.zoom < maximumZoomLevel {return}
                    else if mapView.camera.zoom > minimumZoomLevel {
                        mapView.animate(toZoom: minimumZoomLevel)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.gradualZoomOut(mapView, currentStep: 0, maxSteps: 40)
                        }
                    }else{self.gradualZoomOut(mapView, currentStep: 0, maxSteps: 40)}
                }
                
            }
        }
    }
    
    private func gradualZoomOut(_ mapView: GMSMapView, currentStep: Int, maxSteps: Int) {
            guard currentStep < maxSteps else { return }

        let newZoomLevel = mapView.camera.zoom - 0.1
            mapView.animate(toZoom: newZoomLevel)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.gradualZoomOut(mapView, currentStep: currentStep + 1, maxSteps: maxSteps)
            }
        }
    
    func applyCustomMapStyle(_ mapView: GMSMapView) {
        if let styleURL = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
            do {
                try mapView.mapStyle = GMSMapStyle(contentsOfFileURL: styleURL)
            } catch {
                print("Failed to load map style: \(error)")
            }
        }
    }
}
