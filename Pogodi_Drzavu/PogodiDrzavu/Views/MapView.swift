//
//  MapView.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 07.05.2024..
//

import SwiftUI
import GoogleMaps
import FirebaseStorage

struct MapView: UIViewRepresentable {
    @StateObject var viewModel: MapViewModel

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        viewModel.applyCustomMapStyle(mapView)
        viewModel.loadGeoJsonData(mapView)
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
    }
}

#Preview {
    MapView(viewModel: MapViewModel(country: "italy", continent: "Europa"))
}
