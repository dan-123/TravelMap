//
//  NetworkService.swift
//  TravelMap
//
//  Created by Даниил Петров on 01.07.2021.
//

import Foundation
import UIKit

// MARK: - Protocol

typealias GetCoordinateResponse = Result<CoordinateModel, NetworkServiceError>

protocol CoordinateNetworkServiceProtocol {
    func getCoordinate(placeType: String, placeName: String, countryCode: String?, completion: @escaping (GetCoordinateResponse) -> Void)
}

protocol ImageNetworkServiceProtocol {
    func getCountryImageURL(country: String, completion: @escaping (Result<CountryImageModel, NetworkServiceError>) -> Void)
    func loadImage(imageStringURL: [String], completion: @escaping (Result<[UIImage], NetworkServiceError>) -> Void)
}

// MARK: - Network service

final class NetworkService {
    
    // MARK: Properties
    private let session: URLSession = .shared
    private let imageCache = ImageCache.shared.imageCache
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // MARK: Methods
    private func httpResponse(data: Data?, response: URLResponse?) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode),
              let data = data else {
            throw NetworkServiceError.network
        }
        return data
    }
}

// MARK: - Extension (NetworkServiceProtocol)

extension NetworkService: CoordinateNetworkServiceProtocol {
    
    func getCoordinate(placeType: String, placeName: String, countryCode: String?, completion: @escaping (GetCoordinateResponse) -> Void) {
        var components = URLComponents(string: Constants.Coordinate.getContryCoordinate)
        
        switch placeType {
        case Constants.Coordinate.countryCoordinte:
            components?.queryItems = [
                URLQueryItem(name: "text", value: placeName),
                URLQueryItem(name: "type", value: placeType),
                URLQueryItem(name: "apiKey", value: Constants.apiKey)
            ]
        case Constants.Coordinate.cityCoordinate:
            guard let countryCode = countryCode else { return }
            components?.queryItems = [
                URLQueryItem(name: "text", value: placeName),
                URLQueryItem(name: "type", value: placeType),
                URLQueryItem(name: "apiKey", value: Constants.apiKey),
                URLQueryItem(name: "filter", value: "countrycode:\(countryCode)"),
                URLQueryItem(name: "limit", value: String(Constants.Coordinate.limit)),
            ]
        default:
            break
        }
        
        guard let url = components?.url else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                let response = try self.decoder.decode(CoordinateModel.self, from: data)
                completion(.success(response))
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
        }.resume()
    }
}

// MARK: - Extension (ImageNetworkServiceProtocol)

extension NetworkService: ImageNetworkServiceProtocol {
    
    func getCountryImageURL(country: String, completion: @escaping (Result<CountryImageModel, NetworkServiceError>) -> Void) {
        var components = URLComponents(string: Constants.Image.getCountryImageURL)
        
        components?.queryItems = [
            URLQueryItem(name: "query", value: country),
            URLQueryItem(name: "total_results", value: Constants.Image.totalResult),
            URLQueryItem(name: "per_page", value: String(Constants.Image.perPage))
        ]
        
        guard let url = components?.url else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Constants.Image.authorization, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                let response = try self.decoder.decode(CountryImageModel.self, from: data)
                completion(.success(response))
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
        }.resume()
    }
    
    func loadImage(imageStringURL: [String], completion: @escaping (Result<[UIImage], NetworkServiceError>) -> Void) {
        let myGroup = DispatchGroup()
        var results = [UIImage]()
        
        for stringURL in imageStringURL {
            myGroup.enter()
            
            guard let url = URL(string: stringURL) else { return }
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            
            
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                results.append(cachedImage)
                myGroup.leave()

                
            } else {
                session.dataTask(with: request) { (rawData: Data?, response: URLResponse?, error: Error?) in
                    do {
                        let data = try self.httpResponse(data: rawData, response: response)
                        guard let image = UIImage(data: data) else { return }
                        results.append(image)
                        self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    } catch let error as NetworkServiceError {
                        completion(.failure(error))
                    } catch {
                        completion(.failure(.unknown))
                    }
                    
                    myGroup.leave()
                }.resume()
            }
        }
        myGroup.notify(queue: DispatchQueue.main) {
            completion(.success(results))
        }
    }
}
