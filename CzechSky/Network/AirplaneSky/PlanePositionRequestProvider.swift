//
//  PlanePositionRequestProvider.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 11.04.2022.
//

import Alamofire

struct PlanePositionRequestProvider: RequestProvider {
    var baseUrl: String?
    
    var path: String {
        "https://opensky-network.org/api/states/all?lamin=48.55&lomin=12.9&lamax=51.06&lomax=18.87"
    }

    var method: HTTPMethod {
        .get
    }

    var encoding: ParameterEncoder {
        JSONParameterEncoder.default
    }
}
