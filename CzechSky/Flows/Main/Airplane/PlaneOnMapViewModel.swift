//
//  PlaneOnMapViewModel.swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 11.04.2022.
//

import Combine
import MapKit
import SwiftUI

protocol PlaneOnMapViewModelProtocol: ObservableObject {
    var getAirplanePositions: Subscribers.MergeSink<Bool> { get }
}

final class PlaneOnMapViewModel: PlaneOnMapViewModelProtocol {
    
    enum Constants {
        enum Description {
            static let states = "states"
        }
    }
    
    @Published private(set) var isLoading: Bool = false
    @Published var airplanePositions = [PlanePositionsModel]()
    @Published var shouldShowEnableBiometricPrompt: Bool = false
    
    var getAirplanePositions: Subscribers.MergeSink<Bool> {
        return domainModel.onViewWillAppear
    }
    
    private var airplaneRequestDomain: PlaneRepositoryProtocol
    private var domainModel: PlaneDomainModel
    
    private var cancellableBag = Set<AnyCancellable>()
    
    init(airplaneRequestDomain: PlaneRepositoryProtocol,
         domainModel: PlaneDomainModel) {
       
        self.airplaneRequestDomain = airplaneRequestDomain
        self.domainModel = domainModel
        
        domainModel.$isDataLoading
            .assign(to: &self.$isLoading)
        
        domainModel.airplanePositions
            .sink { [weak self] data in
                guard let self = self else { return }
                
                self.airplanePositions = []
                self.makeItemViewModel(from: data)
            }
            .store(in: &cancellableBag)
        
        domainModel.error
            .sink { [weak self] error in
                guard let self = self else { return }
                
                self.shouldShowEnableBiometricPrompt.toggle()
            }
            .store(in: &cancellableBag)
    }
}

private extension PlaneOnMapViewModel {
    func makeItemViewModel(from data: Data) {
        var dm = [PlanePositionsModel]()
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]
            if let states = json?[Constants.Description.states] as? [[Any]] {
                
                for items in states.enumerated() {
                    var latitude: Double?
                    var longitude: Double?
                    var trueTrack: Double?
                    var country: String?
                    
                    for (itemNumber, stateItem) in items.element.enumerated() {
                        switch itemNumber {
                        case PlanePositionsModel.PlaneInfoPositionsEnum.originCountry.rawValue:
                            country = stateItem as? String
                        case PlanePositionsModel.PlaneInfoPositionsEnum.longitude.rawValue:
                            longitude = stateItem as? Double
                        case PlanePositionsModel.PlaneInfoPositionsEnum.latitude.rawValue:
                            latitude = stateItem as? Double
                        case PlanePositionsModel.PlaneInfoPositionsEnum.trueTrack.rawValue:
                            trueTrack = stateItem as? Double
                        default:
                            break
                        }
                        
                        if let lt = latitude,
                           let ln = longitude,
                           let tt = trueTrack,
                           let cn = country {
                            
                            dm.append(PlanePositionsModel(latitude: lt, longitude: ln, trueTrack: tt, country: cn))
                            
                            latitude = nil
                            longitude = nil
                            trueTrack = nil
                            country = nil
                        }
                    }
                }
            }
        } catch {
            self.shouldShowEnableBiometricPrompt.toggle()
        }
        
        self.airplanePositions = dm
    }
}
