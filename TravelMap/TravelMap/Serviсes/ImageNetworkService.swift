//
//  ImageNetworkService.swift
//  TravelMap
//
//  Created by Даниил Петров on 13.07.2021.
//

import Foundation
import UIKit

// MARK: - Protocol

protocol ImageNetworkServiceProtocol {
    func loadImage(firstURL: String, secondURL: String, thirdURL: String, completion: @escaping (Result<[UIImage], Error>) -> Void)
}

final class ImageNetworkService {
    private let session: URLSession = .shared
    
}

extension ImageNetworkService: ImageNetworkServiceProtocol {
    
    func loadImage(firstURL: String, secondURL: String, thirdURL: String, completion: @escaping (Result<[UIImage], Error>) -> Void) {
        
        let myGroup = DispatchGroup()
        
        var results = [UIImage]()
        
        
        let urls = [URL(string: firstURL), URL(string: secondURL), URL(string: thirdURL)]
        
        for url in urls {
            myGroup.enter()
            
            guard let url = url else { return }
            
            session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode),
                      let data = data else {
                    guard let error = error else { return }
                    return completion(.failure(error))
                }
                guard let image = UIImage(data: data) else { return }
                
                results.append(image)
                myGroup.leave()
            }.resume()
        }
        
        myGroup.notify(queue: DispatchQueue.main) {
            completion(.success(results))
        }
    }
    
}

