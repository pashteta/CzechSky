//
//  BackendError.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 12.04.2022.
//

import Foundation

struct BackendError: Codable, Error {
    var status: String
    var message: String
}
