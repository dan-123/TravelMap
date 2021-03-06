//
//  CoordinateLoaderServiceTests.swift
//  TravelMapTests
//
//  Created by Даниил Петров on 26.07.2021.
//

import XCTest

// MARK: -  Description

/// Проверка сервиса загрузки данных о стране и городе по следующим кейсам:
/// 1. Запрос вернул пустые данные (возможно при некорректном введении страны или города).
/// 2. Страна или город уже были добавлены ранее.
/// 3. Некорректные данные от сервера.

class CoordinateLoaderServiceTests: XCTestCase {
    
    // MARK: - Test that function return error if there is no country data
    
    func testThatFunctionReturnErrorIfThereIsNoCountryData() {
        //arrange
        let coordinateModel = CoordinateModel.init(features: [])
        
        let networkServiceTest = CoordinateNetworkServiceClass(coordinateModel: coordinateModel, networkCompletion: .success)
        let coreDataServiceTest = CoreDataServiceClass(countryIsAdded: false, cityIsAdded: false)
        
        let coordinateLoderService = CoordinateLoaderService(networkService: networkServiceTest,
                                                             coreDataService: coreDataServiceTest)
        
        let expectation = expectation(description: "Success and no country data")
        let expectedError = NetworkServiceError.country
        
        //act
        coordinateLoderService.loadCountryCoordinate(country: "country") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                //assert
                XCTAssertTrue(error.localizedDescription == expectedError.localizedDescription)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    // MARK: - Test that function return error if there is no city data
    
    func testThatFunctionReturnErrorIfThereIsNoCityData() {
        //arrange
        let coordinateModel = CoordinateModel.init(features: [])
        
        let networkServiceTest = CoordinateNetworkServiceClass(coordinateModel: coordinateModel, networkCompletion: .success)
        let coreDataServiceTest = CoreDataServiceClass(countryIsAdded: false, cityIsAdded: false)
        
        let coordinateLoderService = CoordinateLoaderService(networkService: networkServiceTest,
                                                             coreDataService: coreDataServiceTest)
        
        let expectation = expectation(description: "Success and no city data")
        let expectedError = NetworkServiceError.city
        
        //act
        coordinateLoderService.loadCityCoordinate(city: "city", countryCode: "countryCode") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                //assert
                XCTAssertTrue(error.localizedDescription == expectedError.localizedDescription)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    // MARK: - Test that function return error if the country was added earlier

    func testThatFunctionReturnErrorIfTheCountryWasAddedEarlier() {
        //arrange
        let coordinateModel = CoordinateModel.init(features: [.init(properties: .init(city: nil, country: "Italy", countryCode: "it", lon: 12.674297, lat: 42.6384261, placeId: "51f294d5743d59294059d7344af2b7514540f00101f9011393050000000000c0020b"), bbox: [6.6272658, 35.2889616, 18.7844746, 47.0921462])])
        
        let networkServiceTest = CoordinateNetworkServiceClass(coordinateModel: coordinateModel, networkCompletion: .success)
        let coreDataServiceTest = CoreDataServiceClass(countryIsAdded: true, cityIsAdded: true)
        
        let coordinateLoderService = CoordinateLoaderService(networkService: networkServiceTest,
                                                             coreDataService: coreDataServiceTest)
        
        let expectation = expectation(description: "Success and country was added")
        let expectedError = NetworkServiceError.repeatCountry
        
        //act
        coordinateLoderService.loadCountryCoordinate(country: "country") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                //assert
                XCTAssertTrue(error.localizedDescription == expectedError.localizedDescription)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    // MARK: - Test that function return error if the city was added earlier

    func testThatFunctionReturnErrorIfTheCityWasAddedEarlier() {
        //arrange
        let coordinateModel = CoordinateModel.init(features: [.init(properties: .init(city: "Milan", country: "Italy", countryCode: "it", lon: 9.1905, lat: 45.4668, placeId: "51a8c64b378961224059ebe2361ac0bb4640f00101f90173af000000000000c00208"), bbox: [9.0408867, 45.3867381, 9.2781103, 45.5358482])])
        
        let networkServiceTest = CoordinateNetworkServiceClass(coordinateModel: coordinateModel, networkCompletion: .success)
        let coreDataServiceTest = CoreDataServiceClass(countryIsAdded: true, cityIsAdded: true)
        
        let coordinateLoderService = CoordinateLoaderService(networkService: networkServiceTest,
                                                             coreDataService: coreDataServiceTest)
        
        let expectation = expectation(description: "Success and city was added")
        let expectedError = NetworkServiceError.repeatCity
        
        //act
        coordinateLoderService.loadCityCoordinate(city: "city", countryCode: "countryCode") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                //assert
                XCTAssertTrue(error.localizedDescription == expectedError.localizedDescription)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    // MARK: - Test that function returns error if received network error from service for country
    
    func testThatFunctionReturnsErrorIfReceivedNetworkErrorFromServiceForCountry() {
        //arrange
        let coordinateModel = CoordinateModel.init(features: [])
        
        let networkServiceTest = CoordinateNetworkServiceClass(coordinateModel: coordinateModel, networkCompletion: .failure)
        let coreDataServiceTest = CoreDataServiceClass(countryIsAdded: true, cityIsAdded: true)
        
        let coordinateLoderService = CoordinateLoaderService(networkService: networkServiceTest,
                                                             coreDataService: coreDataServiceTest)
        
        let expectation = expectation(description: "Failure and network error for country")
        let expectedError = NetworkServiceError.network
        
        //act
        coordinateLoderService.loadCountryCoordinate(country: "country") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                //assert
                XCTAssertTrue(error.localizedDescription == expectedError.localizedDescription)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    // MARK: - Test that function returns error if received network error from service for city
    
    func testThatFunctionReturnsErrorIfReceivedNetworkErrorFromServiceForCity() {
        //arrange
        let coordinateModel = CoordinateModel.init(features: [])
        
        let networkServiceTest = CoordinateNetworkServiceClass(coordinateModel: coordinateModel, networkCompletion: .failure)
        let coreDataServiceTest = CoreDataServiceClass(countryIsAdded: true, cityIsAdded: true)
        
        let coordinateLoderService = CoordinateLoaderService(networkService: networkServiceTest,
                                                             coreDataService: coreDataServiceTest)
        
        let expectation = expectation(description: "Failure and network error for city")
        let expectedError = NetworkServiceError.network
        
        //act
        coordinateLoderService.loadCityCoordinate(city: "city", countryCode: "countryCode") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                //assert
                XCTAssertTrue(error.localizedDescription == expectedError.localizedDescription)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10)
    }
}
