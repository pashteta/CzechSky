//
//  PlaneSkyRepository.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 11.04.2022.
//

import Combine
import Alamofire

protocol PlaneRepositoryProtocol {
    func getPlanesPosition() -> AnyPublisher<DataResponse<Data, NetworkError>, Never>
}

final class PlaneRepository: PlaneRepositoryProtocol {
    func getPlanesPosition() -> AnyPublisher<DataResponse<Data, NetworkError>, Never> {
        let request = PlanePositionRequestProvider()
        
        return AF.request(request.path,
                          method: request.method)
            .validate()
            .publishData()
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
