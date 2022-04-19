//
//  PlaneSkyDomainModel.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 11.04.2022.
//

import Combine
import UIKit

enum PlaneDomainModelError: Error {
    case removeItemFailed(Error)
}

final class PlaneDomainModel {

    // MARK: - Output
    
    @Published private(set) var isDataLoading: Bool = false
    
    var airplanePositions: AnyPublisher<Data, Never> {
        return airplanePositionsRelay.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<PlaneDomainModelError, Never> {
        return errorRelay.eraseToAnyPublisher()
    }
    
    private(set) lazy var onViewWillAppear = Subscribers.MergeSink<Bool> { [weak self] isInitialAppear in
        self?.loadIntialData()
    }
    
    // MARK: - Stored properties
    
    private var airplanePositionsRepository: PlaneRepositoryProtocol
    private var cancellableBag = Set<AnyCancellable>()
    
    // MARK: Relays
    
    private let airplanePositionsRelay = PassthroughSubject<Data, Never>()
    private let errorRelay = PassthroughSubject<PlaneDomainModelError, Never>()
    
    init(airplanePositionsRepository: PlaneRepositoryProtocol) {
        self.airplanePositionsRepository = airplanePositionsRepository
    }
}

// MARK: - AirplaneSkyDomainModel Extensions -

private extension PlaneDomainModel {
    func loadIntialData() {
        isDataLoading = true
        
        airplanePositionsRepository.getPlanesPosition()
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isDataLoading = false
                
                if case .failure(let error) = completion {
                    self.errorRelay.send(.removeItemFailed(error))
                }
            } receiveValue: { [weak self] cartModel in
                guard let self = self else { return }
                self.isDataLoading = false
                
                if let model = cartModel.value {
                    self.airplanePositionsRelay.send(model)
                }
            }.store(in: &cancellableBag)
    }
}
