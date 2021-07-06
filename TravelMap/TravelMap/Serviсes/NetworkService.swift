//
//  NetworkService.swift
//  TravelMap
//
//  Created by Даниил Петров on 01.07.2021.
//

import Foundation

// MARK: - Protocol

typealias GetCountryCoordinateResponce = Result<CountryCoordinateModel, NetworkServiceError>

protocol NetworkServiceProtocol {
    func getCountryCoordinate(countryName: String, completion: @escaping (GetCountryCoordinateResponce) -> Void)
//    func checkAnnotationCoordinate(latitude: Double, longitude: Double, completion: @escaping (GetCountryCoordinateResponce) -> Void)
}

// MARK: - Network service

final class NetworkService {
    private let session: URLSession = .shared
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

// MARK: - Extension

extension NetworkService: NetworkServiceProtocol {
    
    func getCountryCoordinate(countryName: String, completion: @escaping (GetCountryCoordinateResponce) -> Void) {
        var components = URLComponents(string: Constants.CountryCoordinate.getContryCoordinate)
        components?.queryItems = [
            URLQueryItem(name: "text", value: countryName),
            URLQueryItem(name: "type", value: Constants.CountryCoordinate.type),
            URLQueryItem(name: "apiKey", value: Constants.apiKey)
        ]
        
        guard let url = components?.url else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { rawData, responce, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: responce)
                let responce = try self.decoder.decode(CountryCoordinateModel.self, from: data)
                completion(.success(responce))
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
        }.resume()
    }
    
//    func checkAnnotationCoordinate(latitude: Double, longitude: Double, completion: @escaping (GetCountryCoordinateResponce) -> Void) {
//        var components = URLComponents(string: Constants.CountryCoordinate.getAnnotationCoordinate)
//        components?.queryItems = [
//            URLQueryItem(name: "lat", value: String(latitude)),
//            URLQueryItem(name: "lon", value: String(longitude)),
//            URLQueryItem(name: "apiKey", value: Constants.apiKey)
//        ]
//        
//        guard let url = components?.url else {
//            completion(.failure(.unknown))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        session.dataTask(with: request) { rawData, responce, taskError in
//            do {
//                let data = try self.httpResponse(data: rawData, response: responce)
//                let responce = try self.decoder.decode(CountryCoordinateModel.self, from: data)
//                completion(.success(responce))
//            } catch let error as NetworkServiceError {
//                completion(.failure(error))
//            } catch {
//                completion(.failure(.unknown))
//            }
//        }.resume()
//        
//        
//    }
    
    private func httpResponse(data: Data?, response: URLResponse?) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode),
              let data = data else {
            throw NetworkServiceError.network
        }
        return data
    }
}
