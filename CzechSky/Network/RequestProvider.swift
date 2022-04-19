//
//  RequestProvider.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 11.04.2022.
//

import Alamofire

public protocol RequestProvider {
    var baseUrl: String? { get set }

    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoder { get }
}

public extension RequestProvider {
    var method: HTTPMethod {
        .get
    }

    var encoding: ParameterEncoder {
        URLEncodedFormParameterEncoder.default
    }
}
