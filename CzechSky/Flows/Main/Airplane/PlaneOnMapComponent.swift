//
//  PlaneOnMapComponent .swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 15.04.2022.
//

import NeedleFoundation
import SwiftUI

protocol PlaneOnMapComponentProtocol {
    var registerView: AnyView { get }
}

final class PlaneOnMapComponent: Component<EmptyDependency>, PlaneOnMapComponentProtocol {
    var homeViewModel: PlaneOnMapViewModel {
        PlaneOnMapViewModel(airplaneRequestDomain: PlaneRepository(),
                                  domainModel: PlaneDomainModel(airplanePositionsRepository: PlaneRepository()))
    }

    var registerView: AnyView {
        AnyView(
            PlaneOnMapView(
                viewModel: self.homeViewModel
            )
        )
    }
}
