//
//  NetworkError.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 12.04.2022.
//

import Alamofire

struct NetworkError: Error {
    let initialError: AFError
    let backendError: BackendError?
}
