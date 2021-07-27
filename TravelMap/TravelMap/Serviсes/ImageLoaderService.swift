//
//  ImageLoaderService.swift
//  TravelMap
//
//  Created by Даниил Петров on 27.07.2021.
//

import Foundation
import UIKit

// MARK: - Protocol

protocol ImageLoaderServiceProtocol {
    func loadImage(country: String, completion: @escaping (Result<[UIImage], NetworkServiceError>) -> Void)
}

// MARK: - Image loader service

class ImageLoaderService {
    
    // MARK: Properties
    private var imageStringURL = [String]()
    let networkService: ImageNetworkServiceProtocol
    
    // MARK: Init
    init(networkService: ImageNetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
}

// MARK: - Extensions (ImageLoaderServiceProtocol)

extension ImageLoaderService: ImageLoaderServiceProtocol {
    func loadImage(country: String, completion: @escaping (Result<[UIImage], NetworkServiceError>) -> Void) {
        networkService.getCountryImageURL(country: country) { responce in
            DispatchQueue.main.async {
                switch responce {
                case .success(let data):
                    for image in data.photos {
                        self.imageStringURL.append(image.src.medium) 
                    }
                    loadImageData()
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        func loadImageData() {
            networkService.loadImage(imageStringURL: imageStringURL) { responce in
                DispatchQueue.main.async {
                    switch responce {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
