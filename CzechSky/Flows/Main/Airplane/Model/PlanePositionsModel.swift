//
//  PlanePositionsModel.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 14.04.2022.
//

import MapKit
import SwiftUI

struct PlanePositionsModel: Identifiable {
    var id = UUID()
    var latitude: Double
    var longitude: Double
    var trueTrack: Double
    var country: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
    
    enum PlaneInfoPositionsEnum: Int {
        case originCountry = 2
        case latitude = 5
        case longitude = 6
        case trueTrack = 10
    }
}
