//
//  PlanesListView.swift
//  CzechSky
//
//  Created by Pavel Okhrimenko on 15.04.2022.
//

import SwiftUI

struct PlanesListView: View {
    
    enum Constants {
        static let mapAnnotationImageName = UIImage(named: "map_airpane")!

        enum Size {
            static let planeImageWidthHeight = 20.0
        }
        
        enum Fonts {
            static let countryFont = Font.system(size: 16, weight: .regular)
        }
    }
    
    @Binding var airplanePositions: [PlanePositionsModel]

    var body: some View {
        VStack {
            List(airplanePositions) { planePositions in
                HStack {
                    Image(uiImage: Constants.mapAnnotationImageName)
                        .resizable()
                        .frame(width: Constants.Size.planeImageWidthHeight,
                               height: Constants.Size.planeImageWidthHeight, alignment: .leading)
                    VStack {
                        Text(planePositions.country)
                            .font(Constants.Fonts.countryFont)
                            .foregroundColor(.black)
                    }
                }.font(.title)
            }
        }
    }
}

