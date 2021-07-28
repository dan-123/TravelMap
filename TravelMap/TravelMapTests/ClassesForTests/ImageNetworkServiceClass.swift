//
//  ImageNetworkServiceClass.swift
//  TravelMapTests
//
//  Created by Даниил Петров on 28.07.2021.
//

import UIKit

class ImageNetworkServiceClass: ImageNetworkServiceProtocol {
    
    let countryImageModel: CountryImageModel
    let imageResult: [UIImage]
    let networkCompletion: Completion
    
    enum Completion {
        case success
        case failure
    }
    
    init(countryImageModel: CountryImageModel, imageResult: [UIImage], networkCompletion: Completion) {
        self.countryImageModel = countryImageModel
        self.imageResult = imageResult
        self.networkCompletion = networkCompletion
    }
    
    func getCountryImageURL(country: String, completion: @escaping (Result<CountryImageModel, NetworkServiceError>) -> Void) {
        switch networkCompletion {
        case .success:
            completion(.success(countryImageModel))
        case .failure:
            completion(.failure(.network))
        }
    }
    
    func loadImage(imageStringURL: [String], completion: @escaping (Result<[UIImage], NetworkServiceError>) -> Void) {
        switch networkCompletion {
        case .success:
            completion(.success(imageResult))
        case .failure:
            completion(.failure(.network))
        }
    }
}
