//
//  RootComponent.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 15.04.2022.
//

import NeedleFoundation
import SwiftUI

final class RootComponent: BootstrapComponent {
    var rootView: some View {
        RootView(planeComponent: planeComponent)
    }
    
    var planeComponent: PlaneOnMapComponent {
        PlaneOnMapComponent(parent: self)
    }
}

