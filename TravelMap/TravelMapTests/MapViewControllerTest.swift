//
//  MapViewControllerTest.swift
//  TravelMapTests
//
//  Created by Даниил Петров on 22.07.2021.
//

import XCTest

// MARK: - Network service

class CoordinateNetworkService: CoordinateNetworkServiceProtocol {
    
    enum Completion {
        case success
        case failure
    }
    
    let coordinateModel: CoordinateModel
    let networkCompletion: Completion
    
    init(coordinateModel: CoordinateModel, networkCompletion: Completion) {
        self.coordinateModel = coordinateModel
        self.networkCompletion = networkCompletion
    }
    
    func getCoordinate(placeType: String, placeName: String, countryCode: String?, completion: @escaping (GetCoordinateResponce) -> Void) {
        switch networkCompletion {
        case .success:
            completion(.success(coordinateModel))
        case .failure:
            completion(.failure(.network))
        }
    }
}

// MARK: - City core data service

class CountryCoreDataService: CoreDataServiceCountryProtocol & CoreDataServiceCityProtocol {
    
    let countryIsAdded: Bool
    
    init(countryIsAdded: Bool) {
        self.countryIsAdded = countryIsAdded
    }
    
    func addCountry(country: [CountryDTO]) -> Bool {
        return countryIsAdded
    }
    
    func getCountryData(predicate: String?) -> [CountryDTO]? {
        return []
    }
    
    func deleteCountry(country: [CountryDTO]?) {
        
    }
    
    func addCity(city: [CityDTO]) -> Bool {
        return true
    }
    
    func getCityData(predicate: String?) -> [CityDTO]? {
        return []
    }
    
    func deleteCity(city: [CityDTO]?) {
    }
    
    
}

// MARK: - Map view controller test

class MapViewControllerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Test that function return error if there is no data
    
    func testThatFunctionReturnErrorIfThereIsNoData() {
        //arrange
        let coordinateModel = CoordinateModel.init(features: [])
        
        let coordinateNetworkService = CoordinateNetworkService(coordinateModel: coordinateModel, networkCompletion: .success)
        let countryCoreDataService = CountryCoreDataService(countryIsAdded: false)
        
        let mapViewController = MapViewController(networkService: coordinateNetworkService,
                                                  coreDataService: countryCoreDataService)
        
        let expectation = expectation(description: "Success and no country data")
        let expectedError = NetworkServiceError.country
        var isEqual: Bool = false

        //act
        mapViewController.loadCountryCoordinate(country: "Test")
        mapViewController.showAlert = { error in
            isEqual = error.localizedDescription == expectedError.localizedDescription
            //assert
            XCTAssertTrue(isEqual)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    // MARK: - Test that function return error if the city was added earlier

    func testThatFunctionReturnErrorIfTheCityWasAddedEarlier() {
        //arrange
        let coordinateModel = CoordinateModel.init(features: [.init(properties: .init(city: nil, country: "Italy", countryCode: "it", lon: 12.674297, lat: 42.6384261, placeId: "51f294d5743d59294059d7344af2b7514540f00101f9011393050000000000c0020b"), bbox: [6.6272658, 35.2889616, 18.7844746, 47.0921462])])
        
        let coordinateNetworkService = CoordinateNetworkService(coordinateModel: coordinateModel, networkCompletion: .success)
        let countryCoreDataService = CountryCoreDataService(countryIsAdded: true)
        
        let mapViewController = MapViewController(networkService: coordinateNetworkService,
                                                  coreDataService: countryCoreDataService)
        
        let expectation = expectation(description: "Success and country was added")
        let expectedError = NetworkServiceError.repeatCountry
        var isEqual: Bool = false
        
        //act
        mapViewController.loadCountryCoordinate(country: "Test")
        mapViewController.showAlert = { error in
            isEqual = error.localizedDescription == expectedError.localizedDescription
            //assert
            XCTAssertTrue(isEqual)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    // MARK: - Test that function returns error if received network error from the service
    
    func testThatFunctionReturnsErrorIfReceivedNetworkErrorFromTheService() {
        //arrange
        let coordinateModel = CoordinateModel.init(features: [])
        
        let coordinateNetworkService = CoordinateNetworkService(coordinateModel: coordinateModel, networkCompletion: .failure)
        let countryCoreDataService = CountryCoreDataService(countryIsAdded: true)
        
        let mapViewController = MapViewController(networkService: coordinateNetworkService,
                                                  coreDataService: countryCoreDataService)
        
        let expectation = expectation(description: "Failure and network error")
        let expectedError = NetworkServiceError.network
        var isEqual: Bool = false
        
        //act
        mapViewController.loadCountryCoordinate(country: "Test")
        mapViewController.showAlert = { error in
            isEqual = error.localizedDescription == expectedError.localizedDescription
            //assert
            XCTAssertTrue(isEqual)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
