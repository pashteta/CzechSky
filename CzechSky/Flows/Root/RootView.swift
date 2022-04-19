//
//  RootView.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 15.04.2022.
//

import SwiftUI

struct RootView: View {
    let planeComponent: PlaneOnMapComponentProtocol

    var body: some View {
        NavigationView {
            planeComponent.registerView
        }
    }
}
