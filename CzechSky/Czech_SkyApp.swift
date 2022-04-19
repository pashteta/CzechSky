//
//  Czech_SkyApp.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 11.04.2022.
//

import SwiftUI
import NeedleFoundation

@main
struct Czech_SkyApp: App {
        
    init() {
        registerProviderFactories()
    }

    var body: some Scene {
        WindowGroup {
            RootComponent().rootView
        }
    }
}

