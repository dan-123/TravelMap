////
////  ImageNetworkServiceTest.swift
////  TravelMapTests
////
////  Created by Даниил Петров on 27.07.2021.
////
//
//import UIKit
//
//// MARK: - Image network service
//
//class ImageNetworkServiceTest: ImageNetworkServiceProtocol {
//    
//    let imageModel: CountryImageModel
//    let networkCompletion: Completion
//    
//    enum Completion {
//        case success
//        case failure
//    }
//    
//    init(imageModel: CountryImageModel, networkCompletion: Completion) {
//        self.imageModel = imageModel
//        self.networkCompletion = networkCompletion
//    }
//    
//    func getCountryImageURL(country: String, completion: @escaping (Result<CountryImageModel, NetworkServiceError>) -> Void) {
//        switch networkCompletion {
//        case .success:
//            
//        case .failure:
//            
//        }
//        completion(.success(imageModel))
//    }
//    
//    func loadImage(imageStringURL: [String], completion: @escaping (Result<[UIImage], NetworkServiceError>) -> Void) {
//        <#code#>
//    }
//}
