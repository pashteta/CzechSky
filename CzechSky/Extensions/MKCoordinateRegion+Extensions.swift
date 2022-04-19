//
//  MKCoordinateRegion+Extensions.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 14.04.2022.
//

import MapKit

public extension MKCoordinateRegion {
    enum Constants {
        static let latitude = 49.8038
        static let longitude = 15.4749
        static let latitudeDelta = 1.5
        static let longitudeDelta = 2.0
    }
    
    static func getCzechRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Constants.latitude,
                                                          longitude: Constants.longitude),
                           span: MKCoordinateSpan(latitudeDelta: Constants.latitudeDelta,
                                                  longitudeDelta: Constants.longitudeDelta)
        )
    }
}
