//
//  CoordinateNetworkServiceTest.swift
//  TravelMapTests
//
//  Created by Даниил Петров on 27.07.2021.
//

// MARK: - Coordinate network service

class CoordinateNetworkServiceTest: CoordinateNetworkServiceProtocol {
    
    let coordinateModel: CoordinateModel
    let networkCompletion: Completion
    
    enum Completion {
        case success
        case failure
    }
    
    init(coordinateModel: CoordinateModel, networkCompletion: Completion) {
        self.coordinateModel = coordinateModel
        self.networkCompletion = networkCompletion
    }
    
    func getCoordinate(placeType: String, placeName: String, countryCode: String?, completion: @escaping (GetCoordinateResponse) -> Void) {
        switch networkCompletion {
        case .success:
            completion(.success(coordinateModel))
        case .failure:
            completion(.failure(.network))
        }
    }
}
