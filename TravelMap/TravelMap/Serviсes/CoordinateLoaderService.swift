//
//  CoordinateLoaderService.swift
//  TravelMap
//
//  Created by Даниил Петров on 25.07.2021.
//

import Foundation

// MARK: - Protocol

protocol CoordinateCountryLoaderServiceProtocol {
    func loadCountryCoordinate(country: String, completion: @escaping (Result<CountryDTO, NetworkServiceError>) -> Void)
}

protocol CoordinateCityLoaderServiceProtocol {
    func loadCityCoordinate(city: String, countryCode: String, completion: @escaping (Result<CityDTO, NetworkServiceError>) -> Void)
}

// MARK: - Coordinate loader service

class CoordinateLoaderService {
    
    // MARK: Properties
    
    let coreDataService: CoreDataServiceCountryProtocol & CoreDataServiceCityProtocol
    let networkService: CoordinateNetworkServiceProtocol
    
    // MARK: Init
    
    init(networkService: CoordinateNetworkServiceProtocol = NetworkService(),
         coreDataService: CoreDataServiceCountryProtocol & CoreDataServiceCityProtocol = CoreDataService()) {
        self.networkService = networkService
        self.coreDataService = coreDataService
    }
}

// MARK: - Extension (CountryCoordinateLoaderServiceProtocol)

extension CoordinateLoaderService: CoordinateCountryLoaderServiceProtocol {
    func loadCountryCoordinate(country: String, completion: @escaping (Result<CountryDTO, NetworkServiceError>) -> Void) {
        networkService.getCoordinate(placeType: Constants.Coordinate.countryCoordinte, placeName: country, countryCode: nil) { responce in
            DispatchQueue.main.async {
                switch responce {
                case .success(let data):
                    print(data)
                    if data.features.isEmpty {
                        completion(.failure(.country))
                    } else {
                        guard let countryCode = data.features.first?.properties.countryCode,
                              let country = data.features.first?.properties.country,
                              let latitude = data.features.first?.properties.lat,
                              let longitude = data.features.first?.properties.lon,
                              let countryBorder = data.features.first?.bbox else {
                            return
                        }
                        let countryDTO = CountryDTO(countryCode: countryCode, country: country, latitude: latitude, longitude: longitude, border: countryBorder)
                        //добавление данных в core data
                        let result = self.coreDataService.addCountry(country: [countryDTO])
                        
                        if result == true {
                            completion(.failure(.repeatCountry))
                        } else {
                            completion(.success(countryDTO))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - Extension (CityCoordinateLoaderServiceProtocol)

extension CoordinateLoaderService: CoordinateCityLoaderServiceProtocol {
    func loadCityCoordinate(city: String, countryCode: String, completion: @escaping (Result<CityDTO, NetworkServiceError>) -> Void) {
        networkService.getCoordinate(placeType: Constants.Coordinate.cityCoordinate, placeName: city, countryCode: countryCode) { responce in
            DispatchQueue.main.async {
                switch responce {
                case .success(let data):
                    if data.features.isEmpty {
                        completion(.failure(.city))
                    } else {
                        print(data)
                        guard let cityId = data.features.first?.properties.placeId,
                              let countryCode = data.features.first?.properties.countryCode,
                              let city = data.features.first?.properties.city,
                              let latitude = data.features.first?.properties.lat,
                              let longitude = data.features.first?.properties.lon else {
                            return
                        }
                        let cityDTO = CityDTO(cityId: cityId, countryCode: countryCode, city: city, latitude: latitude, longitude: longitude)
                        completion(.success(cityDTO))
                        //добавление данных в core data
                        let result = self.coreDataService.addCity(city: [cityDTO])
                        
                        if result == true {
                            completion(.failure(.repeatCity))
                        } else {
                            completion(.success(cityDTO))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
