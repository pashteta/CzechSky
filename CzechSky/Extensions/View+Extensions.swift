//
//  View+Extensions.swift
//  CzechSky
//
//  Created by Pavel Okhrimenko on 15.04.2022.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}
